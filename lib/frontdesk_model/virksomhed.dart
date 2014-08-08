part of frontdesk.model;

class Company {
  int VirkIDnr;
  String VirkNavn;
  int VirkPostnr;
  int VirkPostnr2;
  String VirkTlf1;
  String VirkTlf2;
  String VirkFax1;
  String VirkFax2;
  String VirkTH_nr;
  String VirkAktion;
  String VirkHaster_nr;
  String VirkCVR;
  String VirkBank_konto;
  String VirkGiro_konto;
  String VirkEmail;
  String VirkTHmail;
  String VirkWWW;
  String VirkKontortid;
  String VirkProduktbesk;
  String VirkNote;
  String VirkVelkomst;
  String Virkbeliggenhed;
  String VirkMaxKald;
  String VirkPrisPrKald;
  String VirkAgenter;
  String Macro1App;
  String Macro2App;
  String Macro1Params;
  String Macro2Params;
  String sidste_data_tjek;
  String data_kontakt;
  String Macro1Alarm;
  String Macro2Alarm;
  String VirkVigtigInfo;
  String VirkAdr1;
  String VirkAdr2;
  String VirkPostby;
  String VirkPostby2;

  Map toJson() => {
    'VirkIDnr': VirkIDnr,
    'VirkNavn': VirkNavn,
    'VirkPostnr': VirkPostnr,
    'VirkPostnr2': VirkPostnr2,
    'VirkTlf1': VirkTlf1,
    'VirkTlf2': VirkTlf2,
    'VirkFax1': VirkFax1,
    'VirkFax2': VirkFax2,
    'VirkTH_nr': VirkTH_nr,
    'VirkAktion': VirkAktion,
    'VirkHaster_nr': VirkHaster_nr,
    'VirkCVR': VirkCVR,
    'VirkBank_konto': VirkBank_konto,
    'VirkGiro_konto': VirkGiro_konto,
    'VirkEmail': VirkEmail,
    'VirkTHmail': VirkTHmail,
    'VirkWWW': VirkWWW,
    'VirkKontortid': VirkKontortid,
    'VirkProduktbesk': VirkProduktbesk,
    'VirkNote': VirkNote,
    'VirkVelkomst': VirkVelkomst,
    'Virkbeliggenhed': Virkbeliggenhed,
    'VirkMaxKald': VirkMaxKald,
    'VirkPrisPrKald': VirkPrisPrKald,
    'VirkAgenter': VirkAgenter,
    'Macro1App': Macro1App,
    'Macro2App': Macro2App,
    'Macro1Params': Macro1Params,
    'Macro2Params': Macro2Params,
    'sidste_data_tjek': sidste_data_tjek,
    'data_kontakt': data_kontakt,
    'Macro1Alarm': Macro1Alarm,
    'Macro2Alarm': Macro2Alarm,
    'VirkVigtigInfo': VirkVigtigInfo,
    'VirkAdr1': VirkAdr1,
    'VirkAdr2': VirkAdr2,
    'VirkPostby': VirkPostby,
    'VirkPostby2': VirkPostby2
  };

  static int sortByVirkIDnr(Company a, Company b) => a.VirkIDnr.compareTo(b.VirkIDnr);
}
