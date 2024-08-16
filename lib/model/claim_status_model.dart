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

  ClaimStatusModel getClaimBuStatus(int status,{bool reSubmit = false}){
    switch(status){
      case 0:
        return ClaimStatusModel(
          statusName: 'Pending',
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
            statusColor: Colors.blue,
            iconData: Icons.sync_sharp
        );
      case 6:
        if(reSubmit){
          return ClaimStatusModel(
              statusName: 'Re-Submitted',
              statusColor: Colors.green,
              iconData: Icons.check_circle_outline_rounded
          );
        }
        else{
          return ClaimStatusModel(
              statusName: 'Clarification Required',
              statusColor: const Color(0xFFfaad14),
              iconData: Icons.info_outline
          );
        }
      case 7:
        return ClaimStatusModel(
            statusName: 'Invalid',
            statusColor: Colors.red,
            iconData: Icons.error_outline
        );
      case 12:
        return ClaimStatusModel(
            statusName: 'Settled',
            statusColor: Colors.green,
            iconData: Icons.check_circle_outline_rounded
        );
      default:
        return ClaimStatusModel(
            statusName: '',
            statusColor: Colors.red,
            iconData: Icons.error_outline
        );
    }
  }
  ClaimStatusModel getDisputeClaimBuStatus(int status){
    switch(status){
      case 1:
        return ClaimStatusModel(
            statusName: 'Dispute Raised',
            statusColor: const Color(0xFFEF6C00),
            iconData: Icons.access_time_outlined
        );
      case 2:
        return ClaimStatusModel(
            statusName: 'Dispute In Process',
            statusColor: Colors.blue,
            iconData: Icons.sync_sharp
        );
      case 3:
        return ClaimStatusModel(
            statusName: 'Approved',
            statusColor: Colors.green,
            iconData: Icons.check_circle_outline_rounded
        );
      case 4:
        return ClaimStatusModel(
            statusName: 'Rejected',
            statusColor: Colors.red,
            iconData: Icons.cancel_outlined
        );
      case 12:
        return ClaimStatusModel(
            statusName: 'Settled',
            statusColor: Colors.green,
            iconData: Icons.check_circle_outline_rounded
        );
      default:
        return ClaimStatusModel(
            statusName: '',
            statusColor: Colors.red,
            iconData: Icons.error_outline
        );
    }
  }
  ClaimStatusModel getProfileStatus(int status){
    switch(status){
      case 0:
        return ClaimStatusModel(
            statusName: 'Pending For Approval',
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
      default:
        return ClaimStatusModel(
            statusName: '',
            statusColor: Colors.red,
            iconData: Icons.error_outline
        );
    }
  }
}