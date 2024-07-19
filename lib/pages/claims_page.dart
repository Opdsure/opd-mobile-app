import 'dart:convert';
import 'dart:ui';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/model/my_claims_model.dart';
import 'package:opdsure/pages/claims_details_page.dart';
import 'package:opdsure/pages/file_claim_page.dart';
import 'package:opdsure/pages/upload_file_claim_doc.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../model/claim_json_model.dart';
import '../utils/app_colors.dart';

class ClaimsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: AppBasePage(
        appHeader: AppHomeHeader(
          titleUi: const AppTextView(
              text: 'Claims',
              size: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        childContent: ListView(
          children: [
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
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppTextView(
                            text: 'File a new claim',
                            size: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          // SizedBox(
                          //   width: w*0.7,
                          //   child: const AppTextView(
                          //     text: 'There are 18+ benefits available to you, and there are 6+ hospitals network.',
                          //     size: 12.0,
                          //     color: Color(0xFF667085),
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Divider(
                    color: Color(0xFFEAECF0),
                    height: 0.5,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  AppButton(
                    text: 'File a claim',
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FileClaimPage(
                              isUpdate: false,
                            ),
                          ));
                      // typeController.prescriptionList.clear();
                      // typeController.docFeeRcpt.clear();
                      // typeController.pharmacyRcpt.clear();
                      // typeController.labTestRcpt.clear();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => UploadFileClaimDoc(
                      //           ClaimJsonModel(),isUpdate: false,
                      //       ),
                      //     ));
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // Center(
            //   child: AppRoundView(
            //     mChild: Padding(
            //       padding: const EdgeInsets.symmetric(
            //           vertical: 2.0, horizontal: 5.0),
            //       child: ButtonsTabBar(
            //         backgroundColor: buttonColor,
            //         unselectedBackgroundColor: Colors.transparent,
            //         labelStyle: GoogleFonts.montserrat(
            //             color: Colors.white,
            //             fontSize: 14.0,
            //             fontWeight: FontWeight.w500),
            //         borderColor: buttonColor,
            //         height: 45.0,
            //         width: w * 0.45,
            //         contentCenter: true,
            //         unselectedLabelStyle: GoogleFonts.montserrat(
            //             color: Colors.black,
            //             fontSize: 14.0,
            //             fontWeight: FontWeight.w500),
            //         borderWidth: 1,
            //         unselectedBorderColor: Colors.transparent,
            //         radius: 5,
            //         tabs: const [
            //           Tab(
            //             text: "Active Claims",
            //           ),
            //           Tab(
            //             text: "Past Claims",
            //           )
            //         ],
            //       ),
            //     ),
            //     color: const Color(0xFFEAECF0),
            //     corner: 5.0,
            //   ),
            // ),
            // const SizedBox(
            //   height: 10.0,
            // ),
            Obx(() {
              bool refresh = typeController.refreshClaimList.value;
              return SizedBox(
                height: h * 0.6,
                child: refresh
                    ? FutureBuilder(
                        future: OpdSure.of(context).client.getAllClaims(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: AppTextView(
                                text: 'Claims are loading...',
                              ),
                            );
                          } else {
                            print(snapshot.data);
                            MyClaimsModel myClaimsModel =
                                MyClaimsModel.fromJson(
                                    jsonDecode(snapshot.data));
                            List<ClaimRecords> listData =
                                myClaimsModel.data!.records!;
                            return listData.isEmpty
                                ? const Center(
                                    child: AppTextView(
                                      text: 'No Claim Found',
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: listData.length,
                                    itemBuilder: (context, index) {
                                      ClaimRecords records = listData[index];
                                      ClaimStatusModel claimStatusModel =
                                          ClaimStatusModel().getClaimBuStatus(
                                              records.status!);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ClaimsDetailsPage(
                                                        records),
                                              ),
                                            );
                                          },
                                          child: AppCardView(
                                            mChaild: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppTextView(
                                                      text: CommonMethods
                                                          .getClaimNameById(
                                                              '${records.claimType}'),
                                                      size: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                    const Icon(
                                                      Icons
                                                          .keyboard_arrow_right_sharp,
                                                      color: Colors.black,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2.0,
                                                ),
                                                AppTextView(
                                                  text:
                                                  'Applicant name : ${records.memberId!.name}',
                                                  size: 12.0,
                                                  color:
                                                  const Color(0xFF667085),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                AppTextView(
                                                  text:
                                                  'Hospital : ${records.hospital!}',
                                                  size: 12.0,
                                                  color:
                                                  const Color(0xFF667085),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                AppTextView(
                                                  text:
                                                      'Claim ID : ${records.claimId}',
                                                  size: 12.0,
                                                  color:
                                                      const Color(0xFF667085),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              'Claimable Amount : ',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xFF667085),
                                                          )),
                                                      TextSpan(
                                                        text:
                                                            '$rupeeSymbol ${records.claimableAmount}',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color(
                                                                    0xFF027A48)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Row(
                                                //   children: [
                                                //     const AppTextView(
                                                //       text: 'Status : ',
                                                //       size: 12.0,
                                                //       color: Color(0xFF667085),
                                                //       fontWeight:
                                                //           FontWeight.w500,
                                                //     ),
                                                //     Icon(
                                                //       claimStatusModel.iconData,
                                                //       color: claimStatusModel
                                                //           .statusColor,
                                                //       size: 15.0,
                                                //     ),
                                                //     AppTextView(
                                                //       text:
                                                //           ' ${claimStatusModel.statusName}',
                                                //       size: 12.0,
                                                //       color: claimStatusModel
                                                //           .statusColor!,
                                                //       fontWeight:
                                                //           FontWeight.w500,
                                                //     ),
                                                //   ],
                                                // ),
                                                const SizedBox(height: 5,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    (records.status == 6)?AppButton(
                                                      text: 'Clarification Req',
                                                      width: 100,
                                                      height: 30,
                                                      textSize: 10.0,
                                                      fontWeight: FontWeight.normal,
                                                      onClick: (){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                FileClaimPage(
                                                                  isUpdate: true,
                                                                  records: records,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ):Row(
                                                      children: [
                                                        const AppTextView(
                                                          text: 'Status: ',
                                                          size: 12.0,
                                                          color: Color(0xFF667085),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        Icon(
                                                          claimStatusModel.iconData,
                                                          color: claimStatusModel.statusColor,
                                                          size: 15.0,
                                                        ),
                                                        AppTextView(
                                                          text: ' ${claimStatusModel.statusName}',
                                                          size: 12.0,
                                                          color: claimStatusModel.statusColor!,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ],
                                                    ),
                                                    AppTextView(
                                                      text: 'Claim Date: ${CommonMethods.formatIsoDateString(records.createdAt!)}',
                                                      size: 10.0,
                                                      color: const Color(0xFF667085),
                                                      fontWeight: FontWeight.w500,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 5,),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          }
                        },
                      )
                    : Container(),
              );
            })
          ],
        ),
      ),
    );
  }
}
