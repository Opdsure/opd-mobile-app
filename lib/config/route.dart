import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/claims_page.dart';
import 'package:opdsure/pages/file_claim_page.dart';
import 'package:opdsure/pages/forget_password/forget_password_controller.dart';
import 'package:opdsure/pages/homepage/home_page.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';
import 'package:opdsure/pages/name_email_number/name_email_number_controller.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/pages/preview/preview_page.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../pages/add_family_details/add_family_details.dart';
import '../pages/checkout/checkout_controller.dart';
import '../pages/otp_page/otp_page_controller.dart';
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
          : '/signup';

  static FutureOr<String?> getRedirectNameForHome(
      BuildContext context, GoRouterState state) {
    final opd = OpdSure.of(context);
    if (opd.client.isLogged) {
      if (opd.profileData!.phone == null || opd.profileData!.email == null) {
        opd.isWithEmail =
            opd.profileData!.email == null && opd.profileData!.email!.isEmpty;
        return '/home/name_email_number';
      }
      if (opd.client.isPlanPurchased) {
        return null;
      } else {
        if (opd.isSelectPlans) {
          if (opd.isPlansSelect) {
            return '/home/view_plans/plans_payment';
          }
          return '/home/view_plans/select_plans';
        } else {
          return '/home/view_plans';
        }
      }
    } else {
      return '/signup';
    }
  }

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
        PreviewPage(),
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
              path: 'otp',
              pageBuilder: (context, state) {
                final otpMap = state.extra as Map<String, dynamic>;
                return defaultPageBuilder(
                  context,
                  state,
                  OtpPage(
                      password: otpMap['password'],
                      email: otpMap['email'],
                      confirmPassword: otpMap['confirmPassword'],
                      phone: otpMap['phone'],
                      termCondition: otpMap['termCondition'],
                      isWithEmail: otpMap['isWithEmail'],
                      countryCode: otpMap['countryCode']),
                );
              }),
          GoRoute(
            path: 'login',
            pageBuilder: (context, state) => defaultPageBuilder(
              context,
              state,
              const LoginPage(),
            ),
            routes: [
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
            redirect: getRedirectNameForHome,
            pageBuilder: (context, state) =>
                defaultPageBuilder(context, state, HomePage()),
            routes: [
              ShellRoute(
                pageBuilder: defaultPageBuilder,
                routes: [
                  GoRoute(
                    path: "name_email_number",
                    pageBuilder: (context, state) => defaultPageBuilder(
                      context,
                      state,
                      const NameEmailNumber(),
                    ),
                  ),
                ],
              ),
              ShellRoute(
                pageBuilder: defaultPageBuilder,
                routes: [
                  GoRoute(
                    path: 'view_plans',
                    pageBuilder: (context, state) => defaultPageBuilder(
                      context,
                      state,
                      FileClaimPage(),
                    ),
                    routes: [
                      GoRoute(
                          path: 'select_plans',
                          pageBuilder: (context, state) {
                            PlansResponse? plans;
                            if (state.extra != null) {
                              plans = state.extra as PlansResponse;
                            }
                            return defaultPageBuilder(
                              context,
                              state,
                              PlansPage(plans: plans),
                            );
                          }),
                      GoRoute(
                          path: 'plans_payment',
                          pageBuilder: (context, state) {
                            Map<String, dynamic>? data;
                            Records? records;
                            MembershipOptions? options;
                            if (state.extra != null) {
                              data = state.extra as Map<String, dynamic>;
                              records = data['records'] as Records;
                              if(data['options'] != null){
                                options = data['options'] as MembershipOptions;
                              }

                            }
                            return defaultPageBuilder(
                              context,
                              state,
                              CheckoutPage(
                                records: records,
                                options: options,
                              ),
                            );
                          }),
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
