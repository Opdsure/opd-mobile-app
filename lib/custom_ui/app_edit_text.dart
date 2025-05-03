import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/utils/app_colors.dart';

import 'app_text_view.dart';

class AppEditText extends StatelessWidget {
  final String hint;
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

  const AppEditText({
    required this.hint,
    this.textEditingController,
    this.size = 15.0,
    this.fontWeight = FontWeight.normal,
    this.color = backIconCl,
    this.textInputType = TextInputType.text,
    this.isPasswordField = false,
    this.isViewPassword = false,
    this.eyeCallback,
    this.viewSuffix = false,
    this.disableText = false,
    this.suffixWidget,
    this.viewCallback,
    this.mOnChanged,
    this.errorMessage = '',
    this.showErrorMessage = false,
    this.expands = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBorderBox(
          myChild: Center(
            child: TextField(
              textCapitalization: TextCapitalization.characters,
              controller: textEditingController,
              keyboardType: textInputType,
              readOnly: disableText,
              style: GoogleFonts.montserrat(fontSize: size, color: color),
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
                fillColor: Colors.white,
                suffixIcon: viewSuffix
                    ? isPasswordField
                    ? InkWell(
                  onTap: eyeCallback,
                  child: Icon(
                    isViewPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xff667085),
                    size: 24.0,
                  ),
                )
                    : InkWell(
                  onTap: eyeCallback,
                  child: suffixWidget,
                )
                    : null,
                hintStyle: GoogleFonts.montserrat(),
              ),

            ),
          ),
          mCallback: viewCallback,
        ),
        Visibility(
          visible: showErrorMessage,
          child: AppTextView(
            text: errorMessage,
            color: Colors.red,
            size: 12.0,
          ),
        )
      ],
    );
  }
}
