import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/utils/app_colors.dart';

class AppTextView extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color color;
  final TextAlign mTextAlign;
  final VoidCallback? onClick;
  final bool isLineThrough;
  final Color lineColor;
  final bool softWrap;

  const AppTextView(
      {required this.text,
      this.size = 15.0,
      this.softWrap = true,
      this.fontWeight = FontWeight.normal,
      this.mTextAlign = TextAlign.start,
      this.fontStyle = FontStyle.normal,
      this.color = Colors.black,
      this.onClick,
      this.isLineThrough = false,
      this.lineColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: onClick == null
          ? Text(
              text,
              textAlign: mTextAlign,
              softWrap: softWrap,
              style: GoogleFonts.montserrat(
                  fontSize: size,
                  fontWeight: fontWeight,
                  color: color,
                  fontStyle: fontStyle,
                  decoration: isLineThrough ? TextDecoration.lineThrough : null,
                  decorationColor: isLineThrough ? lineColor : null,
                  decorationThickness: 2),
            )
          : TextButton(
              onPressed: onClick,
              child: Text(
                text,
                textAlign: mTextAlign,
                softWrap: softWrap,
                style: GoogleFonts.montserrat(
                    fontSize: size,
                    fontWeight: fontWeight,
                    color: color,
                    fontStyle: fontStyle,
                    decoration:
                        isLineThrough ? TextDecoration.lineThrough : null,
                    decorationColor: isLineThrough ? lineColor : null,
                    decorationThickness: 2),
              ),
            ),
    );
  }
}
