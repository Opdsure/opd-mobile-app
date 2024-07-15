import 'package:flutter/material.dart';
import 'package:opdsure/pages/health_check_up/health_checkup_details/health_checkup_details_view.dart';

class HealthCheckupDetails extends StatefulWidget {
  const HealthCheckupDetails({super.key});

  @override
  State<HealthCheckupDetails> createState() => HealthCheckupDetailsController();
}

class HealthCheckupDetailsController extends State<HealthCheckupDetails> {
  @override
  Widget build(BuildContext context) => HealthCheckupDetailsView(this);
}
