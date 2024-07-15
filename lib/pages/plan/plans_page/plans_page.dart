import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_drop_down.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/login_scafold.dart';
import 'package:opdsure/custom_ui/select_plan.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page_controller.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../../utils/app_colors.dart';

class PlansPageView extends StatelessWidget {
  final PlansPageController controller;

  const PlansPageView(this.controller, {super.key});

  final Color textColor = const Color(0xFF8A48B3);

  Widget commonRow(BuildContext context, String imgUri, String desc) {
    double w = CommonMethods.deviceWidth(context);
    return Row(
      children: [
        Image.asset('assets/images/$imgUri.png'),
        const SizedBox(
          width: 10.0,
        ),
        SizedBox(
          width: w * 0.8,
          child: AppTextView(text: desc),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.plansLength!,
      child: LoginScaffold(
        enforceMobileMode: !OpdSure.of(context).client.isLogged,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              AppHeader(
                headerName: '${controller.record!.name} Plan',
              ),
              const SizedBox(
                height: 30.0,
              ),
              ButtonsTabBar(
                backgroundColor: Colors.transparent,
                unselectedBackgroundColor: Colors.white,
                labelStyle: GoogleFonts.montserrat(
                  color: buttonColor,
                ),
                borderColor: buttonColor,
                height: 40.0,
                width: 100.0,
                contentCenter: true,
                unselectedLabelStyle: GoogleFonts.montserrat(
                  color: Colors.black,
                ),
                borderWidth: 1,
                unselectedBorderColor: const Color(0xFFEAECF0),
                radius: 15,
                tabs: controller.plansTab!,
                onTap: (index) {
                  controller.getIndexedRecords(index: index);
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextView(
                    text: (!controller.isIndividual &&
                            controller.familyOptions == null)
                        ? 'Select Member'
                        : '₹ ${controller.options!.charges!}',
                    color: textColor,
                    size: (!controller.isIndividual &&
                        controller.familyOptions == null) ? 16.0 : 40.0,
                    fontWeight: FontWeight.w700,
                  ),
                  if (controller.record!.planType == PlanType.both) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            AppTextView(
                              text: controller.planType,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                            Switch(
                              value: controller.isIndividual,
                              onChanged: controller.toggleIndividual,
                              activeTrackColor: textColor,
                              inactiveTrackColor: textColor,
                              trackOutlineColor: controller.isIndividual
                                  ? null
                                  : WidgetStatePropertyAll<Color>(textColor),
                              inactiveThumbColor: Colors.white,
                              thumbIcon: WidgetStatePropertyAll<Icon>(
                                Icon(
                                  controller.isIndividual
                                      ? Icons.person
                                      : Icons.family_restroom,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppTextView(
                          text:
                              'Toggle for ${controller.isIndividual ? "family" : "individual"}',
                          size: 12,
                          color: textColor,
                        ),
                      ],
                    ),
                  ]
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppTextView(
                text: CommonMethods.getPlanFrequency(
                    controller.record!.frequency!),
                size: 16.0,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppTextView(
                text: 'Benefits of ${controller.record!.name!}',
                size: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              if ((controller.record!.planType! == PlanType.family ||
                      controller.record!.planType! == PlanType.both) &&
                  !controller.isIndividual) ...[
                const SizedBox(
                  height: 10.0,
                ),
                AppDropDown<MembershipOptions>(
                    hint: const AppTextView(
                      text: "Select plan type",
                    ),
                    items: controller.getPlanItem(),
                    onChanged: controller.setPlanItem,
                    value: controller.familyOptions),
              ],
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 400,
                child: ListView.builder(
                    itemCount: controller.record!.planBenefits!.length,
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.verified,
                          color: textColor,
                        ),
                        title: AppTextView(
                          color: Colors.black,
                          text: controller
                              .record!.planBenefits![index].planLabel!,
                          size: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: AppTextView(
                            color: Colors.black,
                            text: controller
                                .record!.planBenefits![index].planFeature!),
                      );
                    }),
              ),
              AppButton(
                text: 'Select',
                color: (!controller.isIndividual &&
                        controller.familyOptions == null)
                    ? const Color(0xFFD9D7D7)
                    : buttonColor,
                textColor: (!controller.isIndividual &&
                        controller.familyOptions == null)
                    ? Colors.black
                    : Colors.white,
                borderColor: (!controller.isIndividual &&
                        controller.familyOptions == null)
                    ? const Color(0xFFD9D7D7)
                    : buttonColor,
                onClick: () {
                  if (!(!controller.isIndividual &&
                      controller.familyOptions == null)) {
                    controller.goToCheckout();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void modalBottomSheetMenu(BuildContext context) {
    bool isFamily = false;
    bool isIndividual = false;
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 20,
        ),
        builder: (builder) {
          return StatefulBuilder(builder: (stateFullBuilder, setState) {
            return Container(
              height: 450.0,
              decoration: const BoxDecoration(
                color: Color(0xFFF2F2F7),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppTextView(
                          text: 'Select One',
                          size: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        Image.asset(
                          'assets/images/cancel_icon.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    SelectPlan(
                      onClick: () {
                        setState(() {
                          isFamily = true;
                          isIndividual = false;
                        });
                      },
                      isSelected: isFamily,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    SelectPlan(
                      onClick: () {
                        setState(() {
                          isFamily = false;
                          isIndividual = true;
                        });
                      },
                      imgUri: 'indivisual_icon',
                      isPopular: false,
                      forWhat: 'For Individual',
                      memberCount: 'Enjoy all the services yourself.',
                      isSelected: isIndividual,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    'You can cancel whenever you want. By confirming, you agree to the ',
                                style: GoogleFonts.montserrat(
                                    color: const Color(0xFF667085))),
                            TextSpan(
                              text: 'Terms & Conditions.',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475467)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AppButton(
                      text: 'Continue',
                      onClick: () async {},
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
