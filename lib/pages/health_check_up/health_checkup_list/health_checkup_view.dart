import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../../utils/app_var.dart';
import 'health_checkup_controller.dart';

class HealthCheckupView extends StatelessWidget {
  final HealthCheckupController controller;

  const HealthCheckupView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHomeHeader(
        title: Text('Health Checkup Plan', style: AppDesign.titleLg),
      ),
      childContent: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (controller.healthCheckupResponse == null) {
      return _buildEmptyState();
    }

    final records = controller.healthCheckupResponse!.data!.records!;

    if (records.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: records.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: AppDesign.spacingSm),
      itemBuilder: (context, index) {
        HealthCheckupRecords healthCheckupRecords = records[index];
        String basePriceShow = (healthCheckupRecords.basePrice! +
                (healthCheckupRecords.basePrice! * 18) / 100)
            .toStringAsFixed(2);
        String discountPriceShow = (healthCheckupRecords.discountedPrice! +
                (healthCheckupRecords.discountedPrice! * 18) / 100)
            .toStringAsFixed(2);
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDesign.spacingMd),
          child: AppCardView(
            onTap: () {
              context.push('/home/health_checkup_details',
                  extra: {"plan": healthCheckupRecords, "isView": false});
            },
            mChaild: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkup code badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesign.spacingSm,
                          vertical: AppDesign.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppDesign.accentLight,
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusSm),
                        ),
                        child: Text(
                          healthCheckupRecords.checkupCode ?? '',
                          style: AppDesign.caption.copyWith(
                            color: AppDesign.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDesign.spacingSm),
                      // Name
                      Text(
                        healthCheckupRecords.name!,
                        style: AppDesign.bodyMd.copyWith(
                          color: AppDesign.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDesign.spacingSm),
                      // Prices row
                      Row(
                        children: [
                          Text(
                            '$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, basePriceShow)}',
                            style: AppDesign.bodySm.copyWith(
                              color: AppDesign.textTertiary,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppDesign.textTertiary,
                            ),
                          ),
                          const SizedBox(width: AppDesign.spacingMd),
                          Text(
                            '$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, roundOff: true, discountPriceShow)}',
                            style: AppDesign.titleMd.copyWith(
                              color: AppDesign.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppDesign.textTertiary,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
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
              Icons.medical_services_outlined,
              size: 32,
              color: AppDesign.accent,
            ),
          ),
          const SizedBox(height: AppDesign.spacingLg),
          Text(
            'No Health Checkups Available',
            style: AppDesign.titleLg.copyWith(color: AppDesign.textSecondary),
          ),
          const SizedBox(height: AppDesign.spacingSm),
          const Text(
            'Check back later for available plans',
            style: AppDesign.bodySm,
          ),
        ],
      ),
    );
  }
}
