import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/route.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/all_checkup_model.dart';
import 'package:opdsure/model/checkup_status_model.dart';
import 'package:opdsure/pages/health_check_up_page.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../utils/common_methods.dart';

class AllCheckupPage extends StatelessWidget {
  const AllCheckupPage({super.key});

  String getTestName(List value) {
    String allTest = '';
    if (value.contains(1)) {
      allTest = '$allTest Blood Sugar';
    }
    if (value.contains(2)) {
      allTest = '$allTest Lipid';
    }
    if (value.contains(3)) {
      allTest = '$allTest Full Body';
    }
    return allTest;
  }

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    return AppBasePage(
      isAddBottomPadding: true,
      appHeader: const AppHeader(
        headerName: 'Free Health Check-up',
      ),
      childContent: FutureBuilder(
        future: OpdSure.of(context).client.getAllCheckup(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: AppTextView(
                text: 'Loading data...',
              ),
            );
          } else {
            AllCheckupModel allCheckupModel =
                AllCheckupModel.fromJson(jsonDecode(snapshot.data));
            List<AllCheckupRecords> allCheckupRecords =
                allCheckupModel.data!.records!;
            return allCheckupRecords.isEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                    const Center(
                      child: AppTextView(
                        fontWeight: FontWeight.w600,
                          mTextAlign: TextAlign.center,
                          text:
                              "You haven't booked a health checkup plan yet. Please book a plan to proceed."),
                    ),
                    AppButton(
                      text: 'Book Health Checkup',
                      onClick: () {
                        context.push('/home/book_checkup/add_health_checkup');
                      },
                    ),
                  ])
                : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          // typeController.refreshClaimListChange(false);
                          // typeController.refreshClaimListChange(true);
                        },
                        child: ListView.builder(
                          itemCount: allCheckupRecords.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            AllCheckupRecords records =
                                allCheckupRecords[index];
                            MemberDetails memberDetails =
                                records.memberDetails!;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: AppCardView(
                                mChaild: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppTextView(
                                          text: memberDetails.name!,
                                          size: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        const Visibility(
                                          visible: false,
                                          child: Icon(
                                            Icons.keyboard_arrow_right_sharp,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    AppTextView(
                                      text:
                                          'Health CheckUp ID : ${records.healthCheckupId}',
                                      size: 12.0,
                                      color: const Color(0xFF667085),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    AppTextView(
                                      text:
                                          'Test : ${getTestName(records.checkupFor!)}',
                                      size: 12.0,
                                      color: const Color(0xFF667085),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppTextView(
                                      text:
                                          'Booking Date: ${CommonMethods.formatIsoDateString(records.createdAt!, isTime: true, isAddTime: true)}',
                                      size: 10.0,
                                      color: const Color(0xFF667085),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      AppButton(
                        text: 'Book Health Checkup',
                        onClick: () {
                          context.push('/home/book_checkup/add_health_checkup');
                        },
                      )
                    ],
                  );
          }
        },
      ),
    );
  }
}
