import 'dart:ui';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';

import '../../../custom_ui/app_border_box.dart';
import '../../../custom_ui/app_button.dart';
import '../../../custom_ui/app_edit_text.dart';
import '../../../custom_ui/app_mobile_field.dart';
import '../../../custom_ui/app_text_view.dart';
import '../../../get_controllers/type_controller.dart';
import '../../../utils/app_colors.dart';

class LoginView extends StatelessWidget {
  final LoginPageController controller;
  final countryPicker = const FlCountryCodePicker();

  const LoginView(this.controller, {super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: ()=> context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: backIconCl,
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
            const SizedBox(
              height: 24.0,
            ),
            const Center(
              child: AppTextView(
                text: 'Welcome Back!',
                color: Colors.black,
                size: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Center(
              child: AppTextView(
                text: 'Please enter your login details.',
                color: Color(0xff475467),
                size: 16.0,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),

            controller.isWithEmail ? AppEditText(
                  hint: 'Enter your email address',
                  size: 14.0,
                  textInputType: TextInputType.emailAddress,
                  textEditingController: controller.emailTextController,
                ) :
             AppMobileField(
                  hint: 'Enter your mobile number',
                  countryCode: '+91',
                  textEditingController: controller.phoneTextController,
                  errorText: controller.phoneError,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(13),
                  ],
                  countryCallback: () async {
                    // Show the country code picker when tapped.
                    final picked =
                        await countryPicker.showPicker(context: context);
                    // Null check
                    if (picked != null) print(picked);
                  },
                ),
            const SizedBox(
              height: 16.0,
            ),
        AppEditText(
          hint: 'Enter password',
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
            Align(
              alignment: Alignment.centerRight,
              child: AppTextView(
                text: 'Forgot Password',
                size: 12.0,
                fontWeight: FontWeight.w600,
                color: buttonColor,
                onClick: () {
                  controller.forgetPassword();
                },
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            AppButton(text: 'Continue', onClick: (){
              controller.login();
            },),
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
                mCallback: controller.toggleEmailOrPhone
              ),
            const SizedBox(
              height: 24.0,
            ),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Don’t have an account? ',
                        style: GoogleFonts.montserrat()),
                    TextSpan(
                        text: 'Sign Up',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600, color: buttonColor),
                        recognizer: controller.signupRecognizer),
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
