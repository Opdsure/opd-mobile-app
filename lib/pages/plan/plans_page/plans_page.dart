import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_drop_down.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/select_plan.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page_controller.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../../config/app_config.dart';
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
    OpdSureState opd = OpdSure.of(context);
    return DefaultTabController(
      length: controller.plansLength!,
      child: AppBasePage(
        appHeader: AppHeader(
          headerName: 'Plans',
        ),
        childContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonsTabBar(
              controller: controller.tabController,
              backgroundColor: Colors.transparent,
              unselectedBackgroundColor: Colors.white,
              labelStyle: GoogleFonts.montserrat(
                color: AppConfig.primaryColor,
              ),
              borderColor: AppConfig.primaryColor,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppTextView(
                      text: (!controller.isIndividual &&
                              controller.familyOptions == null)
                          ? 'Select Member'
                          : '₹ ${CommonMethods.amountFormater((controller.options!.charges! + ((controller.options!.charges!) * 18) / 100).toStringAsFixed(0))}',
                      color: textColor,
                      size: (!controller.isIndividual &&
                              controller.familyOptions == null)
                          ? 16.0
                          : 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                    AppTextView(
                      text: '(incl GST 18%)',
                      color: textColor,
                      size: 12.0,
                      fontWeight: FontWeight.w500,
                    )
                  ],
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
                        controller.isIndividual ? 'Add family member' : 'Back to individual',
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
              text:
                  CommonMethods.getPlanFrequency(controller.record!.frequency!),
              size: 16.0,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
              width: CommonMethods.deviceWidth(context),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: textColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your total OPD wallet balance ',
                      style: GoogleFonts.montserrat(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text:
                          '$rupeeSymbol ${CommonMethods.amountFormater(controller.options!.walletBalance!.toString())}',
                      style: GoogleFonts.montserrat(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            AppTextView(
              text: 'Benefits of ${controller.record!.name!} plan',
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
            Expanded(
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
                        text:
                            controller.record!.planBenefits![index].planLabel!,
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
              color: controller.buttonColors,
              textColor: controller.textColors,
              borderColor: controller.borderColors,
              onClick: controller.onPlanSelect,
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
