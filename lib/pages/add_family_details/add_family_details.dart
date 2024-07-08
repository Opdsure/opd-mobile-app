import 'dart:convert';
import 'dart:ui';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_bottom_sheet.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_edit_text.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/relation_model.dart';
import 'package:opdsure/model/state_model.dart';
import 'package:opdsure/repository/network_api/api.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../custom_ui/app_mobile_field.dart';

class AddFamilyDetails extends StatefulWidget{
  @override
  State<AddFamilyDetails> createState() => _AddFamilyDetailsState();
}

class _AddFamilyDetailsState extends State<AddFamilyDetails> {
  final countryPicker = const FlCountryCodePicker();

  List<String> genderList = ['Male',"Female","Other"];

  TextEditingController nameCtrl = TextEditingController();

  TextEditingController phoneCtrl = TextEditingController();

  TextEditingController cityCtrl = TextEditingController();

  TextEditingController pinCodeCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDOB(BuildContext context,TypeController typeController) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      typeController.familyMemDOBChange(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Add Details',
        showRightView: true,
        rightView: const AppTextView(
          text: 'Skip',
          color: Color(0xFF475467),
          size: 16.0,
        ),
      ),
      childContent: ListView(
        children: [
          const AppTextView(
            text: 'Fill Your Details',
            size: 18.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF101828),
          ),
          const SizedBox(height: 16.0,),
          const AppTextView(
            text: 'Name',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          AppEditText(
            hint: 'Enter the name',
            textEditingController: nameCtrl,
          ),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'Relation',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          InkWell(
            onTap: ()async{
              var data = await OpdSure.of(context).client.getRelation();
              RelationModel relationModel = relationModelFromJson(data);
              List<Map<String,dynamic>> keys = [];
              for (var entry in relationModel.data.toJson().entries) {
                Map<String,dynamic> mMap = {
                  'key':entry.key,
                  'value':entry.value
                };
                keys.add(mMap);
              }
              AppBottomSheet(
                  height: 600,
                  mChild: ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AppTextView(
                          onClick: (){
                            typeController.selectRelationChange(keys[index]['key']);
                            typeController.selectRelationKeyChange('${keys[index]['value']}');
                            Navigator.pop(context);
                          },
                          text: keys[index]['key'],
                        ),
                      );
                    },
                  )
              ).modalBottomSheetMenu(context);
            },
            child: AppBorderBox(
              myChild: Obx((){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: typeController.selectRelation.value==''?'Select Relation':typeController.selectRelation.value,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Color(0xff667085),
                      size: 24.0,
                    )
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'DOB',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          Obx((){
            String dob = typeController.familyMemDOB.value;
            String showDate = '';
            if(dob!=''){
              showDate = CommonMethods.changeDateFormat(dob,from: 'yyyy-MM-dd',to: 'dd/MM/yyyy');
            }
            return AppEditText(
              hint: dob==''?'Enter date of birth':showDate,
              disableText: true,
              viewSuffix: true,
              suffixWidget: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff667085),
                size: 24.0,
              ),
              eyeCallback: (){
                _selectDOB(context, typeController);
              },

            );
          }),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'Gender',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          InkWell(
            onTap: ()async{
              AppBottomSheet(
                  height: 300,
                  mChild: ListView.builder(
                    itemCount: genderList.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AppTextView(
                          onClick: (){
                            typeController.selectGenderChange(genderList[index]);
                            Navigator.pop(context);
                          },
                          text: genderList[index],
                        ),
                      );
                    },
                  )
              ).modalBottomSheetMenu(context);
            },
            child: AppBorderBox(
              myChild: Obx((){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: typeController.selectGender.value==''?'Select Gender':typeController.selectGender.value,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Color(0xff667085),
                      size: 24.0,
                    )
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'Phone Number',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          AppMobileField(
            hint: 'Enter your mobile number',
            countryCode: '+91',
            textEditingController: phoneCtrl,
            countryCallback: ()async{
              // Show the country code picker when tapped.
              final picked= await countryPicker.showPicker(context: context);
              // Null check
              if (picked!= null) print(picked);
            },
          ),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'State',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          InkWell(
            onTap: ()async{
              var data = await Api().getAllState();
              StateModel stateModel = statemodelFromJson(data);
              List<StateListData> stateListData = stateModel.data;
              AppBottomSheet(
                  height: 600,
                  mChild: ListView.builder(
                    itemCount: stateListData.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AppTextView(
                          onClick: (){
                            typeController.selectStateChange(stateListData[index].name);
                            Navigator.pop(context);
                          },
                          text: stateListData[index].name,
                        ),
                      );
                    },
                  )
              ).modalBottomSheetMenu(context);
            },
            child: AppBorderBox(
              myChild: Obx((){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextView(
                      text: typeController.selectState.value==''?'Select State':typeController.selectState.value,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Color(0xff667085),
                      size: 24.0,
                    )
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'City',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          AppEditText(
            hint: 'Enter the city',
            textEditingController: cityCtrl,
          ),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'Pin code',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          AppEditText(
            hint: 'Enter the pin code',
            textEditingController: pinCodeCtrl,
          ),
          const SizedBox(height: 20.0,),
          AppButton(
            text: 'Save',
            onClick: ()async{
              CommonMethods.showAlertDialog(context);
              var data = await OpdSure.of(context).client.addFamilyMember(
                  name: nameCtrl.text,
                  relation: typeController.selectRelationKey.value,
                  dob: typeController.familyMemDOB.value,
                  gender: CommonMethods.genderKey(typeController.selectGender.value),
                  phone: phoneCtrl.text,
                  countryCode: '+91',
                  address: '${cityCtrl.text} ${pinCodeCtrl.text}'
              );
              Navigator.of(context,rootNavigator: true).pop();
              print(data);
              Map<String,dynamic> resMap = jsonDecode(data);
              if(resMap['success']){
                CommonMethods.showToast('Member Added successfully');
              }
            },
          ),
          const SizedBox(height: 15.0,),
          AppButton(
            text: 'Add Another Member',
            color: Color(0xFFebecf1),
            textColor: buttonColor,
            borderColor: buttonColor,
            onClick: (){
              Navigator.of(context,rootNavigator: true).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFamilyDetails()));
            },
          )
        ],
      ),
    );
  }
}