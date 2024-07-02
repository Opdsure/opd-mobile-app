import 'package:flutter/material.dart';
import 'package:opdsure/pages/forget_password/forget_password_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => ForgetPasswordPageController();
}

class ForgetPasswordPageController extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) => ForgetPasswordPageView(this);
}
