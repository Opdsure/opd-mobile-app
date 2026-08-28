import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/preview/preview_page_view.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../utils/app_var.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  PreviewPageController createState() => PreviewPageController();
}

class PreviewPageController extends State<PreviewPage> {
  int currentPage = 0;
  final PageController pageController = PageController();

  void onPageChanged(int index) => setState(() => currentPage = index);

  void nextPage() {
    if (currentPage == previewImgUri.length - 1) {
      _completeOnboarding();
    } else if (pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() => _completeOnboarding();

  void _completeOnboarding() {
    OpdSure.of(context).store.setBool(AppKey.onBoardScreen, true);
    context.go('/signup');
  }

  @override
  Widget build(BuildContext context) => PreviewPageView(this);
}
