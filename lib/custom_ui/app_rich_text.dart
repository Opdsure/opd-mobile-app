import 'package:flutter/material.dart';
import 'package:opdsure/config/app_config.dart';

class AppRichText extends StatelessWidget {
  final InlineSpan textSpan;
  const AppRichText({required this.textSpan, super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        textScaler: TextScaler.linear(AppConfig.fontSizeFactor),
        textSpan);
  }
}
