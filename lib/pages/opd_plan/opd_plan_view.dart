import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_text_view.dart';
import '../../model/plans/plans_response.dart';
import '../../utils/app_var.dart';
import '../../utils/common_methods.dart';
import '../../widget/opd_widget.dart';
import '../checkout/checkout_controller.dart';

class OpdPlanView extends StatelessWidget {
  final PlanRecords record;
  final MembershipOptions options;
  final bool activated;
  const OpdPlanView({required this.record, required this.options, required this.activated, super.key});

  final Color textColor = const Color(0xFF8A48B3);

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Subscribed Plan',
      ),
       childContent: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   SizedBox(
                     width: CommonMethods.deviceWidth(context) - 30,
                     child: AppTextView(
                       text: '${options.membershipLabel}',
                       color: textColor,
                       size: 16.0,
                       fontWeight: FontWeight.w700,
                     ),
                   ),
                 ],
               ),
             ],
           ),
           const SizedBox(
             height: 15.0,
           ),
           AppTextView(
             text:
                 '$rupeeSymbol${double.parse(options.charges!.toString()).toStringAsFixed(2)}/${CommonMethods.getPlanFrequency(record.frequency!)}',
             size: 16.0,
             fontWeight: FontWeight.w600,
           ),
           const SizedBox(
             height: 15.0,
           ),
           AppTextView(
             text: 'Benefits of ${record.name!}',
             size: 20.0,
             color: Colors.black,
             fontWeight: FontWeight.w600,
           ),
           const SizedBox(
             height: 10.0,
           ),
           Expanded(
             child: ListView.builder(
                 itemCount: record.planBenefits!.length,
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
                       text: record.planBenefits![index].planLabel!,
                       size: 16,
                       fontWeight: FontWeight.bold,
                     ),
                     subtitle: AppTextView(
                         color: Colors.black,
                         text: record.planBenefits![index].planFeature!),
                   );
                 }),
           ),
         ],
       ),
      isBottomContent: activated,
      bottomContent: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
              width: CommonMethods.deviceWidth(context) * 0.4,
              child: AppButton(
                text: 'Upgrade',
                onClick: () async {
                  final opd = OpdSure.of(context);
                  // opd.isPlanUpgrade = true;
                  // opd.isSelectPlans = false;
                  // opd.isPlansSelect = false;
                  context.push('/view_plans', extra: PaymentType.planUpgrade).then((_){
                    // opd.isPlanUpgrade = false;
                    // opd.isSelectPlans = false;
                    // opd.isPlansSelect = false;
                  });
                },
              ),
            ),
            SizedBox(
              height: 50,
              width: CommonMethods.deviceWidth(context) * 0.4,
              child: AppButton(
                text: 'Renew',
                onClick: () async {
                  // final opd = OpdSure.of(context);
                  // opd.isSelectPlans = false;
                  // opd.isPlansSelect = false;
                  context.push('/view_plans', extra: PaymentType.planRenew).then((_){
                    // opd.isPlanUpgrade = false;
                    // opd.isSelectPlans = false;
                    // opd.isPlansSelect = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
