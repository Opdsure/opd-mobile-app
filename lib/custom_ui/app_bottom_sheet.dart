import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBottomSheet{
  final double height;
  final Widget mChild;

  AppBottomSheet({
    required this.height,
    required this.mChild
  });

  void modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 20, // here increase or decrease in width
        ),
        builder: (builder){
          return Container(
            height: height,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F7),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
              child: mChild,
            ),
          );
        }
    );

  }

}