import 'package:hive/hive.dart';
import 'package:opdsure/model/client/client_box.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/database_api/database_api.dart';

class OpdDatabaseApi extends DatabaseApi{
  static const int version = 1;
  final String name;
  late Box<OpdClient> _clientBox;

  OpdDatabaseApi(this.name);

  @override
  Future<ClientBox> getClient(String name) {
    // TODO: implement getClient
    throw UnimplementedError();
  }

  @override
  Future insertClient(String baseUri, String accessToken, String userId) {
    // TODO: implement insertClient
    throw UnimplementedError();
  }

  @override
  Future updateClient(String baseUri, String accessToken, String userId) {
    // TODO: implement updateClient
    throw UnimplementedError();
  }

  
}