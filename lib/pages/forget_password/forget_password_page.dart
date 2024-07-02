import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/forget_password/forget_password_controller.dart';

import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_edit_text.dart';
import '../../custom_ui/app_text_view.dart';
import '../../utils/app_colors.dart';

class ForgetPasswordPageView extends StatelessWidget{
  final ForgetPasswordPageController controller;
  const ForgetPasswordPageView(this.controller, {super.key});

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
            const SizedBox(height: 24.0,),
            const Center(
              child: AppTextView(
                text: 'Reset Password',
                color: Colors.black,
                size: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Center(
              child: AppTextView(
                text: 'Please enter your email address to request a password reset',
                color: Color(0xff475467),
                size: 16.0,
                mTextAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0,),

            const AppEditText(
              hint: 'Enter your email address',
              size: 14.0,
              textInputType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 24.0,),
            const AppButton(text: 'Send Mail'),

            const SizedBox(height: 24.0,),
            Center(
              child: AppTextView(
                text: 'Back to Login',
                color: buttonColor,
                size: 14.0,
                fontWeight: FontWeight.w600,
                onClick: (){
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}