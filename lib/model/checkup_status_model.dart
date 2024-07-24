import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckupStatusModel{
  final String? statusName;
  final Color? statusColor;
  final IconData? iconData;

  CheckupStatusModel({
    this.statusName,
    this.statusColor,
    this.iconData
  });

  CheckupStatusModel getCheckupByStatus(int status){
    switch(status){
      case 0:
        return CheckupStatusModel(
            statusName: 'Pending',
            statusColor: const Color(0xFFEF6C00),
            iconData: Icons.access_time_outlined
        );
      case 1:
        return CheckupStatusModel(
            statusName: 'Done',
            statusColor: Colors.green,
            iconData: Icons.check_circle_outline_rounded
        );
      case 2:
        return CheckupStatusModel(
            statusName: 'Cancelled',
            statusColor: Colors.red,
            iconData: Icons.cancel_outlined
        );
      default:
        return CheckupStatusModel();
    }
  }
}