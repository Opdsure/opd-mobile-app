import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/widget/opd_widget.dart';

class HealthCheckupView extends StatelessWidget {
  const HealthCheckupView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      childContent: FutureBuilder<HealthCheckup?>(
          future: OpdSure.of(context).client.getHealthCheckupPlan(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: 10,
                itemBuilder: (context, index) {
              return ListTile(
                title: AppTextView(text: 'Testn Name'),
                subtitle: AppTextView(text: ' test price'),
              );
            });
          }),
    );
  }
}
