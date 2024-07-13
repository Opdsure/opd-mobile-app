import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final ValueChanged? mOnChanged;
  final String errorMessage;
  final bool showErrorMessage;

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
    this.showErrorMessage = false
  });

  // @override
  // Widget build(BuildContext context) {
  //   return AppBorderBox(
  //     myChild: Center(
  //       child: TextField(
  //         controller: textEditingController,
  //         keyboardType: textInputType,
  //         readOnly: disableText,
  //         style: GoogleFonts.montserrat(fontSize: size, color: color),
  //         obscureText: isViewPassword,
  //         textAlignVertical: TextAlignVertical.center,
  //         onChanged: mOnChanged,
  //         decoration: InputDecoration(
  //           errorText: errorText,
  //           errorStyle: errorStyle,
  //           isDense: true,
  //           hintText: hint,
  //           border: InputBorder.none,
  //           fillColor: Colors.white,
  //           suffixIcon: viewSuffix
  //               ? isPasswordField
  //                   ? InkWell(
  //                       onTap: eyeCallback,
  //                       child: Icon(
  //                         isViewPassword
  //                             ? Icons.visibility_off_outlined
  //                             : Icons.visibility_outlined,
  //                         color: const Color(0xff667085),
  //                         size: 24.0,
  //                       ),
  //                     )
  //                   : InkWell(
  //                       onTap: eyeCallback,
  //                       child: suffixWidget,
  //                     )
  //               : null,
  //           hintStyle: GoogleFonts.montserrat(),
  //         ),
  //
  //       ),
  //     ),
  //     mCallback: viewCallback,
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBorderBox(
          myChild: Center(
            child: TextField(
              controller: textEditingController,
              keyboardType: textInputType,
              readOnly: disableText,
              style: GoogleFonts.montserrat(fontSize: size, color: color),
              obscureText: isViewPassword,
              textAlignVertical: TextAlignVertical.center,
              onChanged: mOnChanged,
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
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
