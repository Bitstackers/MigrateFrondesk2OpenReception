part of adaheads.model;

class Phone {
  int id;
  String value;
  String kind;
  String description;
  String billingType; //Landline, mobile, which foreign country
  List<String> tag; //tags
  bool confidential = false;

  Phone();

  Map toJson() => {
    'id': id != null ? id : 0,
    'value': value != null ? value : '',
    'kind': kind != null ? kind : '',
    'description': description != null ? description : '',
    'billing_type': billingType != null ? billingType : '',
    'tag': tag != null ? tag : [],
    'confidential': confidential != null ? confidential : false};
}

