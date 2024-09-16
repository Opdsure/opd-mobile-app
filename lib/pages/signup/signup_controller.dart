import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/name_email_number/name_email_number_view.dart';
import 'package:opdsure/pages/signup/sign_up_page_view.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import 'package:opdsure/utils/opd_extension/string_extension.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpController();
}

class SignUpController extends State<SignUpPage> {
  late TapGestureRecognizer loginRecognizer;
  TextEditingController phoneTextController = TextEditingController();

  final countryPicker = const FlCountryCodePicker();
  bool isTermAndConditions = false;

  FocusNode focusNode = FocusNode();

  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';
  String phoneError = '';
  String? nameError = '';
  bool loading = false;
  bool isShowErrorMobile = false;

  String countryCode = '+91';
  String isoCode = 'IN';

  InputType inputType = InputType.firstName;

  String flagUri = 'packages/fl_country_code_picker/assets/flags/in.png';

  onChanged(String? value) {
    setState(() {
      emailError = '';
      passwordError = '';
      confirmPasswordError = '';
      phoneError = '';
      nameError;
      isShowErrorMobile = false;
    });
  }

  onTermAndConditions(bool? value) =>
      setState(() => isTermAndConditions = value ?? false);

  @override
  void initState() {
    super.initState();
    loginRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _login();
      };
  }

  _login() {
    context.go('/login');
  }

  void register() async {
    final opdSure = OpdSure.of(context);
    if (phoneTextController.text.isEmpty) {
      setState(() {
        phoneError = 'Phone no is empty';
        isShowErrorMobile = true;
      });
      return;
    }
    if (!phoneTextController.text.isValidPhoneNumber) {
      setState(() {
        phoneError = 'Enter a valid phone no';
        isShowErrorMobile = true;
      });
      return;
    }
    else {
      setState(() {
        isShowErrorMobile = false;
      });
    }
    if (!isTermAndConditions) {
      CommonMethods.showToast('Please accept term and conditions.');
      return;
    }

    CommonMethods.showAlertDialog(context);

    try {
      focusNode.unfocus();
      final response = await opdSure.client.registerOtp(
        phone: phoneTextController.text,
        countryCode: countryCode,
      );

      if (response.success!) {
        context.push('/signup/otp', extra: {
          'otp_type': 1,
          'phone': phoneTextController.text,
          'country_code': countryCode
        });
      } else {
        Navigator.of(context, rootNavigator: false).pop();
        CommonMethods.showToast(response.message!);
      }

      Navigator.of(context, rootNavigator: false).pop();
    } catch (e) {
      setState(() => confirmPasswordError = e.toString());
      Navigator.of(context, rootNavigator: false).pop();
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }


  getCountryCode() async {
    final picked = await countryPicker.showPicker(context: context);
    if (picked != null) {
      flagUri =
      'packages/fl_country_code_picker/assets/flags/${picked.code
          .toLowerCase()}.png';
      isoCode = picked.code;
      countryCode = picked.dialCode;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => SignUpView(this);
}
