import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClaimStatusModel{
  final String? statusName;
  final Color? statusColor;
  final IconData? iconData;

  ClaimStatusModel({
    this.statusName,
    this.statusColor,
    this.iconData
  });

  ClaimStatusModel getClaimBuStatus(int status){
    switch(status){
      case 0:
        return ClaimStatusModel(
          statusName: 'Processing',
          statusColor: const Color(0xFFEF6C00),
          iconData: Icons.access_time_outlined
        );
      case 1:
        return ClaimStatusModel(
            statusName: 'Approved',
            statusColor: Colors.green,
            iconData: Icons.check_circle_outline_rounded
        );
      case 2:
        return ClaimStatusModel(
            statusName: 'Rejected',
            statusColor: Colors.red,
            iconData: Icons.cancel_outlined
        );
      case 3:
        return ClaimStatusModel(
            statusName: 'Duplicate',
            statusColor: const Color(0xFFEF6C00),
            iconData: Icons.copy
        );
      case 4:
        return ClaimStatusModel(
            statusName: 'In Process',
            statusColor: const Color(0xFFEF6C00),
            iconData: Icons.hourglass_empty
        );
      case 6:
        return ClaimStatusModel(
            statusName: 'Clarification',
            statusColor: const Color(0xFFfaad14),
            iconData: Icons.info_outline
        );
      case 7:
        return ClaimStatusModel(
            statusName: 'Invalid',
            statusColor: Colors.red,
            iconData: Icons.error_outline
        );
      default:
        return ClaimStatusModel();
    }
  }
}