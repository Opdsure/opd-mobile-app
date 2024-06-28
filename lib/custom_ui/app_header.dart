import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'app_text_view.dart';

class AppHeader extends StatelessWidget{
  final String headerName;

  AppHeader({
    this.headerName = 'OPDSure'
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        const Align(
          alignment: Alignment.bottomLeft,
          child: Icon(
            Icons.arrow_back_ios,
            color: backIconCl,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AppTextView(
            text: headerName,
            size: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}