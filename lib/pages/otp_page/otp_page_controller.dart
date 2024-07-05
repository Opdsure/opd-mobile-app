import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widget/opd_widget.dart';
import 'otp_page.dart';

class OtpPage extends StatefulWidget {
  String? phone;
  String? email;
  String? password;
  String? otp;
  String? confirmPassword;
  String? name;
  bool? termAndCondition;
  String? countryCode;
  OtpPage({this.countryCode, this.name, this.termAndCondition, this.phone, this.email, this.password, this.confirmPassword, this.otp, super.key});

  @override
  State<OtpPage> createState() => OtpPageController();
}

class OtpPageController extends State<OtpPage> {

  bool loading = false;

  String? phone;
  String? email;
  String? password;
  String? confirmPassword;
  String? name;
  bool? termAndCondition;
  String? otp;
  String? countryCode;


  @override
  void initState() {
    super.initState();
    phone = widget.phone;
    email = widget.email;
    otp = widget.otp;
    password = widget.password;
    confirmPassword = widget.confirmPassword;
    name =widget.name;
    termAndCondition = widget.termAndCondition;
    countryCode = widget.countryCode;
  }
  void otpVerify(String? otp) async {
    final opdSure = OpdSure.of(context);
    if(this.otp == otp) {
      try {
        await opdSure.getLoginClient().register(
            emailAddress: email,
            password: password,
            confirmPassword: confirmPassword,
            phone: phone,
          countryCode: countryCode,
          name: name,
          termAndCondition: termAndCondition
        );
      } catch (e) {
        return setState(() => loading = false);
      }
    }else{
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (innerContext){
            return AlertDialog(
              title: Text("Verification Code"),
              content: Text('$otp is wrong'),
              actions: [TextButton(onPressed: (){
                context.pop();
              }, child: Text('close'))],
            );
          }
      );
    }
    if(mounted) setState(() => loading = false);
    }

  @override
  Widget build(BuildContext context) => OtpPageView(this);
}

