import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBorderBox extends StatelessWidget{

  final Widget myChild;
  final Color borderColor;
  final Color boxColor;
  final double height;
  final VoidCallback? mCallback;

  const AppBorderBox({
    required this.myChild,
    this.borderColor = const Color(0xFFEAECF0),
    this.boxColor = const Color(0x0D101828),
    this.height = 50.0,
    this.mCallback
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: mCallback,
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: boxColor, // spotColor and ambientColor combined
              blurRadius: 2,
              offset: const Offset(0, 2), // assuming the shadow elevation is 2.dp
            ),
          ],
        ),
        child: myChild,
      ),
    );
  }

}