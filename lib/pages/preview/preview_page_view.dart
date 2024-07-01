import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/preview/preview_page.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../../utils/app_var.dart';

class PreviewPageView extends StatelessWidget{
  final PreviewPageController controller;
  const PreviewPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    double h = CommonMethods.deviceHeight(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 16.0,),
           Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const  EdgeInsets.only(right: 10.0),
              child: AppTextView(
                onClick: (){
                  OpdSure.of(context).store.setBool(AppKey.onBoardScreen, true);
                  context.go("/signup");
                },
                text: 'Skip',
                color: buttonColor,
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
          SizedBox(height: h*0.04,),
          SizedBox(
            height: h*0.61,
            child: PageView(
              controller: controller.pageController,
              children: controller.getAllPreview(context),
            ),
          ),
          const SizedBox(height: 15.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: AppButton(
              text: 'Next',
              onClick: (){
                int count = typeController.previewCount.value;
                if(count<5) {
                  typeController.previewCountChange(count + 1);
                  controller.nextPage();
                }else{
                  OpdSure.of(context).store.setBool(AppKey.onBoardScreen, true);
                  context.go("/signup");
                }
              },
            ),
          )
        ],
      ),
    );
  }

}