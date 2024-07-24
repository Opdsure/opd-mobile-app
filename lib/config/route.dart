import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/empty_page.dart';
import 'package:opdsure/custom_ui/two_column_layout.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/add_family_details/add_family_details.dart';
import 'package:opdsure/pages/file_claim_page.dart';
import 'package:opdsure/pages/forget_password/forget_password_controller.dart';
import 'package:opdsure/pages/health_check_up/health_checkup_details/health_checkup_details_controller.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';
import 'package:opdsure/pages/name_email_number/name_email_number_controller.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';
import 'package:opdsure/pages/preview/preview_page.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_widget.dart';

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

  // static FutureOr<String?> isPlanPurchasedRedirect(
  //   BuildContext context,
  //   GoRouterState state,
  // ) =>
  //     OpdSure.of(context).client.isLogged
  //         ? OpdSure.of(context).client.isPlanPurchased
  //             ? null
  //             : OpdSure.of(context).isSelectPlans
  //                 ? '/home/view_plans/select_plans'
  //                 : '/home/view_plans'
  //         : '/signup';

  static FutureOr<String?> getRedirectNameForHome(
      BuildContext context, GoRouterState state) async {
    final opd = OpdSure.of(context);
    if (opd.client.isLogged) {
      if (opd.profileData!.phone!.isEmpty || opd.profileData!.email!.isEmpty) {
        opd.isWithEmail = opd.profileData!.email!.isEmpty;
        return '/home/name_email_number';
      }
      if (opd.client.isPlanPurchased) {
        return null;
        // return '/home/view_plans/add_members';
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

  static bool displayRailNavigation(BuildContext context, GoRouterState state) {
    final opd = OpdSure.of(context);
    if (opd.client.isLogged) {
      if (opd.profileData!.phone!.isEmpty || opd.profileData!.email!.isEmpty) {
        opd.isWithEmail = opd.profileData!.email!.isEmpty;
        return false;
      }
      if (opd.client.isPlanPurchased) {
        return OpdThemes.isColumnMode(context);
      } else {
        if (opd.isSelectPlans) {
          if (opd.isPlansSelect) {
            return false;
          }
          return false;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  AppRoutes();

  static Future<bool> _showExitDialog(BuildContext context) async {
    if(OpdSure.of(context).isLogout){
      return true;
    }
    if(OpdSure.of(context).selectedPage != 0){
      OpdSure.of(context).selectedPage = 0;
      return false;
    }
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AppTextView(
            text: 'Exit Confirmation',
            size: 18.0,
            fontWeight: FontWeight.w600,
          ),
          content: const AppTextView(text: 'Do you really want to exit?'),
          actions: [
            MaterialButton(
              child: const AppTextView(text: 'Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            MaterialButton(
              child: const AppTextView(text: 'Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  static final List<RouteBase> routes = [
    GoRoute(
        path: '/',
        redirect: (context, state) =>
            !OpdSure.of(context).isOnboardScreenActive && !PlatformInfos.isWeb
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
                    userId: otpMap['user_id'],
                    accessToken: otpMap['access_token'],
                  ),
                );
              }),

        ]),
    GoRoute(
      path: '/login',
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
    ShellRoute(
      pageBuilder: (context, state, child) => defaultPageBuilder(
          context,
          state,
          OpdThemes.isColumnMode(context) &&
                  displayRailNavigation(context, state)
              ? TwoColumnLayout(
                  mainView: DashBoardPage(
                    displayNavigationRail:
                        displayRailNavigation(context, state),
                  ),
                  sideView: child,
                  displayNavigationRail: displayRailNavigation(context, state),
                )
              : child),
      routes: [
        GoRoute(
            path: '/home',
            onExit: (context, state) async {
              return await _showExitDialog(context);
            },
            redirect: getRedirectNameForHome,
            pageBuilder: (context, state) => defaultPageBuilder(
                  context,
                  state,
                  OpdThemes.isColumnMode(context)
                      ? const EmptyPage()
                      : const DashBoardPage(),
                ),
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
                  GoRoute(
                    path: "file_claim",
                    pageBuilder: (context, state) => defaultPageBuilder(
                      context,
                      state,
                      FileClaimPage(isUpdate: false,),
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
                      ViewPlansPage(),
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
                            PlanRecords? records;
                            MembershipOptions? options;
                            if (state.extra != null) {
                              data = state.extra as Map<String, dynamic>;
                              records = data['records'] as PlanRecords;
                              if (data['options'] != null) {
                                options = data['options'] as MembershipOptions;
                              }
                            }
                            return defaultPageBuilder(
                              context,
                              state,
                              CheckoutPage(
                                paymentType: PaymentType.buyPlan,
                                records: records,
                                options: options,
                              ),
                            );
                          }),
                      GoRoute(
                          path: 'add_members',
                          pageBuilder: (context, state) {
                            return defaultPageBuilder(
                              context,
                              state,
                              AddFamilyDetails(isUpdate: false,isFirstMember: true,),
                            );
                          }),
                    ],
                  ),
                ],
              ),
              ShellRoute(
                  pageBuilder: defaultPageBuilder,
                  routes: [
                    GoRoute(
                        path: 'health_checkup_details',
                        pageBuilder: (context, state) {
                          HealthCheckupRecords? records;
                          if (state.extra != null) {
                            records = state.extra as HealthCheckupRecords;
                          }
                          return defaultPageBuilder(
                            context,
                            state,
                            HealthCheckupDetails(records: records),
                          );
                        }),
                    GoRoute(
                        path: 'health_checkup_checkout',
                        pageBuilder: (context, state) {
                          HealthCheckupRecords? records;
                          if (state.extra != null) {
                            records = state.extra as HealthCheckupRecords;
                          }
                          return defaultPageBuilder(
                            context,
                            state,
                            CheckoutPage(paymentType: PaymentType.buyHealthCheckup, healthCheckupRecords: records,),
                          );
                        }),
                  ])
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
