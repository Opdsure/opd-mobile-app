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


  static String getPlanFrequency(int frequency,{bool isBilled = true}) {
    switch (frequency) {
      case 1:
        return '${isBilled ? "Billed " : ""}yearly';
      case 2:
        return '${isBilled ? "Billed " : ""}Billed half yearly';
      case 3:
        return '${isBilled ? "Billed " : ""}Billed quarterly';
      case 4:
        return '${isBilled ? "Billed " : ""}Billed monthly';
      default:
        return '';
    }
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

  static String genderKey(String gender){
    switch(gender){
      case 'Male':
        return '1';
      case 'Female':
        return '2';
      case 'Other':
        return '3';
      default:
        return '';
    }
  }

  static void showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  static String getClaimNameById(String id){
    switch(id){
      case '0':
        return 'OPD';
      case '1':
        return 'PHARMACY';
      case '2':
        return 'LAB_TEST';
      default:
        return 'OPD';
    }
  }

  static String getClaimStatus(String id){
    switch(id){
      case '0':
        return 'PENDING';
      case '1':
        return 'APPROVED';
      case '2':
        return 'REJECTED';
      case '3':
        return 'DUPLICATE';
      case '4':
        return 'IN_PROCESS';
      case '6':
        return 'CLARIFICATION';
      case '7':
        return 'INVALID';
      default:
        return '';
    }
  }

}