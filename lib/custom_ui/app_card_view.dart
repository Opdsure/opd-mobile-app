import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCardView extends StatelessWidget{
  final Widget mChaild;

  AppCardView({
    required this.mChaild
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0F101828).withOpacity(0.05), // Adjust opacity if necessary
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: const Color(0x1A101828).withOpacity(0.05), // Adjust opacity if necessary
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: mChaild,
    );
  }

}