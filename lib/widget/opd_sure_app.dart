import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/config/route.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/utils/custom_scroll_behaviour.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:opdsure/widget/theme_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/client/OpdClient.dart';


class OpdSureApp extends StatelessWidget {
  final Widget? testWidget;
  final SharedPreferences store;
  final List<OpdClient> clients;
  const OpdSureApp({
    required this.clients,
    required this.store,
    this.testWidget,
    super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(routes: AppRoutes.routes, navigatorKey: navigatorKey);
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (context, mode, color) => MaterialApp.router(
        title: AppConfig.applicationName,
        themeMode: mode,
        theme: OpdThemes.buildTheme(context, Brightness.light, color),
        darkTheme: OpdThemes.buildTheme(context, Brightness.dark, color),
        scrollBehavior: CustomScrollBehavior(),
        routerConfig: router,
        builder: (context, child) => Navigator(
          onGenerateRoute: (_) =>
              MaterialPageRoute(builder: (_) =>
                  OpdSure(
                    clients: clients,
                    store: store,
                    child: child,
          )),
        ),
      ),
    );
  }
}
