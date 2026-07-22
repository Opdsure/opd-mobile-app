import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';

class AppHomeHeader extends StatelessWidget {
  final Widget title;

  const AppHomeHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacingLg,
        vertical: AppDesign.spacingSm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacingLg,
          vertical: AppDesign.spacingMd,
        ),
        decoration: BoxDecoration(
          color: AppDesign.card,
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          boxShadow: AppDesign.shadowSm,
        ),
        child: Row(
          children: [
            Expanded(child: title),
            const SizedBox(width: AppDesign.spacingSm),
            _HeaderIconButton(
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => context.push('/home/wallet'),
            ),
            const SizedBox(width: AppDesign.spacingSm),
            _HeaderIconButton(
              icon: Icons.notifications_outlined,
              showBadge: true,
              onTap: () => context.push('/home/notifications'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBadge;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppDesign.surface,
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppDesign.textPrimary, size: 20),
            if (showBadge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppDesign.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
