import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback? onClick;

  const AppButton({
    required this.text,
    this.size = 15.0,
    this.fontWeight = FontWeight.normal,
    this.color = buttonColor,
    this.borderColor = buttonColor,
    this.onClick,
    this.textColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,
          height: 45.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: borderColor)
          ),
          child: Center(
            child: AppTextView(
              text: text,
              color: textColor,
              size: 16.0,
              fontWeight: FontWeight.w600,
            ),
          )
      ),
    );
  }
}