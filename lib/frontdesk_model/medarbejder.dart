part of frontdesk.model;

class Employee {
  int MedID;
  String MedNavn;
  int VirkID;
  String MedStilling;
  String MedFoedselsdag;
  String MedAfd;
  String MedEmail;
  String MedPrivatEmail;
  String MedAdr;
  String MedPostnr;
  String MedPostby;
  String MedAnsvarsomraade;
  String MedNote;
  String MedDirTlf;
  String MedDirLokalnr;
  String MedDirTlfOpl;
  String MedMobil;
  String MedMobilOpl;
  String MedDirFax;
  String MedHasterTlf;
  String MedHasterTlfOpl;
  String MedPrivTlf;
  String MedPrivTlfOpl;
  String MedSMS;
  String MedTHMail;
  String MedAktionAften;
  String statusmail;
  String MedIngenGem;
  String MedIngenFax;
  String MedIngenEmail;
  String MedIngenSMS;
  String MedStdBesked;
  String MedPrimNummer;

  Map toJson() => {
    'MedID': MedID,
    'MedNavn': MedNavn,
    'VirkID': VirkID,
    'MedStilling': MedStilling,
    'MedFoedselsdag': MedFoedselsdag,
    'MedAfd': MedAfd,
    'MedEmail': MedEmail,
    'MedPrivatEmail': MedPrivatEmail,
    'MedAdr': MedAdr,
    'MedPostnr': MedPostnr,
    'MedPostby': MedPostby,
    'MedAnsvarsomraade': MedAnsvarsomraade,
    'MedNote': MedNote,
    'MedDirTlf': MedDirTlf,
    'MedDirLokalnr': MedDirLokalnr,
    'MedDirTlfOpl': MedDirTlfOpl,
    'MedMobil': MedMobil,
    'MedMobilOpl': MedMobilOpl,
    'MedDirFax': MedDirFax,
    'MedHasterTlf': MedHasterTlf,
    'MedHasterTlfOpl': MedHasterTlfOpl,
    'MedPrivTlf': MedPrivTlf,
    'MedPrivTlfOpl': MedPrivTlfOpl,
    'MedSMS': MedSMS,
    'MedTHMail': MedTHMail,
    'MedAktionAften': MedAktionAften,
    'statusmail': statusmail,
    'MedIngenGem': MedIngenGem,
    'MedIngenFax': MedIngenFax,
    'MedIngenEmail': MedIngenEmail,
    'MedIngenSMS': MedIngenSMS,
    'MedStdBesked': MedStdBesked,
    'MedPrimNummer': MedPrimNummer
  };

  static int sortByMedID(Employee a, Employee b) => a.MedID.compareTo(b.MedID);
}
