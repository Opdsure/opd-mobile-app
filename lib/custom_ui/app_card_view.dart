import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

class AppCardView extends StatelessWidget {
  final Widget mChaild;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadow;
  final double? borderRadius;
  final Border? border;
  final VoidCallback? onTap;

  const AppCardView({
    super.key,
    required this.mChaild,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.shadow,
    this.borderRadius,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: AppDesign.animFast,
      padding: padding ?? const EdgeInsets.all(AppDesign.spacingLg),
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppDesign.card) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDesign.radiusLg,
        ),
        border: border,
        boxShadow: shadow ?? AppDesign.shadowSm,
      ),
      child: mChaild,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}

/// A premium gradient card for hero sections
class AppGradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;

  const AppGradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDesign.spacingXl),
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ?? AppDesign.heroGradient,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDesign.radiusXl,
        ),
        boxShadow: AppDesign.shadowXl,
      ),
      child: child,
    );
  }
}
