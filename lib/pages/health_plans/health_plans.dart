import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/buy_health_plan/buy_health_plan.dart';
import 'package:opdsure/model/update_member/update_member.dart';

import '../../custom_ui/app_base_page.dart';
import '../../custom_ui/app_header.dart';
import '../../custom_ui/app_round_view.dart';
import '../../custom_ui/app_text_view.dart';
import '../../utils/common_methods.dart';
import '../../widget/opd_widget.dart';

class HealthPlans extends StatelessWidget {
  const HealthPlans({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Health Plan'),
      childContent: FutureBuilder<BuyHealthPlan>(
          future: OpdSure.of(context).client.getPurchasedHealtchekupPlans(),
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
                    return AppRoundView(
                      isMargin: true,
                      corner: 10.0,
                      color: const Color(0x1A486AB3),
                      mChild: ListTile(
                        onTap: () async {
                          CommonMethods.showAlertDialog(context);
                          final plan = await OpdSure.of(context).client.getHealthPlanById(snapshot.data!.data!.records![index].healthPlan!.id!);
                          context.pop();
                          context.push('/home/health_checkup_details', extra: {"plan" : plan, "isView" : true});
                        },
                        title: AppTextView(text: snapshot.data!.data!.records![index].healthPlan!.name!,),
                        subtitle: AppTextView(text: 'Total no of test ${snapshot.data!.data!.records![index].healthPlan!.parameters!}',),
                      ),
                    );
                  });
            }

          }
      ),
    );
  }
}
