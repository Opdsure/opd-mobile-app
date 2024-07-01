import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/preview/preview_page_view.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../../utils/app_var.dart';

class PreviewPage extends StatefulWidget {


  @override
  PreviewPageController createState() => PreviewPageController();

}
class PreviewPageController extends State<PreviewPage> {


  final PageController pageController = PageController();
  void nextPage() {
    if (pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  Widget swipeView(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    double h = CommonMethods.deviceHeight(context);
    return ListView(
      children: [
        Obx(() {
          int pageNo = typeController.previewCount.value;
          return Image.asset('assets/images/${previewImgUri[pageNo]}.png');
        }),
        SizedBox(height: h * 0.05,),
        Obx(() {
          int pageNo = typeController.previewCount.value;
          return Center(
            child: AppTextView(
              text: previewTitleStr[pageNo],
              size: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              mTextAlign: TextAlign.center,
            ),
          );
        }),
        Obx(() {
          int pageNo = typeController.previewCount.value;
          return Center(
            child: AppTextView(
              text: previewDescriptionStr[pageNo],
              size: 16.0,
              color: Colors.black,
              mTextAlign: TextAlign.center,
            ),
          );
        }),
      ],
    );
  }

  List<Widget> getAllPreview(BuildContext context) {
    List<Widget> allView = [];
    TypeController typeController = Get.put(TypeController());
    double h = CommonMethods.deviceHeight(context);
    for (int i = 0; i < 5; i++) {
      allView.add(ListView(
        children: [
          Obx(() {
            int pageNo = typeController.previewCount.value;
            return Image.asset('assets/images/${previewImgUri[i]}.png');
          }),
          SizedBox(height: h * 0.05,),
          Obx(() {
            int pageNo = typeController.previewCount.value;
            return Center(
              child: AppTextView(
                text: previewTitleStr[i],
                size: 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                mTextAlign: TextAlign.center,
              ),
            );
          }),
          Obx(() {
            int pageNo = typeController.previewCount.value;
            return Center(
              child: AppTextView(
                text: previewDescriptionStr[i],
                size: 16.0,
                color: Colors.black,
                mTextAlign: TextAlign.center,
              ),
            );
          }),
        ],
      ));
    }
    return allView;
  }
  @override
  Widget build(BuildContext context) => PreviewPageView(this);

}