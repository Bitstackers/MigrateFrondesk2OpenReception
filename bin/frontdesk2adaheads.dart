import 'dart:async';
import 'dart:io';

import '../lib/configuration.dart';
import '../lib/file2ir.dart';
import '../lib/frontdesk_model.dart';
import '../lib/adaheads_model.dart';
import '../lib/database.dart';
import '../lib/utilities.dart';

int phoneNumberId = 1;

void main(List<String> args) {
  Configuration config = new Configuration(args);
  // Parse Arguments
  if (config.showHelp()) {
    print(config.getUsage());
  } else if (config.isValid()) {
    print(config);
    AccessInstance acc = Convert(config);
    //acc.virksomheder.forEach((v) => print(v.VirkIDnr));

    setupDatabase(config).then((Database db) {
      return Future.wait(acc.virksomheder.map((virk) => createOrganization(db,
          virk, acc.medarbejder.where((m) => m.VirkID == virk.VirkIDnr).toList()))
          ).whenComplete(() => db.close()).then((_) {
        print('Completed. Added ${acc.virksomheder.length} companies and ${acc.medarbejder.length} employees');
      });

      //manualCheck(db, acc);
    });
  }
}

void manualCheck(Database db, AccessInstance acc) {
  db.close();
  for (Medarbejder med in acc.medarbejder) {
    if (med.MedNavn.contains('Sælger')) {
      //print('${removeLeadingDots(med.MedNavn)} "${med.MedTHMail}" Virksomed: ${med.VirkID}');
    }
    if (med.MedNavn.contains('Åbningstider')) {
      //print('${med.MedNavn} "${med.MedStilling}" Virksomed: ${med.VirkID}');
      //          if(med.MedStilling.contains('Tors') || med.MedStilling.contains('tors') || med.MedStilling.contains('Tor')) {
      //            print('${med.MedNavn} "${med.MedStilling}" Virksomed: ${med.VirkID}');
      //          }
    }
  }

  for (var virk in acc.virksomheder) {
    if (virk.VirkIDnr == 33170197) {
      print(virk.VirkNavn);
    }
  }

  for (Medarbejder med in acc.medarbejder) {
    if (numberIsBroken(med.MedDirTlf)) {
      print('Navn: ${med.MedNavn}. DirTlf: ${med.MedDirTlf}');
    }
    if (numberIsBroken(med.MedMobil)) {
      print('Navn: ${med.MedNavn}. Mobil: ${med.MedMobil}');
    }
    if (numberIsBroken(med.MedHasterTlf)) {
      print('Navn: ${med.MedNavn}. HasterTlf: ${med.MedHasterTlf}');
    }
    if (numberIsBroken(med.MedPrivTlf)) {
      print('Navn: ${med.MedNavn}. PrivTlf: ${med.MedPrivTlf}');
    }
  }

  print('complete');
}

Future createOrganization(Database db, Virksomhed virk, List<Medarbejder>
    medarbejdere) {
  return db.createOrganization(virk.VirkNavn, '', '').then((int orgId) {
    return createReception(virk, db, orgId, medarbejdere);
  });
}

Future createReception(Virksomhed virk, Database db, int
    orgId, List<Medarbejder> medarbejdere) {
  String phonenumber = virk.VirkTH_nr;

  Reception recep = new Reception()
      ..full_name = virk.VirkNavn
      ..organization_id = orgId
      ..handlings = noEmptyStrings([virk.VirkNote, virk.VirkAktion,
          virk.VirkTHmail])
      ..product = virk.VirkProduktbesk
      ..other = virk.VirkVigtigInfo
      ..greeting = virk.VirkVelkomst
      ..addresses = noEmptyStrings([virk.Virkbeliggenhed,
          '${virk.VirkPostnr} ${virk.VirkPostby} ${virk.VirkAdr1}',
          '${virk.VirkPostnr2} ${virk.VirkPostby2} ${virk.VirkAdr2}'])
      ..registrationnumbers = noEmptyStrings([virk.VirkCVR])
      ..telephonenumbers = noEmptyStrings([virk.VirkTlf1, virk.VirkTlf2])
      ..bankinginformation = noEmptyStrings([virk.VirkBank_konto,
          virk.VirkGiro_konto])
      ..websites = noEmptyStrings([virk.VirkWWW])
      ..openinghours = noEmptyStrings([virk.VirkKontortid])
      ..emailaddresses = noEmptyStrings([virk.VirkEmail]);

  if (virk.VirkFax1 != null && virk.VirkFax1.trim().isNotEmpty) {
    recep.telephonenumbers.add('FAX ${virk.VirkFax1}');
  }

  if (virk.VirkFax2 != null && virk.VirkFax2.trim().isNotEmpty) {
    recep.telephonenumbers.add('FAX ${virk.VirkFax2}');
  }

  Medarbejder openingshours = medarbejdere.firstWhere((e) => e.MedNavn.contains(
      'Åbningstider'), orElse: () => null);
  if (openingshours != null && openingshours.MedStilling != null &&
      openingshours.MedStilling.trim().isNotEmpty) {
    recep.openinghours.add(openingshours.MedStilling);
    medarbejdere.remove(openingshours);
  }

  Medarbejder salesCall = medarbejdere.firstWhere((e) => e.MedNavn.contains(
      'Sælgere / Analyser'), orElse: () => null);
  if (salesCall != null && salesCall.MedTHMail != null &&
      salesCall.MedTHMail.trim().isNotEmpty) {
    recep.crapcallhandling.add(salesCall.MedTHMail);
    medarbejdere.remove(salesCall);
  }

  Map attributes = recep.attributes;
  attributes['frontdesk'] = virk;
  return db.createReception(recep.organization_id, recep.full_name, attributes,
      recep.extradatauri, true, phonenumber).then((int id) {
    return Future.wait(medarbejdere.map((med) => createContact(db, id, med)));
  });
}

Future createContact(Database db, int receptionId, Medarbejder med) {
  String contactType = med.MedNavn.startsWith('.') ? 'function' : 'human';
  String contactName = med.MedNavn; //removeLeadingDots(med.MedNavn);

  return db.createContact(contactName, contactType, true).then((int contactId) {
    ReceptionContact rc = new ReceptionContact()
        ..receptionId = receptionId
        ..contactId = contactId
        ..wantsMessages = med.MedIngenFax == '0' && med.MedIngenEmail == '0' &&
            med.MedIngenSMS == '0'
        ..position = med.MedStilling
        ..department = med.MedAfd
        ..emailaddresses = noEmptyStrings([med.MedEmail, med.MedPrivatEmail])
        //TODO Message table
        ..responsibility = med.MedAnsvarsomraade
        ..info = med.MedNote
        ..handling = noEmptyStrings([med.MedTHMail])
        ..statusEmail = med.statusmail == '1'
        ..branch = '${med.MedPostnr} ${med.MedPostby} ${med.MedAdr}'.trim();
    ;

    List<Phone> phoneNumbers = [makePhone(phoneNumberId++, med.MedDirTlf,
        med.MedDirTlfOpl, 'Direkte'), makePhone(phoneNumberId++, med.MedMobil,
        med.MedMobilOpl, 'Mobil'), makePhone(phoneNumberId++, med.MedHasterTlf,
        med.MedHasterTlfOpl, 'Haster'), makePhone(phoneNumberId++, med.MedPrivTlf,
        med.MedPrivTlfOpl, 'Privat')];

    if (med.MedPrimNummer == '2') {
      Phone p = phoneNumbers[1];
      phoneNumbers.removeAt(1);
      phoneNumbers.insert(0, p);

    } else if (med.MedPrimNummer == '3') {
      Phone p = phoneNumbers[2];
      phoneNumbers.removeAt(2);
      phoneNumbers.insert(0, p);
    }

    rc.phoneNumbers = phoneNumbers.where((e) => e != null).toList();
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
    return db.createReceptionContact(rc.receptionId, rc.contactId,
        rc.wantsMessages, rc.phoneNumbers, rc.distributionList, attributes, true, rc.dataContact,
        rc.statusEmail);
  });
}
