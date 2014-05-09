part of adaheads.model;

class Contact {
  int id;
  String fullName;
  String contactType;
  bool enabled;
  
  Map get attributes {
    return {};
  }
  
  Contact();
  
  Contact.fromDB(int this.id, String this.fullName, String this.contactType, bool this.enabled);
}
