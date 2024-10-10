import 'dart:ui';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/login_scafold.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../../config/app_config.dart';
import '../../../custom_ui/app_border_box.dart';
import '../../../custom_ui/app_button.dart';
import '../../../custom_ui/app_edit_text.dart';
import '../../../custom_ui/app_mobile_field.dart';
import '../../../custom_ui/app_rich_text.dart';
import '../../../custom_ui/app_text_view.dart';
import '../../../get_controllers/type_controller.dart';
import '../../../utils/app_colors.dart';

class LoginView extends StatelessWidget {
  final LoginPageController controller;
  final countryPicker = const FlCountryCodePicker();

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      childContent: ListView(
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
           AppMobileField(
                hint: 'Enter your mobile number',
                countryCode: '+91',
                focusNode: controller.focusNode,
                textEditingController: controller.phoneTextController,
                errorMessage: controller.phoneError,
                showErrorMessage: controller.isMobileError,
             inputFormatters: [
               LengthLimitingTextInputFormatter(10),
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
          Center(
            child: AppRichText(
              textSpan: TextSpan(
                children: [
                  TextSpan(
                      text: 'Don’t have an account? ',
                      style: GoogleFonts.montserrat()),
                  TextSpan(
                      text: 'Sign Up',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600, color: AppConfig.primaryColor),
                      recognizer: controller.signupRecognizer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
