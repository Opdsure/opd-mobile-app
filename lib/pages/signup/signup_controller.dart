import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/signup/sign_up_page_view.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../get_controllers/type_controller.dart';
import 'package:opdsure/utils/opd_extension/string_extension.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpController();
}

class SignUpController extends State<SignUpPage> {
  late TapGestureRecognizer loginRecognizer;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController(text: '8510819003');

  bool isTermAndConditions = false;

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? phoneError;
  bool loading = false;

  onTermAndConditions(bool? value) => setState(() => isTermAndConditions = value ?? false);


  @override
  void initState() {
    super.initState();
    loginRecognizer = TapGestureRecognizer()
      ..onTap = () {
      _login();
      };
  }

  _login(){
    context.push('${GoRouter.of(context).routeInformationProvider.value.uri.path}/login');
  }

  void register() async {
    final opdSure = OpdSure.of(context);
    if(Get.put(TypeController()).signUpBy.value == 'phone'){
      if(phoneTextController.text.isEmpty){
        setState(() => phoneError = 'Phone no is empty');
        return;
      }else{
        if(!phoneTextController.text.isValidPhoneNumber){
          setState(() => phoneError = 'Enter a valid phone no');
          return;
        }
      }
    }else{
      if(emailTextController.text.isEmpty){
        setState(() => emailError = 'Email address is empty');
        return;
      }else{
        if(!emailTextController.text.isValidEmail){
          setState(() => emailError = 'Enter a valid email address');
          return;
        }
      }
    }
    if(passwordTextController.text.isEmpty){
      setState(() => passwordError = 'password is empty');
      return;
    }else{
      if(!passwordTextController.text.isValidPassword){
        setState(() => passwordError = 'Enter a valid password');
        return;
      }
    }
    if(confirmPasswordTextController.text.isEmpty){
      setState(() => confirmPasswordError = 'confirm password is empty');
      return;
    }else{
      if(passwordTextController.text != confirmPasswordTextController.text){
        setState(() => confirmPasswordError = 'Password not matched');
        return;
      }
    }

    setState(() =>  loading = true);

    try{
      await opdSure.getLoginClient().register(
        name: 'sahil yadav',
        emailAddress: emailTextController.text,
        password: passwordTextController.text,
        confirmPassword: confirmPasswordTextController.text,
        phone: phoneTextController.text,
        countryCode: '+91',
        termAndCondition: isTermAndConditions,
      );
    }catch(e){
      setState(() => confirmPasswordError = e.toString());
      return setState(() => loading = false);
    }

    if(mounted) setState(() => loading = false);

  }

  @override
  Widget build(BuildContext context) => SignUpView(this);
}
