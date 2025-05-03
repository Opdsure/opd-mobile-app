import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/pages/profile_page/member_tile.dart';
import 'package:opdsure/pages/profile_page/profile_page.dart';
import 'package:opdsure/utils/opd_extension/int_extention.dart';

import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_key_value.dart';
import '../../custom_ui/app_round_view.dart';
import '../../custom_ui/app_text_view.dart';
import '../../model/my_member_model.dart';
import '../../model/update_member/update_member.dart';
import '../../utils/app_colors.dart';
import '../../utils/common_methods.dart';

class PendingFamilyMember extends StatelessWidget {
  final ProfilePageController controller;

  const  PendingFamilyMember(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.memberModel == null) {
      return Center(
        child:
        SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.getProfileData();
                  },
                  child: ListView.builder(
                      itemCount: controller.updateMember!.data!.length,
                      itemBuilder: (context, index) {
                       return MemberTile(controller.updateMember!.data![index]);
                      }),
                ))
        ],
      );
    }
  }
}
