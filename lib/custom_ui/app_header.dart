import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';

class AppHeader extends StatelessWidget {
  final String headerName;
  final Widget? rightView;
  final bool showRightView;
  final void Function()? onBackTap;

  const AppHeader({
    super.key,
    this.headerName = 'OPDSure',
    this.rightView,
    this.showRightView = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacingLg,
        vertical: AppDesign.spacingMd,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacingXs,
          vertical: AppDesign.spacingXs,
        ),
        decoration: BoxDecoration(
          color: AppDesign.card,
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          boxShadow: AppDesign.shadowSm,
        ),
        child: Row(
          children: [
            // Back button
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                onTap: onBackTap ?? () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppDesign.surface,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppDesign.textPrimary,
                    size: 18,
                  ),
                ),
              ),
            ),
            // Title
            Expanded(
              child: Text(
                headerName,
                textAlign: TextAlign.center,
                style: AppDesign.titleLg,
              ),
            ),
            // Right view or spacer
            if (showRightView && rightView != null)
              rightView!
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
