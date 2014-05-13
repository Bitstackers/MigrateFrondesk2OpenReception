import 'dart:async';
import 'dart:io';

import '../lib/configuration.dart';
import '../lib/file2ir.dart';
import '../lib/frontdesk_model.dart';
import '../lib/adaheads_model.dart';
import '../lib/database.dart';

int phoneNumberId = 1;

void main(List<String> args) {
  Configuration config = new Configuration(args);
  // Parse Arguments
  if(config.showHelp()) {
    print(config.getUsage());
  } else if(config.isValid()) {
    print(config);
    AccessInstance acc = Convert(config);
    //acc.virksomheder.forEach((v) => print(v.VirkIDnr));

    setupDatabase(config).then((Database db) {
      return Future.wait(acc.virksomheder.map((virk) =>
          createOrganization(db, virk, acc.medarbejder.where((m) => m.VirkID == virk.VirkIDnr).toList())))
          .whenComplete(() => db.close())
          .then((_) {print('Completed');});
    });
  }
}

Future createOrganization(Database db, Virksomhed virk, List<Medarbejder> medarbejdere) {
  return db.createOrganization(virk.VirkNavn, '', '').then((int orgId) {
    return createReception(virk, db, orgId, medarbejdere);
  });
}

Future createReception(Virksomhed virk, Database db, int orgId, List<Medarbejder> medarbejdere) {
  String phonenumber = virk.VirkTH_nr;

  Reception recep = new Reception()
    ..full_name = virk.VirkNavn
    ..organization_id = orgId
    ..handlings = [virk.VirkNote, virk.VirkAktion, virk.VirkTHmail]
    ..product = virk.VirkProduktbesk
    ..other =  virk.VirkVigtigInfo
    ..greeting = virk.VirkVelkomst
    ..addresses = [virk.Virkbeliggenhed,
                  '${virk.VirkPostnr} ${virk.VirkPostby} ${virk.VirkAdr1}',
                  '${virk.VirkPostnr2} ${virk.VirkPostby2} ${virk.VirkAdr2}']
    ..registrationnumbers = [virk.VirkCVR]
    ..telephonenumbers = [virk.VirkTlf1, virk.VirkTlf2, 'Fax ${virk.VirkFax1}', 'Fax ${virk.VirkFax2}']
    ..bankinginformation = [virk.VirkBank_konto, virk.VirkGiro_konto]
    ..websites = [virk.VirkWWW]
    ..openinghours = [virk.VirkKontortid]
    ..emailaddresses = [virk.VirkEmail];

  Map attributes = recep.attributes;
  attributes['frontdesk'] = virk;
  return db.createReception(recep.organization_id, recep.full_name, attributes, recep.extradatauri, true, phonenumber).then((int id) {
    return Future.wait(medarbejdere.map((med) => createContact(db, id, med)));
  });
}

Future createContact(Database db, int receptionId, Medarbejder med) {
  return db.createContact(med.MedNavn, 'human', true).then((int contactId) {
    ReceptionContact rc = new ReceptionContact()
      ..receptionId = receptionId
      ..contactId = contactId
      ..wantsMessages = med.MedIngenFax == '0' && med.MedIngenEmail == '0' && med.MedIngenSMS == '0'
      ..position = med.MedStilling
      ..department = med.MedAfd
      ..emailaddresses = [med.MedEmail, med.MedPrivatEmail] //TODO Message table
      ..responsibility = med.MedAnsvarsomraade
      ..info = med.MedNote
      ..phoneNumbers = [
        new Phone()
          ..id = phoneNumberId++
          ..kind = 'PSTN'
          ..value = med.MedDirTlf
          ..description = 'Direkte'
          ..bill_type = 'mobile'
          ..confidential = med.MedDirTlfOpl == '1' ? true : false,

        new Phone()
          ..id = phoneNumberId++
          ..kind = 'PSTN'
          ..value = med.MedMobil
          ..description = 'mobil'
          ..bill_type = 'mobile'
          ..confidential = med.MedMobilOpl == '1' ? true : false,

        new Phone()
          ..id = phoneNumberId++
          ..kind = 'PSTN'
          ..value = med.MedHasterTlf
          ..description = 'Haster'
          ..bill_type = 'mobile'
          ..confidential = med.MedHasterTlfOpl == '1' ? true : false,

        new Phone()
          ..id = phoneNumberId++
          ..kind = 'PSTN'
          ..value = med.MedPrivTlf
          ..description = 'privat'
          ..bill_type = 'mobile'
          ..confidential = med.MedPrivTlfOpl == '1' ? true: false
      ]
      ..handling = [med.MedTHMail]
      ..statusEmail = med.statusmail == '1'
      ..branch = '${med.MedPostnr} ${med.MedPostby} ${med.MedAdr}';
    ;

    if(med.MedPrimNummer == '2') {
      Phone p = rc.phoneNumbers[1];
      rc.phoneNumbers.removeAt(1);
      rc.phoneNumbers.insert(0, p);

    } else if (med.MedPrimNummer == '3') {
      Phone p = rc.phoneNumbers[2];
      rc.phoneNumbers.removeAt(2);
      rc.phoneNumbers.insert(0, p);
    }

    rc.phoneNumbers = rc.phoneNumbers.where((e) => e.value.isNotEmpty).toList();
/*
  String MedAdr;
  String MedPostnr;
  String MedPostby;

  String MedDirTlf;
  String MedDirLokalnr;  ????
  String MedDirTlfOpl; //Oplys
  String MedMobil;
  String MedMobilOpl;
  String MedHasterTlf;
  String MedHasterTlfOpl;
  String MedPrivTlf;
  String MedPrivTlfOpl;

  String MedSMS;   //Message (Indeholder CPSmS er det SMS ellers Email)
  String MedTHMail; //Message
  String statusmail; //Vil de have afvide om nedbrud/lukket
  String MedIngenFax;    hvis 0 => wantsMessage = true
  String MedIngenEmail;  -||-
  String MedIngenSMS;    -||-
  String MedStdBesked; //Bruges til at fortælle om der skal spørge efter noget specifikt. [blah] fjernes fra emails.
  String MedPrimNummer; //Indikere hvilke numer er det primær
 */
    Map attributes = rc.attributes;
    attributes['frontdesk'] = med;
    return db.createReceptionContact(rc.receptionId, rc.contactId, rc.wantsMessages, rc.phoneNumbers, attributes, true, rc.dataContact, rc.statusEmail);
  });
}

