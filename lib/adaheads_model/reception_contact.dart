part of adaheads.model;

class ReceptionContact {
  int contactId;
  bool contactEnabled;
  int receptionId;
  bool wantsMessages;
  Map distributionList;
  List<Phone> phoneNumbers;

  bool dataContact = false;
  bool statusEmail = true;

  Map _attributes;

  Map get attributes => _attributes;

  void set attributes (Map value) {
    _attributes = value;
  }

  List<String> get backup => priorityListFromJson(_attributes, 'backup');
  void set backup(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['backup'] = priorityListToJson(list);
  }

  List<String> get emailaddresses => priorityListFromJson(_attributes, 'emailaddresses');
  void set emailaddresses(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['emailaddresses'] = priorityListToJson(list);
  }

  List<String> get handling => priorityListFromJson(_attributes, 'handling');
  void set handling(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['handling'] = priorityListToJson(list);
  }

  List<String> get workhours => priorityListFromJson(_attributes, 'workhours');
  void set workhours(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['workhours'] = priorityListToJson(list);
  }

  List<String> get tags => _attributes['tags'];
  void set tags(List<String> list) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['tags'] = list;
  }

  String get department => _attributes['department'];
  void set department(String value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['department'] = value;
  }

  String get info => _attributes['info'];
  void set info(String value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['info'] = value;
  }

  String get position => _attributes['position'];
  void set position(String value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['position'] = value;
  }

  String get relations => _attributes['relations'];
  void set relations(String value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['relations'] = value;
  }

  String get responsibility => _attributes['responsibility'];
  void set responsibility(String value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['responsibility'] = value;
  }

  String get branch => _attributes['branch'];
  void set branch(String value) {
    if(_attributes == null) {
      _attributes = {};
    }
    _attributes['branch'] = value;
  }

  ReceptionContact() {
    distributionList = new Map();

    attributes = {
      'department': '',
      'info': '',
      'position': '',
      'relations': '',
      'responsibility': '',
      'backup': [],
      'emailaddresses': [],
      'handling': [],
      //'telephonenumbers': priorityListToJson(telephonenumbers),
      'workhours': [],
      'tags': [],
      'branch': ''
    };
  }

  factory ReceptionContact.fromJson(Map json) {
    ReceptionContact object = new ReceptionContact()
      ..contactId = json['contact_id']
      ..contactEnabled = json['contact_enabled']
      ..receptionId = json['reception_id']
      ..wantsMessages = json['wants_messages']
      ..distributionList = json['distributionList']
      ..phoneNumbers = (json['contact_phonenumbers'] as List<Map>).map((Map json) => new Phone.fromJson(json)).toList();

    if (json.containsKey('attributes')) {
      Map attr = json['attributes'];
      for(String key in attr) {
        object._attributes[key] = attr[key];
      }
    }

    return object;
  }

  String toJson() {
    Map data = {
      'contact_id': contactId,
      'reception_id': receptionId,
      'wants_messages': wantsMessages,
      'enabled': contactEnabled,
      'phonenumbers' : phoneNumbers,
      'attributes': attributes
    };

    return JSON.encode(data);
  }
}
