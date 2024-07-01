import 'package:opdsure/model/client/client_box.dart';

abstract class DatabaseApi{

Future<ClientBox?> getClient(String name);

Future updateClient(ClientBox clientBox);

Future insertClient(
    String baseUri,
    String accessToken,
    String userId
    );

}