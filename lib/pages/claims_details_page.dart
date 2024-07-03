import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_colors.dart';

import '../utils/common_methods.dart';

class ClaimsDetailsPage extends StatelessWidget{

  Widget commonRow(String key, String value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextView(
          text: key,
          size: 14.0,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF344054),
        ),
        AppTextView(
          text: value,
          size: 14.0,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF344054),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0,),
            AppHeader(headerName: 'Claim Details',),
            const SizedBox(height: 16.0,),
            AppCardView(
              mChaild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTextView(
                    text: 'Car Accident Claim | Max Hospital ',
                    size: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10.0,),
                  commonRow('Type','Medicine'),
                  const SizedBox(height: 7.0,),
                  commonRow('Name','Jaya Sharma'),
                  const SizedBox(height: 7.0,),
                  commonRow('Doctor Name','Mr. Singh'),
                  const SizedBox(height: 7.0,),
                  commonRow('Doc. Reg. Number','48308'),
                  const SizedBox(height: 7.0,),
                  commonRow('Hospital Address','Gurugram'),
                  const SizedBox(height: 7.0,),
                  commonRow('Hospital Cont. Info.','080 - 22640321'),
                  const SizedBox(height: 7.0,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: 'Status',
                        size: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF344054),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color: Color(0xFFEF6C00),
                            size: 15.0,
                          ),
                          SizedBox(width: 5.0,),
                          AppTextView(
                            text: 'Rejected',
                            size: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF344054),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15.0,),
            AppCardView(
              mChaild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTextView(
                    text: 'Uploaded Documents',
                    size: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10.0,),
                  SizedBox(
                    height: h*0.2,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/document.png',
                                    height: 30.0,
                                    width: 30.0,
                                  ),
                                  const SizedBox(width: 10.0,),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppTextView(
                                        text: 'Report',
                                        size: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF344054),
                                      ),
                                      AppTextView(
                                        text: '200 KB',
                                        size: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF475467),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Image.asset(
                                'assets/images/delete.png',
                                height: 25.0,
                                width: 25.0,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0,),
            const AppBorderBox(
              myChild: Center(
                child: AppTextView(
                  text: 'Raise Dispute',
                  color: buttonColor,
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              borderColor: buttonColor,
              borderWidth: 1.0,
              height: 45.0,
            )
          ],
        ),
      ),
    );
  }

}