import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/config/route.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/model/my_claim/my_claims_model.dart';

import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_card_view.dart';
import '../../custom_ui/app_text_view.dart';
import '../../utils/app_var.dart';
import '../../utils/common_methods.dart';
import '../file_claim_page.dart';
import 'claims_details_page.dart';


class ClaimTile extends StatelessWidget {
  final ClaimRecords records;
  final ClaimStatusModel claimStatus;
  final ClaimStatusModel disputeClaimStatus;
  const ClaimTile({required this.records, required this.claimStatus, required this.disputeClaimStatus, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 5.0),
      child: InkWell(
        onTap: () {
          context.push('/home/claim_details', extra: {
            'claim_records': records,
            'isDispute': false,
          });
        },
        child: AppCardView(
          mChaild: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  AppTextView(
                    text:
                    'Hospital | ${records.hospital} ',
                    size: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Icon(
                    Icons
                        .keyboard_arrow_right_sharp,
                    color: Colors.black,
                  )
                ],
              ),
              const SizedBox(
                height: 2.0,
              ),
              AppTextView(
                text:
                'Applicant name : ${records.memberId!.name}',
                size: 12.0,
                color: const Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
              AppTextView(
                text:
                'Hospital : ${records.hospital!}',
                size: 12.0,
                color: const Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
              AppTextView(
                text:
                'Claim ID : ${records.claimId}',
                size: 12.0,
                color: const Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text:
                        'Claimable Amount: ',
                        style: GoogleFonts
                            .montserrat(
                          fontSize: 12.0,
                          fontWeight:
                          FontWeight.w500,
                          color: const Color(
                              0xFF667085),
                        )),
                    TextSpan(
                      text:
                      '$rupeeSymbol ${records.claimableAmount!.toDouble()}',
                      style: GoogleFonts
                          .montserrat(
                          fontSize: 12.0,
                          fontWeight:
                          FontWeight
                              .w500,
                          color: const Color(
                              0xFF027A48)),
                    ),
                  ],
                ),
              ),
              AppTextView(
                text:
                'Claim Date: ${CommonMethods.formatIsoDateString(records.createdAt!)}',
                size: 12.0,
                color:
                const Color(0xFF667085),
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 5,
              ),
              (records.status == 6 && !(records.subscriberReaction!))
                  ? AppButton(
                text:
                'Clarification Required',
                height: 40.0,
                width: CommonMethods
                    .deviceWidth(
                    context),
                textSize: 14.0,
                fontWeight:
                FontWeight.w500,
                onClick: () {
                  context.push('/home/file_claim', extra: true);
                },
              )
                  : Row(
                children: [
                  const AppTextView(
                    text: 'Status: ',
                    size: 12.0,
                    color: Color(
                        0xFF667085),
                    fontWeight:
                    FontWeight
                        .w500,
                  ),
                  Icon(
                    claimStatus
                        .iconData,
                    color: claimStatus
                        .statusColor,
                    size: 15.0,
                  ),
                  AppTextView(
                    text:
                    ' ${claimStatus.statusName}',
                    size: 12.0,
                    color: claimStatus
                        .statusColor!,
                    fontWeight:
                    FontWeight
                        .w500,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              if((records.status! == 2 || records.status! == 7 || records.status! == 12))...[
                !records.dispute!
                    ? AppButton(
                  text: 'Raise Dispute',
                  height: 40.0,
                  width: CommonMethods.deviceWidth(context),
                  textSize: 14.0,
                  fontWeight:
                  FontWeight.w500,
                  onClick: () {
                    context.push('/home/claim_details', extra: {
                      'claim_records': records,
                      'isDispute': true,
                    });
                  },
                )
                    : Row(
                  children: [
                    const AppTextView(
                      text: 'Dispute status: ',
                      size: 12.0,
                      color: Color(
                          0xFF667085),
                      fontWeight:
                      FontWeight
                          .w500,
                    ),
                    Icon(
                      disputeClaimStatus.iconData,
                      color: disputeClaimStatus.statusColor,
                      size: 15.0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    AppTextView(
                      text:
                      disputeClaimStatus.statusName!,
                      size: 12.0,
                      color: disputeClaimStatus.statusColor!,
                    ),
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
