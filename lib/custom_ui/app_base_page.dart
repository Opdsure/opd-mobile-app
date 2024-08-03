import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import '../config/themes.dart';
import 'app_header.dart';

class AppBasePage extends StatelessWidget{
  final Widget? appHeader;
  final Widget childContent;
  final Widget? bottomContent;
  final bool enforceMobileMode;
  final bool isFloatingButton;
  final Widget? floatingView;

  const AppBasePage({super.key,
    this.appHeader,
    this.bottomContent,
    required this.childContent,
    this.enforceMobileMode = false,
    this.isFloatingButton = false,
    this.floatingView,
  });

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    double headerHeight = MediaQuery.of(context).viewPadding.top;
    double statusBarHeight = AppBar().preferredSize.height;
    double pageHeight = statusBarHeight+headerHeight;
    final isMobileMode = enforceMobileMode || !OpdThemes.isColumnMode(context);
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
          bottomNavigationBar: bottomContent,
          floatingActionButton: isFloatingButton?floatingView:null,
        ),
      ),
    );
  }
}