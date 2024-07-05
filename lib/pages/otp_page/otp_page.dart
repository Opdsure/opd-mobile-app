import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../custom_ui/app_button.dart';
import '../../../custom_ui/app_text_view.dart';
import '../../../utils/app_colors.dart';
import 'otp_page_controller.dart';

class OtpPageView extends StatelessWidget{

  final OtpPageController controller;

  OtpPageView(this.controller, {super.key});

  var otpTextStyles;
  TextStyle? createStyle() {
    return GoogleFonts.montserrat(
        fontSize: 20.0,
        fontWeight: FontWeight.w700
    );
  }


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
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
                text: 'Enter the 4-digit code that we have sent\non the email ',
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
              styles: [
                createStyle(),
                createStyle(),
                createStyle(),
                createStyle(),
              ],
              focusedBorderColor: const Color(0xFFEAECF0),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              //runs when a code is typed in
              onCodeChanged: (String code) {

              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode){
                if(verificationCode.length == 4){
                  controller.otpVerify(verificationCode);
                }
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