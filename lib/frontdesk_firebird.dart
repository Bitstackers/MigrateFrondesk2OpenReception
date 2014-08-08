library Firebird;

import 'dart:io';

import 'frontdesk_model.dart';

List<CalendarEntry> readCalendarFiles(String startFile, String endFile, String messageFile, String usernameFile) {
  List<CalendarEntry> calendarEntries = new List<CalendarEntry>();

  List<String> endDates = _readFirebirdFile(endFile);
  List<String> shortmess = _readFirebirdFile(messageFile);
  List<String> startdate = _readFirebirdFile(startFile);
  List<String> username = _readFirebirdFile(usernameFile);

  if(endDates.length != shortmess.length ||
     endDates.length != startdate.length ||
     endDates.length != username.length) {
    print('The difference Firebird Calendar files, is not of the same length.');
    print('Start: ${startdate.length}');
    print('End: ${endDates.length}');
    print('Message: ${shortmess.length}');
    print('Username: ${username.length}');
  } else {
    int limit = endDates.length;
    for(int index = 0; index < limit; index += 1) {
      CalendarEntry entry = new CalendarEntry()
        ..end = DateTime.parse(endDates[index])
        ..message = shortmess[index]
        ..start = DateTime.parse(startdate[index])
        ..user = username[index];

      calendarEntries.add(entry);
    }
  }

  return calendarEntries;
}

List<String> _readFirebirdFile(String path) {
  File file = new File(path);
  String rawContent = file.readAsStringSync();
  return rawContent.split('\n')
      .map((String t) => t.trim())
      .where((String text) => text.isNotEmpty)
      .toList();
}