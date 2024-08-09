import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/preview/preview_page_view.dart';
import 'package:opdsure/utils/common_methods.dart';
import '../../utils/app_keys/app_key.dart';
import '../../utils/app_var.dart';
import '../../widget/opd_widget.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  PreviewPageController createState() => PreviewPageController();

}
class PreviewPageController extends State<PreviewPage> {


  int initialPage = 0;
  final PageController pageController = PageController();

  void onPageChanged(int? index) => setState(() => initialPage = index ?? 0);



  void nextPage() {
    if (pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  void previousPage() {
    if (pageController.hasClients) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


  void skip(){
    OpdSure.of(context).store.setBool(AppKey.onBoardScreen, true);
    context.go("/signup");
  }

  List<Widget> getAllPreview(BuildContext context) {
    List<Widget> allView = [];
    double h = CommonMethods.deviceHeight(context);
    double w = CommonMethods.deviceWidth(context);
    for (int i = 0; i < previewImgUri.length; i++) {
      allView.add(Column(
        children: [
          Expanded(
              child: Image.asset('assets/images/${previewImgUri[i]}.png')),
          SizedBox(height: h * 0.05,),
          Center(
              child: AppTextView(
                text: previewTitleStr[i],
                size: 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                mTextAlign: TextAlign.center,
              ),
            ),
          Center(
              child: AppTextView(
                text: previewDescriptionStr[i],
                size: 16.0,
                color: Colors.black,
                mTextAlign: TextAlign.center,
              ),
            ),
        ],
      ));
    }
    return allView;
  }
  @override
  Widget build(BuildContext context) => PreviewPageView(this);

}