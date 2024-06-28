import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppGradient extends StatelessWidget{
  final Widget mChild;
  // final List<Color> colorList;

  AppGradient({
    required this.mChild,
    // this.colorList =
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [
            0.1,
            0.4,
            0.6,
            0.9,
          ],
          colors: [
            Color(0xFFfbf2f9),
            Color(0xFFeaddf2),
            Color(0xFFe1def4),
            Color(0xFFcddbf5),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: mChild,
    );
  }

}