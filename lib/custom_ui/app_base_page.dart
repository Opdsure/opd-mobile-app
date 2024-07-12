import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'app_header.dart';

class AppBasePage extends StatelessWidget{
  final Widget? appHeader;
  final Widget childContent;

  const AppBasePage({super.key,
    this.appHeader,
    required this.childContent,
  });

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    double headerHeight = MediaQuery.of(context).viewPadding.top;
    double statusBarHeight = AppBar().preferredSize.height;
    double pageHeight = statusBarHeight+headerHeight;
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: pageBackColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height,
                  child: Center(
                    child: appHeader,
                  ),
                ),
                SizedBox(
                  height: h-pageHeight,
                  child: childContent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}