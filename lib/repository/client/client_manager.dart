import 'package:hive_flutter/adapters.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/utils/logs/logs.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ClientManager{
  static const String clientNamespace = 'io.app.opd.sure.store.clients';

  static Future<List<OpdClient>> getClients({required SharedPreferences store}) async {
    await Hive.initFlutter();
    final clientNames = <String>{};
    try{
      final clientNamesList = store.getStringList(clientNamespace) ?? [];
      clientNames.addAll(clientNamesList);
    } catch (e, s){
      Logs().w('Client names in store are corrupted', e, s);
      await store.remove(clientNamespace);
    }
    if(clientNames.isEmpty){
      clientNames.add(PlatformInfos.clientName);
      await store.setStringList(clientNamespace, clientNames.toList());
    }
    final clients = clientNames.map(createClient).toList();

    if(clients.length > 1 && clients.any((c) => !c.isLogged)){
      final loggedOutClients = clients.where((c) => !c.isLogged).toList();
      for (final client in loggedOutClients) {
        Logs().w(
          'Multi account is enabled but client ${client.userID} is not logged in. Removing...',
        );
        clientNames.remove(client.clientName);
        clients.remove(client);
      }
      await store.setStringList(clientNamespace, clientNames.toList());
    }
    return clients;
  }

  static OpdClient createClient(String clientName){
    return OpdClient(clientName);
  }
}