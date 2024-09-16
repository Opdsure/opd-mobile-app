import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_label.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/opd_extension/string_extension.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_home_header.dart';
import '../custom_ui/app_mobile_field.dart';

class ReferralPage extends StatefulWidget{
  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBasePage(
      appHeader: const AppHomeHeader(
        title: AppTextView(
          text: 'Referral',
          size: 16.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      childContent: ListView(
        children: [
          AppLabel(label: 'Name', isCompulsory: true,),
          AppEditText(
            hint: 'Enter name',
            textEditingController: nameCtrl,
            textInputType: TextInputType.name,),
          const SizedBox(height: 15.0,),
          AppLabel(label: 'Mobile', isCompulsory: true,),
          AppMobileField(
            hint: 'Enter number',
            countryCode: '+91',
            textEditingController: mobileCtrl,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            // flagUri: flagCode.isEmpty?'${mFlagUri}in.png':'$mFlagUri$flagCode.png',
            countryCallback: () async {
              // Show the country code picker when tapped.
              // final picked =
              // await countryPicker.showPicker(context: context);
              // // Null check
              // if (picked != null){
              //   print(picked);
              //   typeController.countryCodeChange(picked.dialCode);
              //   typeController.flagCodeChange(picked.code.toLowerCase());
              // }
            },
          ),
          const SizedBox(height: 15.0,),
          AppLabel(label: 'Email',),
          AppEditText(
            hint: 'Enter email',
            textEditingController: emailCtrl,
            textInputType: TextInputType.emailAddress,),
          const SizedBox(height: 20.0,),
          AppButton(
            text: 'Submit',
            onClick: ()async{
              if(nameCtrl.text.isEmpty){
                CommonMethods.showToast('Please enter name');
              }
              else if(mobileCtrl.text.isEmpty || mobileCtrl.text.length<10){
                CommonMethods.showToast('Please enter valid mobile number');
              }
              // else if(emailCtrl.text.isEmpty || !emailCtrl.text.isValidEmail){
              //   CommonMethods.showToast('Please enter valid email address');
              // }
              else{
                CommonMethods.showAlertDialog(context);
                var response = await OpdSure.of(context).client.sendReferral(
                  name: nameCtrl.text,
                  mobile: '+91${mobileCtrl.text}',
                  email: emailCtrl.text.isEmpty?'abc@gmail.com':emailCtrl.text
                );
                print(response);
                Map<String,dynamic> mapData = jsonDecode(response);
                if(mapData['success']){
                  CommonMethods.showToast('Referral sent successfully');
                  nameCtrl.text = '';
                  mobileCtrl.text = '';
                  emailCtrl.text = '';
                }
                else{
                  CommonMethods.showToast('Something went wrong');
                }
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}