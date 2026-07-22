import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';

class AppEditText extends StatelessWidget {
  final String hint;
  final String? label;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final TextInputType textInputType;
  final bool isPasswordField;
  final bool isViewPassword;
  final VoidCallback? eyeCallback;
  final bool viewSuffix;
  final bool disableText;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final TextEditingController? textEditingController;
  final VoidCallback? viewCallback;
  final ValueChanged<String>? mOnChanged;
  final String errorMessage;
  final bool showErrorMessage;
  final bool expands;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  const AppEditText({
    super.key,
    required this.hint,
    this.label,
    this.textEditingController,
    this.size = 15.0,
    this.fontWeight = FontWeight.normal,
    this.color = AppDesign.textPrimary,
    this.textInputType = TextInputType.text,
    this.isPasswordField = false,
    this.isViewPassword = false,
    this.eyeCallback,
    this.viewSuffix = false,
    this.disableText = false,
    this.suffixWidget,
    this.prefixWidget,
    this.viewCallback,
    this.mOnChanged,
    this.errorMessage = '',
    this.showErrorMessage = false,
    this.expands = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppDesign.labelLg,
          ),
          const SizedBox(height: AppDesign.spacingSm),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppDesign.inputFill,
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            border: Border.all(
              color: showErrorMessage ? AppDesign.error : AppDesign.inputBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A1D2E).withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            textCapitalization: textCapitalization,
            controller: textEditingController,
            keyboardType: textInputType,
            readOnly: disableText,
            style: TextStyle(
              fontFamily: AppDesign.fontFamily,
              fontSize: size,
              fontWeight: fontWeight,
              color: color,
            ),
            obscureText: isViewPassword,
            maxLength: maxLength,
            minLines: minLines,
            maxLines: maxLines,
            expands: expands,
            textAlignVertical: TextAlignVertical.center,
            onChanged: mOnChanged,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spacingLg,
                vertical: AppDesign.spacingMd + 2,
              ),
              prefixIcon: prefixWidget,
              suffixIcon: viewSuffix
                  ? isPasswordField
                      ? GestureDetector(
                          onTap: eyeCallback,
                          child: Icon(
                            isViewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppDesign.textTertiary,
                            size: 22,
                          ),
                        )
                      : GestureDetector(
                          onTap: eyeCallback,
                          child: suffixWidget,
                        )
                  : null,
              hintStyle: TextStyle(
                fontFamily: AppDesign.fontFamily,
                fontSize: size,
                color: AppDesign.textTertiary,
              ),
            ),
          ),
        ),
        if (showErrorMessage) ...[
          const SizedBox(height: AppDesign.spacingXs),
          Text(
            errorMessage,
            style: AppDesign.bodySm.copyWith(color: AppDesign.error),
          ),
        ],
      ],
    );
  }
}
