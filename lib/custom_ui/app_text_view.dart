import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/utils/app_colors.dart';

class AppTextView extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign mTextAlign;
  final VoidCallback? onClick;

  const AppTextView({
    required this.text,
    this.size = 15.0,
    this.fontWeight = FontWeight.normal,
    this.mTextAlign = TextAlign.start,
    this.color = backIconCl,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: onClick == null
          ? Text(
        text,
        textAlign: mTextAlign,
        style: GoogleFonts.montserrat(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
        ),
      )
          : TextButton(
        onPressed: () {
          onClick!.call();
        },
        child: Text(
          text,
          textAlign: mTextAlign,
          style: GoogleFonts.montserrat(
            fontSize: size,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ),
    );
  }
}