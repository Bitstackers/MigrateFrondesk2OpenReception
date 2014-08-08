part of adaheads.server.database;

Future<int> _createCalendarEvent(Pool pool, DateTime start, DateTime stop, String message) {
  String sql = '''
    INSERT INTO calendar_events (start, stop, message)
    VALUES (@start, @end, @message)
    RETURNING id;
  ''';

  Map parameters =
    {'start'   : start,
     'end'     : stop,
     'message' : message};

  return query(pool, sql, parameters).then((rows) => rows.first.id);
}

Future _createContactEvent(Pool pool, int receptionId, int contactId, int eventId) {
  String sql = '''
  INSERT INTO contact_calendar(reception_id, contact_id, event_id)
  VALUES (@reception_id, @contact_id, @event_id);
''';

  Map parameters =
    {'reception_id' : receptionId,
     'contact_id'   : contactId,
     'event_id'     : eventId};

  return execute(pool, sql, parameters);
}
