import 'package:dlibphonenumber/enums/phone_number_format.dart';
import 'package:dlibphonenumber/generated/classes/phone_number/phonenumber.pb.dart';
import 'package:dlibphonenumber/phone_number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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

  static void showToast(String toastMessage){
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.50),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static String convertToE164(String phoneNumber, String countryCode) {
    final PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;
    final PhoneNumber mPhoneNumber = phoneUtil.parse(phoneNumber, countryCode);
    return phoneUtil.format(mPhoneNumber, PhoneNumberFormat.international);
  }

  static String changeDateFormat(String dateStr,{from = 'dd/MM/yyyy',to = 'yyyy-MM-dd'}){
    if(dateStr == '') return "";
    DateTime tempDate = DateFormat(from).parse(dateStr);
    return DateFormat(to).format(tempDate);
  }
}