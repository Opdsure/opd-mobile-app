import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/utils/opd_extension/string_extension.dart';

import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_edit_text.dart';
import '../../custom_ui/app_mobile_field.dart';
import 'name_email_number_controller.dart';

enum InputType { firstName, middleName, lastName, emailOrPhone }

class NameEmailNumberView extends StatelessWidget {
  final NameEmailNumberController controller;

  const NameEmailNumberView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          leadingWidth: 0,
          leading: Container(),
          title: const AppTextView(
            text: 'Enter your details',
            fontWeight: FontWeight.bold,
            size: 18,
            color: Colors.black,
          ),
        ),
        body: StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Center(
                      child: AppTextView(
                        text: 'Welcome to OPDSure',
                        color: Colors.black,
                        size: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Center(
                      child: AppTextView(
                        text: 'Enter your legal name as per your ID card.',
                        color: Color(0xff475467),
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    InputFields(controller, controller.inputType),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
                AppButton(
                  text: 'Next',
                  onClick: () {
                    switch (controller.inputType) {
                      case InputType.firstName:
                        if (controller.firstNameTextController.text.isEmpty) {
                          setState(() =>
                              controller.nameError = 'First name is required');
                        } else {
                          setState(() =>
                              controller.inputType = InputType.middleName);
                        }

                      case InputType.middleName:
                        setState(
                            () => controller.inputType = InputType.lastName);
                      case InputType.lastName:
                        setState(() =>
                            controller.inputType = InputType.emailOrPhone);
                      case InputType.emailOrPhone:
                        if (!controller.isWithEmail) {
                          if (controller.phoneTextController.text.isEmpty) {
                            setState(() =>
                                controller.phoneError = 'Phone no is empty');
                            return;
                          } else {
                            if (!controller
                                .phoneTextController.text.isValidPhoneNumber) {
                              setState(() => controller.phoneError =
                                  'Enter a valid phone no');
                              return;
                            }
                          }
                        } else {
                          if (controller.emailTextController.text.isEmpty) {
                            setState(() => controller.emailError =
                                'Email address is empty');
                            return;
                          } else {
                            if (!controller
                                .emailTextController.text.isValidEmail) {
                              setState(() => controller.emailError =
                                  'Enter a valid email address');
                              return;
                            }
                          }
                        }
                        controller.inputType = InputType.firstName;
                        controller.updateProfile();
                    }
                  },
                ),
              ],
            ),
          );
        }),
      );
}

class InputFields extends StatelessWidget {
  final InputType inputType;
  final NameEmailNumberController controller;
  const InputFields(this.controller, this.inputType, {super.key});

  @override
  build(BuildContext context) {
    switch (inputType) {
      case InputType.firstName:
        return AppEditText(
          hint: 'Enter your first name',
          size: 14.0,
          textInputType: TextInputType.name,
          textEditingController: controller.firstNameTextController,
          errorMessage: controller.nameError,
        );
      case InputType.middleName:
        return AppEditText(
          hint: 'Enter your middle name',
          size: 14.0,
          textInputType: TextInputType.name,
          textEditingController: controller.middleNameTextController,
        );
      case InputType.lastName:
        return AppEditText(
          hint: 'Enter your last name',
          size: 14.0,
          textInputType: TextInputType.name,
          textEditingController: controller.lastNameControllerTextController,
        );
      case InputType.emailOrPhone:
        return controller.isWithEmail
            ? AppEditText(
                hint: 'Enter your email address',
                size: 14.0,
                textInputType: TextInputType.emailAddress,
                textEditingController: controller.emailTextController,
                errorMessage: controller.emailError,
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
              );
    }
  }
}
