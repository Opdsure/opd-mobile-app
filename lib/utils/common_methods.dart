import 'package:flutter/cupertino.dart';

class CommonMethods{

  static double deviceHeight(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .height;
  }
  static double deviceWidth(BuildContext context) {
    return MediaQuery
        .of(context)
        .size
        .width;
  }
}