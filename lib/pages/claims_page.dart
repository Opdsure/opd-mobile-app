import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/pages/checkout/checkout_controller.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../model/my_claim/my_claims_model.dart';
import 'claim_pages/claim_tile.dart';

class ClaimsPage extends StatelessWidget {
  const ClaimsPage({super.key});

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    return DefaultTabController(
      length: 2,
      child: AppBasePage(
        appHeader: AppHomeHeader(
          title: Text('Claims', style: AppDesign.titleLg),
        ),
        childContent: Column(
          children: [
            _buildFileClaimBanner(context),
            const SizedBox(height: AppDesign.spacingXl),
            Expanded(
              child: Obx(() {
                bool refresh = typeController.refreshClaimList.value;
                return refresh
                    ? FutureBuilder<MyClaimsModel?>(
                        future: OpdSure.of(context).client.getAllClaims(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildLoadingState();
                          }
                          if (snapshot.data == null) {
                            return _buildLoadingState();
                          }
                          MyClaimsModel? myClaimsModel = snapshot.data;
                          List<ClaimRecords> listData =
                              myClaimsModel!.data!.records!;
                          if (listData.isEmpty) {
                            return _buildEmptyState();
                          }
                          return RefreshIndicator(
                            color: AppDesign.primary,
                            onRefresh: () async {
                              typeController.refreshClaimListChange(false);
                              typeController.refreshClaimListChange(true);
                            },
                            child: ListView.builder(
                              itemCount: listData.length,
                              itemBuilder: (context, index) {
                                ClaimRecords records = listData[index];
                                ClaimStatusModel claimStatusModel =
                                    ClaimStatusModel().getClaimBuStatus(
                                        records.status!,
                                        reSubmit: records.resubmission!);
                                ClaimStatusModel disputeClaimStatus =
                                    ClaimStatusModel().getDisputeClaimBuStatus(
                                        records.disputeDetails!);
                                return ClaimTile(
                                  records: records,
                                  claimStatus: claimStatusModel,
                                  disputeClaimStatus: disputeClaimStatus,
                                );
                              },
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileClaimBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppDesign.accentGradient,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        boxShadow: AppDesign.shadowMd,
      ),
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              Text(
                'File a new claim',
                style: AppDesign.titleLg.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingLg),
          Divider(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),
          const SizedBox(height: AppDesign.spacingLg),
          OpdSure.of(context).client.isPlanPurchased
              ? AppButton(
                  text: 'File a claim',
                  color: Colors.white,
                  textColor: AppDesign.accent,
                  onClick: () {
                    context.push('/home/file_claim', extra: {
                      'isUpdate': false,
                      'records': null,
                    });
                  },
                )
              : AppButton(
                  text: 'Select Plan',
                  color: Colors.white,
                  textColor: AppDesign.accent,
                  onClick: () {
                    context.go('/view_plans', extra: PaymentType.buyPlan);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppDesign.accent.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: AppDesign.spacingMd),
          Text(
            'Loading claims...',
            style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppDesign.accentLight,
              borderRadius: BorderRadius.circular(AppDesign.radiusFull),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 32,
              color: AppDesign.accent,
            ),
          ),
          const SizedBox(height: AppDesign.spacingLg),
          Text(
            'No Claims Found',
            style: AppDesign.titleLg.copyWith(color: AppDesign.textSecondary),
          ),
          const SizedBox(height: AppDesign.spacingSm),
          const Text(
            'Your filed claims will appear here',
            style: AppDesign.bodySm,
          ),
        ],
      ),
    );
  }
}
