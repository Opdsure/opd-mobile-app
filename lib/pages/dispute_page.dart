import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';

import '../custom_ui/app_button.dart';
import '../utils/app_colors.dart';

class DisputePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Raise Complaint',),
      childContent: ListView(
        children: [
          const SizedBox(height: 20.0),
          const AppTextView(
            text: 'Remark',
            size: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 5.0,),
          SizedBox(
            height: 200,
            child: AppBorderBox(
              myChild: TextField(
                style: GoogleFonts.montserrat(
                    fontSize: 15.0,
                    color: backIconCl
                ),
                maxLines: null, // Set this
                expands: true, // and this
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Write the description',
                  border: InputBorder.none,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0,),
          const AppTextView(
            text: 'Upload Document',
            size: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 5.0,),
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
          const AppButton(text: 'Submit'),
        ],
      ),
    );
  }

}