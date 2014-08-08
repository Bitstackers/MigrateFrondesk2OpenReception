library adaheads.server.database;

import 'dart:async';
import 'dart:convert';

import 'package:postgresql/postgresql_pool.dart';
import 'package:postgresql/postgresql.dart';

import 'adaheads_model.dart' as adaheads_model;
import 'configuration.dart';

part 'database/calendar.dart';
part 'database/contact.dart';
part 'database/endpoint.dart';
part 'database/organization.dart';
part 'database/reception.dart';
part 'database/reception_contact.dart';

Future<Database> setupDatabase(Configuration config) {
  Database db = new Database(config.dbuser, config.dbpassword, config.dbhost, config.dbport, config.dbname);
  return db.start().then((_) => db);
}

class Database {
  Pool pool;
  String user, password, host, name;
  int port, minimumConnections, maximumConnections;

  Database(String this.user, String this.password, String this.host, int this.port, String this.name, {int this.minimumConnections: 1, int this.maximumConnections: 10});

  Future start() {
    String connectString = 'postgres://${user}:${password}@${host}:${port}/${name}';

    pool = new Pool(connectString, min: minimumConnections, max: maximumConnections);
    return pool.start().then((_) => _testConnection());
  }

  void close() {
    pool.destroy();
  }

  Future _testConnection() => pool.connect().then((Connection conn) => conn.close());

  /* ***********************************************
     ***************** Reception *******************
  */

  Future<int> createReception(int organizationId, String fullName, Map attributes, String extradatauri, bool enabled, String number) =>
      _createReception(pool, organizationId, fullName, attributes, extradatauri, enabled, number);

  Future<int> deleteReception(int organizationId, int id) =>
      _deleteReception(pool, organizationId, id);

//  Future<List<adaheads_model.Reception>> getContactReceptions(int contactId) =>
//      _getContactReceptions(pool, contactId);

//  Future<adaheads_model.Reception> getReception(int organizationId, int receptionId) =>
//      _getReception(pool, organizationId, receptionId);

//  Future<List<adaheads_model.Reception>> getReceptionList() => _getReceptionList(pool);

  Future<int> updateReception(int organizationId, int id, String fullName, Map attributes, String extradatauri, bool enabled, String number) =>
      _updateReception(pool, organizationId, id, fullName, attributes, extradatauri, enabled, number);

//  Future<List<adaheads_model.Reception>> getOrganizationReceptionList(int organizationId) =>
//      _getOrganizationReceptionList(pool, organizationId);

  /* ***********************************************
     ****************** Contact ********************
  */

  Future<int> createContact(String fullName, String contact_type, bool enabled) =>
      _createContact(pool, fullName, contact_type, enabled);

  Future<int> deleteContact(int contactId) => _deleteContact(pool, contactId);

  Future<adaheads_model.Contact> getContact(int contactId) => _getContact(pool, contactId);

  Future<List<adaheads_model.Contact>> getContactList() => _getContactList(pool);

  Future<List<String>> getContactTypeList() => _getContactTypeList(pool);

  Future<List<adaheads_model.Contact>> getOrganizationContactList(int organizationId) =>
      _getOrganizationContactList(pool, organizationId);

//  Future<int> updateContact(int contactId, String fullName, String contact_type, bool enabled) =>
//      _updateContact(pool, contactId, fullName, contact_type, enabled);


  /* ***********************************************
     ***************** Endpoints *******************
   */

  Future<int> createEndpoint(adaheads_model.Endpoint endpoint) =>
      _createEndpoint(pool, endpoint);

  /* ***********************************************
     ************ Reception Contacts ***************
   */

  Future<int> createReceptionContact(
      int receptionId,
      int contactId,
      bool wantMessages,
      List phonenumbers,
      Map distributionList,
      Map attributes,
      bool enabled,
      bool data_contact,
      bool status_email) =>

      _createReceptionContact(
          pool,
          receptionId,
          contactId,
          wantMessages,
          phonenumbers,
          distributionList,
          attributes,
          enabled,
          data_contact,
          status_email);

  Future<int> deleteReceptionContact(int receptionId, int contactId) =>
      _deleteReceptionContact(pool, receptionId, contactId);

  Future<int> updateReceptionContact(int receptionId, int contactId, bool wantMessages, List phonenumbers, Map attributes, bool enabled) =>
      _updateReceptionContact(pool, receptionId, contactId, wantMessages, phonenumbers, attributes, enabled);

  /* ***********************************************
     *************** Organization ******************
   */

  Future<int> createOrganization(String fullName, String billingType, String flag) =>
      _createOrganization(pool, fullName, billingType, flag);

  Future<int> deleteOrganization(int organizationId) =>
      _deleteOrganization(pool, organizationId);

  Future<adaheads_model.Organization> getOrganization(int organizationId) =>
      _getOrganization(pool, organizationId);

  Future<List<adaheads_model.Organization>> getOrganizationList() =>
      _getOrganizationList(pool);

  Future<int> updateOrganization(int organizationId, String fullName, String billingType, String flag) =>
      _updateOrganization(pool, organizationId, fullName, billingType, flag);

  /* ***********************************************
     ****************** Calendar *******************
   */

  Future<int> createEvent(DateTime start, DateTime stop, String message) =>
      _createCalendarEvent(pool, start, stop, message);

  Future createContactEvent(int receptionId, int contactId, int eventId) =>
      _createContactEvent(pool, receptionId, contactId, eventId);
}

/* ***********************************************
   ***************** Utilities *******************
 */

Future<List<Row>> query(Pool pool, String sql, [Map parameters = null]) =>  pool.connect()
  .then((Connection conn) => conn.query(sql, parameters).toList()
  .whenComplete(() => conn.close()));

Future<int> execute(Pool pool, String sql, [Map parameters = null]) => pool.connect()
  .then((Connection conn) => conn.execute(sql, parameters)
  .whenComplete(() => conn.close()));
