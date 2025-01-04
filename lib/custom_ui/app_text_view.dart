import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';

class AppTextView extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color color;
  final TextAlign mTextAlign;

  final TextOverflow? textOverflow;
  final VoidCallback? onClick;
  final bool isLineThrough;
  final Color lineColor;
  final bool softWrap;
  final int? maxLines;
  final int? minLines;

  const AppTextView({
    super.key,
    required this.text,
    this.size = 15.0,
    this.softWrap = true,
    this.textOverflow,
    this.fontWeight = FontWeight.normal,
    this.mTextAlign = TextAlign.start,
    this.fontStyle = FontStyle.normal,
    this.color = Colors.black,
    this.onClick,
    this.isLineThrough = false,
    this.lineColor = Colors.grey,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: onClick == null
          ? Text(
        text,
        textAlign: mTextAlign,
        softWrap: softWrap,
        overflow: textOverflow, // Apply only if not null
        maxLines: maxLines, // Apply only if not null
        textScaler: TextScaler.linear(AppConfig.fontSizeFactor),
        style: GoogleFonts.montserrat(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
          fontStyle: fontStyle,
          decoration: isLineThrough ? TextDecoration.lineThrough : null,
          decorationColor: isLineThrough ? lineColor : null,
          decorationThickness: 2,
        ),
      )
          : TextButton(
        onPressed: onClick,
        child: Text(
          text,
          textAlign: mTextAlign,
          softWrap: softWrap,
          overflow: textOverflow, // Apply only if not null
          maxLines: maxLines, // Apply only if not null
          textScaler: TextScaler.linear(AppConfig.fontSizeFactor),
          style: GoogleFonts.montserrat(
            fontSize: size,
            fontWeight: fontWeight,
            color: color,
            fontStyle: fontStyle,
            decoration:
            isLineThrough ? TextDecoration.lineThrough : null,
            decorationColor: isLineThrough ? lineColor : null,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../config/app_config.dart';
//
// class AppTextView extends StatelessWidget {
//   final String text;
//   final double size;
//   final FontWeight fontWeight;
//   final FontStyle fontStyle;
//   final Color color;
//   final TextAlign mTextAlign;
//
//   final TextOverflow? textOverflow;
//   final VoidCallback? onClick;
//   final bool isLineThrough;
//   final Color lineColor;
//   final bool softWrap;
//
//   const AppTextView({
//     super.key,
//     required this.text,
//     this.size = 15.0,
//     this.softWrap = true,
//     this.textOverflow = TextOverflow.ellipsis, // Default to ellipsis
//     this.fontWeight = FontWeight.normal,
//     this.mTextAlign = TextAlign.start,
//     this.fontStyle = FontStyle.normal,
//     this.color = Colors.black,
//     this.onClick,
//     this.isLineThrough = false,
//     this.lineColor = Colors.grey,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: onClick == null
//           ? Text(
//         text,
//         textAlign: mTextAlign,
//         softWrap: softWrap,
//         overflow: textOverflow,
//         maxLines: 1, // Set max lines to 2
//         textScaler: TextScaler.linear(AppConfig.fontSizeFactor),
//         style: GoogleFonts.montserrat(
//           fontSize: size,
//           fontWeight: fontWeight,
//           color: color,
//           fontStyle: fontStyle,
//           decoration: isLineThrough ? TextDecoration.lineThrough : null,
//           decorationColor: isLineThrough ? lineColor : null,
//           decorationThickness: 2,
//         ),
//       )
//           : TextButton(
//         onPressed: onClick,
//         child: Text(
//           text,
//           textAlign: mTextAlign,
//           softWrap: softWrap,
//           overflow: textOverflow,
//           maxLines: 2, // Set max lines to 2
//           textScaler: TextScaler.linear(AppConfig.fontSizeFactor),
//           style: GoogleFonts.montserrat(
//             fontSize: size,
//             fontWeight: fontWeight,
//             color: color,
//             fontStyle: fontStyle,
//             decoration:
//             isLineThrough ? TextDecoration.lineThrough : null,
//             decorationColor: isLineThrough ? lineColor : null,
//             decorationThickness: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }
