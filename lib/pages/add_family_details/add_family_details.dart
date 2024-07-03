import 'dart:ui';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_edit_text.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_colors.dart';

import '../../custom_ui/app_mobile_field.dart';

class AddFamilyDetails extends StatelessWidget{
  final countryPicker = const FlCountryCodePicker();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: pageBackColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0,),
            AppHeader(
              headerName: 'Add Details',
              showRightView: true,
              rightView: const AppTextView(
                text: 'Skip',
                color: Color(0xFF475467),
                size: 16.0,
              ),
            ),
            const SizedBox(height: 20.0,),
            const AppTextView(
              text: 'Fill Your Details',
              size: 18.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
            ),
            const SizedBox(height: 16.0,),
            const AppTextView(
              text: 'Name',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            const AppEditText(hint: 'Enter the name'),
            const SizedBox(height: 15.0,),
            const AppTextView(
              text: 'DOB',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            const AppEditText(
              hint: 'Enter date of birth',
              disableText: true,
              viewSuffix: true,
              suffixWidget: Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff667085),
                size: 24.0,
              ),
            ),
            const SizedBox(height: 15.0,),
            const AppTextView(
              text: 'Gender',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            const AppEditText(
              hint: 'Select Gender',
              disableText: true,
              viewSuffix: true,
              suffixWidget: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Color(0xff667085),
                size: 24.0,
              ),
            ),
            const SizedBox(height: 15.0,),
            const AppTextView(
              text: 'Phone Number',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            AppMobileField(
              hint: 'Enter your mobile number',
              countryCode: '+91',
              countryCallback: ()async{
                // Show the country code picker when tapped.
                final picked= await countryPicker.showPicker(context: context);
                // Null check
                if (picked!= null) print(picked);
              },
            ),
            const SizedBox(height: 15.0,),
            const AppTextView(
              text: 'Gender',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            const AppEditText(
              hint: 'Select Gender',
              disableText: true,
              viewSuffix: true,
              suffixWidget: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Color(0xff667085),
                size: 24.0,
              ),
            ),
            const SizedBox(height: 15.0,),
            const AppTextView(
              text: 'City',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            const AppEditText(hint: 'Enter the city'),
            const SizedBox(height: 15.0,),
            const AppTextView(
              text: 'Pincode',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            const AppEditText(hint: 'Enter the pincode'),
            const SizedBox(height: 20.0,),
            AppButton(text: 'Save'),
            const SizedBox(height: 15.0,),
            AppButton(
              text: 'Add Another Member',
              color: Color(0xFFebecf1),
              textColor: buttonColor,
              borderColor: buttonColor,
            )
          ],
        ),
      ),
    );
  }

}