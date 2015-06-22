library configuration;

import 'dart:io';
import 'package:args/args.dart';

class Configuration {
  ArgResults    parsedArgs;
  ArgParser     parser = new ArgParser();

  String get company    => parsedArgs['company'];
  String get employee   => parsedArgs['employee'];
  String get dbuser     => parsedArgs['dbuser'];
  String get dbpassword => parsedArgs['dbpassword'];
  String get dbhost     => parsedArgs['dbhost'];
  int    get dbport     => int.parse(parsedArgs['dbport']);
  String get dbname     => parsedArgs['dbname'];

  String get calendarStartFile    => parsedArgs['calendarstartfile'];
  String get calendarEndFile      => parsedArgs['calendarendfile'];
  String get calendarMessageFile  => parsedArgs['calendarmessagefile'];
  String get calendarUsernameFile => parsedArgs['calendarusernamefile'];

  String _seperator = ';';
  String get seperator => _seperator;

  Configuration._();

  factory Configuration(List<String> arguments) {
    Configuration config = new Configuration._();
    config.parsedArgs = config._registerAndParseCommandlineArguments(arguments);

    return config;
  }

  ArgResults _registerAndParseCommandlineArguments(List<String> arguments) {
    parser.addFlag  ('help', abbr: 'h', help: 'Output this help');
    parser.addOption('company',         help: 'The database user');
    parser.addOption('employee',        help: 'The database user');
    parser.addOption('dbuser',          help: 'The database user');
    parser.addOption('dbpassword',      help: 'The database password');
    parser.addOption('dbhost',          help: 'The database host. Defaults to localhost');
    parser.addOption('dbport',          help: 'The database port. Defaults to 5432');
    parser.addOption('dbname',          help: 'The database name');

    parser.addOption('calendarstartfile',    help: 'The calendar file for start timestamp');
    parser.addOption('calendarendfile',      help: 'The calendar file for end timestamp');
    parser.addOption('calendarmessagefile',  help: 'The calendar file for messages');
    parser.addOption('calendarusernamefile', help: 'The calendar file for user ids');

    return parser.parse(arguments);
  }

  bool showHelp() => parsedArgs['help'];
  String getUsage() => parser.getUsage;
  bool isValid() => _validArguments();

  bool _validArguments() {
    if(!_hasArgument('company', parsedArgs)) {
      print('Missing argument company');
      return false;
    } else {
      File file = new File(parsedArgs['company']);
      if(!file.existsSync()) {
        print('Missing file ${parsedArgs['company']}');
        return false;
      }
    }

    if(!_hasArgument('employee', parsedArgs)) {
      print('Missing argument employee');
      return false;
    } else {
      File file = new File(parsedArgs['employee']);
      if(!file.existsSync()) {
        print('Missing file ${parsedArgs['employee']}');
        return false;
      }
    }

    if(!_hasArgument('dbuser', parsedArgs)) {
      print('Missing argument dbuser');
      return false;
    }

    if(!_hasArgument('dbpassword', parsedArgs)) {
      print('Missing argument dbpassword');
      return false;
    }

    if(!_hasArgument('dbhost', parsedArgs)) {
      print('Missing argument dbhost');
      return false;
    }

    if(!_hasArgument('dbport', parsedArgs)) {
      print('Missing argument dbport');
      return false;
    }

    if(!_hasArgument('dbname', parsedArgs)) {
      print('Missing argument dbname');
      return false;
    }

    //Calendar Files
    if(!_hasArgument('calendarstartfile', parsedArgs)) {
      print('Missing argument calendarstartfile');
      return false;
    } else {
      File file = new File(parsedArgs['calendarstartfile']);
      if(!file.existsSync()) {
        print('Missing file ${parsedArgs['calendarstartfile']}');
        return false;
      }
    }

    if(!_hasArgument('calendarendfile', parsedArgs)) {
      print('Missing argument calendarendfile');
      return false;
    } else {
      File file = new File(parsedArgs['calendarendfile']);
      if(!file.existsSync()) {
        print('Missing file ${parsedArgs['calendarendfile']}');
        return false;
      }
    }

    if(!_hasArgument('calendarmessagefile', parsedArgs)) {
      print('Missing argument calendarmessagefile');
      return false;
    } else {
      File file = new File(parsedArgs['calendarmessagefile']);
      if(!file.existsSync()) {
        print('Missing file ${parsedArgs['calendarmessagefile']}');
        return false;
      }
    }

    if(!_hasArgument('calendarusernamefile', parsedArgs)) {
      print('Missing argument calendarusernamefile');
      return false;
    } else {
      File file = new File(parsedArgs['calendarusernamefile']);
      if(!file.existsSync()) {
        print('Missing file ${parsedArgs['calendarusernamefile']}');
        return false;
      }
    }

    return true;
  }

  bool _hasArgument(String key, ArgResults args) =>
      args.options.contains(key) && args[key] != null && args[key].trim() != '';

  String toString() =>'''
    Virksomhedsfil: $company
    Medarbejderfil: $employee
    Database:
      Host: $dbhost
      Port: $dbport
      User: $dbuser
      Pass: ${dbpassword.codeUnits.map((_) => '*').join()}
      Name: $dbname
    
    Calendar:
      Start  : $calendarStartFile
      End    : $calendarEndFile
      Message: $calendarMessageFile
      user   : $calendarUsernameFile
  ''';
}
