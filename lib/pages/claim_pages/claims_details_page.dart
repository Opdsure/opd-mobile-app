import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/model/my_claim/my_claims_model.dart';
import 'package:opdsure/pages/claim_pages/dispute_page.dart';

import '../../utils/app_var.dart';
import '../../utils/common_methods.dart';

class ClaimsDetailsPage extends StatelessWidget {
  final ClaimRecords oneClaim;
  final bool isDispute;

  const ClaimsDetailsPage(
      {required this.oneClaim, this.isDispute = false, super.key});

  Widget commonRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextView(
          text: key,
          size: 14.0,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF344054),
        ),
        AppTextView(
          text: value,
          size: 14.0,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF344054),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ClaimStatusModel claimStatusModel = ClaimStatusModel().getClaimBuStatus(
        oneClaim.status!!!,
        reSubmit: oneClaim.subscriberReaction!);
    ClaimStatusModel disputeClaimStatusModel =
        ClaimStatusModel().getDisputeClaimBuStatus(oneClaim.disputeDetails!);
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Claim Details',
      ),
      childContent: ListView(
        children: [
          if ((oneClaim.status! == 2 ||
                  oneClaim.status! == 7 ||
                  oneClaim.status! == 12) &&
              !oneClaim.dispute! &&
              isDispute) ...[DisputePage(oneClaim.id)],
          AppCardView(
            mChaild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextView(
                  text: 'Hospital | ${oneClaim.hospital} ',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Claim Date',
                    CommonMethods.formatIsoDateString(oneClaim.createdAt!)),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Name', oneClaim.memberId!.name!),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Doctor Name', oneClaim.docName!),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Doc. Reg. Number', oneClaim.docRegistration!),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Hospital Address', oneClaim.city!),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Hospital Cont. Info.', '${oneClaim.docPhone!}'),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Doctor Email', oneClaim.docEmail!),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Name', oneClaim.memberId!.name!),
                const SizedBox(
                  height: 7.0,
                ),
                // commonRow(
                //     'OPD date',
                //     CommonMethods.changeDateFormat(oneClaim.opdDate!,
                //         from: 'yyyy-MM-dd', to: 'dd/MM/yyyy')),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Address', oneClaim.docAddress!),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('City', oneClaim.city!),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Pin Code', oneClaim.pincode!.toString()),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow(
                    'Total Pay Amt', '$rupeeSymbol ${oneClaim.billAmount!}'),
                const SizedBox(
                  height: 7.0,
                ),
                commonRow('Claimable Amt.',
                    '$rupeeSymbol ${oneClaim.claimableAmount}'),
                const SizedBox(
                  height: 7.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppTextView(
                      text: 'Status',
                      size: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344054),
                    ),
                    Row(
                      children: [
                        Icon(
                          claimStatusModel.iconData,
                          color: claimStatusModel.statusColor,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        AppTextView(
                          text: claimStatusModel.statusName!,
                          size: 14.0,
                          fontWeight: FontWeight.w500,
                          color: claimStatusModel.statusColor!,
                        ),
                      ],
                    ),
                  ],
                ),
                if ((oneClaim.status! == 2 ||
                        oneClaim.status! == 7 ||
                        oneClaim.status! == 12) &&
                    oneClaim.dispute!) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextView(
                        text: 'Dispute status',
                        size: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF344054),
                      ),
                      Row(
                        children: [
                          Icon(
                            disputeClaimStatusModel.iconData,
                            color: disputeClaimStatusModel.statusColor,
                            size: 15.0,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          AppTextView(
                            text: disputeClaimStatusModel.statusName!,
                            size: 14.0,
                            fontWeight: FontWeight.w500,
                            color: disputeClaimStatusModel.statusColor!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          if (oneClaim.subscriberRemark!.isNotEmpty) ...[
            AppCardView(
              mChaild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextView(
                    text: 'Remarks',
                    size: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: oneClaim.subscriberRemark!.length,
                        itemBuilder: (context, index) {
                          return commonRow(
                              oneClaim.subscriberRemark![index].designation! ==
                                      -1
                                  ? 'Subscriber'
                                  : 'Support',
                              oneClaim.subscriberRemark![index].message!);
                        }),
                  ),
                ],
              ),
            )
          ],
          const SizedBox(
            height: 15.0,
          ),
          const SizedBox(height: 70.0),
        ],
      ),
    );
  }
}
