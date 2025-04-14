import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/pages/profile_page/profile_page.dart';

import '../../config/app_config.dart';
import '../../custom_ui/app_key_value.dart';
import '../../custom_ui/app_round_view.dart';
import '../../custom_ui/app_text_view.dart';
import '../../utils/common_methods.dart';
import '../../widget/opd_widget.dart';
import '../checkout/checkout_controller.dart';

class Profile extends StatelessWidget {
  final ProfilePageController controller;

  const Profile(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    String actualDob = '';
    if (controller.userProfile == null) {
      return const Center(
        child:
            SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
      );
    } else {
      if (controller.userProfile!.data!.dob!.isNotEmpty) {
        actualDob = CommonMethods.formatIsoDateString(
            controller.userProfile!.data!.dob!);
      }
      return RefreshIndicator(
        onRefresh: () async {
          controller.getProfileData();
        },
        child: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            AppRoundView(
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextView(
                          text: 'Personal Information',
                          size: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.primaryColor,
                        ),
                        InkWell(
                          onTap: () {
                            controller.updateProfile();
                          },
                          child: Image.asset('assets/images/edit_pen.png',
                              height: 20.0,
                              width: 20.0,
                              color: AppConfig.primaryColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    AppKeyValue(
                      mKey: 'Name',
                      value: controller.userProfile!.data!.name!,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    AppKeyValue(
                      mKey: 'Age',
                      value: actualDob.isEmpty
                          ? ''
                          : CommonMethods.calculateAge(
                              DateFormat("dd/MM/yyyy").parse(actualDob)),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    AppKeyValue(
                      mKey: 'Gender',
                      value: CommonMethods.getGenderByKey(
                          controller.userProfile!.data!.gender!),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    AppKeyValue(
                      mKey: 'Date of Birth',
                      value: actualDob,
                      // value: userProfile.data!.dob!,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    AppKeyValue(
                      mKey: 'Mobile Number',
                      value:
                          '${controller.userProfile!.data!.countryCode!} ${controller.userProfile!.data!.phone!}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextView(
                          text: 'Address',
                          size: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.primaryColor,
                        ),
                        Visibility(
                          visible: false,
                          child: Image.asset('assets/images/edit_pen.png',
                              height: 20.0,
                              width: 20.0,
                              color: AppConfig.primaryColor),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    AppKeyValue(
                      mKey: 'Address',
                      value: controller.userProfile!.data!.address!,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    AppKeyValue(
                      mKey: 'City',
                      value: controller.userProfile!.data!.city!,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    AppKeyValue(
                      mKey: 'Pin code',
                      value: '${controller.userProfile!.data!.pinCode!}' == '0'
                          ? ''
                          : '${controller.userProfile!.data!.pinCode!}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              onClick: () async {
                final plan = await OpdSure.of(context).client.getPlanById(
                      planId: controller.userProfile!.data!.plan!.id,
                      memberShipId:
                          controller.userProfile!.data!.plan!.membershipId,
                    );
                context.push('/home/opd-plan', extra: {
                  'records': plan,
                  'option': plan!.membershipOptions![0],
                  'buyDate': controller.userProfile!.data!,
                  'isSub': true,
                  'active': true
                });
              },
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: 'Subscribed Plan',
                      size: 16.0,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(Icons.chevron_right, color: AppConfig.primaryColor)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              onClick: () async {

                context.push('/home/view_plans', extra: PaymentType.planRenew);
                // final plan = await OpdSure.of(context).client.getPlanById(
                //   planId: controller.userProfile!.data!.plan!.id,
                //   memberShipId:
                //   controller.userProfile!.data!.plan!.membershipId,
                // );
                // context.push('/home/opd-plan', extra: {
                //   'records': plan,
                //   'option': plan!.membershipOptions![0],
                //   'buyDate': controller.userProfile!.data!,
                //   'isSub': true,
                //   'active': true
                // });


                // context.push('/home/renew-plan');
              },
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: 'Renew Plans',
                      size: 16.0,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(Icons.chevron_right, color: AppConfig.primaryColor)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              onClick: () {
                context.push('/home/health-plan');
              },
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: 'Health Checkup Plans',
                      size: 16.0,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(Icons.chevron_right, color: AppConfig.primaryColor)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              onClick: () {
                context.push('/home/free-health-plan');
              },
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: 'Booked Free Health Checkup ',
                      size: 16.0,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(Icons.chevron_right, color: AppConfig.primaryColor)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              onClick: () {
                context.push('/home/referral-member');
              },
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: 'Referral Member',
                      size: 16.0,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppConfig.primaryColor,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              onClick: () {
                CommonMethods.showLogoutAlertDialog(context,
                    'Are you sure want to logout', 'Logout', 'Yes', 'Cancel');
              },
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: 'Logout',
                      size: 16.0,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.logout,
                      size: 20.0,
                      color: AppConfig.primaryColor,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppRoundView(
              onClick: () {
                CommonMethods.showLogoutAlertDialog(context,
                    'Are you sure want to Delete your account', 'Account Deletion', 'Yes', 'Cancel');
              },
              corner: 10.0,
              color: AppConfig.roundedViewColor,
              mChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: 'Delete Account',
                      size: 16.0,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.delete,
                      size: 20.0,
                      color: AppConfig.primaryColor,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
