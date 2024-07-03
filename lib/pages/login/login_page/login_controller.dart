import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/login/login_page/login_page_view.dart';
import 'package:opdsure/utils/opd_extension/string_extension.dart';

import '../../../get_controllers/type_controller.dart';
import '../../../widget/opd_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageController();
}

class LoginPageController extends State<LoginPage> {

  TextEditingController emailTextController = TextEditingController(text: 'sahil.yadav@intileo.com');
  TextEditingController passwordTextController = TextEditingController(text: 'Intileo@123');
  TextEditingController phoneTextController = TextEditingController(text: '8510819003');

  String? emailError;
  String? passwordError;
  String? phoneError;

  bool loading = false;
  late TapGestureRecognizer signupRecognizer;


  @override
  void initState() {
    super.initState();
    signupRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _signUp();
      };
  }

  _signUp(){
    context.go('/signup');
  }

  forgetPassword(){
    context.push('/signup/login/forget_password');
  }

  void login() async {
    final opdSure = OpdSure.of(context);
    if(Get.put(TypeController()).loginBy.value == 'phone'){
      if(phoneTextController.text.isEmpty){
        setState(() => phoneError = 'Enter a valid phone no');
      }else{
        if(!phoneTextController.text.isValidPhoneNumber){
          setState(() => phoneError = 'Enter a valid phone no');
        }
      }
    }else{
      if(emailTextController.text.isEmpty){
        setState(() => emailError = 'Enter a valid email address');
      }else{
        if(!emailTextController.text.isValidEmail){
          setState(() => emailError = 'Enter a valid email address');
        }
      }
    }
    if(passwordTextController.text.isEmpty){
      setState(() => phoneError = 'Enter a valid password');
    }

    setState(() =>  loading = true);

    try{
      await opdSure.getLoginClient().login(
        emailAddress: emailTextController.text,
        password: passwordTextController.text,
        phone: phoneTextController.text);
    }catch(e){
      setState(() => passwordError = e.toString());
      return setState(() => loading = false);
    }

    if(mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => LoginView(this);
}
