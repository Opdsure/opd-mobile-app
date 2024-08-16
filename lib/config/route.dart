import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/empty_page.dart';
import 'package:opdsure/custom_ui/two_column_layout.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/add_family_details/add_family_details.dart';
import 'package:opdsure/pages/file_claim_page.dart';
import 'package:opdsure/pages/forget_password/forget_password_controller.dart';
import 'package:opdsure/pages/health_check_up/health_checkup_details/health_checkup_details_controller.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';
import 'package:opdsure/pages/name_email_number/name_email_number_controller.dart';
import 'package:opdsure/pages/notification/notification_page.dart';
import 'package:opdsure/pages/opd_plan/opd_plan_view.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';
import 'package:opdsure/pages/preview/preview_page.dart';
import 'package:opdsure/pages/referral_member_page/referral_member_page.dart';
import 'package:opdsure/pages/referral_page.dart';
import 'package:opdsure/pages/renew_plans/renew_plans.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/pages/update_profile_page.dart';
import 'package:opdsure/pages/wallet_page.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../pages/checkout/checkout_controller.dart';
import '../pages/health_plans/health_plans.dart';
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
      } else {
        return '/view_plans';
      }
    } else {
      return '/signup';
    }
  }

  AppRoutes();

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
    GoRoute(
      path: '/view_plans',
      pageBuilder: (context, state) {
        PaymentType type;
        if (state.extra != null) {
          type = state.extra as PaymentType;
        } else {
          type = PaymentType.buyPlan;
        }
        return defaultPageBuilder(
          context,
          state,
          ViewPlansPage(type: type),
        );
      },
      routes: [
        GoRoute(
          path: 'select_plans',
          onExit: (context, state) async {
            if (!OpdSure.of(context).client.isPlanPurchased) {
              final result = await CommonMethods.showExitDialog(context,
                  message:
                      'Are you sure? You want to exit the app without purchased any plan.');
              if (result) {
                SystemNavigator.pop();
              }
              return result;
            } else {
              return true;
            }
          },
          pageBuilder: (context, state) {
            Map<String, dynamic>? data;
            PlansResponse? plans;
            PaymentType type;
            if (state.extra != null) {
              data = state.extra as Map<String, dynamic>;
              plans = data['plans'] as PlansResponse;
              if (data['type'] != null) {
                type = data['type'] as PaymentType;
              } else {
                type = PaymentType.buyPlan;
              }
            } else {
              type = PaymentType.buyPlan;
            }
            return defaultPageBuilder(
              context,
              state,
              PlansPage(
                plans: plans,
                type: type,
              ),
            );
          },
        ),
        GoRoute(
            path: 'plans_payment',
            onExit: (context, state) {
              OpdSure.of(context).client.getProfile(update: true);
              return true;
            },
            pageBuilder: (context, state) {
              Map<String, dynamic>? data;
              PlanRecords? records;
              MembershipOptions? options;
              PaymentType type;
              if (state.extra != null) {
                data = state.extra as Map<String, dynamic>;
                records = data['records'] as PlanRecords;
                if (data['options'] != null) {
                  options = data['options'] as MembershipOptions;
                }
                if (data['type'] != null) {
                  type = data['type'] as PaymentType;
                } else {
                  type = PaymentType.buyPlan;
                }
              } else {
                type = PaymentType.buyPlan;
              }
              return defaultPageBuilder(
                context,
                state,
                CheckoutPage(
                  paymentType: type,
                  records: records,
                  options: options,
                ),
              );
            }),
      ],
    ),
    ShellRoute(
      pageBuilder: (context, state, child) => defaultPageBuilder(
          context,
          state,
          OpdThemes.isColumnMode(context)
              ? TwoColumnLayout(
                  mainView: const DashBoardPage(
                    displayNavigationRail: true,
                  ),
                  sideView: child,
                  displayNavigationRail: true,
                )
              : child),
      routes: [
        GoRoute(
            path: '/home',
            onExit: (context, state) async {
              OpdSureState opd = OpdSure.of(context);
              if (opd.client.isLogged) {
                if (opd.selectedPage == 0) {
                  return await CommonMethods.showExitDialog(context);
                } else {
                  opd.selectedPage = 0;
                  return false;
                }
              } else {
                return true;
              }
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
              GoRoute(
                  path: 'wallet',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(context, state, WalletPage());
                  }),
              GoRoute(
                  path: 'opd-plan',
                  pageBuilder: (context, state) {
                    bool activate = true;
                    bool isSub = false;
                    Map<String, dynamic> data =
                        state.extra! as Map<String, dynamic>;
                    PlanRecords record = data['records'] as PlanRecords;
                    MembershipOptions options =
                        data['option'] as MembershipOptions;
                    if (data['active'] != null) {
                      activate = data['active'] as bool;
                    }
                    if (data['isSub'] != null) {
                      isSub = data['isSub'] as bool;
                    }
                    return defaultPageBuilder(
                        context,
                        state,
                        OpdPlanView(
                            record: record,
                            options: options,
                            activated: activate,
                            isSub: isSub));
                  }),
              GoRoute(
                  path: 'renew-plan',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(
                        context, state, const RenewPlans());
                  }),
              GoRoute(
                  path: 'health-plan',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(
                        context, state, const HealthPlans());
                  }),
              GoRoute(
                  path: 'referral-member',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(
                        context, state, const ReferralMemberPage());
                  }),
              GoRoute(
                  path: 'add-members',
                  pageBuilder: (context, state) {
                    MemberList? member;
                    bool isUpdate = false;
                    if (state.extra != null) {
                      Map<String, dynamic> data =
                          state.extra as Map<String, dynamic>;

                      if (data['member'] != null) {
                        member = data['member'] as MemberList;
                      }
                      if (data['isUpdate'] != null) {
                        isUpdate = data['isUpdate'] as bool;
                      }
                    }
                    return defaultPageBuilder(
                      context,
                      state,
                      AddFamilyDetails(
                        isUpdate: isUpdate,
                        member: member,
                      ),
                    );
                  }),
              GoRoute(
                  path: 'update-profile',
                  pageBuilder: (context, state) {
                    Map<String, dynamic> data =
                        state.extra as Map<String, dynamic>;
                    UserProfile? profile;
                    if (data['profile'] != null) {
                      profile = data['profile'] as UserProfile;
                    }
                    return defaultPageBuilder(
                      context,
                      state,
                      UpdateProfilePage(profile),
                    );
                  }),
              GoRoute(
                  path: 'notifications',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(
                      context,
                      state,
                      const NotificationPage(),
                    );
                  }),
              GoRoute(
                path: 'view_plans',
                pageBuilder: (context, state) {
                  PaymentType type;
                  if (state.extra != null) {
                    type = state.extra as PaymentType;
                  } else {
                    type = PaymentType.buyPlan;
                  }
                  return defaultPageBuilder(
                    context,
                    state,
                    ViewPlansPage(type: type),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'select_plans',
                    onExit: (context, state) async {
                      if (!OpdSure.of(context).client.isPlanPurchased) {
                        final result = await CommonMethods.showExitDialog(
                            context,
                            message:
                                'Are you sure? You want to exit the app without purchased any plan.');
                        if (result) {
                          SystemNavigator.pop();
                        }
                        return result;
                      } else {
                        return true;
                      }
                    },
                    pageBuilder: (context, state) {
                      Map<String, dynamic>? data;
                      PlansResponse? plans;
                      PaymentType type;
                      if (state.extra != null) {
                        data = state.extra as Map<String, dynamic>;
                        plans = data['plans'] as PlansResponse;
                        if (data['type'] != null) {
                          type = data['type'] as PaymentType;
                        } else {
                          type = PaymentType.buyPlan;
                        }
                      } else {
                        type = PaymentType.buyPlan;
                      }
                      return defaultPageBuilder(
                        context,
                        state,
                        PlansPage(
                          plans: plans,
                          type: type,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                      path: 'plans_payment',
                      onExit: (context, state) {
                        OpdSure.of(context).client.getProfile(update: true);
                        return true;
                      },
                      pageBuilder: (context, state) {
                        Map<String, dynamic>? data;
                        PlanRecords? records;
                        MembershipOptions? options;
                        PaymentType type;
                        if (state.extra != null) {
                          data = state.extra as Map<String, dynamic>;
                          records = data['records'] as PlanRecords;
                          if (data['options'] != null) {
                            options = data['options'] as MembershipOptions;
                          }
                          if (data['type'] != null) {
                            type = data['type'] as PaymentType;
                          } else {
                            type = PaymentType.buyPlan;
                          }
                        } else {
                          type = PaymentType.buyPlan;
                        }
                        return defaultPageBuilder(
                          context,
                          state,
                          CheckoutPage(
                            paymentType: type,
                            records: records,
                            options: options,
                          ),
                        );
                      }),
                ],
              ),
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
                  FileClaimPage(
                    isUpdate: false,
                  ),
                ),
              ),
              GoRoute(
                  path: 'health_checkup_details',
                  pageBuilder: (context, state) {
                    HealthCheckupRecords? records;
                    bool isView = false;
                    Map<String, dynamic> data =
                        state.extra as Map<String, dynamic>;
                    if (data['plan'] != null) {
                      records = data['plan'] as HealthCheckupRecords;
                    }
                    if (data['isView'] != null) {
                      isView = data['isView'] as bool;
                    }
                    return defaultPageBuilder(
                      context,
                      state,
                      HealthCheckupDetails(
                        records: records,
                        isView: isView,
                      ),
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
                      CheckoutPage(
                        paymentType: PaymentType.buyHealthCheckup,
                        healthCheckupRecords: records,
                      ),
                    );
                  }),
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
