import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_round_box.dart';
import 'package:opdsure/utils/app_colors.dart';

class AppEditText extends StatelessWidget {
  final String hint;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final TextInputType textInputType;
  final bool isPasswordField;
  final bool isViewPassword;
  final VoidCallback? eyeCallback;

  const AppEditText({
    required this.hint,
    this.size = 15.0,
    this.fontWeight = FontWeight.normal,
    this.color = backIconCl,
    this.textInputType = TextInputType.text,
    this.isPasswordField = false,
    this.isViewPassword = false,
    this.eyeCallback
  });

  @override
  Widget build(BuildContext context) {
    return AppRoundBox(
      myChild: Center(
        child: TextField(
          keyboardType: textInputType,
          style: GoogleFonts.montserrat(
              fontSize: size,
              color: color
          ),
          obscureText: isViewPassword,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            border: InputBorder.none,
            suffixIcon: isPasswordField?InkWell(
              onTap: eyeCallback,
              child: Icon(
                isViewPassword?Icons.visibility_off_outlined:Icons.visibility_outlined,
                color: const Color(0xff667085),
                size: 24.0,
              ),
            ):null,
            hintStyle: GoogleFonts.montserrat(

            ),
          ),
        ),
      ),
    );
  }
}