import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final VoidCallback? onClick;

  const AppButton({
    required this.text,
    this.size = 15.0,
    this.fontWeight = FontWeight.normal,
    this.color = backIconCl,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
        height: 45.0,
        decoration: const BoxDecoration(
          color: buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Center(
          child: AppTextView(
            text: text,
            color: Colors.white,
            size: 16.0,
            fontWeight: FontWeight.w600,
          ),
        )
    );
  }
}