import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_mobile_field.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHomeHeader(
        title: Text('Referral', style: AppDesign.titleLg),
      ),
      childContent: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: AppDesign.spacingSm),
          // Form card container
          Container(
            padding: const EdgeInsets.all(AppDesign.spacingXxl),
            decoration: BoxDecoration(
              color: AppDesign.card,
              borderRadius: BorderRadius.circular(AppDesign.radiusXl),
              boxShadow: AppDesign.shadowMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppDesign.accentLight,
                        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                      ),
                      child: const Icon(
                        Icons.people_outline_rounded,
                        color: AppDesign.accent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDesign.spacingMd),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refer a Friend',
                          style: AppDesign.headingSm,
                        ),
                        const SizedBox(height: AppDesign.spacingXs),
                        Text(
                          'Share the wellness benefits',
                          style: AppDesign.bodySm.copyWith(
                            color: AppDesign.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppDesign.spacing3Xl),

                // Name field
                _buildLabel('Name', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                  hint: 'Enter name',
                  textEditingController: nameCtrl,
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: AppDesign.spacingXl),

                // Mobile field
                _buildLabel('Mobile', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppMobileField(
                  hint: 'Enter number',
                  countryCode: '+91',
                  textEditingController: mobileCtrl,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  countryCallback: () async {},
                ),
                const SizedBox(height: AppDesign.spacingXl),

                // Email field
                _buildLabel('Email'),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                  hint: 'Enter email',
                  textEditingController: emailCtrl,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppDesign.spacing3Xl),

                // Submit button
                AppButton(
                  text: 'Submit Referral',
                  icon: Icons.send_rounded,
                  onClick: () async {
                    if (nameCtrl.text.isEmpty) {
                      CommonMethods.showToast('Please enter name');
                    } else if (mobileCtrl.text.isEmpty ||
                        mobileCtrl.text.length < 10) {
                      CommonMethods.showToast(
                          'Please enter valid mobile number');
                    } else {
                      CommonMethods.showAlertDialog(context);
                      var response =
                          await OpdSure.of(context).client.sendReferral(
                                name: nameCtrl.text,
                                mobile: '+91${mobileCtrl.text}',
                                email: emailCtrl.text.isEmpty
                                    ? 'abc@gmail.com'
                                    : emailCtrl.text,
                              );
                      Map<String, dynamic> mapData = jsonDecode(response);
                      if (mapData['success']) {
                        CommonMethods.showToast('Referral sent successfully');
                        nameCtrl.text = '';
                        mobileCtrl.text = '';
                        emailCtrl.text = '';
                      } else {
                        CommonMethods.showToast('Something went wrong');
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    if (!isRequired) {
      return Text(text, style: AppDesign.labelLg);
    }
    return RichText(
      text: TextSpan(
        style: AppDesign.labelLg,
        children: [
          TextSpan(text: text),
          const TextSpan(text: ' '),
          TextSpan(
            text: '*',
            style: AppDesign.labelLg.copyWith(color: AppDesign.error),
          ),
        ],
      ),
    );
  }
}
