import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/pages/checkout/checkout_controller.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../model/my_claim/my_claims_list_model.dart';
import '../model/my_claim/my_claims_model.dart';
import 'claim_pages/claim_tile.dart';

class ClaimsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    TypeController typeController = Get.put(TypeController());
    return DefaultTabController(
      length: 2,
      child: AppBasePage(
        appHeader: const AppHomeHeader(
          title: AppTextView(
              text: 'Claims',
              size: 16.0,
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
                  OpdSure.of(context).client.isPlanPurchased
                      ? AppButton(
                          text: 'File a claim',
                          onClick: () {
                            context.push('/home/file_claim', extra: {
                              'isUpdate' : false,
                              'records' : null
                            });
                          },
                        )
                      : AppButton(
                          text: 'Select Plan',
                          onClick: () {
                            context.go('/view_plans', extra: PaymentType.buyPlan);

                          },
                        )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),

            Obx(() {
              bool refresh = typeController.refreshClaimList.value;
              return SizedBox(
                height: h * 0.55,
                child: refresh
                    ? FutureBuilder<MyClaimsModel?>(
                        future: OpdSure.of(context).client.getAllClaims(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: AppTextView(
                                text: 'Claims are loading...',
                              ),
                            );
                          } else {
                            MyClaimsModel? myClaimsModel = snapshot.data;
                            List<ClaimRecords> listData = myClaimsModel!.data!.records!;
                            return listData.isEmpty
                                ? const Center(
                                    child: AppTextView(text: 'No Claim Found',),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      typeController
                                          .refreshClaimListChange(false);
                                      typeController
                                          .refreshClaimListChange(true);
                                      // await OpdSure.of(context).client.getAllClaims();
                                    },
                                    child: ListView.builder(
                                      itemCount: listData.length,
                                      itemBuilder: (context, index) {
                                        ClaimRecords records = listData[index];
                                        ClaimStatusModel claimStatusModel = ClaimStatusModel().getClaimBuStatus(records.status!, reSubmit: records.resubmission!);
                                        ClaimStatusModel disputeClaimStatus = ClaimStatusModel().getDisputeClaimBuStatus(records.disputeDetails!);
                                        return ClaimTile(records: records, claimStatus: claimStatusModel, disputeClaimStatus: disputeClaimStatus);
                                      },
                                    ),
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
