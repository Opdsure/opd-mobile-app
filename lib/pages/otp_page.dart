import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_ui/app_button.dart';
import '../custom_ui/app_text_view.dart';
import '../utils/app_colors.dart';

class OtpPage extends StatelessWidget{

   // TODO: Bro ye code mere me error throw kar rha hai
  // var otpTextStyles = [
  //   createStyle(),
  //   createStyle(accentYellowColor),
  //   createStyle(accentDarkGreenColor),
  //   createStyle(accentOrangeColor),
  //   createStyle(accentPinkColor),
  //   createStyle(accentPurpleColor),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  color: backIconCl,
                ),
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 100.0,
                  width: 100.0,
                ),
                Container()
              ],
            ),
            const SizedBox(height: 24.0,),
            const Center(
              child: AppTextView(
                text: 'Enter OTP',
                color: Colors.black,
                size: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Center(
              child: AppTextView(
                text: 'Enter the 4-digit code that we have sent\non the email mukesh@example.com',
                color: Color(0xff475467),
                size: 16.0,
                mTextAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0,),

            OtpTextField(
              numberOfFields: 4,
              showFieldAsBox: true,
              fieldWidth: 60.0,
              fieldHeight: 60.0,
              focusedBorderColor: const Color(0xFFEAECF0),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode){
                showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    }
                );
              }, // end onSubmit
            ),
            const SizedBox(height: 24.0,),
            const AppButton(text: 'Verify OTP'),

            const SizedBox(height: 24.0,),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Don’t receive the OTP? ',
                        style: GoogleFonts.montserrat()
                    ),
                    TextSpan(
                      text: 'Resend',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: buttonColor
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}