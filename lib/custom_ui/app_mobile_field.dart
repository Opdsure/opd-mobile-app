import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';

import '../utils/app_var.dart';

class AppMobileField extends StatelessWidget {
  final String hint;
  final String countryCode;
  final String flagUri;
  final double size;
  final FontWeight fontWeight;
  final bool isPasswordField;
  final Color color;
  final bool isViewPassword;
  final VoidCallback? countryCallback;
  final TextEditingController? textEditingController;
  final String? errorText;
  final TextStyle? errorStyle;
  final List<TextInputFormatter>? inputFormatters;
  final String errorMessage;
  final bool showErrorMessage;
  final int? maxLength;
  final bool disableText;
  final ValueChanged<String>? mOnChanged;
  final FocusNode? focusNode;

  const AppMobileField({
    super.key,
    required this.hint,
    this.textEditingController,
    this.countryCode = '+91',
    this.size = 15.0,
    this.errorText,
    this.errorStyle,
    this.disableText = false,
    this.color = AppDesign.textPrimary,
    this.flagUri = '${mFlagUri}in.png',
    this.fontWeight = FontWeight.normal,
    this.isPasswordField = false,
    this.isViewPassword = false,
    this.mOnChanged,
    this.countryCallback,
    this.inputFormatters,
    this.errorMessage = '',
    this.showErrorMessage = false,
    this.maxLength,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: AppDesign.spacingMd),
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
          child: Row(
            children: [
              GestureDetector(
                onTap: countryCallback,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.asset(
                        flagUri,
                        fit: BoxFit.fill,
                        width: 28,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: AppDesign.spacingSm),
                    Text(
                      countryCode,
                      style: TextStyle(
                        fontFamily: AppDesign.fontFamily,
                        fontSize: size,
                        fontWeight: FontWeight.w500,
                        color: AppDesign.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppDesign.spacingXs),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppDesign.textTertiary,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Container(
                height: 28,
                width: 1,
                margin: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spacingMd,
                ),
                color: AppDesign.divider,
              ),
              Flexible(
                child: TextField(
                  controller: textEditingController,
                  style: TextStyle(
                    fontFamily: AppDesign.fontFamily,
                    fontSize: size,
                    color: color,
                  ),
                  focusNode: focusNode,
                  obscureText: isViewPassword,
                  textAlignVertical: TextAlignVertical.center,
                  inputFormatters: inputFormatters,
                  keyboardType: TextInputType.phone,
                  readOnly: disableText,
                  maxLength: maxLength,
                  onChanged: mOnChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                      fontFamily: AppDesign.fontFamily,
                      fontSize: size,
                      color: AppDesign.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
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
