import 'package:flutter/material.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/widget/opd_widget.dart';

import 'health_checkup_view.dart';

class HealthCheckup extends StatefulWidget {
  const HealthCheckup({super.key});

  @override
  State<HealthCheckup> createState() => HealthCheckupController();
}

class HealthCheckupController extends State<HealthCheckup> {
  HealthCheckupResponse? healthCheckupResponse;

  @override
  void initState() {
    super.initState();
    _getHealthCheckup();
  }

  _getHealthCheckup() async {
    final response = await OpdSure.of(context).client.getHealthCheckupPlan();
    setState(() {
      healthCheckupResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) => HealthCheckupView(this);
}
