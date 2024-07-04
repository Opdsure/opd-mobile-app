import 'package:flutter/cupertino.dart';

import 'app_text_view.dart';

class AppKeyValue extends StatelessWidget{
  final String mKey;
  final String value;

  AppKeyValue({
    this.mKey = '',
    this.value = ''
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextView(
          text: mKey,
          size: 14.0,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF344054),
        ),
        AppTextView(
          text: value,
          size: 14.0,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF344054),
        ),
      ],
    );
  }

}