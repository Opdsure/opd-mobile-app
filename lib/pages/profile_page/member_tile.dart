import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/utils/opd_extension/int_extention.dart';

import '../../custom_ui/app_key_value.dart';
import '../../custom_ui/app_round_view.dart';
import '../../custom_ui/app_text_view.dart';
import '../../model/claim_status_model.dart';
import '../../model/update_member/update_member.dart';
import '../../utils/common_methods.dart';

class MemberTile extends StatelessWidget {
  final UpdateMemberData member;
  const MemberTile(this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    ClaimStatusModel profileStatus = ClaimStatusModel().getProfileStatus(member.reviewStatus!);
    int fmAge;
    if (member.dob == null) {
      fmAge = 0;
    } else {
      fmAge = CommonMethods.calculateAge(
          DateFormat("yyyy-MM-dd").parse(member.dob!));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      child: AppRoundView(
        corner: 10.0,
        color: const Color(0x1A486AB3),
        mChild: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextView(
                    text:
                    '${member.name!} | ${member.relation!.getRelation()}',
                    size: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  InkWell(
                    onTap: () {
                    },
                    child: Container(),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppTextView(
                    text: 'Status',
                    size: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Icon(
                        profileStatus.iconData,
                        size: 17.0,
                        color: profileStatus.statusColor,
                      ),
                      AppTextView(
                        text: profileStatus.statusName!,
                        size: 14.0,
                        fontWeight: FontWeight.w500,
                        color: profileStatus.statusColor!,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              AppKeyValue(
                mKey: 'Age',
                value: '$fmAge years',
              ),
              const SizedBox(
                height: 5.0,
              ),
              AppKeyValue(
                mKey: 'Date of Birth',
                value: member.dob == null
                    ? ''
                    : CommonMethods.changeDateFormat(member.dob!,
                    from: 'yyyy-MM-dd', to: 'dd/MM/yyyy'),
              ),
              const SizedBox(
                height: 5.0,
              ),
              AppKeyValue(
                mKey: 'Mobile',
                value: '${member.phone!}',
              ),
              AppKeyValue(
                mKey: 'Plan',
                value:
                (member.planStatus! == 1) ? 'Paid' : 'Unpaid',
              ),
              const SizedBox(
                height: 5.0,
              ),
              SizedBox(
                width: w * 0.9,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTextView(
                      text: 'Address:',
                      size: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344054),
                    ),
                    member.address == null
                        ? Container()
                        : SizedBox(
                      width: w * 0.55,
                      child: AppTextView(
                        text: member.address!,
                        size: 14.0,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF344054),
                        mTextAlign:
                        member.address!.length > 30
                            ? TextAlign.start
                            : TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
