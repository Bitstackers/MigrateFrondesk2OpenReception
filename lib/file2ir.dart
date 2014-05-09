library File2Ir;

import 'dart:io';

import 'package:csvparser/csvparser.dart';

import 'configuration.dart';
import 'frontdesk_model.dart';

AccessInstance Convert(Configuration config) {
  AccessInstance instance = new AccessInstance();

  File VirkFile = new File(config.company);
  String VirkData = VirkFile.readAsStringSync();
  CsvParser cp = new CsvParser(VirkData, seperator:';', quotemark:'"', lineend: '\n', setHeaders: true);
  while(cp.moveNext()) {
    Map<String, String> tokens = cp.current.toMap(cp.headers);
    Virksomhed virk = mapVirksomhed(tokens);
    instance.virksomheder.add(virk);
  }
  instance.virksomheder.sort((a,b) => a.VirkIDnr.compareTo(b.VirkIDnr));

  File MedFile = new File(config.employee);
  String MedData = MedFile.readAsStringSync();
  cp = new CsvParser(MedData, seperator:';', quotemark:'"', lineend: '\n', setHeaders: true);
  while(cp.moveNext()) {
    Map<String, String> tokens = cp.current.toMap(cp.headers);
    Medarbejder med = mapMedarbejder(tokens);
    instance.medarbejder.add(med);
  }
  instance.medarbejder.sort((a,b) => a.MedID.compareTo(b.MedID));

  return instance;
}

Virksomhed mapVirksomhed(Map<String, String> tokens) {
  Virksomhed virksomhed = new Virksomhed()
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

Medarbejder mapMedarbejder(Map<String, String> tokens) {
  Medarbejder medarbejder = new Medarbejder()
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
