import 'dart:io';

import 'package:dlibphonenumber/enums/phone_number_format.dart';
import 'package:dlibphonenumber/generated/classes/phone_number/phonenumber.pb.dart';
import 'package:dlibphonenumber/phone_number_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/widget/opd_widget.dart';
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

  static Future<bool> showExitDialog(BuildContext context, {String? message}) async {
    OpdSureState opd = OpdSure.of(context);
    if(opd.isExitDialogShowing) return false;
    opd.isExitDialogShowing = true;
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          onPopInvoked: (_){
            opd.isExitDialogShowing = false;
          },
          child: AlertDialog(
            title: const AppTextView(
              text: 'Exit Confirmation',
              size: 18.0,
              fontWeight: FontWeight.w600,
            ),
            content: AppTextView(text: message?? 'Do you really want to exit?'),
            actions: [
              MaterialButton(
                child: const AppTextView(text: 'Cancel'),
                onPressed: () {
                  opd.isExitDialogShowing = false;
                  Navigator.of(context).pop(false);
                },
              ),
              MaterialButton(
                child: const AppTextView(text: 'Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    ) ??
        false;
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
    Widget okButton = AppButton(
      onClick: mCallback,
      text: 'OK'
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

  static String formatIsoDateString(String isoString,{isTime = false, isAddTime = false}) {
    DateTime dateTime = DateTime.parse(isoString);
    if(isAddTime) {
      dateTime = dateTime.add(const Duration(hours: 5, minutes: 30));
    }
    String formattedDate = '';
    if(isTime){
      formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
    }
    else{
      formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    }
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

  static showLogoutAlertDialog(BuildContext context, String message, String heading,
      String buttonAcceptTitle, String buttonCancelTitle) {
    Widget cancelButton = MaterialButton(
      child: Text(buttonCancelTitle),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.pop(context);
      },
    );
    Widget continueButton = MaterialButton(
      child: Text(buttonAcceptTitle),
      onPressed: () async {
        await OpdSure.of(context).client.logout();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
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

  static FilePickerResult xFileToFilePickerResult(XFile xfile) {
    final platformFile = PlatformFile(
      name: 'File1',
      path: xfile.path,
      size: File(xfile.path).lengthSync(),
      bytes: File(xfile.path).readAsBytesSync(),
    );

    return FilePickerResult([platformFile]);
  }

}