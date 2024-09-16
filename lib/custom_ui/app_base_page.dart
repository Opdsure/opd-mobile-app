import 'package:flutter/material.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/utils/app_colors.dart';

class AppBasePage extends StatelessWidget {
  final Widget? appHeader;
  final Widget childContent;
  final Widget? bottomContent;
  final bool isFloatingButton;
  final bool isBottomContent;
  final Widget? floatingContent;

  const AppBasePage({
    super.key,
    this.appHeader,
    this.bottomContent,
    required this.childContent,
    this.isFloatingButton = false,
    this.isBottomContent = false,
    this.floatingContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppConfig.primaryColorLight,
      appBar: appHeader != null
          ? PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height + 15),
        child: SafeArea(child: appHeader!),
      )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Expanded(
              child: childContent,
            ),
          ],
        ),
      ),
      bottomNavigationBar: isBottomContent ? bottomContent : null,
      floatingActionButton: isFloatingButton ? floatingContent : null,
    );
  }
}
