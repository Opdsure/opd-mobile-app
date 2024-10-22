import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/model/buy_health_plan/buy_health_plan.dart';
import 'package:opdsure/model/free_health_checkups/free_health_checkups_model.dart';
import 'package:opdsure/model/update_member/update_member.dart';

import '../../config/app_config.dart';
import '../../custom_ui/app_base_page.dart';
import '../../custom_ui/app_header.dart';
import '../../custom_ui/app_round_view.dart';
import '../../custom_ui/app_text_view.dart';
import '../../utils/common_methods.dart';
import '../../widget/opd_widget.dart';

class FreeHealthTests extends StatelessWidget {
  const FreeHealthTests({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Free Health Tests'),
      childContent: FutureBuilder<FreeHealthCheckupsModel?>(
          future: OpdSure.of(context).client.getFreeHealthCheckup(),
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
                      "You haven't book a free health checkup yet."),
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
                        children: [
                          AppKeyValue(mKey: 'Booking Date', value: CommonMethods.formatIsoDateString(snapshot.data!.data!.records![index].createdAt!),),
                          AppKeyValue(mKey: 'Health CheckUp ID', value: snapshot.data!.data!.records![index].healthCheckupId!,),
                          AppKeyValue(mKey: 'Name', value: snapshot.data!.data!.records![index].memberDetails!.name!,),
                          AppKeyValue(mKey: 'Address', value: snapshot.data!.data!.records![index].memberDetails!.address!,),
                          AppKeyValue(mKey: 'Tests', value: snapshot.data!.data!.records![index].tests),
                          AppKeyValue(mKey: 'Appointment', value: CommonMethods.formatIsoDateString(snapshot.data!.data!.records![index].appointment!, isTime: true),),
                        ],
                      ),
                    );
                  });
            }

          }
      ),
    );
  }
}
