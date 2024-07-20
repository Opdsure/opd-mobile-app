import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';

import '../custom_ui/app_border_box.dart';
import '../custom_ui/app_bottom_sheet.dart';
import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_key_value.dart';
import '../custom_ui/app_text_view.dart';
import '../model/user_profile/user_profile.dart';
import '../utils/common_methods.dart';
import '../widget/opd_widget.dart';

class UpdateProfilePage extends StatefulWidget{
  final UserProfile? userProfile;
  UpdateProfilePage(this.userProfile);
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  List<String> genderList = ['Male',"Female","Other"];

  TextEditingController addressCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController pinCtrl = TextEditingController();

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
      typeController.myDOBChange(formattedDate);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TypeController typeController = Get.put(TypeController());
    addressCtrl.text = widget.userProfile!.data!.address!;
    pinCtrl.text = '${widget.userProfile!.data!.pinCode!}';
    cityCtrl.text = widget.userProfile!.data!.city!;
    typeController.myDOB(widget.userProfile!.data!.dob!);
    if(widget.userProfile!.data!.gender! == 0){
      typeController.selectGenderChange('');
    }
    else{
      typeController.selectGenderChange(genderList[widget.userProfile!.data!.gender!-1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Update Profile',),
      childContent: ListView(
        children: [
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
          const SizedBox(height: 15.0,),const AppTextView(
            text: 'Pin Code',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          AppEditText(
            hint: 'Enter the address',
            textEditingController: pinCtrl,
            maxLength: 6,
            textInputType: TextInputType.number,
          ),
          const SizedBox(height: 15.0,),

          const AppTextView(
            text: 'DOB',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          Obx((){
            String dob = typeController.myDOB.value;
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
          const SizedBox(height: 20.0,),
          AppButton(
            text: 'Update',
            onClick: () async {
              CommonMethods.showAlertDialog(context);
              if(addressCtrl.text.isEmpty){
                CommonMethods.showToast('Enter Address');
                Navigator.of(context).pop();
                return;
              }
              if(cityCtrl.text.isEmpty){
                CommonMethods.showToast('Enter city');
                Navigator.of(context).pop();
                return;
              }
              if(pinCtrl.text.isEmpty){
                CommonMethods.showToast('Enter pin code');
                Navigator.of(context).pop();
                return;
              }
              var data = await OpdSure.of(context).client.updateUserProfile(
                dob: typeController.myDOB.value,
                gender: CommonMethods.genderKey(typeController.selectGender.value),
                address: addressCtrl.text,
                pinCode: pinCtrl.text,
                city: cityCtrl.text
              );
              Navigator.of(context).pop();
              if(data!.success!){
                FocusScope.of(context).unfocus();
                typeController.refreshMemberListChange(false);
                typeController.refreshMemberListChange(true);
                CommonMethods.showToast('Profile update successfully');
              }
            },
          ),
        ],
      ),
    );
  }
}