import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../../custom_ui/app_header.dart';
import '../../../custom_ui/app_text_view.dart';
import 'health_checkup_details_controller.dart';

class HealthCheckupDetailsView extends StatelessWidget {
  final HealthCheckupDetailsController controller;
  final Color textColor = buttonColor;

  const HealthCheckupDetailsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Health CheckUp',
      ),
      childContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Container(
                width: CommonMethods.deviceWidth(context) * 0.65,
                child: AppTextView(
                  text: controller.records!.name!,
                  color: textColor,
                  size: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          buttonColor.withOpacity(0.25),
                          Colors.white.withOpacity(0.25)
                        ])),
                child: AppTextView(
                  text: "${controller.records!.parameters!.toString()}\nTests",
                  size: 18,
                  fontWeight: FontWeight.bold,
                  color: buttonColor,
                  mTextAlign: TextAlign.center,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          AppTextView(
            text: 'Test Included',
            size: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: CommonMethods.deviceHeight(context) * 0.65,
            child: ListView.builder(
                itemCount: controller.records!.testDetails!.length,
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.verified,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 8,),
                          SizedBox(
                            width: CommonMethods.deviceWidth(context) * 0.8,
                            child: AppTextView(
                              text: controller
                                  .records!.testDetails![index].subParameter!,
                              size: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      if (controller.records!.testDetails![index].testsName!
                          .isNotEmpty) ...[
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8,),
                            SizedBox(
                              width: CommonMethods.deviceWidth(context) * 0.8,
                              child: AppTextView(
                                  color: Colors.black,
                                  text: controller
                                      .records!.testDetails![index].testsName!),
                            ),
                          ],
                        )
                      ],
                    ],
                  );
                  // return ListTile(
                  //   tileColor: Colors.grey,
                  //   leading: Icon(
                  //     Icons.verified,
                  //     color: textColor,
                  //   ),
                  //   title: AppTextView(
                  //     color: Colors.black,
                  //     text:
                  //     controller.records!.testDetails![index].subParameter!,
                  //     size: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   subtitle: controller.records!.testDetails![index].testsName!
                  //       .isEmpty ? null : AppTextView(
                  //       color: Colors.black,
                  //       text:
                  //       controller.records!.testDetails![index].testsName!),
                  // );
                }),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      bottomContent: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
        width: CommonMethods.deviceWidth(context),
        height: AppBar().preferredSize.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppTextView(
                  text:
                      "$rupeeSymbol ${controller.records!.discountedPrice.toString()}",
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  width: 5,
                ),
                AppTextView(
                  text:
                      "$rupeeSymbol ${controller.records!.basePrice.toString()}",
                  fontStyle: FontStyle.italic,
                  isLineThrough: true,
                ),
              ],
            ),
            AppButton(
              text: 'Buy Now',
              width: 120,
              height: 60,
              onClick: (){
                context.push('/home/health_checkup_checkout', extra: controller.records!);
              },
            )
          ],
        ),
      ),
    );
  }
}
