import 'dart:async';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({Key? key}) : super(key: key);
  @override
  State<MyWebView> createState() => _MyWebViewState();
}
class _MyWebViewState extends State<MyWebView> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://stage.opdsure.net/user/login'),
      );
  }
  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Terms & Conditions',),
      childContent: WebViewWidget(
        controller: controller,
      ),
    );
  }
}