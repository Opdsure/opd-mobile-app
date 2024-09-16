import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_mobile_field.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/pages/terms_condition_page.dart';
import '../../config/app_config.dart';
import '../../utils/app_colors.dart';

class SignUpView extends StatelessWidget {
  final SignUpController controller;

  const SignUpView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      childContent:  ListView(
        children: [
          const SizedBox(
            height: 16.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if(context.canPop()){
                    context.pop();
                  }
                },
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
          AppMobileField(
            hint: 'Enter your mobile number',
            countryCode: controller.countryCode,
            focusNode: controller.focusNode,
            textEditingController: controller.phoneTextController,
            flagUri: controller.flagUri,
            errorMessage: controller.phoneError,
            showErrorMessage: controller.isShowErrorMobile,
            mOnChanged: controller.onChanged,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            countryCallback: () {
              controller.getCountryCode();
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 20,
                child: Checkbox(
                  activeColor: AppConfig.primaryColor,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  value: controller.isTermAndConditions,
                  onChanged: controller.onTermAndConditions,
                  // onChanged: controller.onTermAndConditions,
                ),
              ),
              InkWell(
                onTap: (){
                  context.push('/signup/terms', extra: 'SIGNUP');
                },
                child: SizedBox(
                  height: 20,
                  child: Text.rich(
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
                  ),
                ),
              )
            ],
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
                          fontWeight: FontWeight.w600, color: AppConfig.primaryColor),
                      recognizer: controller.loginRecognizer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
