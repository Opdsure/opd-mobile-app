import 'package:flutter/material.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/pages/preview/preview_page.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../utils/app_var.dart';

class PreviewPageView extends StatelessWidget {
  final PreviewPageController controller;

  const PreviewPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final h = CommonMethods.deviceHeight(context);
    final w = CommonMethods.deviceWidth(context);
    final isLastPage = controller.currentPage == previewImgUri.length - 1;

    return AppBasePage(
      childContent: Column(
        children: [
          const SizedBox(height: 16.0),
          // Skip button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: AppTextView(
                onClick: controller.skip,
                text: 'Skip',
                color: AppConfig.primaryColor,
                size: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // PageView swiper
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: previewImgUri.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/${previewImgUri[index]}.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    AppTextView(
                      text: previewTitleStr[index],
                      size: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      mTextAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AppTextView(
                        text: previewDescriptionStr[index],
                        size: 16.0,
                        color: Colors.black54,
                        mTextAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20.0),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              previewImgUri.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 10.0,
                width: controller.currentPage == index ? 24.0 : 10.0,
                decoration: BoxDecoration(
                  color: controller.currentPage == index
                      ? AppConfig.primaryColor
                      : AppConfig.primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          // Action button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: AppButton(
              width: w - 30,
              text: isLastPage ? 'Get Started' : 'Next',
              onClick: controller.nextPage,
            ),
          ),
        ],
      ),
    );
  }
}
