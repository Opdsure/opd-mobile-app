import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/model/QueuedPlans/quequed_plans.dart';
import 'package:opdsure/model/QueuedPlans/renew_plan_status.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../config/app_config.dart';
import '../../custom_ui/app_text_view.dart';

class RenewPlans extends StatelessWidget {
  const RenewPlans({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Renew Plan'),
      childContent: SizedBox(
        height: CommonMethods.deviceHeight(context),
        width: CommonMethods.deviceWidth(context),
        child: FutureBuilder<QueuedPlans>(
          future: OpdSure.of(context).client.getQueuedPlans(),
          builder: (context, snapshot) {
            if(snapshot.data == null){
              return const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data!.data!.records!.length,
                  itemBuilder: (context, index) {
                  RenewPlanStatus  status = RenewPlanStatus().getRenewPlan(snapshot.data!.data!.records![index].activated!);
                    return AppRoundView(
                      isMargin: true,
                        isPadding: true,
                        onClick: () async {
                          final plan = await OpdSure.of(context)
                              .client
                              .getPlanById(
                            planId:
                            snapshot.data!.data!.records![index].planId!.id!,
                            memberShipId: snapshot.data!.data!.records![index].membershipId,
                          );
                          context.push('/home/opd-plan', extra: {
                            'records': plan,
                            'option': plan!.membershipOptions![0],
                            'active' : snapshot.data!.data!.records![index].activated!
                          });
                        },
                        corner: 10.0,
                        color: AppConfig.roundedViewColor,
                        mChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 AppTextView(text: snapshot.data!.data!.records![index].planId!.name!, size: 18, fontWeight: FontWeight.bold,),
                                 SizedBox(
                                   width: 100,
                                   height: 20,
                                   child: Row(
                                     children: [
                                       Icon(
                                         status.iconData,
                                         color: status.statusColor,
                                         size: 15.0,
                                       ),
                                       AppTextView(
                                         text: ' ${status.statusName}',
                                         size: 12.0,
                                         color: status.statusColor!,
                                         fontWeight: FontWeight.w500,
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(height: 5,),
                             AppTextView(text: 'Price Paid - ₹${CommonMethods.amountFormater(snapshot.data!.data!.records![index].paidPrice!.toStringAsFixed(0))}(incl. GST)'),
                             AppTextView(text: 'Purchased on - ${CommonMethods.formatIsoDateString(snapshot.data!.data!.records![index].createdAt!)}'),
                             AppTextView(text: 'Membership Label: ${snapshot.data!.data!.records![index].planId!.membershipOptions!.where((e) => e.membershipId! == snapshot.data!.data!.records![index].membershipId!).toList()[0].membershipLabel!}'),
                             AppTextView(text: 'Member Count: ${snapshot.data!.data!.records![index].planId!.membershipOptions!.where((e) => e.membershipId! == snapshot.data!.data!.records![index].membershipId!).toList()[0].memberCount!}'),

                           ],
                        ));
                  });
            }

          }
        ),
      ),
    );
  }
}
