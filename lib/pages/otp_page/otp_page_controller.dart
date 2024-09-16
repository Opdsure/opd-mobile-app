import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../model/register_otp_verify.dart';
import 'otp_page.dart';

class OtpPage extends StatefulWidget {
  final int otpType;
  final String phone;
  final String countryCode;

  const OtpPage(
      {required this.otpType,
      required this.phone,
      required this.countryCode,
      super.key});

  @override
  State<OtpPage> createState() => OtpPageController();
}

class OtpPageController extends State<OtpPage> {
  bool? loading;
  String otp = '';

  @override
  void initState() {
    super.initState();
  }

  void onCodeChange(String code) {
    setState(() => otp = code);
  }

  void onSubmit(String code) {
    setState(() => otp = code);
  }

  void otpVerify() async {
    if (otp.length != 6) {
      return;
    }
    {

      switch(widget.otpType){
        case 1:
          await _register(OpdSure.of(context));
          break;
        case 2:
          await _login(OpdSure.of(context));
          break;
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _login(OpdSureState opd) async {
    final loginResponse = await opd.client.login(
        otp: int.parse(otp),
        countryCode: widget.countryCode,
        phone: widget.phone,
        loginType: 1);

    if (loginResponse.data != null) {
      opd.client.init(newUserId: loginResponse.data!.userId!, newAccessToken: loginResponse.data!.token!);
    }else{
      CommonMethods.showToast(loginResponse.message!);
    }
  }

  Future<void> _register(OpdSureState opd) async {
    RegisterOtpVerify? isOtpVerify = await opd.client.registerVerifyOtp(
          phone: widget.phone,
          countryCode: widget.countryCode,
          otp: int.parse(otp));
    if(isOtpVerify != null){

      if(isOtpVerify.data!.verified!){
        final response = await opd.client.register(countryCode: widget.countryCode, phone: widget.phone, loginType: 1, termAndCondition: true);
        if(response.success!){
          opd.client.init(newUserId: response.data!.userId!, newAccessToken: response.data!.token!);
        } else{
          CommonMethods.showToast(response.message!);
        }
      }
     else{
        CommonMethods.showToast(isOtpVerify.message!);
      }
    }else{
      CommonMethods.showToast('Try again');
    }
  }

  @override
  Widget build(BuildContext context) => OtpPageView(this);
}
