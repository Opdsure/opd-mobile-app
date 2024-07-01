import 'package:hive/hive.dart';
import 'package:opdsure/model/client/client_box.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/database_api/database_api.dart';

class OpdDatabaseApi extends DatabaseApi{
  static const int version = 1;
  final String name;
  late Box<ClientBox> _clientBox;

  OpdDatabaseApi(this.name);

  @override
  Future<ClientBox?> getClient(String name) async  {
    return _clientBox.get(name, defaultValue: null);
  }

  @override
  Future insertClient(String baseUri, String accessToken, String userId) async {
    await _clientBox.put(
      name,
      ClientBox(
            userId: userId,
            accessToken: accessToken,
            baseServerUrl: baseUri),
    );
  }

  @override
  Future updateClient(ClientBox clientBox) async {
    await _clientBox.put(name, clientBox);
  }

  Future<void> open() async {
    Hive.registerAdapter(ClientBoxAdapter());
    _clientBox = await Hive.openBox(name);
  }
  
}