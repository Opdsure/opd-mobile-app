import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/pages/login_page.dart';
import 'package:opdsure/widget/opd_widget.dart';

abstract class AppRoutes{

  static FutureOr<String?> loggedInRedirect(
      BuildContext context,
      GoRouterState state,
      ) =>
      OpdSure.of(context).client.isLogged ? '/rooms' : null;

  static FutureOr<String?> loggedOutRedirect(
      BuildContext context,
      GoRouterState state,
      ) =>
      OpdSure.of(context).client.isLogged ? null : '/login';
  AppRoutes();

  static final List<RouteBase> routes = [
    GoRoute(
      path: '/',
    redirect:(context, state) => OpdSure.of(context).client.isLogged ? "/home" : '/login'
    ),
    GoRoute(
        path: '/login',
      pageBuilder: (context, state) => defaultPageBuilder(
          context,
          state,
          LoginPage()
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => defaultPageBuilder(
          context,
          state,
          LoginPage()
      ),
    ),
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