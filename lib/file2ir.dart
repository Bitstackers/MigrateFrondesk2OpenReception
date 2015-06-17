library File2Ir;

import 'dart:io';

import 'package:csv/csv.dart';


import 'configuration.dart';
import 'frontdesk_model.dart';
import 'frontdesk_firebird.dart';

AccessInstance Convert(Configuration config) {
  AccessInstance instance = new AccessInstance();

  File csvFile = new File(config.company);
  String buffer = csvFile.readAsStringSync();

  final decoder = new CsvToListConverter
       (fieldDelimiter: ';', parseNumbers: false, eol: '\n');

  List<String> headers;

  List<List<String>> decodedCsv = decoder.convert(buffer);

    /// Cherry-pick the headers.
    headers = decodedCsv.removeAt(0);
    print ('Headers: $headers');

    decodedCsv.forEach((List<String> rowElements) {
      int column = 0;
      Map value  = {};
      rowElements.forEach((var element) {
        value[headers[column]] = element;
        column++;
      });

      Company virk = mapVirksomhed(value);
      //print (virk.VirkIDnr);
      instance.companies.add(virk);
  });

  instance.companies.sort(Company.sortByVirkIDnr);


  // Clear headers.
  headers = [];
  csvFile = new File(config.employee);
  buffer = csvFile.readAsStringSync();

    decodedCsv = decoder.convert(buffer);

    /// Cherry-pick the headers.
    headers = decodedCsv.removeAt(0);
    print ('Headers: $headers');

    decodedCsv.forEach((List<String> rowElements) {
      int column = 0;
      Map value  = {};
      rowElements.forEach((var element) {
        value[headers[column]] = element;
        column++;
      });

      Employee med = mapMedarbejder(value);
      instance.employees.add(med);
    });

  instance.employees.sort(Employee.sortByMedID);

  String startFile    = config.calendarStartFile;
  String endFile      = config.calendarEndFile;
  String messageFile  = config.calendarMessageFile;
  String usernameFile = config.calendarUsernameFile;

  instance.calendar = readCalendarFiles(startFile, endFile, messageFile, usernameFile);

  return instance;
}

Company mapVirksomhed(Map<String, String> tokens) {
  Company virksomhed = new Company()
    ..VirkIDnr = int.parse(tokens['VirkIDnr'])
    ..VirkNavn = tokens['VirkNavn']
    ..VirkPostnr = parseInt(tokens['VirkPostnr'])
    ..VirkPostnr2 = parseInt(tokens['VirkPostnr2'])
    ..VirkTlf1 = tokens['VirkTlf1']
    ..VirkTlf2 = tokens['VirkTlf2']
    ..VirkFax1 = tokens['VirkFax1']
    ..VirkFax2 = tokens['VirkFax2']
    ..VirkTH_nr = tokens['VirkTH-nr']
    ..VirkAktion = tokens['VirkAktion']
    ..VirkHaster_nr = tokens['VirkHaster_nr']
    ..VirkCVR = tokens['VirkCVR']
    ..VirkBank_konto = tokens['VirkBank_konto']
    ..VirkGiro_konto = tokens['VirkGiro_konto']
    ..VirkEmail = tokens['VirkEmail']
    ..VirkTHmail = tokens['VirkTHmail']
    ..VirkWWW = tokens['VirkWWW']
    ..VirkKontortid = tokens['VirkKontortid']
    ..VirkProduktbesk = tokens['VirkProduktbesk']
    ..VirkNote = tokens['VirkNote']
    ..VirkVelkomst = tokens['VirkVelkomst']
    ..Virkbeliggenhed = tokens['Virkbeliggenhed']
    ..VirkMaxKald = tokens['VirkMaxKald']
    ..VirkPrisPrKald = tokens['VirkPrisPrKald']
    ..VirkAgenter = tokens['VirkAgenter']
    ..Macro1App = tokens['Macro1App']
    ..Macro2App = tokens['Macro2App']
    ..Macro1Params = tokens['Macro1Params']
    ..Macro2Params = tokens['Macro2Params']
    ..sidste_data_tjek = tokens['sidste_data_tjek']
    ..data_kontakt = tokens['data_kontakt']
    ..Macro1Alarm = tokens['Macro1Alarm']
    ..Macro2Alarm = tokens['Macro2Alarm']
    ..VirkVigtigInfo = tokens['VirkVigtigInfo']
    ..VirkAdr1 = tokens['VirkAdr1']
    ..VirkAdr2 = tokens['VirkAdr2']
    ..VirkPostby = tokens['VirkPostby']
    ..VirkPostby2 = tokens['VirkPostby2'];

  return virksomhed;
}

Employee mapMedarbejder(Map<String, String> tokens) {
  Employee medarbejder = new Employee()
    ..MedID = parseInt(tokens['MedID'])
    ..MedNavn = tokens['MedNavn']
    ..VirkID = parseInt(tokens['VirkID'])
    ..MedStilling = tokens['MedStilling']
    ..MedFoedselsdag = tokens['MedFødselsdag']
    ..MedAfd = tokens['MedAfd']
    ..MedEmail = tokens['MedEmail']
    ..MedPrivatEmail = tokens['MedPrivatEmail']
    ..MedAdr = tokens['MedAdr']
    ..MedPostnr = tokens['MedPostnr']
    ..MedPostby = tokens['MedPostby']
    ..MedAnsvarsomraade = tokens['MedAnsvarsområde']
    ..MedNote = tokens['MedNote']
    ..MedDirTlf = tokens['MedDirTlf']
    ..MedDirLokalnr = tokens['MedDirLokalnr']
    ..MedDirTlfOpl = tokens['MedDirTlfOpl']
    ..MedMobil = tokens['MedMobil']
    ..MedMobilOpl = tokens['MedMobilOpl']
    ..MedDirFax = tokens['MedDirFax']
    ..MedHasterTlf = tokens['MedHasterTlf']
    ..MedHasterTlfOpl = tokens['MedHasterTlfOpl']
    ..MedPrivTlf = tokens['MedPrivTlf']
    ..MedPrivTlfOpl = tokens['MedPrivTlfOpl']
    ..MedSMS = tokens['MedSMS']
    ..MedTHMail = tokens['MedTHMail']
    ..MedAktionAften = tokens['MedAktionAften']
    ..statusmail = tokens['statusmail']
    ..MedIngenGem = tokens['MedIngenGem']
    ..MedIngenFax = tokens['MedIngenFax']
    ..MedIngenEmail = tokens['MedIngenEmail']
    ..MedIngenSMS = tokens['MedIngenSMS']
    ..MedStdBesked = tokens['MedStdBesked']
    ..MedPrimNummer = tokens['MedPrimNummer'];

  return medarbejder;
}

int parseInt(String text) {
  try {
    return int.parse(text);
  } catch(e) {
    return null;
  }
}
