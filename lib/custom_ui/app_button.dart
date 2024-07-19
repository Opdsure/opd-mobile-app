import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final FontWeight fontWeight;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback? onClick;
  final double textSize;
  const AppButton({super.key,
    required this.text,
    this.height = 45.0,
    this.width = double.infinity,
    this.fontWeight = FontWeight.w600,
    this.color = buttonColor,
    this.borderColor = buttonColor,
    this.onClick,
    this.textColor = Colors.white,
    this.textSize = 16.0,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: borderColor)
          ),
          child: Center(
            child: AppTextView(
              text: text,
              color: textColor,
              size: textSize,
              fontWeight: fontWeight,
            ),
          )
      ),
    );
  }
}