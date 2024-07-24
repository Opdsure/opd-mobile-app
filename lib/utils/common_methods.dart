import 'package:dlibphonenumber/enums/phone_number_format.dart';
import 'package:dlibphonenumber/generated/classes/phone_number/phonenumber.pb.dart';
import 'package:dlibphonenumber/phone_number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static String getGenderByKey(int gender){
    switch(gender){
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      case 3:
        return 'Other';
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
      useRootNavigator: false,
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
        return 'LAB TEST';
      default:
        return 'OPD';
    }
  }

  static showOneButtonDialog(BuildContext context,String message,VoidCallback mCallback) {

    // set up the button
    Widget okButton = TextButton(
      onPressed: mCallback,
      child: const AppTextView(text: 'OK',),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: const Center(child: AppTextView(text: "Success!")),
      content: AppTextView(text: message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
        return 'IN PROCESS';
      case '6':
        return 'CLARIFICATION';
      case '7':
        return 'INVALID';
      default:
        return '';
    }
  }

  static String getCheckupStatus(String id){
    switch(id){
      case '0':
        return 'PENDING';
      case '1':
        return 'DONE';
      case '2':
        return 'CANCELLED';
      default:
        return '';
    }
  }

  static setStringPref(String key, String value)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    mPref.setString(key, value);
  }

  static setBoolPref(String key, bool value)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    mPref.setBool(key, value);
  }

  static Future<String> getStringPref(String key)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String data = mPref.getString(key) ?? '';
    return data;
  }

  static Future<bool> getBoolPref(String key)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    bool? data = mPref.getBool(key);
    return data ?? false;
  }

  static String formatIsoDateString(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  static int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

}