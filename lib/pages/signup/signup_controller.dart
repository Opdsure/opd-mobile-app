import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:opdsure/pages/name_email_number/name_email_number_view.dart';
import 'package:opdsure/pages/signup/sign_up_page_view.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import 'package:opdsure/utils/opd_extension/string_extension.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpController();
}

class SignUpController extends State<SignUpPage> {
  late TapGestureRecognizer loginRecognizer;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController =
  TextEditingController(text: 'Intileo@123');
  TextEditingController confirmPasswordTextController =
  TextEditingController(text: 'Intileo@123');
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController middleNameTextController = TextEditingController();
  TextEditingController lastNameControllerTextController =
  TextEditingController();
  TextEditingController phoneTextController =
  TextEditingController(text: '8510819003');

  final countryPicker = const FlCountryCodePicker();
  bool isTermAndConditions = false;

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? phoneError;
  String? nameError;
  bool loading = false;

  bool isWithEmail = false;
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  String countryCode = '+91';
  String isoCode = 'IN';

  InputType inputType = InputType.firstName;

  String flagUri = 'packages/fl_country_code_picker/assets/flags/in.png';

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
    context.push(
        '${GoRouter
            .of(context)
            .routeInformationProvider
            .value
            .uri
            .path}/login');
  }

  void sendOtp() async {
      OpdSure
          .of(context)
          .client
          .getFirebaseOTP(
          CommonMethods.convertToE164(phoneTextController.text, isoCode),
          codeAutoRetrievalTimeout: (_) {

          },
          codeSent: (_, __) {
            setState(() => loading = true);
            context.push('/signup/otp', extra: {
              "email": emailTextController.text,
              "phone": phoneTextController.text,
              "password": passwordTextController.text,
              "confirmPassword": confirmPasswordTextController.text,
              "termCondition": isTermAndConditions,
              "isWithEmail" : isWithEmail,
              "countryCode" : countryCode
            });
          },
          verificationCompleted: (_) {

          },
          verificationFailed: (_) {
            setState(() => loading = false);
          });
  }

  void toggleEmailOrPhone() {
    setState(() => isWithEmail = !isWithEmail);
  }

  void togglePassword() {
    setState(() => isPasswordObscure = !isPasswordObscure);
  }

  void toggleConfirmPassword() {
    setState(() => isConfirmPasswordObscure = !isConfirmPasswordObscure);
  }

  void register() async {
    final opdSure = OpdSure.of(context);
    if (!isWithEmail) {
      if (phoneTextController.text.isEmpty) {
        setState(() => phoneError = 'Phone no is empty');
        return;
      } else {
        if (!phoneTextController.text.isValidPhoneNumber) {
          setState(() => phoneError = 'Enter a valid phone no');
          return;
        }
      }
    } else {
      if (emailTextController.text.isEmpty) {
        setState(() => emailError = 'Email address is empty');
        return;
      } else {
        if (!emailTextController.text.isValidEmail) {
          setState(() => emailError = 'Enter a valid email address');
          return;
        }
      }
    }
    if (passwordTextController.text.isEmpty) {
      setState(() => passwordError = 'password is empty');
      return;
    } else {
      if (!passwordTextController.text.isValidPassword) {
        setState(() => passwordError = 'Enter a valid password');
        return;
      }
    }
    if (confirmPasswordTextController.text.isEmpty) {
      setState(() => confirmPasswordError = 'confirm password is empty');
      return;
    } else {
      if (passwordTextController.text != confirmPasswordTextController.text) {
        setState(() => confirmPasswordError = 'Password not matched');
        return;
      }
    }

    if (!isTermAndConditions) {
      CommonMethods.showToast('Please accept term and conditions.');
      return;
    }

    setState(() => loading = true);

    if(!isWithEmail){
      sendOtp();
    }else{
      try {
        await opdSure.getLoginClient().register(
          emailAddress: emailTextController.text,
          password: passwordTextController.text,
          confirmPassword: confirmPasswordTextController.text,
          phone: phoneTextController.text,
          countryCode: countryCode,
          termAndCondition: isTermAndConditions,
          loginType: isWithEmail ? 0: 1,
        );
      } catch (e) {
        setState(() => confirmPasswordError = e.toString());
        return setState(() => loading = false);
      }
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
