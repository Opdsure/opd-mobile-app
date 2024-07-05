import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/client/client_manager.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_sure_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/firebase_options.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final store = await SharedPreferences.getInstance();
  final clients = await ClientManager.getClients(store: store);

  if (PlatformInfos.isAndroid && AppLifecycleState.detached == WidgetsBinding.instance.lifecycleState) {
    WidgetsBinding.instance.addObserver(AppStarter(clients, store));
  }
 await startGui(clients, store);
}

Future<void> startGui(List<OpdClient> clients, SharedPreferences store) async {

 // ErrorWidget.builder = (details) => FluffyChatErrorWidget(details);
  runApp(OpdSureApp(clients : clients, store: store,));
}


class AppStarter with WidgetsBindingObserver {
  bool guiStarted = false;
  SharedPreferences store;
  List<OpdClient> clients;

  AppStarter(this.clients, this.store);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (guiStarted) return;
    if (state == AppLifecycleState.detached) return;

    startGui(clients, store);
    // We must make sure that the GUI is only started once.
    guiStarted = true;
  }
}