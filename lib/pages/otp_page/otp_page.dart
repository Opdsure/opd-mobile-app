import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../custom_ui/app_button.dart';
import '../../../custom_ui/app_text_view.dart';
import '../../../utils/app_colors.dart';
import '../../config/app_config.dart';
import '../../custom_ui/app_rich_text.dart';
import 'otp_page_controller.dart';

class OtpPageView extends StatelessWidget{

  final OtpPageController controller;

  const OtpPageView(this.controller, {super.key});

  TextStyle? createStyle() {
    return GoogleFonts.montserrat(
        fontSize: 20.0,
        fontWeight: FontWeight.w700
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: backIconCl,
                    ),
                  ),
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
            Center(
              child: AppTextView(
                text: 'Enter the 6-digit code that we have sent\non the +91-${controller.widget.phone} ',
                color: const Color(0xff475467),
                size: 16.0,
                mTextAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0,),

            OtpTextField(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              numberOfFields: 6,
              showFieldAsBox: true,
              fieldWidth: 48.5,
              fieldHeight: 60.0,
              showCursor: false,
              styles: [
                createStyle(),
                createStyle(),
                createStyle(),
                createStyle(),
                createStyle(),
                createStyle(),
              ],
              focusedBorderColor: AppConfig.primaryColor,
              borderColor: AppConfig.primaryColor,
              disabledBorderColor: AppConfig.primaryColor,
              enabledBorderColor: AppConfig.primaryColor,
              enabled: true,
              filled: true,
              fillColor: AppConfig.roundedViewColor,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              onCodeChanged: controller.onCodeChange,
              onSubmit: controller.onSubmit, // end onSubmit
            ),
            const SizedBox(height: 24.0,),
            AppButton(onClick: (){
              controller.otpVerify();
            },text: 'Verify OTP'),

            const SizedBox(height: 24.0,),
            Center(
              child: AppRichText(
                textSpan: TextSpan(
                  children: [
                    TextSpan(
                        text: "Didn't receive the OTP? ",
                        style: GoogleFonts.montserrat()
                    ),
                    TextSpan(
                      text: 'Resend',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: AppConfig.primaryColor
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