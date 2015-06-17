import 'dart:async';

import '../lib/configuration.dart';
import '../lib/file2ir.dart';
import '../lib/frontdesk_model.dart';
import '../lib/adaheads_model.dart';
import '../lib/database.dart';
import '../lib/utilities.dart';

int phoneNumberId = 1;
List<CalendarEntry> calendarEntries;

void main(List<String> args) {
  Configuration config = new Configuration(args);
  // Parse Arguments
  if (config.showHelp()) {
    print(config.getUsage());
  } else if (config.isValid()) {
    print(config);
    AccessInstance acc = Convert(config);
    calendarEntries = acc.calendar;
    //acc.companies.forEach((v) => print(v.VirkNavn));

    setupDatabase(config).then((Database db) {
      return Future.wait(acc.companies.map((virk) => createOrganization(db, virk, acc.employees.where((m) => m.VirkID == virk.VirkIDnr).toList())) )
          .whenComplete(() => db.close()).then((_) {
        print('Completed. Added ${acc.companies.length} companies and ${acc.employees.length} employees');
      });

      //manualCheck(db, acc);
    });
  }
}

void manualCheck(Database db, AccessInstance acc) {
  db.close();
  for (Employee med in acc.employees) {
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

  for (var virk in acc.companies) {
    if (virk.VirkIDnr == 33170197) {
      print(virk.VirkNavn);
    }
  }

  for (Employee med in acc.employees) {
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

Future createOrganization(Database db, Company virk, List<Employee>
    medarbejdere) {
  return db.createOrganization(virk.VirkNavn, '', '').then((int orgId) {
    return createReception(virk, db, orgId, medarbejdere);
  });
}

Future createReception(Company virk, Database db, int
    orgId, List<Employee> medarbejdere) {

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
      ..telephonenumbers = [createVirkPhone(phoneNumberId++, virk.VirkTlf1),
                            createVirkPhone(phoneNumberId++, virk.VirkTlf2)].where((e) => e != null).toList()
      ..bankinginformation = noEmptyStrings([virk.VirkBank_konto,
          virk.VirkGiro_konto])
      ..websites = noEmptyStrings([virk.VirkWWW])
      ..openinghours = noEmptyStrings([virk.VirkKontortid])
      ..emailaddresses = noEmptyStrings([virk.VirkEmail])
      ..receptionNumber = virk.VirkTH_nr;

  Employee openingshours = medarbejdere.firstWhere((e) => e.MedNavn.contains(
      'Åbningstider'), orElse: () => null);
  if (openingshours != null && openingshours.MedStilling != null &&
      openingshours.MedStilling.trim().isNotEmpty) {
    recep.openinghours.add(openingshours.MedStilling);
    medarbejdere.remove(openingshours);
  }

  Employee salesCall = medarbejdere.firstWhere((e) => e.MedNavn.contains(
      'Sælgere / Analyser'), orElse: () => null);
  if (salesCall != null && salesCall.MedTHMail != null &&
      salesCall.MedTHMail.trim().isNotEmpty) {
    recep.salesCalls.add(salesCall.MedTHMail);
    medarbejdere.remove(salesCall);
  }

  Map attributes = recep.attributes;
  attributes['frontdesk'] = virk;
  return db.createReception(recep.organization_id, recep.full_name, attributes,
      recep.extradatauri, true, recep.receptionNumber).then((int id) {
    return Future.wait(medarbejdere.map((med) => createContact(db, id, med)));
  });
}

Future createContact(Database db, int receptionId, Employee med) {
  String contactType = med.MedNavn.startsWith('.') ? 'function' : 'human';
  String contactName = removeLeadingDots(med.MedNavn); //med.MedNavn;

  return db.createContact(contactName, contactType, true).then((int contactId) {
    ReceptionContact rc = new ReceptionContact()
        ..receptionId = receptionId
        ..contactId = contactId
        ..wantsMessages = med.MedIngenFax == '0' && med.MedIngenEmail == '0' &&
            med.MedIngenSMS == '0'
        ..position = med.MedStilling
        ..department = med.MedAfd
        //TODO is this still used?
        ..emailaddresses = noEmptyStrings([med.MedEmail, med.MedPrivatEmail])
        ..responsibility = med.MedAnsvarsomraade
        ..info = med.MedNote
        ..handling = noEmptyStrings([med.MedTHMail])
        ..statusEmail = med.statusmail == '1'
        ..branch = '${med.MedPostnr} ${med.MedPostby} ${med.MedAdr}'.trim()
        ..contactEnabled = true;

    //These code blocks here, rely on the fact that "makePhone" returns a null,
    // if there are no data, to make a number out of.
    List<Phone> phoneNumbers = [createPhone(phoneNumberId++, med.MedDirTlf,
        med.MedDirTlfOpl, 'Direkte'), createPhone(phoneNumberId++, med.MedMobil,
        med.MedMobilOpl, 'Mobil'), createPhone(phoneNumberId++, med.MedHasterTlf,
        med.MedHasterTlfOpl, 'Haster'), createPhone(phoneNumberId++, med.MedPrivTlf,
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
        rc.wantsMessages, rc.phoneNumbers, attributes, rc.contactEnabled, rc.dataContact,
        rc.statusEmail)
        .then((_) => db.createDistributionListEntry(rc.receptionId, rc.contactId, 'to', rc.receptionId, rc.contactId))
        .whenComplete(() => handleEndpoints(med, rc, db));
//        .whenComplete(() {
//          List<CalendarEntry> entries = calendarEntries.where((c) => c.userId == med.MedID).toList();
//
//          return Future.forEach(entries, (CalendarEntry entry) => db.createEvent(entry.start, entry.end, entry.message)
//              .then((int eventId) => db.createContactEvent(rc.receptionId, rc.contactId, eventId) ) );
//    });
  });
}

Future handleEndpoints(Employee med, ReceptionContact rc, Database db) {
  List<Endpoint> endpoints = new List<Endpoint>();

  if(med.MedEmail != null && med.MedEmail.trim().isNotEmpty) {
    Iterable<String> rawEmails = med.MedEmail.split(';').map((e) => e.trim());

    for(String rawEmail in rawEmails) {
      Endpoint email = extractEndpoint(rawEmail)
          ..contactId = rc.contactId
          ..receptionId = rc.receptionId
          ..enabled = true
          ..confidential = false
          ..priority = 0
          ..description = 'Firma E-mail';

      if(!containsEndpoint(endpoints, email)) {
        endpoints.add(email);
      }
    }
  }

  if(med.MedPrivatEmail != null && med.MedPrivatEmail.trim().isNotEmpty) {
    Iterable<String> rawEmails = med.MedPrivatEmail.split(';').map((e) => e.trim());

    for(String rawEmail in rawEmails) {
      Endpoint email = extractEndpoint(rawEmail)
        ..contactId = rc.contactId
        ..receptionId = rc.receptionId
        ..enabled = true
        ..confidential = false
        ..priority = 0
        ..description = 'Private E-mail';

      if(!containsEndpoint(endpoints, email)) {
        endpoints.add(email);
      }
    }
  }

  if(med.MedSMS != null && med.MedSMS.trim().isNotEmpty) {
    Iterable<String> rawEmails = med.MedSMS.split(';').map((e) => e.trim());

    for(String rawEmail in rawEmails) {
      Endpoint email = extractEndpoint(rawEmail);

      email
        ..contactId = rc.contactId
        ..receptionId = rc.receptionId
        ..enabled = true
        ..confidential = false
        ..priority = 0
        ..description = email.addressType;

      if(!containsEndpoint(endpoints, email)) {
        endpoints.add(email);
      }
    }
  }

  return Future.forEach(endpoints, db.createEndpoint);
}

String removeLeadingDots(String text) {
  String tmp = text;
  while(tmp.startsWith('.')) {
    tmp = tmp.substring(1);
  }
  return tmp;
}

bool containsEndpoint(List<Endpoint> list, Endpoint endpoint) {
  return list.any((e) => e.address == endpoint.address && e.addressType == endpoint.addressType);
}

Endpoint extractEndpoint(String text) {
  if(text.contains('@cpsms.dk')) {
    String number = text.split('.').first;
    return new Endpoint()
        ..address = number
        ..addressType = 'sms';
  } else {
    return new Endpoint()
        ..address = text
        ..addressType = 'email';
  }
}
