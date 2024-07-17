import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'app_text_view.dart';

class AppHeader extends StatelessWidget{
  final String headerName;
  final Widget? rightView;
  final bool showRightView;

  AppHeader({
    this.headerName = 'OPDSure',
    this.rightView,
    this.showRightView = false
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: (){
              Navigator.of(context,rootNavigator: false).pop();
            },
            child: const SizedBox(
              height: 40.0,
              width: 40.0,
              child: Icon(
                Icons.arrow_back_ios,
                color: backIconCl,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AppTextView(
            text: headerName,
            size: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        showRightView?Align(
          alignment: Alignment.centerRight,
          child: rightView,
        ):Container(),
      ],
    );
  }

}