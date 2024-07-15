import 'package:flutter/material.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/pages/health_check_up/health_checkup_details/health_checkup_details_view.dart';

class HealthCheckupDetails extends StatefulWidget {
  final HealthCheckupRecords? records;
  const  HealthCheckupDetails({this.records, super.key});

  @override
  State<HealthCheckupDetails> createState() => HealthCheckupDetailsController();
}

class HealthCheckupDetailsController extends State<HealthCheckupDetails> {
  HealthCheckupRecords? records;

  @override
  void initState() {
    super.initState();
    records = widget.records;
  }

  @override
  Widget build(BuildContext context) => HealthCheckupDetailsView(this);
}
