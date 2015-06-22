part of adaheads.model;

class ReceptionContact {
  int contactId;
  bool contactEnabled;
  int receptionId;
  bool wantsMessages;
  List<Phone> phoneNumbers;

  bool dataContact = false;
  bool statusEmail = true;

  Map _attributes;

  Map get attributes => _attributes;

  void set attributes (Map value) {
    _attributes = value;
  }

  List<String> get backup => _attributes[OR.ContactJSONKey.backup];
  void set backup(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.backup] = list;
  }

  List<String> get emailaddresses => _attributes[OR.ContactJSONKey.emailaddresses];
  void set emailaddresses(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.emailaddresses] = list;
  }

  List<String> get handling => _attributes[OR.ContactJSONKey.handling];
  void set handling(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.handling] = list;
  }

  List<String> get workhours => _attributes[OR.ContactJSONKey.workhours];
  void set workhours(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.workhours] = list;
  }

  List<String> get tags => _attributes[OR.ContactJSONKey.tags];
  void set tags(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.tags] = list;
  }

  List<String> get department => _attributes[OR.ContactJSONKey.departments];
  void set department(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.departments] = value;
  }

  List<String> get info => _attributes[OR.ContactJSONKey.infos];
  void set info(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.infos] = value;
  }

  List<String> get position => _attributes[OR.ContactJSONKey.titles];
  void set position(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.titles] = value;
  }

  List<String> get relations => _attributes[OR.ContactJSONKey.relations];
  void set relations(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.relations] = value;
  }

  List<String> get responsibility => _attributes[OR.ContactJSONKey.responsibilities];
  void set responsibility(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[OR.ContactJSONKey.responsibilities] = value;
  }

  ReceptionContact() {
    attributes = {
      OR.ContactJSONKey.departments: [],
      OR.ContactJSONKey.infos: [],
      OR.ContactJSONKey.titles: [],
      OR.ContactJSONKey.relations: [],
      OR.ContactJSONKey.responsibilities: [],
      OR.ContactJSONKey.backup: [],
      OR.ContactJSONKey.emailaddresses: [],
      OR.ContactJSONKey.handling: [],
      OR.ContactJSONKey.workhours: [],
      OR.ContactJSONKey.tags: [],
    };
  }

  String toJson() {
    Map data = {
      OR.ContactJSONKey.contactID : contactId,
      OR.ContactJSONKey.receptionID: receptionId,
      OR.ContactJSONKey.wantsMessages: wantsMessages,
      OR.ContactJSONKey.enabled: contactEnabled,
      OR.ContactJSONKey.phones : phoneNumbers,
      'attributes': attributes
    };

    return JSON.encode(data);
  }
}
