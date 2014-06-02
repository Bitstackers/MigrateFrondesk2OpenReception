library utilities;

import 'adaheads_model.dart';

List<String> noEmptyStrings(Iterable<String> list) {
  if(list == null) return null;

  List<String> newlist = new List<String>();
  for(String text in list) {
    if(text != null && text.trim().isNotEmpty && text.trim() != 'null') {
      newlist.add(text.trim());
    }
  }
  return newlist;
}

Phone makePhone(int id, String number, String oplys, String beskrivelse, [String kind = 'PSTN']) {
  if(number == null || number.trim().isEmpty ||
     oplys == null || oplys.trim().isEmpty) {
    return null;
  }

  //TODO Do something more? Make a preCommit Check?
  if(numberIsBroken(number)) {
    return null;
  }

  Phone obj = new Phone()
    ..id = id
    ..confidential = oplys == '1' ? true : false
    ..description = beskrivelse
    ..kind = kind;

  //Extract the "real" number
  var components = number.trim().split(' ');
  obj.value = components[1];

  //And the bill type
  String billCode = components[0].substring(1,2);
  obj.bill_type = billCode;
  return obj;
}



bool numberIsBroken(String number, [bool verbose = false]) {
  if(number == null || number.isEmpty) {
    return false;
  }

  var components = number.trim().split(' ');
  if(components.length != 2) {
    if(verbose)print('components count. "${components.length}" "${components}"');
    return true;
  }

  String internalCode = components[0];

  if(internalCode.length != 5) {
    if(verbose)print('component 0 length. ${internalCode.length}');
    return true;
  }

  String billCode = internalCode.substring(1,2);
  if(billCode != '1' && billCode != '2' && components[1].length == 8) {
    if(verbose)print('Billcode is 8 charaters long: billcode:"${billCode}" $internalCode');
    return true;
  }

  if(billCode == '0') {
    if(verbose)print('Invalid billcode: ${billCode}');
    return true;
  }

  return false;
}

String removeLeadingDots(String text) {
  if(text == null || text.isEmpty || !text.startsWith('.')) {
    return text;
  }

  String name = text;
  while(name.startsWith('.')) {
    name = name.substring(1);
  }

  return name;
}
