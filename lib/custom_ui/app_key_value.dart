import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

class AppKeyValue extends StatelessWidget {
  final String mKey;
  final String value;
  final Color? keyColor;
  final Color? valueColor;
  final bool showDivider;

  const AppKeyValue({
    super.key,
    this.mKey = '',
    this.value = '',
    this.keyColor,
    this.valueColor,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDesign.spacingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mKey,
                style: AppDesign.bodyMd.copyWith(
                  color: keyColor ?? AppDesign.textSecondary,
                ),
              ),
              const SizedBox(width: AppDesign.spacingLg),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: AppDesign.titleMd.copyWith(
                    color: valueColor ?? AppDesign.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: AppDesign.divider.withOpacity(0.5),
          ),
      ],
    );
  }
}
