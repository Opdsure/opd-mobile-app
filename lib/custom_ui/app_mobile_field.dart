import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';

import '../utils/app_colors.dart';
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

  const AppMobileField({
    required this.hint,
    this.textEditingController,
    this.countryCode = '+91',
    this.size = 15.0,
    this.errorText,
    this.errorStyle,
    this.color = backIconCl,
    this.flagUri = '${mFlagUri}in.png',
    this.fontWeight = FontWeight.normal,
    this.isPasswordField = false,
    this.isViewPassword = false,
    this.countryCallback,
    this.inputFormatters
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: const Color(0xFFEAECF0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D101828), // spotColor and ambientColor combined
            blurRadius: 2,
            offset: Offset(0, 2), // assuming the shadow elevation is 2.dp
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: countryCallback,
            child: Row(
              children: [
                Image.asset(
                  flagUri,
                  fit: BoxFit.fill,
                  width: 30.0,
                ),
                const SizedBox(width: 5,),
                AppTextView(text: countryCode),
                const SizedBox(width: 5,),
                const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: backIconCl,
                )
              ],
            ),
          ),
          const VerticalDivider(
            color: backIconCl,
            thickness: 0.5,
          ),
          Flexible(
            child: TextField(
              controller: textEditingController,
              style: GoogleFonts.montserrat(
                  fontSize: size,
                  color: color
              ),
              obscureText: isViewPassword,
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
                border: InputBorder.none,
                fillColor: Colors.white,
                errorText: errorText,
                errorStyle: errorStyle,
                hintStyle: GoogleFonts.montserrat(

                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}