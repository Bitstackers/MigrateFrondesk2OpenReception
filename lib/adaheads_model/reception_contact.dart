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

  List<String> get backup => _attributes[Key.backup];
  void set backup(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.backup] = list;
  }

  List<String> get emailaddresses => _attributes[Key.emailaddresses];
  void set emailaddresses(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.emailaddresses] = list;
  }

  List<String> get handling => _attributes[Key.handling];
  void set handling(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.handling] = list;
  }

  List<String> get workhours => _attributes[Key.workhours];
  void set workhours(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.workhours] = list;
  }

  List<String> get tags => _attributes[Key.tags];
  void set tags(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.tags] = list;
  }

  List<String> get department => _attributes[Key.departments];
  void set department(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.departments] = value;
  }

  List<String> get info => _attributes[Key.infos];
  void set info(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.infos] = value;
  }

  List<String> get position => _attributes[Key.titles];
  void set position(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.titles] = value;
  }

  List<String> get relations => _attributes[Key.relations];
  void set relations(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.relations] = value;
  }

  List<String> get responsibility => _attributes[Key.responsibilities];
  void set responsibility(List<String> value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes[Key.responsibilities] = value;
  }

  ReceptionContact() {
    attributes = {
      Key.departments: [],
      Key.infos: [],
      Key.titles: [],
      Key.relations: [],
      Key.responsibilities: [],
      Key.backup: [],
      Key.emailaddresses: [],
      Key.handling: [],
      Key.workhours: [],
      Key.tags: [],
    };
  }

  String toJson() {
    Map data = {
      Key.contactID : contactId,
      Key.receptionID: receptionId,
      Key.wantsMessages: wantsMessages,
      Key.enabled: contactEnabled,
      Key.phones : phoneNumbers,
      'attributes': attributes
    };

    return JSON.encode(data);
  }
}
