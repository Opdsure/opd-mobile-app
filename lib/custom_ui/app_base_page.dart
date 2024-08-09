import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import '../config/themes.dart';
import 'app_header.dart';

class AppBasePage extends StatelessWidget {
  final Widget? appHeader;
  final Widget childContent;
  final Widget? bottomContent;

  final bool isFloatingButton;
  final bool isBottomContent;
  final Widget? floatingView;

  const AppBasePage({
    super.key,
    this.appHeader,
    this.bottomContent,
    required this.childContent,
    this.isFloatingButton = false,
    this.isBottomContent = false,
    this.floatingView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: pageBackColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appHeader != null) ...[
                  SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Center(
                      child: appHeader,
                    ),
                  ),
                ],
                Expanded(
                  child: childContent,
                )
              ],
            ),
          ),
          bottomNavigationBar: isBottomContent
              ? bottomContent
              : null,
          floatingActionButton: isFloatingButton ? floatingView : null,
        ),
      ),
    );
  }
}
