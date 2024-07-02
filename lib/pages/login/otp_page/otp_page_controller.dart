import 'package:flutter/material.dart';
import 'package:opdsure/pages/login/otp_page/otp_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => OtpPageController();
}

class OtpPageController extends State<OtpPage> {
  @override
  Widget build(BuildContext context) => OtpPageView(this);
}

