import 'dart:ui';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_edit_text.dart';
import 'package:opdsure/custom_ui/app_mobile_field.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';

import '../../custom_ui/app_border_box.dart';
import '../../get_controllers/type_controller.dart';
import '../../utils/app_colors.dart';

class SignUpView extends StatelessWidget {
  final SignUpController controller;

  const SignUpView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 16.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 100.0,
                  width: 100.0,
                ),
                Container()
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            const Center(
              child: AppTextView(
                text: 'Sign Up',
                color: Colors.black,
                size: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Center(
              child: AppTextView(
                text: 'Please enter your details.',
                color: Color(0xff475467),
                size: 16.0,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            controller.isWithEmail
                ? AppEditText(
                    hint: 'Enter your email address',
                    size: 14.0,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: controller.emailTextController,
                    errorText: controller.emailError,
                  )
                : AppMobileField(
                    hint: 'Enter your mobile number',
                    countryCode: controller.countryCode,
                    textEditingController: controller.phoneTextController,
                    flagUri: controller.flagUri,
                    errorText: controller.phoneError,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                    ],
                    countryCallback: () {
                      controller.getCountryCode();
                    },
                  ),
            const SizedBox(
              height: 16.0,
            ),
            AppEditText(
              hint: 'Create a password',
              size: 14.0,
              isPasswordField: true,
              isViewPassword: controller.isPasswordObscure,
              textEditingController: controller.passwordTextController,
              viewSuffix: true,
              errorText: controller.passwordError,
              eyeCallback: controller.togglePassword,
            ),
            const SizedBox(
              height: 5.0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: AppTextView(
                text: 'Must be at least 8 characters',
                color: Color(0xff475467),
                size: 12.0,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            AppEditText(
              hint: 'Confirm password',
              size: 14.0,
              isPasswordField: true,
              viewSuffix: true,
              isViewPassword: controller.isConfirmPasswordObscure,
              textEditingController: controller.confirmPasswordTextController,
              errorText: controller.confirmPasswordError,
              eyeCallback: controller.toggleConfirmPassword,
            ),
            const SizedBox(
              height: 24.0,
            ),
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    activeColor: buttonColor,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    value: controller.isTermAndConditions,
                    onChanged: controller.onTermAndConditions,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: 'I agree to the ',
                            style: GoogleFonts.montserrat()),
                        TextSpan(
                          text: 'Terms and Conditions.',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            AppButton(
              text: 'Get Started',
              onClick: () async {
                controller.register();
              },
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Color(0xffEAECF0),
                  ),
                ),
                SizedBox(width: 20),
                AppTextView(
                  text: 'or',
                  size: 16.0,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Color(0xffEAECF0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            AppBorderBox(
              myChild: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google_icon.png',
                      height: 24.0,
                      width: 24.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const AppTextView(
                      text: 'Continue with Google',
                      size: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344054),
                    ),
                  ],
                ),
              ),
              borderColor: const Color(0xFFD0D5DD),
              boxColor: const Color(0x1A101828),
            ),
            const SizedBox(
              height: 12.0,
            ),
            AppBorderBox(
              myChild: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      controller.isWithEmail
                          ? 'assets/images/phone_img.png'
                          : 'assets/images/mail_icon.png',
                      height: 24.0,
                      width: 24.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    AppTextView(
                      text: controller.isWithEmail
                          ? 'Continue with Phone'
                          : 'Continue with Email',
                      size: 16.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF344054),
                    ),
                  ],
                ),
              ),
              borderColor: const Color(0xFFD0D5DD),
              boxColor: const Color(0x1A101828),
              mCallback: () {
                controller.toggleEmailOrPhone();
              },
            ),
            const SizedBox(
              height: 24.0,
            ),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Already have an account? ',
                        style: GoogleFonts.montserrat()),
                    TextSpan(
                        text: 'Log In',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600, color: buttonColor),
                        recognizer: controller.loginRecognizer),
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
