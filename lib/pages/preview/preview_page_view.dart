import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/login_scafold.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/preview/preview_page.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../../config/app_config.dart';
import '../../utils/app_var.dart';

class PreviewPageView extends StatelessWidget {
  final PreviewPageController controller;

  const PreviewPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    double w = CommonMethods.deviceWidth(context);
    return AppBasePage(
      childContent: Column(
        children: [
          const SizedBox(
            height: 16.0,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: AppTextView(
                onClick: controller.skip,
                text: 'Skip',
                color: AppConfig.primaryColor,
                size: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              height: 100.0,
              width: 100.0,
            ),
          ),
          SizedBox(
            height: h * 0.04,
          ),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: controller.getAllPreview(context),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only( bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.initialPage != 0)...[
                  AppButton(
                    width: w * 0.4,
                    text: 'Previous',
                    onClick: () => controller.previousPage(),
                  ),
                ],
                AppButton(
                  width: controller.initialPage == 0 ? w - 30 : w * 0.4,
                  text: 'Next',
                  onClick: () {
                    if (controller.initialPage != previewImgUri.length -1) {
                      controller.nextPage();
                    } else {
                      controller.skip();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
