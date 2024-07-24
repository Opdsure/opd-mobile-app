import 'dart:convert';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_bottom_sheet.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_edit_text.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/relation/relations.dart';
import 'package:opdsure/model/state_model.dart';
import 'package:opdsure/repository/network_api/api.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/opd_extension/int_extention.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../custom_ui/app_mobile_field.dart';
import '../../model/my_member_model.dart';

class AddFamilyDetails extends StatefulWidget{
  final MemberList? member;
  final bool? isUpdate;
  final bool? isFirstMember;
  AddFamilyDetails({this.member,this.isUpdate,this.isFirstMember});

  @override
  State<AddFamilyDetails> createState() => _AddFamilyDetailsState();
}

class _AddFamilyDetailsState extends State<AddFamilyDetails> {
  final countryPicker = const FlCountryCodePicker();

  List<String> genderList = ['Male',"Female","Other"];

  TextEditingController nameCtrl = TextEditingController();

  TextEditingController phoneCtrl = TextEditingController();

  TextEditingController addressCtrl = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    TypeController typeController = Get.put(TypeController());
    OpdSure.of(context).client.getProfile().then((value){
      print(value);
      if(widget.isFirstMember!){
        nameCtrl.text = value.data!.name!;
        phoneCtrl.text = value.data!.phone!;
        typeController.selectRelationKeyChange(0);
      }
    });
    if(widget.isUpdate!){
      nameCtrl.text = widget.member!.name!;
      phoneCtrl.text = '${widget.member!.phone!}';
      addressCtrl.text = widget.member!.address!;
      typeController.familyMemDOBChange(widget.member!.dob!);
      typeController.selectRelationKeyChange(widget.member!.relation!);
      typeController.selectRelationChange(widget.member!.relation!.getRelation());
      typeController.selectGenderChange(genderList[widget.member!.gender!-1]);
    }

  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Add Details',
        showRightView: true,
        rightView: AppTextView(
          text: 'Done',
          color: const Color(0xFF475467),
          size: 16.0,
          onClick: (){
            context.pop();
          },
        ),
      ),
      childContent: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ListView(
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
                Relations? data = await OpdSure.of(context).client.getRelation();
                AppBottomSheet(
                    height: 600,
                    mChild: ListView.builder(
                      itemCount: data!.relationsData.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            typeController.selectRelationChange(data.relationsData[index].name);
                            typeController.selectRelationKeyChange(data.relationsData[index].value);
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: AppTextView(
                                  text: data.relationsData[index].name,
                                ),
                              ),
                              const Divider(height: 1,color: Color(0x1A101828),),
                            ],
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
              return Stack(
                children: [
                  AppEditText(
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

                  ),
                  InkWell(
                    onTap: (){
                      _selectDOB(context, typeController);
                    },
                    child: const SizedBox(
                      height: 40,
                      width: 400,
                    ),
                  )
                ],
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
                    height: 200,
                    mChild: ListView.builder(
                      itemCount: genderList.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            typeController.selectGenderChange(genderList[index]);
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: AppTextView(
                                  text: genderList[index],
                                ),
                              ),
                              const Divider(height: 1,color: Color(0x1A101828),),
                            ],
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
              maxLength: 13,
              countryCallback: ()async{
                // Show the country code picker when tapped.
                final picked= await countryPicker.showPicker(context: context);
                // Null check
                if (picked!= null) print(picked);
              },
            ),
            const SizedBox(height: 15.0,),
            const AppTextView(
              text: 'Address',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            AppEditText(
              hint: 'Enter the address',
              textEditingController: addressCtrl,
            ),
            const SizedBox(height: 20.0,),
            AppButton(
              text: 'Save',
              onClick: ()async{
                CommonMethods.showAlertDialog(context);
                if(nameCtrl.text.isEmpty){
                  CommonMethods.showToast('Name is blank');
                  Navigator.of(context).pop();
                  return;
                }
                if(typeController.selectRelationKey.value == 100){
                  CommonMethods.showToast('Relation is blank');
                  Navigator.of(context).pop();
                  return;
                }
                if(typeController.selectGender.value.isEmpty){
                  CommonMethods.showToast('Gender is blank');
                  Navigator.of(context).pop();
                  return;
                }
                if(phoneCtrl.text.isEmpty){
                  CommonMethods.showToast('Phone is blank');
                  Navigator.of(context).pop();
                  return;
                }
                if(typeController.familyMemDOB.value.isEmpty){
                  CommonMethods.showToast('Date of birth is blank');
                  Navigator.of(context).pop();
                  return;
                }

                if(addressCtrl.text.isEmpty){
                  CommonMethods.showToast('Address is blank');
                  Navigator.of(context).pop();
                  return;
                }
                var data;
                if(widget.isUpdate!){
                  data = await OpdSure.of(context).client.updateFamilyMember(
                      name: nameCtrl.text,
                      relation: typeController.selectRelationKey.value,
                      dob: typeController.familyMemDOB.value,
                      gender: CommonMethods.genderKey(typeController.selectGender.value),
                      phone: phoneCtrl.text,
                      countryCode: '+91',
                      address: addressCtrl.text,
                      memberId: widget.member!.id!,
                      file: 'user/1c0f78e5-e2cc-4b7e-8d16-939abf9c4003/Capture.PNG',
                  );
                }
                else{
                  data = await OpdSure.of(context).client.addFamilyMember(
                      name: nameCtrl.text,
                      relation: typeController.selectRelationKey.value,
                      dob: typeController.familyMemDOB.value,
                      gender: CommonMethods.genderKey(typeController.selectGender.value),
                      phone: phoneCtrl.text,
                      countryCode: '+91',
                      address: addressCtrl.text
                  );
                }
                Navigator.of(context).pop();
                print(data);
                Map<String,dynamic> resMap = jsonDecode(data);
                if(resMap['success']){
                  FocusScope.of(context).unfocus();
                  typeController.refreshMemberListChange(false);
                  typeController.refreshMemberListChange(true);
                  CommonMethods.showToast(widget.isUpdate!?'Member update successfully':'Member Added successfully');
                  nameCtrl.text = '';
                  phoneCtrl.text = '';
                  addressCtrl.text = '';
                  typeController.familyMemDOBChange('');
                  typeController.selectStateChange('');
                  typeController.selectGenderChange('');
                  typeController.selectRelationChange('');
                  typeController.selectRelationKeyChange(100);
                }
              },
            ),
            const SizedBox(height: 15.0,),
            const SizedBox(height: 50.0,),
          ],
        ),
      ),
    );
  }
}