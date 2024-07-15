import 'package:flutter/material.dart';

import 'health_checkup_view.dart';


class HealthCheckup extends StatefulWidget {
  const HealthCheckup({super.key});

  @override
  State<HealthCheckup> createState() => HealthCheckupController();
}

class HealthCheckupController extends State<HealthCheckup> {
  @override
  Widget build(BuildContext context) => const HealthCheckupView();
}
