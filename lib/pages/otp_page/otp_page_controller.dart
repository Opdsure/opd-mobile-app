import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widget/opd_widget.dart';
import 'otp_page.dart';

class OtpPage extends StatefulWidget {
  String? accessToken;
  String? userId;


  OtpPage(
      {this.accessToken,
      this.userId,
      super.key});

  @override
  State<OtpPage> createState() => OtpPageController();
}

class OtpPageController extends State<OtpPage> {

  String? accessToken;
  String? userId;
  bool? loading;


  @override
  void initState() {
    super.initState();
    accessToken = widget.accessToken??'';
    userId = widget.userId??'';
  }

  void otpVerify(String otp) async {
    final user = await OpdSure.of(context).client.signInWithOTP(otp);
    if(user != null) {
      try {
        await OpdSure.of(context).client.init(newUserId: userId, newAccessToken: accessToken, newIsPlanPurchased: false);
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
