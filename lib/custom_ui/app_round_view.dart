import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';

import '../utils/app_colors.dart';

class AppRoundView extends StatelessWidget {
  final Widget mChild;
  final double corner;
  final double width;
  final Color color;
  final VoidCallback? onClick;
  final bool isMargin;
  final bool isPadding;

  const AppRoundView({
    required this.mChild,
    this.corner = 15.0,
    this.width = double.infinity,
    this.color = Colors.white,
    this.onClick,
    this.isMargin = false,
    this.isPadding = false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: isMargin ? const EdgeInsets.only(bottom: 5) : null,
        padding: isPadding ? const EdgeInsets.all(8) : null,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(corner)),
        ),
        child: mChild,
      ),
    );
  }
}