import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/login/login_page/login_page_view.dart';
import 'package:opdsure/utils/opd_extension/string_extension.dart';

import '../../../widget/opd_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageController();
}

class LoginPageController extends State<LoginPage> {
  TextEditingController emailTextController =
      TextEditingController();
  TextEditingController passwordTextController =
      TextEditingController(text: 'Intileo@123');
  TextEditingController phoneTextController =
      TextEditingController(text: '8510819003');

  String emailError = '';
  String passwordError = '';
  String phoneError = '';
  bool isShowError = false;
  bool isWithEmail = false;

  String countryCode = '+91';

  bool loading = false;
  bool isPasswordObscure = true;
  final countryPicker = const FlCountryCodePicker();
  late TapGestureRecognizer signupRecognizer;
  String flagUri = 'packages/fl_country_code_picker/assets/flags/in.png';
  @override
  void initState() {
    super.initState();
    signupRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _signUp();
      };
  }
  void togglePassword() {
    setState(() => isPasswordObscure = !isPasswordObscure);
  }
  void toggleEmailOrPhone() {
    setState((){
      isWithEmail = !isWithEmail;
      isShowError = false;
    });
  }
  _signUp() {
    context.go('/signup');
  }

  forgetPassword() {
    context.push('/signup/login/forget_password');
  }

  getCountryCode() async {
    final picked = await countryPicker.showPicker(context: context);
    if (picked != null) {
      flagUri =
      'packages/fl_country_code_picker/assets/flags/${picked.code.toLowerCase()}.png';
      countryCode = picked.dialCode;
      setState(() {});
    }
  }

  void login() async {
    final opdSure = OpdSure.of(context);
    if (!isWithEmail) {
      if (phoneTextController.text.isEmpty) {
        setState((){
          phoneError = 'Enter a valid phone no';
          isShowError = true;
        });
        // return;
      } else {
        if (!phoneTextController.text.isValidPhoneNumber) {
          setState((){
            phoneError = 'Enter a valid phone no';
            isShowError = true;
          });
          // return;
        }
      }
    } else {
      if (emailTextController.text.isEmpty) {
        setState(() {
          emailError = 'Enter a valid email address';
          isShowError = true;
        });
        // return;
      } else {
        if (!emailTextController.text.isValidEmail) {
          setState((){
            emailError = 'Enter a valid email address';
            isShowError = true;
          });
          // return;
        }
      }
    }
    if (passwordTextController.text.isEmpty) {
      setState((){
        passwordError = 'Enter a valid password';
        isShowError = true;
      });
    }else{
      if(!passwordTextController.text.isValidPassword){
        setState((){
          passwordError = 'Enter a valid password';
          isShowError = true;
        });
        // return;
      }
    }

    setState(() => loading = true);

    try {
      await opdSure.getLoginClient().login(
        loginType: isWithEmail ? 0 : 1,
        countryCode: isWithEmail ? null : countryCode,
        emailAddress: isWithEmail ? emailTextController.text : null,
        password: passwordTextController.text,
        phone: isWithEmail ? null : phoneTextController.text);
    } catch (e) {
      // setState(() => passwordError = e.toString());
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => LoginView(this);
}
