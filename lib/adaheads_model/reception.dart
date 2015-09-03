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

  Map get attributes => {
    Key.product: product != null ? product : '',
    Key.other: other != null ? other : '',
    Key.greeting: greeting != null ? greeting : '',
        Key.shortGreeting : shortgreeting != null
        ? shortgreeting
        : (greeting != null ? greeting : ''),
        Key.customerTypes:
        customertype != null ? customertype : [],
            Key.addresses: addresses,
            Key.alternateNames: alternatenames,
            Key.bankingInfo: bankinginformation,
            Key.salesMarketingHandling: salesCalls,
            Key.emailaddresses: emailaddresses,
            Key.handlingInstructions: handlings,
            Key.openingHours: openinghours,
            Key.vatNumbers: registrationnumbers,
    Key.phoneNumbers: telephonenumbers,
    Key.websites: websites
  };

  /**
   * Default constructor
   */
  Reception();

  String toJson() {
    Map data = {
      Key.ID: id,
      Key.organizationId: organization_id,
      Key.fullName: full_name,
      Key.extradataUri: uri,
      Key.enabled: enabled,
      Key.extension: receptionNumber,
      Key.attributes: attributes
    };

    return JSON.encode(data);
  }
}
