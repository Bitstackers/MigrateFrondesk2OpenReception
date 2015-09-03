part of adaheads.model;

class Phone {
  String value;
  String kind;
  String description;
  String billingType; //Landline, mobile, which foreign country
  List<String> tag; //tags
  bool confidential = false;

  Phone();

  Map toJson() => {
    Key.value: value != null ? value : '',
    Key.type: kind != null ? kind : '',
    Key.description: description != null ? description : '',
    Key.billingType: billingType != null ? billingType : '',
    Key.tag: tag != null ? tag : [],
    Key.confidential: confidential != null ? confidential : false
  };
}
