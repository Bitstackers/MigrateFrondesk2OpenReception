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
      'product': product != null ? product : '',
      'other': other != null ? other : '',
      'greeting': greeting != null ? greeting : '',
      'short_greeting': shortgreeting != null ? shortgreeting : (greeting != null ? greeting : ''),
      'customertypes': customertype != null ? customertype : [],
      'addresses': addresses,
      'alternatenames': alternatenames,
      'bankinginformation': bankinginformation,
      'salescalls': salesCalls,
      'emailaddresses': emailaddresses,
      'handlings': handlings,
      'openinghours': openinghours,
      'registrationnumbers': registrationnumbers,
      'telephonenumbers': telephonenumbers,
      'websites': websites
    };

  /**
   * Default constructor
   */
  Reception();

  String toJson() {
    Map data = {
      'id': id,
      'orgaanization_id': organization_id,
      'full_name': full_name,
      'uri': uri,
      'enabled': enabled,
      'number': receptionNumber,
      'attributes': attributes
    };

    return JSON.encode(data);
  }
}