

import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/database_api/opd_database_api.dart';

import 'database_api.dart';

Future<DatabaseApi> opdDatabaseBuilder(OpdClient client) async {
  final database = OpdDatabaseApi(client.clientName);
  await database.open();
  return database;
}