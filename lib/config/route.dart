import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/pages/login_page.dart';
import 'package:opdsure/pages/preview_page.dart';
import 'package:opdsure/pages/sign_up_page.dart';
import 'package:opdsure/widget/opd_widget.dart';

abstract class AppRoutes {
  static FutureOr<String?> loggedInRedirect(
    BuildContext context,
    GoRouterState state,
  ) =>
      OpdSure.of(context).client.isLogged ? '/home' : null;

  static FutureOr<String?> loggedOutRedirect(
    BuildContext context,
    GoRouterState state,
  ) =>
      OpdSure.of(context).client.isLogged ? null : '/signup';

  AppRoutes();

  static final List<RouteBase> routes = [
    GoRoute(
        path: '/',
        redirect: (context, state) => !OpdSure.of(context).isOnboardScreenActive
            ? "/on_board_screen"
            : '/signup'),
    GoRoute(
      path: '/on_board_screen',
      pageBuilder: (context, state) =>
          defaultPageBuilder(context, state, PreviewPage(),),
    ),
    GoRoute(
        path: '/signup',
        redirect: loggedInRedirect,
        pageBuilder: (context, state) =>
            defaultPageBuilder(context, state, const SignUpPage(),),
        routes: [
          GoRoute(
            path: 'login',
            pageBuilder: (context, state) =>
                defaultPageBuilder(context, state, LoginPage(),),
          ),
        ]),
    ShellRoute(pageBuilder: defaultPageBuilder, routes: [
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => defaultPageBuilder(
          context,
          state,
          Container(),
        ),
      ),
    ])
  ];

  static Page defaultPageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) =>
      OpdThemes.isColumnMode(context)
          ? NoTransitionPage(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: child,
            )
          : MaterialPage(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: child,
            );
}
