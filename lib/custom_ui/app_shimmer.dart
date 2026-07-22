import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

/// Premium shimmer loading placeholder widget
/// Inspired by iOS skeleton loading and CRED shimmer effects
class AppShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = AppDesign.radiusMd,
    this.margin,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFEEF0F5),
                Color(0xFFF8F9FB),
                Color(0xFFEEF0F5),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer card for list loading states
class AppShimmerCard extends StatelessWidget {
  final int lines;
  final bool showAvatar;
  final bool showAction;

  const AppShimmerCard({
    super.key,
    this.lines = 3,
    this.showAvatar = false,
    this.showAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      margin: const EdgeInsets.only(bottom: AppDesign.spacingMd),
      decoration: BoxDecoration(
        color: AppDesign.card,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        boxShadow: AppDesign.shadowSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            const AppShimmer(
              width: 48,
              height: 48,
              borderRadius: AppDesign.radiusFull,
            ),
            const SizedBox(width: AppDesign.spacingMd),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmer(width: 140, height: 14),
                const SizedBox(height: AppDesign.spacingSm),
                for (int i = 0; i < lines; i++) ...[
                  AppShimmer(
                    height: 12,
                    width: i == lines - 1 ? 100 : double.infinity,
                  ),
                  if (i < lines - 1)
                    const SizedBox(height: AppDesign.spacingSm),
                ],
              ],
            ),
          ),
          if (showAction) ...[
            const SizedBox(width: AppDesign.spacingMd),
            const AppShimmer(
              width: 32,
              height: 32,
              borderRadius: AppDesign.radiusSm,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer list for loading states - replaces CircularProgressIndicator
class AppShimmerList extends StatelessWidget {
  final int itemCount;
  final bool showAvatar;

  const AppShimmerList({
    super.key,
    this.itemCount = 5,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return AppShimmerCard(
          showAvatar: showAvatar,
          lines: index % 2 == 0 ? 3 : 2,
        );
      },
    );
  }
}

/// Empty state widget with illustration placeholder
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spacing3Xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppDesign.accentLight,
                borderRadius: BorderRadius.circular(AppDesign.radiusXxl),
              ),
              child: Icon(
                icon,
                size: 36,
                color: AppDesign.accent,
              ),
            ),
            const SizedBox(height: AppDesign.spacingXxl),
            Text(
              title,
              style: AppDesign.headingSm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesign.spacingSm),
            Text(
              description,
              style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppDesign.spacingXxl),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spacingXxl,
                    vertical: AppDesign.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: AppDesign.primary,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                    boxShadow: AppDesign.shadowGlow,
                  ),
                  child: Text(
                    actionText!,
                    style: AppDesign.button,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
