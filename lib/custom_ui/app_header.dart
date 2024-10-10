import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';
import 'app_text_view.dart';

class AppHeader extends StatelessWidget {
  final String headerName;
  final Widget? rightView;
  final bool showRightView;
  final void Function()? onBackTap;

  const AppHeader(
      {this.headerName = 'OPDSure',
      this.rightView,
      this.showRightView = false,
      this.onBackTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Material(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onBackTap ??
                        () {
                      context.pop();
                    },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: backIconCl,
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
            if (showRightView) ...[
              Align(
                alignment: Alignment.centerRight,
                child: rightView,
              )
            ],
          ],
        ),
      ),
    );
  }
}
