part of adaheads.model;

class Reception {
  int id;
  int organization_id;
  String full_name;
  String uri;
  String product;
  String other;
  String greeting;
  String shortgreeting;
  List<String> customertype;
  String extradatauri;
  bool enabled;
  String receptionNumber;

  List<String> addresses = [];
  List<String> alternatenames = [];
  List<String> bankinginformation = [];
  List<String> salesCalls = [];
  List<String> emailaddresses = [];
  List<String> handlings = [];
  List<String> openinghours = [];
  List<String> registrationnumbers = [];
  List<Phone> telephonenumbers = [];
  List<String> websites = [];

  Map get attributes =>
    {
    OR.ReceptionJSONKey.PRODUCT: product != null ? product : '',
    OR.ReceptionJSONKey.OTHER: other != null ? other : '',
    OR.ReceptionJSONKey.GREETING: greeting != null ? greeting : '',
    OR.ReceptionJSONKey.SHORT_GREETING: shortgreeting != null ? shortgreeting : (greeting != null ? greeting : ''),
    OR.ReceptionJSONKey.CUSTOMER_TYPES: customertype != null ? customertype : [],
    OR.ReceptionJSONKey.ADDRESSES: addresses,
    OR.ReceptionJSONKey.ALT_NAMES: alternatenames,
    OR.ReceptionJSONKey.BANKING_INFO: bankinginformation,
    OR.ReceptionJSONKey.SALES_MARKET_HANDLING: salesCalls,
    OR.ReceptionJSONKey.EMAIL_ADDRESSES: emailaddresses,
    OR.ReceptionJSONKey.HANDLING_INSTRUCTIONS: handlings,
    OR.ReceptionJSONKey.OPENING_HOURS: openinghours,
    OR.ReceptionJSONKey.VAT_NUMBERS: registrationnumbers,
    OR.ReceptionJSONKey.PHONE_NUMBERS: telephonenumbers,
    OR.ReceptionJSONKey.WEBSITES: websites
    };

  /**
   * Default constructor
   */
  Reception();

  String toJson() {
    Map data = {
      OR.ReceptionJSONKey.ID: id,
      OR.ReceptionJSONKey.ORGANIZATION_ID: organization_id,
      OR.ReceptionJSONKey.FULL_NAME: full_name,
      OR.ReceptionJSONKey.EXTRADATA_URI: uri,
      OR.ReceptionJSONKey.ENABLED: enabled,
      OR.ReceptionJSONKey.EXTENSION: receptionNumber,
      OR.ReceptionJSONKey.ATTRIBUTES: attributes
    };

    return JSON.encode(data);
  }
}