import 'dart:async';
import 'dart:io';

import '../lib/configuration.dart';
import '../lib/file2ir.dart';
import '../lib/frontdesk_model.dart';
import '../lib/adaheads_model.dart';
import '../lib/database.dart';

void main(List<String> args) {
  Configuration config = new Configuration(args);

  // Parse Arguments
  if(config.showHelp()) {
    print(config.getUsage());
  } else if(config.isValid()) {
    AccessInstance acc = Convert(config);
    //acc.virksomheder.forEach((v) => print(v.VirkIDnr));

    setupDatabase(config).then((Database db) {
      return Future.wait(acc.virksomheder.map((virk) =>
          createOrganization(db, virk, acc.medarbejder.where((m) => m.VirkID == virk.VirkIDnr).toList())))
          .then((_) => db.close());
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
    ..handlings = [virk.VirkAktion, virk.VirkTHmail]
    ..product = virk.VirkProduktbesk
    ..other = virk.VirkNote + " " + virk.VirkVigtigInfo
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
    bool wantMessages = true;
    ReceptionContact rc = new ReceptionContact()
      ..receptionId = receptionId
      ..contactId = contactId
      ..wantsMessages = true
      ..position = med.MedStilling
      ..department = med.MedAfd
      ..emailaddresses = [med.MedEmail, med.MedPrivatEmail] //TODO Message table
      ..responsibility = med.MedAnsvarsomraade
      ..info = med.MedNote
      ..phoneNumbers = [
        new Phone()..kind = 'PSTN'..value = med.MedDirTlf,
        new Phone()..kind = 'PSTN'..value = med.MedMobil,
        new Phone()..kind = 'PSTN'..value = med.MedHasterTlf,
        new Phone()..kind = 'PSTN'..value = med.MedPrivTlf
      ]
    ..handling = [med.MedTHMail]
    ;
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
    return db.createReceptionContact(rc.receptionId, rc.contactId, rc.wantsMessages, rc.phoneNumbers, attributes, true);
  });
}

