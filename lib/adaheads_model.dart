library adaheads.model;

import 'dart:convert';

part 'adaheads_model/contact.dart';
part 'adaheads_model/organization.dart';
part 'adaheads_model/phone.dart';
part 'adaheads_model/reception.dart';
part 'adaheads_model/reception_contact.dart';

String stringFromJson(Map json, String key) {
  if(json.containsKey(key)) {
    return json[key];
  } else {
    print('Key "$key" not found in "${json}"');
    return null;
  }
}

List<String> priorityListFromJson(Map json, String key) {
  try {
    if(json.containsKey(key) && json[key] is List) {
      List<Map> rawList = json[key];
      List<String> list = new List<String>();

      rawList.sort((a, b) => a['priority'] - b['priority']);
      //Sorte by priority.
      for(Map item in json[key]) {
        list.add(item['value']);
      }
      return list;
    } else {
      return null;
    }
  } catch(e) {
    //log Error.
    print('"$e key: "$key" json: "$json"');
    return null;
  }
}

List priorityListToJson(List<String> list) {
  if(list == null) return null;

  List<Map> result = new List<Map>();

  int priority = 1;
  for(String item in list) {
    result.add({
      'priority': priority,
      'value': item
    });
  }

  return result;
}
