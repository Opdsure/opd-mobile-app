import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_rich_text.dart';

class AppLabel extends StatelessWidget {
  final String? label;
  final bool isCompulsory;
  AppLabel({
    this.label,
    this.isCompulsory = false,
  });
  @override
  Widget build(BuildContext context) {
    return AppRichText(
      textSpan: TextSpan(
        children: [
          TextSpan(
              text: label,
              style: const TextStyle(
                  fontFamily: 'GoogleSansFlex',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D2939))),
          TextSpan(
            text: isCompulsory ? ' *' : '',
            style: const TextStyle(
                fontFamily: 'GoogleSansFlex', color: Colors.red),
          ),
        ],
      ),
    );
  }
}
