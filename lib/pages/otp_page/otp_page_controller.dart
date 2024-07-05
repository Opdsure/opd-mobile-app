import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widget/opd_widget.dart';
import 'otp_page.dart';

class OtpPage extends StatefulWidget {
  String? phone;
  String? email;
  String? password;
  String? confirmPassword;
  String? countryCode;
  bool? termCondition;
  bool? isWithEmail;

  OtpPage(
      {this.password,
      this.confirmPassword,
      this.termCondition,
      this.countryCode,
      this.phone,
      this.email,
      this.isWithEmail,
      super.key});

  @override
  State<OtpPage> createState() => OtpPageController();
}

class OtpPageController extends State<OtpPage> {
  bool loading = false;

  String? phone;
  String? email;
  String? password;
  String? confirmPassword;
  String? countryCode;
  bool? termCondition;
  bool? isWithEmail;

  @override
  void initState() {
    super.initState();
    phone = widget.phone;
    email = widget.email;
    password = widget.password;
    confirmPassword = widget.confirmPassword;
    termCondition = widget.termCondition;
    countryCode = widget.countryCode;
    isWithEmail = widget.isWithEmail ?? false;
  }

  void otpVerify(String otp) async {
    final user = await OpdSure.of(context).client.signInWithOTP(otp);
    if(user != null) {
      try {
        await OpdSure.of(context).getLoginClient().register(
          emailAddress: email,
          password: password,
          confirmPassword: confirmPassword,
          phone: phone,
          countryCode: countryCode,
          termAndCondition: termCondition,
          loginType: isWithEmail! ? 0 : 1,
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
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => OtpPageView(this);
}
