import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppGradient extends StatelessWidget{
  final Widget mChild;
  final List<Color>? colorList;

  AppGradient({
    required this.mChild,
    this.colorList
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const [
            0.1,
            0.4,
            0.6,
            0.9,
          ],
          colors: colorList!
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