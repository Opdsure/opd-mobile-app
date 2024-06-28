import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import '../utils/app_var.dart';

class PreviewPage extends StatelessWidget{

  final PageController _pageController = PageController();

  PreviewPage({super.key});

  void _nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget swipeView(BuildContext context){
    TypeController typeController = Get.put(TypeController());
    double h = CommonMethods.deviceHeight(context);
    return ListView(
      children: [
        Obx((){
          int pageNo = typeController.previewCount.value;
          return Image.asset('assets/images/${previewImgUri[pageNo]}.png');
        }),
        SizedBox(height: h*0.05,),
        Obx((){
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
        Obx((){
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

  List<Widget> getAllPreview(BuildContext context){
    List<Widget> allView = [];
    TypeController typeController = Get.put(TypeController());
    double h = CommonMethods.deviceHeight(context);
    for(int i=0;i<5;i++){
      allView.add(ListView(
        children: [
          Obx((){
            int pageNo = typeController.previewCount.value;
            return Image.asset('assets/images/${previewImgUri[i]}.png');
          }),
          SizedBox(height: h*0.05,),
          Obx((){
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
          Obx((){
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
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    double h = CommonMethods.deviceHeight(context);
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 16.0,),
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: AppTextView(
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
              controller: _pageController,
              children: getAllPreview(context),
            ),
          ),
          const SizedBox(height: 15.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: AppButton(
              text: 'Next',
              onClick: (){
                int count = typeController.previewCount.value;
                if(count<4) {
                  typeController.previewCountChange(count + 1);
                  // _controller.next(animation: true);
                  _nextPage();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}