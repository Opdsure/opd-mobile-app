import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';

import 'health_checkup_details_controller.dart';

class HealthCheckupDetailsView extends StatelessWidget {
  final HealthCheckupDetailsController controller;

  const HealthCheckupDetailsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
        childContent: Column(
      children: [],
    ));
  }
}
