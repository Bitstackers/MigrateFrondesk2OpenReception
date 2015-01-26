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
  String customertype;
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
  List<String> telephonenumbers = [];
  List<String> websites = [];

  Map get attributes =>
    {
      'product': product != null ? product : '',
      'other': other != null ? other : '',
      'greeting': greeting != null ? greeting : '',
      'shortgreeting': shortgreeting != null ? shortgreeting : (greeting != null ? greeting : ''),
      'customertype': customertype != null ? customertype : '',
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

  Reception.fromDB(int this.id, int this.organization_id, String this.full_name, String this.uri, Map attributes, String this.extradatauri, bool this.enabled, String this.receptionNumber) {

  }

  factory Reception.fromJson(Map json) {
    Reception reception = new Reception()
      ..id = json['id']
      ..organization_id = json['organization_id']
      ..full_name = json['full_name']
      ..uri = json['uri']
      ..enabled = json['enabled'];

    if(json.containsKey('attributes')) {
      Map attributes = json['attributes'];

      reception
        ..product = stringFromJson(attributes, 'product')
        ..other = stringFromJson(attributes, 'other')
        ..greeting = stringFromJson(attributes, 'greeting')
        ..customertype = stringFromJson(attributes, 'customertype')

        ..addresses = attributes['addresses']
        ..alternatenames = attributes['alternatenames']
        ..bankinginformation = attributes['bankinginformation']
        ..salesCalls = attributes['salescalls']
        ..emailaddresses = attributes['emailaddresses']
        ..handlings = attributes['handlings']
        ..openinghours = attributes['openinghours']
        ..registrationnumbers = attributes['registrationnumbers']
        ..telephonenumbers = attributes['telephonenumbers']
        ..websites = attributes['websites'];
    }

    return reception;
  }

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