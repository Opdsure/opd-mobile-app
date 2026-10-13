import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  final String text;
  final double? height;
  final double? width;
  final FontWeight fontWeight;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback? onClick;
  final double textSize;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.height,
    this.width,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.borderColor,
    this.onClick,
    this.textColor,
    this.textSize = 16.0,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _height {
    if (widget.height != null) return widget.height!;
    switch (widget.size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 52;
      case AppButtonSize.large:
        return 58;
    }
  }

  Color get _backgroundColor {
    if (widget.color != null) return widget.color!;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppDesign.primary;
      case AppButtonVariant.secondary:
        return AppDesign.accentLight;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    if (widget.textColor != null) return widget.textColor!;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return AppDesign.primary;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return AppDesign.primary;
    }
  }

  Color get _borderColor {
    if (widget.borderColor != null) return widget.borderColor!;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return Colors.transparent;
      case AppButtonVariant.secondary:
        return Colors.transparent;
      case AppButtonVariant.outline:
        return AppDesign.primary;
      case AppButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  List<BoxShadow> get _shadow {
    if (widget.variant == AppButtonVariant.primary && widget.onClick != null) {
      return [
        BoxShadow(
          color: AppDesign.primary.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // Treat a loading button as disabled so it can't be tapped again while an
    // API call is in flight (prevents duplicate submissions).
    final isDisabled = widget.onClick == null || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => _controller.forward(),
        onTapUp: isDisabled ? null : (_) => _controller.reverse(),
        onTapCancel: isDisabled ? null : () => _controller.reverse(),
        onTap: isDisabled ? null : widget.onClick,
        child: AnimatedContainer(
          duration: AppDesign.animFast,
          width: widget.fullWidth
              ? (widget.width ?? double.infinity)
              : widget.width,
          height: _height,
          decoration: BoxDecoration(
            color: isDisabled
                ? _backgroundColor.withOpacity(0.5)
                : _backgroundColor,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(
              color: isDisabled ? _borderColor.withOpacity(0.5) : _borderColor,
              width: widget.variant == AppButtonVariant.outline ? 1.5 : 0,
            ),
            boxShadow: isDisabled ? [] : _shadow,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _foregroundColor,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: _foregroundColor,
                          size: 20,
                        ),
                        const SizedBox(width: AppDesign.spacingSm),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontFamily: AppDesign.fontFamily,
                          fontSize: widget.textSize,
                          fontWeight: widget.fontWeight,
                          color: isDisabled
                              ? _foregroundColor.withOpacity(0.7)
                              : _foregroundColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
