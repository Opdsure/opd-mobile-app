import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/model/buy_health_plan/buy_health_plan.dart';
import 'package:opdsure/model/update_member/update_member.dart';

import '../../config/app_config.dart';
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
      appHeader: const AppHeader(headerName: 'Health Plan'),
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
              if(snapshot.data!.data!.records!.length == 0){
                return const Center(
                  child: AppTextView(
                      fontWeight: FontWeight.w600,
                      mTextAlign: TextAlign.center,
                      text:
                      "You haven't buy a health checkup plan yet."),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.data!.records!.length,
                  itemBuilder: (context, index) {
                    return AppRoundView(
                      isMargin: true,
                      isPadding: true,
                      corner: 10.0,
                      color: AppConfig.roundedViewColor,
                      mChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextView(text: snapshot.data!.data!.records![index].healthPlan!.name!, fontWeight: FontWeight.bold,),
                          AppKeyValue(mKey: 'Price paid', value: '${snapshot.data!.data!.records![index].paidPrice!}/-',),
                          AppKeyValue(mKey: 'Purchased on', value: CommonMethods.formatIsoDateString(snapshot.data!.data!.records![index].createdAt!),),

                          if(!snapshot.data!.data!.records![index].detailsSubmitted!)...[
                            const SizedBox(height: 10,),
                            AppButton(
                              onClick: (){
                                context.push('/home/health-plan/add-patient-details', extra: snapshot.data!.data!.records![index].id!);
                              },
                                text: 'Submit Patient Details')]
                        ],
                      )
                    );
                  });
            }

          }
      ),
    );
  }
}
