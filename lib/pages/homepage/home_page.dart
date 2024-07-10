import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_gradient.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/logs/logs.dart';
import 'package:opdsure/widget/opd_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    double w = CommonMethods.deviceWidth(context);
    // TODO: implement build
    return Scaffold(
      backgroundColor: pageBackColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Welcome, ',
                              style: GoogleFonts.montserrat(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          TextSpan(
                              text: OpdSure.of(context).profileData!.name!,
                              style: GoogleFonts.montserrat(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: buttonColor)),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/wallet_icon.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Image.asset(
                      'assets/images/bell_icon.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                  ],
                )
              ],
            ),
            const AppTextView(
              text: 'Have a great day',
              color: Color(0xFF667085),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            AppGradient(
              mChild: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/claim.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              width: w * 0.75,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppTextView(
                                        text: '100 + Claims Filed',
                                        size: 13.0,
                                        color: Color(0xFF667085),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      AppTextView(
                                        text: 'File an OPD Claim',
                                        size: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.keyboard_arrow_right_sharp)
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              width: w * 0.7,
                              child: const AppTextView(
                                text:
                                    'File your OPD Claim quickly and effortlessly, and let us take care of the rest',
                                size: 14.0,
                                color: Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              colorList: const [
                Color(0xFFfcf2f9),
                Color(0xFFede0f2),
                Color(0xFFe0dff5),
                Color(0xFFd3dff7),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            AppGradient(
              mChild: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppRoundView(
                          corner: 7.0,
                          color: Color(0xFF79ceff),
                          mChild: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.add_box,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 2,
                            ),
                            SizedBox(
                              width: w * 0.75,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppTextView(
                                    text: 'Book Free Health Check-up',
                                    size: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Icon(Icons.keyboard_arrow_right_sharp)
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              width: w * 0.7,
                              child: const AppTextView(
                                text:
                                    'Book your free health check -up today and prioritize your well-being with confidence.',
                                size: 14.0,
                                color: Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              colorList: const [
                Color(0xFFeff9ff),
                Color(0xFFd8f1ff),
                Color(0xFFc0e7ff),
                Color(0xFFcaebff),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextView(
                  text: 'My Claims',
                  color: Colors.black,
                  size: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                Row(
                  children: [
                    AppTextView(
                      text: 'View all',
                      color: Color(0xFF98A2B3),
                      size: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: Color(0xFF98A2B3),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            AppBorderBox(
              mCallback: () {
                OpdSure.of(context).client.logout();
              },
              height: h * 0.12,
              myChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/accident.png'),
                            const SizedBox(
                              width: 10,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextView(
                                  text: 'Accidental Claim',
                                  size: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                AppTextView(
                                  text: 'HR26DK 8873',
                                  size: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF3C3C43),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10.0,
                              color: Colors.green,
                            ),
                            AppTextView(
                              text: 'Active',
                              size: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: AppTextView(
                        text: 'Due on 18/06/2024',
                        color: Color(0xFFF04438),
                        size: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
