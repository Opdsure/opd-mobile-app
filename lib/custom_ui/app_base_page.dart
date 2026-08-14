import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

class AppBasePage extends StatelessWidget {
  final Widget? appHeader;
  final Widget childContent;
  final Widget? bottomContent;
  final bool isFloatingButton;
  final bool isBottomContent;
  final bool isAddBottomPadding;
  final Widget? floatingContent;
  final Color? backgroundColor;

  const AppBasePage({
    super.key,
    this.appHeader,
    this.bottomContent,
    required this.childContent,
    this.isFloatingButton = false,
    this.isBottomContent = false,
    this.isAddBottomPadding = false,
    this.floatingContent,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor ?? AppDesign.background,
      appBar: appHeader != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(82),
              child: SafeArea(child: appHeader!),
            )
          : null,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDesign.spacingLg),
          child: Column(
            children: [
              Expanded(child: childContent),
              if (isAddBottomPadding)
                const SizedBox(height: AppDesign.spacingXl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isBottomContent ? bottomContent : null,
      floatingActionButton: isFloatingButton ? floatingContent : null,
    );
  }
}
