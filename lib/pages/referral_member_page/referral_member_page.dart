import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/model/referral_member/referral_member.dart';

import '../../custom_ui/app_base_page.dart';
import '../../custom_ui/app_header.dart';
import '../../custom_ui/app_round_view.dart';
import '../../custom_ui/app_text_view.dart';
import '../../utils/common_methods.dart';
import '../../widget/opd_widget.dart';

class ReferralMemberPage extends StatelessWidget {
  const ReferralMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Referred Member'),
      childContent: SizedBox(
        height: CommonMethods.deviceHeight(context),
        width: CommonMethods.deviceWidth(context),
        child: FutureBuilder<ReferralMember>(
            future: OpdSure.of(context).client.getReferredUsers(),
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
                        mChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                           children: [
                             AppKeyValue(mKey: 'Date', value: CommonMethods.formatIsoDateString(snapshot.data!.data!.records![index].createdAt!, isTime: true),),
                             AppKeyValue(mKey: 'Name', value: snapshot.data!.data!.records![index].referName!,),
                             AppKeyValue(mKey: 'Email', value: snapshot.data!.data!.records![index].referEmail!,),
                             AppKeyValue(mKey: 'Phone No.', value: snapshot.data!.data!.records![index].referPhone!,),
                           ],
                          ),
                        ),
                      );
                    });
              }

            }
        ),
      ),
    );
  }
}
