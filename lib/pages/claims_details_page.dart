import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/model/my_claims_model.dart';
import 'package:opdsure/utils/app_colors.dart';

import '../utils/common_methods.dart';

class ClaimsDetailsPage extends StatelessWidget{
  final Records oneClaim;
  ClaimsDetailsPage(this.oneClaim);

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
    ClaimStatusModel claimStatusModel = ClaimStatusModel().getClaimBuStatus(oneClaim.status!);
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Claim Details',),
      childContent: ListView(
        children: [
          AppCardView(
            mChaild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextView(
                  text: '${CommonMethods.getClaimNameById('${oneClaim.claimType}')} Claim | ${oneClaim.hospital} ',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                const SizedBox(height: 10.0,),
                commonRow('Type','Medicine'),
                const SizedBox(height: 7.0,),
                commonRow('Name',oneClaim.docName!),
                const SizedBox(height: 7.0,),
                commonRow('Doctor Name',oneClaim.docName!),
                const SizedBox(height: 7.0,),
                commonRow('Doc. Reg. Number',oneClaim.docRegistration!),
                const SizedBox(height: 7.0,),
                commonRow('Hospital Address',oneClaim.city!),
                const SizedBox(height: 7.0,),
                commonRow('Hospital Cont. Info.','${oneClaim.docPhone!}'),
                const SizedBox(height: 7.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppTextView(
                      text: 'Status',
                      size: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF344054),
                    ),
                    Row(
                      children: [
                        Icon(
                          claimStatusModel.iconData,
                          color: claimStatusModel.statusColor,
                          size: 15.0,
                        ),
                        const SizedBox(width: 5.0,),
                        AppTextView(
                          text: claimStatusModel.statusName!,
                          size: 14.0,
                          fontWeight: FontWeight.w500,
                          color: claimStatusModel.statusColor!,
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
                const AppTextView(
                  text: 'Prescription',
                  color: Colors.black,
                ),
                SizedBox(
                  height: h*oneClaim.prescription!.length*0.075,
                  child: ListView.builder(
                    itemCount: oneClaim.prescription!.length,
                    physics: const NeverScrollableScrollPhysics(),
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
                const AppTextView(
                  text: 'Fees Receipt',
                  color: Colors.black,
                ),
                SizedBox(
                  height: h*oneClaim.feeReceipt!.length*0.075,
                  child: ListView.builder(
                    itemCount: oneClaim.feeReceipt!.length,
                    physics: const NeverScrollableScrollPhysics(),
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
                const AppTextView(
                  text: 'Pharmacy Receipt',
                  color: Colors.black,
                ),
                SizedBox(
                  height: h*oneClaim.pharmacyReceipt!.length*0.075,
                  child: ListView.builder(
                    itemCount: oneClaim.pharmacyReceipt!.length,
                    physics: const NeverScrollableScrollPhysics(),
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
                const AppTextView(
                  text: 'Test Receipt',
                  color: Colors.black,
                ),
                SizedBox(
                  height: h*oneClaim.testReceipt!.length*0.075,
                  child: ListView.builder(
                    itemCount: oneClaim.testReceipt!.length,
                    physics: const NeverScrollableScrollPhysics(),
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
          ),
          const SizedBox(height: 20.0,),
        ],
      ),
    );
  }

}