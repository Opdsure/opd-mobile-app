// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:opdsure/custom_ui/app_base_page.dart';
// import 'package:opdsure/custom_ui/app_card_view.dart';
// import 'package:opdsure/custom_ui/app_home_header.dart';
// import 'package:opdsure/custom_ui/app_text_view.dart';
// import 'package:opdsure/model/health_checkup/health_checkup.dart';
// import 'package:opdsure/utils/app_colors.dart';
// import 'package:opdsure/utils/common_methods.dart';
//
// import '../../../utils/app_var.dart';
// import '../health_checkup_details/health_checkup_details_controller.dart';
// import 'health_checkup_controller.dart';
//
// class HealthCheckupView extends StatelessWidget {
//   HealthCheckupController controller;
//
//   HealthCheckupView(this.controller, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBasePage(
//       appHeader: AppHomeHeader(
//         titleUi: const AppTextView(
//             text: 'Health Checkup',
//             size: 22.0,
//             fontWeight: FontWeight.w600,
//             color: Colors.black),
//       ),
//       childContent: controller.healthCheckupResponse == null
//           ? Container()
//           : ListView.builder(
//           itemCount: controller.healthCheckupResponse!.data!.records!.length,
//           itemBuilder: (context, index) {
//             HealthCheckupRecords healthCheckupRecords = controller.healthCheckupResponse!.data!.records![index];
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               child: AppCardView(
//                 mChaild: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppTextView(
//                       text: 'Checkup Code : ${healthCheckupRecords.checkupCode}',
//                       color: buttonColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     AppTextView(
//                       text: healthCheckupRecords.name!,
//                       color: Colors.black,
//                       size: 12,
//                     ),
//                     AppTextView(
//                       text: 'Base Price : $rupeeSymbol ${healthCheckupRecords.basePrice}',
//                       color: buttonColor,
//                       size: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     AppTextView(
//                       text: 'Discount Price : ${healthCheckupRecords.discountedPrice}',
//                       color: buttonColor,
//                       size: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
