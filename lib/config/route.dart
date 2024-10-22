import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/empty_page.dart';
import 'package:opdsure/custom_ui/two_column_layout.dart';
import 'package:opdsure/custom_ui/web_view/webView.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/my_claim/my_claims_model.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/add_family_details/add_family_details.dart';
import 'package:opdsure/pages/file_claim_page.dart';
import 'package:opdsure/pages/forget_password/forget_password_controller.dart';
import 'package:opdsure/pages/free_health_tests/free_health_tests.dart';
import 'package:opdsure/pages/health_check_up/health_checkup_details/health_checkup_details_controller.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';
import 'package:opdsure/pages/name_email_number/name_email_number_controller.dart';
import 'package:opdsure/pages/notification/notification_page.dart';
import 'package:opdsure/pages/opd_plan/opd_plan_view.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';
import 'package:opdsure/pages/preview/preview_page.dart';
import 'package:opdsure/pages/preview/preview_page_view.dart';
import 'package:opdsure/pages/referral_member_page/referral_member_page.dart';
import 'package:opdsure/pages/referral_page.dart';
import 'package:opdsure/pages/renew_plans/renew_plans.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/pages/submit_patient_details/submit_patient_details.dart';
import 'package:opdsure/pages/terms_condition_page.dart';
import 'package:opdsure/pages/update_profile_page.dart';
import 'package:opdsure/pages/wallet_page.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../model/claim_json_model.dart';
import '../pages/all_checkup_page.dart';
import '../pages/checkout/checkout_controller.dart';
import '../pages/claim_pages/claims_details_page.dart';
import '../pages/health_check_up_page.dart';
import '../pages/health_plans/health_plans.dart';
import '../pages/otp_page/otp_page_controller.dart';
import '../pages/plan/plans_page/plans_page_controller.dart';
import '../pages/upload_file_claim_doc.dart';
import '../pages/view_image_page.dart';

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
      OpdSure.of(context).client.isLogged ? null : '/login';

  static FutureOr<String?> getRedirectNameForHome(
      BuildContext context, GoRouterState state) async {
    final opd = OpdSure.of(context);
    if (opd.client.isLogged) {
      if (opd.profileData!.email!.isEmpty) {
        return '/home/name_email_number';
      }
      if (opd.client.isPlanPurchased) {
        return null;
      } else {
        return '/view_plans';
      }
    } else {
      return '/login';
    }
  }

  AppRoutes();

  static final List<RouteBase> routes = [
    GoRoute(
        path: '/',
        redirect: (context, state) =>
            !OpdSure.of(context).isOnboardScreenActive && !PlatformInfos.isWeb
                ? "/on_board_screen"
                : '/login'),
    GoRoute(
      path: '/on_board_screen',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        const PreviewPage(),
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
                      otpType: otpMap['otp_type'],
                      countryCode: otpMap['country_code'],
                      phone: otpMap['phone']),
                );
              }),
          GoRoute(
              path: 'terms',
              pageBuilder: (context, state) => defaultPageBuilder(
                  context,
                  state,
                  TermsConditionPage(
                    termsType: state.extra as String,
                  )))
        ]),
    GoRoute(
      path: '/login',
      redirect: loggedInRedirect,
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        const LoginPage(),
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
                    otpType: otpMap['otp_type'],
                    countryCode: otpMap['country_code'],
                    phone: otpMap['phone']),
              );
            }),
      ],
    ),
    GoRoute(
      path: '/view_plans',
      pageBuilder: (context, state) {
        PaymentType type;
        if (state.extra != null && state.extra.runtimeType == PaymentType) {
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
            pageBuilder: (context, state)
            {
              ActiveDestination destination = ActiveDestination.home;
              if(state.extra != null && state.extra!.runtimeType == ActiveDestination){
                destination = state.extra as ActiveDestination;
              }
                  return defaultPageBuilder(
                    context,
                    state,
                    OpdThemes.isColumnMode(context)
                        ? const EmptyPage()
                        : DashBoardPage(
                            destination: destination),
                  );
                },
            routes: [
              GoRoute(
                  path: 'book_checkup',
                  pageBuilder: (context, state) => defaultPageBuilder(
                      context, state, const AllCheckupPage()),
                  routes: [
                    GoRoute(
                        path: 'add_health_checkup',
                        pageBuilder: (context, state) => defaultPageBuilder(
                            context, state, const HealthCheckUpPage()))
                  ]),
              GoRoute(
                  path: 'web_view',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(
                        context, state, WebView(url: state.extra! as String));
                  }),
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
                  },
                routes: [
                  GoRoute(
                      path: 'add-patient-details',
                    pageBuilder: (context, state) {
                    return defaultPageBuilder(context, state, SubmitPatientDetails(healthCheckupId: state.extra as String?,));
                    }
                  )
                ]
              ),
              GoRoute(
                  path: 'add-patient-details',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(context, state, SubmitPatientDetails(healthCheckupId: state.extra as String?,));
                  }
              ),
              GoRoute(
                  path: 'free-health-plan',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(
                        context, state, const FreeHealthTests());
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
                    bool isAddingFirstMember = false;
                    if (state.extra != null) {
                      Map<String, dynamic> data =
                          state.extra as Map<String, dynamic>;

                      if (data['member'] != null) {
                        member = data['member'] as MemberList;
                      }
                      if (data['isUpdate'] != null) {
                        isUpdate = data['isUpdate'] as bool;
                      }
                      if (data['isAddingFirstMember'] != null) {
                        isAddingFirstMember =
                            data['isAddingFirstMember'] as bool;
                      }
                    }
                    return defaultPageBuilder(
                      context,
                      state,
                      AddFamilyDetails(
                          isUpdate: isUpdate,
                          member: member,
                          isAddingFirstMember: isAddingFirstMember),
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
                  pageBuilder: (context, state) {
                    bool isUpdate = false;
                    ClaimRecords? claim;
                    Map<String, dynamic> extra = {};
                    if (state.extra != null) {
                      Map<String, dynamic> extra =
                          state.extra as Map<String, dynamic>;
                      isUpdate = extra['isUpdate'] ?? false;
                      claim = extra['records'];
                    }
                    return defaultPageBuilder(
                      context,
                      state,
                      FileClaimPage(records: claim, isUpdate: isUpdate),
                    );
                  },
                  routes: [
                    GoRoute(
                        path: 'upload_image',
                        pageBuilder: (context, state) {
                          Map<String, dynamic> extra =
                              state.extra as Map<String, dynamic>;
                          return defaultPageBuilder(
                              context,
                              state,
                              UploadFileClaimDoc(
                                claimId: extra['isUpdate'] as bool
                                    ? extra['claimId'] as String
                                    : null,
                                documentMap: extra['isUpdate'] as bool
                                    ? extra['documentMap']
                                        as Map<String, dynamic>
                                    : null,
                                isUpdate: extra['isUpdate'] as bool,
                                claimJsonModel:
                                    extra['claimJsonModel'] as ClaimJsonModel,
                              ));
                        })
                  ]),
              GoRoute(
                  path: "claim_details",
                  pageBuilder: (context, state) {
                    Map<String, dynamic> extra =
                        state.extra as Map<String, dynamic>;
                    return defaultPageBuilder(
                      context,
                      state,
                      ClaimsDetailsPage(
                        oneClaim: extra['claim_records'] as ClaimRecords,
                        isDispute: extra['isDispute'] as bool,
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: "view_image",
                      pageBuilder: (context, state) {
                        Map<String, dynamic> extra =
                            state.extra as Map<String, dynamic>;
                        return defaultPageBuilder(
                            context,
                            state,
                            ViewImagePage(
                              headerName: extra['headerName'] as String,
                              imageUrl: extra['imageUrl'] as String,
                            ));
                      },
                    ),
                  ]),
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
