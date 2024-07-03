import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_text_view.dart';
import '../utils/app_colors.dart';

class FileClaimPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'File a Claims',),
      childContent: ListView(
        children: [
          const AppTextView(
            text: 'Claim Type',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(
            hint: 'Medicine',
            disableText: true,
            viewSuffix: true,
            suffixWidget: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Color(0xff667085),
              size: 24.0,
            ),
          ),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'User',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(
            hint: 'Select User',
            disableText: true,
            viewSuffix: true,
            suffixWidget: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Color(0xff667085),
              size: 24.0,
            ),
          ),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Doctor Name',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter the name'),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'OPD Visit Date',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(
            hint: 'Enter OPD Visit Date',
            disableText: true,
            viewSuffix: true,
            suffixWidget: Icon(
              Icons.calendar_today_outlined,
              color: Color(0xff667085),
              size: 24.0,
            ),
          ),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Doc Reg. Number',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter doc Reg. Number'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Hospital Name',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter hospital Name'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Hospital Address',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter hospital Address'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Hospital Contact Info.',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter hospital Contact Info.'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Diagnosis',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter diagnosis'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Upload Prescription',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          AppBorderBox(
            myChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/upload.png',
                    height: 40.0,
                    width: 40.0,
                  ),
                  const SizedBox(height: 15.0),
                  const AppTextView(
                    text: 'Click to upload',
                    size: 14.0,
                    fontWeight: FontWeight.w600,
                    color: buttonColor,
                  )
                ],
              ),
            ),
            height: 100.0,
          ),
          const SizedBox(height: 20.0),
          const AppButton(text: 'Continue'),
          const SizedBox(height: 20.0),
        ],
      ),

    );
  }

}