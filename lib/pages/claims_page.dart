import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_bottom_sheet.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../utils/app_colors.dart';

class ClaimsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              const SizedBox(height: 16.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      AppTextView(
                        text: 'Claims',
                        size: 22.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
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
                      const SizedBox(width: 15.0,),
                      Image.asset(
                        'assets/images/bell_icon.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15.0,),
              AppCardView(
                mChaild: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/new_claim.png',
                          height: 35.0,
                          width: 35.0,
                        ),
                        const SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppTextView(
                              text: 'File a new claim',
                              size: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              width: w*0.7,
                              child: const AppTextView(
                                text: 'There are 18+ benefits available to you, and there are 6+ hospitals network.',
                                size: 12.0,
                                color: Color(0xFF667085),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0,),
                    const Divider(color: Color(0xFFEAECF0),height: 0.5,),
                    const SizedBox(height: 15.0,),
                    AppButton(
                      text: 'File a claim',
                      onClick: (){
                        AppBottomSheet(
                          height: h*0.3,
                          mChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/error.png',
                                height: 30.0,
                                width: 30.0,
                              ),
                              const SizedBox(height: 10.0,),
                              const AppTextView(
                                text: 'Bank account not added',
                                size: 18.0,
                                color: Color(0xFF101828),
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 5.0,),
                              const AppTextView(
                                text: 'You won’t be able to receive your reimbursement until bank account not added.',
                                size: 12.0,
                                color: Color(0xFF667085),
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 10.0,),
                              const AppButton(text: 'Add',),
                              const SizedBox(height: 10.0,),
                              const AppBorderBox(
                                myChild: Center(
                                  child: AppTextView(
                                    text: 'Cancel',
                                    size: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                boxColor: Color(0xFF344054),
                              )
                            ],
                          )
                        ).modalBottomSheetMenu(context);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20.0,),
              Center(
                child: AppRoundView(
                  mChild: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 5.0),
                    child: ButtonsTabBar(
                      backgroundColor: buttonColor,
                      unselectedBackgroundColor: Colors.transparent,
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500
                      ),
                      borderColor: buttonColor,
                      height: 45.0,
                      width: w*0.45,
                      contentCenter: true,
                      unselectedLabelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500
                      ),
                      borderWidth: 1,
                      unselectedBorderColor: Colors.transparent,
                      radius: 5,
                      tabs: const [
                        Tab(
                          text: "Active Claims",
                        ),
                        Tab(
                          text: "Past Claims",
                        )
                      ],
                    ),
                  ),
                  color: const Color(0xFFEAECF0),
                  corner: 5.0,
                ),
              ),
              const SizedBox(height: 10.0,),
              SizedBox(
                height: h*0.6,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: AppCardView(
                        mChaild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextView(
                                  text: 'Car Accident',
                                  size: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            const SizedBox(height: 2.0,),
                            const AppTextView(
                              text: 'Max Hospital',
                              size: 12.0,
                              color: Color(0xFF667085),
                              fontWeight: FontWeight.w500,
                            ),
                            const AppTextView(
                              text: 'Claim Number : 3523723080937',
                              size: 12.0,
                              color: Color(0xFF667085),
                              fontWeight: FontWeight.w500,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Reimbursed Amount : ',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF667085),
                                      )
                                  ),
                                  TextSpan(
                                    text: '$rupeeSymbol 400/mo',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF027A48)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const AppTextView(
                                  text: 'Status : ',
                                  size: 12.0,
                                  color: Color(0xFF667085),
                                  fontWeight: FontWeight.w500,
                                ),
                                (index!=2)?const Icon(
                                  Icons.access_time_outlined,
                                  color: Color(0xFFEF6C00),
                                  size: 15.0,
                                ):const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Color(0xFF027A48),
                                  size: 15.0,
                                ),
                                const SizedBox(width: 3,),
                                (index!=2)?const AppTextView(
                                  text: 'Processing',
                                  size: 12.0,
                                  color: Color(0xFFEF6C00),
                                  fontWeight: FontWeight.w500,
                                ):const AppTextView(
                                  text: 'Settled',
                                  size: 12.0,
                                  color: Color(0xFF027A48),
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}