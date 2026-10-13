import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';
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
  bool loading = false;
  String otp = '';
  late TapGestureRecognizer otpRecognizer;

  @override
  void initState() {
    super.initState();

    otpRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _resendOto();
      };
  }

  _resendOto() {
    CommonMethods.showToast('otp send successfully');
  }

  // void onCodeChange(String code) {
  //   otp = code;
  //   setState(() => otp = code);
  // }

  void onSubmit(String code) {
    otp = code;
    otp = code.length > 6 ? code.substring(0, 6) : code;

    // setState(() => otp = code);
  }

  void otpVerify() async {
    if (loading) return;
    if (otp.length != 6) {
      CommonMethods.showToast('Please enter the 6-digit OTP');
      return;
    }

    setState(() => loading = true);
    final opd = OpdSure.of(context);
    try {
      bool success = false;
      switch (widget.otpType) {
        case 1:
          success = await _register(opd);
          break;
        case 2:
          success = await _login(opd);
          break;
      }

      if (!mounted) return;
      if (success && opd.client.isLogged) {
        // Session established -> go to the dashboard.
        context.go('/home', extra: ActiveDestination.home);
        return;
      }
    } catch (e) {
      CommonMethods.showToast('Something went wrong. Please try again.');
    }

    if (mounted) setState(() => loading = false);
  }

  /// Returns true when login + session init succeeded.
  Future<bool> _login(OpdSureState opd) async {
    final loginResponse = await opd.client.login(
        otp: int.parse(otp),
        countryCode: widget.countryCode,
        phone: widget.phone,
        loginType: 1);

    if (loginResponse.data != null) {
      await opd.client.init(
          newUserId: loginResponse.data!.userId!,
          newAccessToken: loginResponse.data!.token!);
      return opd.client.isLogged;
    } else {
      CommonMethods.showToast(loginResponse.message ?? 'Login failed');
      return false;
    }
  }

  /// Returns true when registration + session init succeeded.
  Future<bool> _register(OpdSureState opd) async {
    RegisterOtpVerify? isOtpVerify = await opd.client.registerVerifyOtp(
        phone: widget.phone,
        countryCode: widget.countryCode,
        otp: int.parse(otp));
    if (isOtpVerify != null) {
      if (isOtpVerify.data!.verified!) {
        final response = await opd.client.register(
            countryCode: widget.countryCode,
            phone: widget.phone,
            loginType: 1,
            termAndCondition: true);
        if (response.success!) {
          await opd.client.init(
              newUserId: response.data!.userId!,
              newAccessToken: response.data!.token!);
          return opd.client.isLogged;
        } else {
          CommonMethods.showToast(response.message ?? 'Registration failed');
          return false;
        }
      } else {
        CommonMethods.showToast(isOtpVerify.message ?? 'OTP not verified');
        return false;
      }
    } else {
      CommonMethods.showToast('Try again');
      return false;
    }
  }

  String countryCode = '+91';

  FocusNode focusNode = FocusNode();

  Future<void> login(String phoneNo) async {
    final opdSure = OpdSure.of(context);

    setState(() => loading = true);

    try {
      CommonMethods.showAlertDialog(context);
      focusNode.unfocus();
      final response = await opdSure.client
          .loginOtp(countryCode: countryCode, phone: phoneNo);
      if (response.success!) {
        context.push('/login/otp', extra: {
          'otp_type': 2,
          'phone': phoneNo,
          'country_code': countryCode
        });
      } else {
        CommonMethods.showToast(response.message!);
      }
      Navigator.of(context, rootNavigator: false).pop();
    } catch (e) {
      Navigator.of(context, rootNavigator: false).pop();
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => OtpPageView(this);
}
