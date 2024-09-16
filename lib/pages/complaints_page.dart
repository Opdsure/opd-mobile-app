import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_colors.dart';

import '../config/app_config.dart';

class ComplaintsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Complaints',),
      childContent: ListView(
        children: [
          AppCardView(
            mChaild: const Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF027A48),
                    ),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        AppTextView(
                          text: 'Resolved',
                          color: Color(0xFF027A48),
                          size: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 5.0,),
                        AppTextView(
                          text: 'On Thu, 27th June',
                          color: Color(0xFF667085),
                          size: 10.0,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 15.0,),
                        AppTextView(
                          text: 'Max Hospital',
                          color: Color(0xFF667085),
                          size: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 5.0,),
                        AppTextView(
                          text: 'Claim Number : 3523723080937',
                          color: Color(0xFF667085),
                          size: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10.0,),
                AppTextView(
                  text: 'Your complaint was successfully resolved by Rajesh Kumar on thu 27th June.',
                  color: Color(0xFF667085),
                  size: 10.0,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 10.0,),
                AppBorderBox(
                  boxColor: AppConfig.primaryColor,
                  height: 40.0,
                  myChild: Center(
                    child: AppTextView(
                      text: 'Reopen Complaint',
                      size: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}