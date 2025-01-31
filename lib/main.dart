import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/pages/otp_page/otp_page.dart';
import 'package:opdsure/pages/otp_page/otp_page_controller.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/client/client_manager.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_chat_error_widget.dart';
import 'package:opdsure/widget/opd_sure_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await SharedPreferences.getInstance();
  final clients = await ClientManager.getClients(store: store);

  if (PlatformInfos.isAndroid && AppLifecycleState.detached == WidgetsBinding.instance.lifecycleState) {
    WidgetsBinding.instance.addObserver(AppStarter(clients, store));

  }
  await startGui(clients, store);
}



Future<void> startGui(List<OpdClient> clients, SharedPreferences store) async {
  // if (kDebugMode) {
    ErrorWidget.builder = (details) => OpdSureErrorWidget(details);
  // }
  runApp(OpdSureApp(
    clients: clients,
    store: store,
  ));

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
    guiStarted = true;
  }
}
