import 'dart:ui';

import 'package:flutter/material.dart';

class RenewPlanStatus{
  final String? statusName;
  final Color? statusColor;
  final IconData? iconData;

  RenewPlanStatus({
    this.statusName,
    this.statusColor,
    this.iconData
  });

  RenewPlanStatus getRenewPlan(bool value){
   if(!value){
     return RenewPlanStatus(
         statusName: 'In Queued',
         statusColor: const Color(0xFFEF6C00),
         iconData: Icons.access_time_outlined
     );
   }else{
     return RenewPlanStatus(
         statusName: 'Active',
         statusColor: Colors.green,
         iconData: Icons.check_circle_outline_rounded
     );
   }
  }
}