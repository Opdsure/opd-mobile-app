import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../health_checkup_details/health_checkup_details_controller.dart';
import 'health_checkup_controller.dart';

class HealthCheckupView extends StatelessWidget {
  HealthCheckupController controller;

  HealthCheckupView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHomeHeader(
        titleUi: const AppTextView(
            text: 'Health Checkup',
            size: 22.0,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      ),
      childContent: controller.healthCheckupResponse == null
          ? Container()
          : ListView.builder(
              itemCount:
                  controller.healthCheckupResponse!.data!.records!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    type: MaterialType.card,
                    child: InkWell(
                      onTap: () {
                        context.push('/home/health_checkup_details', extra: controller.healthCheckupResponse!
                            .data!.records![index]);

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextView(
                              text: controller.healthCheckupResponse!.data!
                                  .records![index].name!),
                          AppTextView(
                              text: controller.healthCheckupResponse!.data!
                                  .records![index].basePrice!
                                  .toString()),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
