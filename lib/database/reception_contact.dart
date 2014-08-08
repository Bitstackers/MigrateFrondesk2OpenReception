part of adaheads.server.database;

Future<int> _createReceptionContact(Pool pool, int receptionId, int contactId, bool wantMessages, List phonenumbers, Map distributionList, Map attributes, bool enabled, bool data_contact, bool status_email) {
  String sql = '''
    INSERT INTO reception_contacts (reception_id, contact_id, wants_messages, phonenumbers, distribution_list, attributes, enabled, data_contact, status_email)
    VALUES (@reception_id, @contact_id, @wants_messages, @phonenumbers, @distributionList, @attributes, @enabled, @data_contact, @status_email);
  ''';

  Map parameters =
    {'reception_id'         : receptionId,
     'contact_id'           : contactId,
     'wants_messages'       : wantMessages,
     'phonenumbers'         : phonenumbers == null ? '[]' : JSON.encode(phonenumbers),
     'distributionList'     : distributionList == null ? '{}' : JSON.encode(distributionList),
     'attributes'           : attributes == null ? '{}' : JSON.encode(attributes),
     'enabled'              : enabled,
     'data_contact': data_contact,
     'status_email': status_email};

  return execute(pool, sql, parameters);
}

Future<int> _deleteReceptionContact(Pool pool, int receptionId, int contactId) {
  String sql = '''
    DELETE FROM reception_contacts
    WHERE reception_id=@reception_id AND contact_id=@contact_id;
  ''';

  Map parameters = {'reception_id' : receptionId,
                    'contact_id'   : contactId};
  return execute(pool, sql, parameters);
}

Future<int> _updateReceptionContact(Pool pool, int receptionId, int contactId, bool wantMessages, List phonenumbers, Map attributes, bool enabled) {
  String sql = '''
    UPDATE reception_contacts
    SET wants_messages=@wants_messages,
        attributes=@attributes,
        enabled=@enabled,
        phonenumbers=@phonenumbers
    WHERE reception_id=@reception_id AND contact_id=@contact_id;
  ''';

  Map parameters =
    {'reception_id'         : receptionId,
     'contact_id'           : contactId,
     'wants_messages'       : wantMessages,
     'phonenumbers'         : phonenumbers == null ? '[]' : JSON.encode(phonenumbers),
     'attributes'           : attributes == null ? '{}' : JSON.encode(attributes),
     'enabled'              : enabled};

  return execute(pool, sql, parameters);
}

Future<List<adaheads_model.Organization>> _getAContactsOrganizationList(Pool pool, int contactId) {
  String sql = '''
    SELECT DISTINCT o.id, o.full_name, o.billing_type, o.flag
    FROM reception_contacts rc
    JOIN receptions r on rc.reception_id = r.id
    JOIN organizations o on r.organization_id = o.id
    WHERE rc.contact_id = @contact_id
  ''';

  Map parameters = {'contact_id': contactId};

  return query(pool, sql, parameters).then((rows) {
    List<adaheads_model.Organization> organizations = new List<adaheads_model.Organization>();
    for(var row in rows) {
      organizations.add(new adaheads_model.Organization(row.id, row.full_name, row.billing_type, row.flag));
    }
    return organizations;
  });
}
