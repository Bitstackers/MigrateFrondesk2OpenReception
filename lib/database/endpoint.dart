part of adaheads.server.database;

Future<int> _createEndpoint(Pool pool, adaheads_model.Endpoint endpoint) {
  String sql = '''
    INSERT INTO messaging_end_points (contact_id, reception_id, address, address_type, confidential, enabled, priority, description)
    VALUES (@contactid, @receptionid, @address, @addresstype, @confidential, @enabled, @priority, @description);
  ''';

  Map parameters =
    {'receptionid' : endpoint.receptionId,
     'contactid'   : endpoint.contactId,
     'address'     : endpoint.address,
     'addresstype' : endpoint.addressType,
     'confidential': endpoint.confidential,
     'enabled'     : endpoint.enabled,
     'priority'    : endpoint.priority,
     'description' : endpoint.description};

  return execute(pool, sql, parameters);
}
