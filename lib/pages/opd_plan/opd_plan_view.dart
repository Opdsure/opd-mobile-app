import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
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
  final bool isSub;
  const OpdPlanView(
      {required this.record,
      required this.options,
      required this.activated,
      required this.isSub,
      super.key});

  final Color textColor = const Color(0xFF486AB3);

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Subscribed Plan',
      ),
      childContent: FutureBuilder<UserProfile?>(
          future: OpdSure.of(context).client.getProfile(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Column(
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
                      '$rupeeSymbol ${CommonMethods.amountFormater((double.parse(options.charges!.toString()) + double.parse((options.charges! * 18 / 100).toString())).toStringAsFixed(0))}/${CommonMethods.getPlanFrequency(record.frequency!)}',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                if (isSub) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextView(
                        // text: 'Purchased On: ${"45678"}',
                        text:
                            'Purchased On: ${CommonMethods.formatIsoDateString(snapshot.data!.data!.plan!.startDate!)}',
                        color: Colors.black,
                      ),
                      AppTextView(
                        // text: 'Valid till: ${"45678"}',
                        text:
                            'Valid till: ${CommonMethods.formatIsoDateString(snapshot.data!.data!.plan!.endDate!)}',
                        color: Colors.black,
                      ),
                    ],
                  )
                ],
                AppTextView(
                  text: 'Benefits of ${record.name!} plan',
                  size: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: textColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'On this plan, You get reward of ',
                          style: GoogleFonts.montserrat(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: '$rupeeSymbol${options.walletBalance!}',
                          style: GoogleFonts.montserrat(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: ' in wallet balance.',
                          style: GoogleFonts.montserrat(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ), /*AppTextView(text: 'On this plan, You will be rewarded with $rupeeSymbol${controller.options!.walletBalance!} Wallet Balance.'),*/
                ),
                const SizedBox(
                  height: 15.0,
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
            );
          }),
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
                  final plans =
                      await OpdSure.of(context).client.getPlansForUpgrade();
                  if (plans!.data!.records != null &&
                      plans.data!.records!.isNotEmpty) {
                    context.push('/home/view_plans',
                        extra: PaymentType.planUpgrade);
                  } else {
                    CommonMethods.showToast('You already on highest plan');
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
              width: CommonMethods.deviceWidth(context) * 0.4,
              child: AppButton(
                text: 'Renew',
                onClick: () async {
                  context.push('/home/view_plans',
                      extra: PaymentType.planRenew);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
