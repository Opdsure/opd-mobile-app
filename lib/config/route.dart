import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/claims_page.dart';
import 'package:opdsure/pages/forget_password/forget_password_controller.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';
import 'package:opdsure/pages/login/otp_page/otp_page_controller.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';
import 'package:opdsure/pages/profile_page.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/pages/wallet_page.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../pages/plan/plans_page/plans_page_controller.dart';

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

  static FutureOr<String?> isPlanPurchasedRedirect(
    BuildContext context,
    GoRouterState state,
  ) =>
      OpdSure.of(context).client.isLogged
          ? OpdSure.of(context).client.isPlanPurchased
              ? null
              : OpdSure.of(context).isSelectPlans
                  ? '/home/view_plans/select_plans'
                  : '/home/view_plans'
          : 'signup';

  AppRoutes();

  static final List<RouteBase> routes = [
    GoRoute(
        path: '/',
        redirect: (context, state) => !OpdSure.of(context).isOnboardScreenActive
            ? "/on_board_screen"
            : '/signup'),
    GoRoute(
      path: '/on_board_screen',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        WalletPage(),
      ),
    ),
    GoRoute(
        path: '/signup',
        redirect: loggedInRedirect,
        pageBuilder: (context, state) => defaultPageBuilder(
              context,
              state,
              const SignUpPage(),
            ),
        routes: [
          GoRoute(
            path: 'login',
            pageBuilder: (context, state) => defaultPageBuilder(
              context,
              state,
              const LoginPage(),
            ),
            routes: [
              GoRoute(
                path: 'otp',
                pageBuilder: (context, state) => defaultPageBuilder(
                  context,
                  state,
                  const OtpPage(),
                ),
              ),
              GoRoute(
                path: 'forget_password',
                pageBuilder: (context, state) => defaultPageBuilder(
                  context,
                  state,
                  const ForgetPasswordPage(),
                ),
              ),
            ],
          ),
        ]),
    ShellRoute(
      pageBuilder: defaultPageBuilder,
      routes: [
        GoRoute(
            path: '/home',
            redirect: isPlanPurchasedRedirect,
            pageBuilder: (context, state) =>
                defaultPageBuilder(context, state, ClaimsPage()),
            routes: [
              ShellRoute(
                pageBuilder: defaultPageBuilder,
                routes: [
                  GoRoute(
                    path: 'view_plans',
                    pageBuilder: (context, state) => defaultPageBuilder(
                      context,
                      state,
                      const ViewPlansPage(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'select_plans',
                        pageBuilder: (context, state){
                          PlansResponse? plans;
                          if(state.extra != null){
                            plans = state.extra as PlansResponse;
                          }
                          return defaultPageBuilder(
                          context,
                          state,
                          PlansPage(plans: plans),
                        );
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ]),
      ],
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
