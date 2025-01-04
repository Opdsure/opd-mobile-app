import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_label.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/opd_extension/string_extension.dart';

import '../../config/app_config.dart';
import '../../custom_ui/app_border_box.dart';
import '../../custom_ui/app_bottom_sheet.dart';
import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_edit_text.dart';
import '../../custom_ui/app_mobile_field.dart';
import 'name_email_number_controller.dart';

enum InputType { firstName, middleName, lastName, emailOrPhone }

class NameEmailNumberView extends StatelessWidget {
  final NameEmailNumberController controller;

  NameEmailNumberView(this.controller, {super.key});

  List<String> genderList = ['Male',"Female","Other"];
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDOB(BuildContext context,TypeController typeController) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      typeController.familyMemDOBChange(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppConfig.primaryColorLight,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        leadingWidth: 0,
        leading: Container(),
        title: const AppTextView(
          text: 'Enter your details',
          fontWeight: FontWeight.bold,
          size: 18,
          color: Colors.black,
        ),
      ),
      body: StatefulBuilder(
          builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const Column(
                children: [
                  Center(
                    child: AppTextView(
                      text: 'Welcome to OPDSure',
                      color: Colors.black,
                      size: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Center(
                    child: AppTextView(
                      text: 'Enter details to complete your profile',
                      color: Color(0xff475467),
                      size: 16.0,
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                ],
              ),
              AppLabel(label: 'First Name',isCompulsory: true,),
              AppEditText(
                hint: 'Enter your first name',
                size: 14.0,
                textInputType: TextInputType.name,
                textEditingController: controller.firstNameTextController,
                errorMessage: controller.nameError,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")), ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppLabel(label: 'Middle Name',),
              AppEditText(
                hint: 'Enter your middle name',
                size: 14.0,
                textInputType: TextInputType.name,
                textEditingController: controller.middleNameTextController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")), ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppLabel(label: 'Last Name',),
              AppEditText(
                hint: 'Enter your last name',
                size: 14.0,
                textInputType: TextInputType.name,
                textEditingController: controller.lastNameControllerTextController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),],
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppLabel(label: 'Email',isCompulsory: true,),
              AppEditText(
                hint: 'Enter your email address',
                size: 14.0,
                textInputType: TextInputType.emailAddress,
                textEditingController: controller.emailTextController,
                errorMessage: controller.emailError,
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppButton(
                text: 'Next',
                onClick: () {
                  if (controller.firstNameTextController.text.isEmpty) {
                    setState((){
                      controller.nameError = 'First name is required';
                      CommonMethods.showToast('Enter first name');
                    });
                    return;
                  }
                  else if ((controller.emailTextController.text.isEmpty || !controller.emailTextController.text.isValidEmail)) {
                    setState((){
                      controller.emailError = 'Email address is empty';
                      CommonMethods.showToast('Please enter valid email address');
                    });
                    return;
                  }
                  // else if(typeController.familyMemDOB.value.isEmpty){
                  //   CommonMethods.showToast('Please choose DOB');
                  // }else if(typeController.selectGender.value.isEmpty){
                  //   CommonMethods.showToast('Please choose Gender');
                  // }else if(controller.addressTextController.text.isEmpty){
                  //   CommonMethods.showToast('Please enter address');
                  // }
                  else{
                    controller.updateProfile();
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
