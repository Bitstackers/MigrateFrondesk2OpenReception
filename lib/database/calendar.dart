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

Future _createContactCalendarEntry(Pool pool,
                                   int receptionID, int contactID,
                                   DateTime start, DateTime stop,
                                   int userID, String content) {
  String sql = '''
WITH new_event AS(
  INSERT INTO calendar_events (start, stop, message)
    VALUES (@start, @end, @content)
    RETURNING id as event_id
),
entry_change AS (
  INSERT INTO calendar_entry_changes (user_id, entry_id)
    SELECT @userID, event_id
    FROM new_event
    RETURNING entry_id as event_id
)

INSERT INTO contact_calendar 
  (reception_id, 
   contact_id,
   event_id)
SELECT 
  @receptionID,
  @contactID,
  event_id
FROM entry_change
RETURNING event_id
''';

  Map parameters =
    {'receptionID'      : receptionID,
     'contactID'        : contactID,
     'start'            : start,
     'end'              : stop,
     'userID'           : userID,
     'content'          : content};


  return execute(pool, sql, parameters);
}


