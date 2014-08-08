part of frontdesk.model;

class CalendarEntry {
  DateTime start;
  DateTime end;
  String message;
  String user;

  int get userId => int.parse(user);
}
