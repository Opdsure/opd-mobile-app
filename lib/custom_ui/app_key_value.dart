import 'package:flutter/cupertino.dart';

import 'app_text_view.dart';

class AppKeyValue extends StatelessWidget {
  final String mKey;
  final String value;
  final Color? keyColor;
  final Color? valueColor;

  const AppKeyValue(
      {super.key, this.mKey = '',
      this.value = '',
      this.keyColor = const Color(0xFF000000),
      this.valueColor = const Color(0xFF000000)});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextView(
          text: '$mKey:',
          size: 14.0,
          fontWeight: FontWeight.w600,
          color: keyColor!,
        ),
        AppTextView(
          text: value,
          size: 14.0,
          fontWeight: FontWeight.w500,
          color: valueColor!,
        ),
      ],
    );
  }
}
