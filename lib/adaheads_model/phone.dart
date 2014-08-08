part of adaheads.model;

class Phone {
  int id;
  String value;
  String kind;
  String description;
  String billingType; //Landline, mobile, which foreign country
  String tag; //tags
  bool confidential = false;

  Phone();

  factory Phone.fromJson(Map json) {
    Phone object = new Phone();
    object.id = json['id'];
    object.value = json['value'];
    object.kind = json['kind'];
    object.description = json['description'];
    object.billingType = json['billing_type'];
    object.tag = json['tag'];
    object.confidential = json.containsKey('confidential') ? json['confidential'] : false;

    return object;
  }

  Map toJson() => {
    'id': id != null ? id : 0,
    'value': value != null ? value : '',
    'kind': kind != null ? kind : '',
    'description': description != null ? description : '',
    'billing_type': billingType != null ? billingType : '',
    'tag': tag != null ? tag : '',
    'confidential': confidential != null ? confidential : false};
}

