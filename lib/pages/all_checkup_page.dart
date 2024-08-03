import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/all_checkup_model.dart';
import 'package:opdsure/model/checkup_status_model.dart';
import 'package:opdsure/pages/health_check_up_page.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../utils/common_methods.dart';

class AllCheckupPage extends StatelessWidget{

  String getTestName(List value){
    String allTest = '';
    if(value.contains(1)){
      allTest = '$allTest Blood Sugar';
    }
    if(value.contains(2)){
      allTest = '$allTest Lipid';
    }
    if(value.contains(3)){
      allTest = '$allTest Full Body';
    }
    return allTest;
  }

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Free Health Check-up',
        showRightView: true,
        rightView: InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>HealthCheckUpPage()),
            );
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              AppTextView(text: 'Add')
            ],
          ),
        ),
      ),
      childContent: FutureBuilder(
        future: OpdSure.of(context).client.getAllCheckup(),
        builder: (context,snapshot){
          if(snapshot.data == null){
            return const Center(
              child: AppTextView(text: 'Loading data...',),
            );
          }
          else{
            AllCheckupModel allCheckupModel = AllCheckupModel.fromJson(jsonDecode(snapshot.data));
            List<AllCheckupRecords> allCheckupRecords = allCheckupModel.data!.records!;
            return allCheckupRecords.isEmpty
                    ? const Center(
                  child: AppTextView(
                    text: 'No Data Found',
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: () async {
                    // typeController.refreshClaimListChange(false);
                    // typeController.refreshClaimListChange(true);
                  },
                  child: SizedBox(
                    height: h*0.9,
                    child: ListView.builder(
                      itemCount: allCheckupRecords.length,
                      itemBuilder: (context, index) {
                        AllCheckupRecords records = allCheckupRecords[index];
                        MemberDetails memberDetails = records.memberDetails!;
                        CheckupStatusModel csm = CheckupStatusModel().getCheckupByStatus(records.status!);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0),
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
                                      text: memberDetails.name!,
                                      size: 16,
                                      fontWeight:
                                      FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    const Visibility(
                                      visible: false,
                                      child: Icon(
                                        Icons
                                            .keyboard_arrow_right_sharp,
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
                                  color:
                                  const Color(0xFF667085),
                                  fontWeight: FontWeight.w500,
                                ),
                                AppTextView(
                                  text:
                                  'Test : ${getTestName(records.checkupFor!)}',
                                  size: 12.0,
                                  color:
                                  const Color(0xFF667085),
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 5,),
                                AppTextView(
                                  text: 'Booking Date: ${CommonMethods.formatIsoDateString(records.createdAt!,isTime: true)}',
                                  size: 10.0,
                                  color: const Color(0xFF667085),
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 5,),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            );
          }
        },
      ),
    );
  }
}