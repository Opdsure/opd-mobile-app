import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/model/my_claim/my_claims_model.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';

class ClaimTile extends StatelessWidget {
  final ClaimRecords records;
  final ClaimStatusModel claimStatus;
  final ClaimStatusModel disputeClaimStatus;

  const ClaimTile({
    required this.records,
    required this.claimStatus,
    required this.disputeClaimStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spacingMd),
      child: AppCardView(
        onTap: () {
          context.push('/home/claim_details', extra: {
            'claim_records': records,
            'isDispute': false,
          });
        },
        padding: const EdgeInsets.all(AppDesign.spacingLg),
        mChaild: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Hospital name + Arrow
            Row(
              children: [
                Expanded(
                  child: Text(
                    records.hospital ?? 'Hospital',
                    style: AppDesign.titleLg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppDesign.textTertiary,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spacingSm),

            // Info rows
            _buildInfoRow('Patient', records.memberId!.name ?? '-'),
            _buildInfoRow('Claim ID', records.claimId ?? '-'),
            _buildInfoRow(
              'Claimable',
              '$rupeeSymbol ${records.claimableAmount!.toDouble()}',
              valueColor: AppDesign.success,
            ),
            if (records.approvedClaimableAmount != null &&
                records.approvedClaimableAmount.toString().isNotEmpty)
              _buildInfoRow(
                'Approved',
                '$rupeeSymbol ${records.approvedClaimableAmount}',
                valueColor: AppDesign.success,
              ),
            _buildInfoRow(
              'Date',
              CommonMethods.formatIsoDateString(records.createdAt!),
            ),

            const SizedBox(height: AppDesign.spacingMd),
            Divider(height: 1, color: AppDesign.divider.withOpacity(0.5)),
            const SizedBox(height: AppDesign.spacingMd),

            // Status & Actions
            if (records.status == 6 && !(records.subscriberReaction!))
              AppButton(
                text: 'Clarification Required',
                size: AppButtonSize.small,
                variant: AppButtonVariant.secondary,
                icon: Icons.info_outline_rounded,
                onClick: () {
                  context.push('/home/file_claim', extra: {
                    'isUpdate': true,
                    'records': records,
                  });
                },
              )
            else
              Row(
                children: [
                  _buildStatusChip(claimStatus),
                  if (records.dispute!) ...[
                    const SizedBox(width: AppDesign.spacingSm),
                    _buildStatusChip(disputeClaimStatus, isDispute: true),
                  ],
                ],
              ),

            // Dispute button
            if ((records.status! == 2 ||
                    records.status! == 7 ||
                    records.status! == 12) &&
                !records.dispute!) ...[
              const SizedBox(height: AppDesign.spacingMd),
              AppButton(
                text: 'Raise Dispute',
                size: AppButtonSize.small,
                variant: AppButtonVariant.outline,
                icon: Icons.gavel_rounded,
                onClick: () {
                  context.push('/home/claim_details', extra: {
                    'claim_records': records,
                    'isDispute': true,
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spacingXs),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppDesign.bodySm.copyWith(color: AppDesign.textTertiary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppDesign.bodyMd.copyWith(
                color: valueColor ?? AppDesign.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ClaimStatusModel status, {bool isDispute = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacingSm,
        vertical: AppDesign.spacingXs,
      ),
      decoration: BoxDecoration(
        color: (status.statusColor ?? AppDesign.textTertiary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.iconData,
            size: 12,
            color: status.statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            isDispute
                ? 'Dispute: ${status.statusName}'
                : status.statusName ?? '',
            style: AppDesign.caption.copyWith(
              color: status.statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
