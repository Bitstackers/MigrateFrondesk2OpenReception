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
    OR.PhoneNumberJSONKey.Value: value != null ? value : '',
    OR.PhoneNumberJSONKey.Type: kind != null ? kind : '',
    OR.PhoneNumberJSONKey.Description: description != null ? description : '',
    OR.PhoneNumberJSONKey.Billing_type: billingType != null ? billingType : '',
    OR.PhoneNumberJSONKey.Tag: tag != null ? tag : [],
    OR.PhoneNumberJSONKey.Confidential: confidential != null ? confidential : false};
}

