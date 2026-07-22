import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

class ClaimCountTile extends StatelessWidget {
  final String title;
  final int count;

  const ClaimCountTile({
    super.key,
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDesign.spacingSm),
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      decoration: BoxDecoration(
        color: AppDesign.card,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: AppDesign.divider),
        boxShadow: AppDesign.shadowSm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppDesign.labelSm,
          ),
          const SizedBox(height: AppDesign.spacingXs),
          Text(
            count.toString(),
            style: AppDesign.headingSm.copyWith(
              color: AppDesign.primary,
            ),
          ),
        ],
      ),
    );
  }
}
