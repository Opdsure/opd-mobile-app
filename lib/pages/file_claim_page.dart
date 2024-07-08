import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/common_map/claim_type_model.dart';
import 'package:opdsure/model/file_type_size_model.dart';
import 'package:opdsure/utils/app_var.dart';
import '../custom_ui/app_bottom_sheet.dart';
import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_mobile_field.dart';
import '../custom_ui/app_text_view.dart';
import '../repository/network_api/api.dart';
import '../utils/app_colors.dart';
import '../utils/common_methods.dart';
import  'package:fl_country_code_picker/fl_country_code_picker.dart' as flc;

class FileClaimPage extends StatelessWidget{
  TextEditingController phoneCtrl = TextEditingController();
  final countryPicker = const FlCountryCodePicker();
  List<File> files = [];
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context,TypeController typeController) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      typeController.opdVisitDateChange(formattedDate);
    }
  }
  List<Claim> claimList = [Claim(id: '0', value: 'OPD'),Claim(id: '1', value: 'PHARMACY'),Claim(id: '2', value: 'LAB_TEST')];
  String getClaimName(String id){
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
  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'File a Claims',),
      childContent: ListView(
        children: [
          const AppTextView(
            text: 'Claim Type',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          InkWell(
            onTap: ()async{
              AppBottomSheet(
                  height: 300,
                  mChild: ListView.builder(
                    itemCount: claimList.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AppTextView(
                          onClick: (){
                            typeController.selectClaimChange(claimList[index].id);
                            Navigator.pop(context);
                          },
                          text: claimList[index].value,
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
                      text: typeController.selectClaim.value==''?'Select Claim':getClaimName(typeController.selectClaim.value),
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
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'User',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(
            hint: 'Select User',
            disableText: true,
            viewSuffix: true,
            suffixWidget: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Color(0xff667085),
              size: 24.0,
            ),
          ),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Doctor Name',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter the name'),
          const SizedBox(height: 15.0,),
          const AppTextView(
            text: 'OPD Visit Date',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          Obx((){
            String date = typeController.opdVisitDate.value;
            String showDate = '';
            if(date!=''){
              showDate = CommonMethods.changeDateFormat(date,from: 'yyyy-MM-dd',to: 'dd/MM/yyyy');
            }
            return AppEditText(
              hint: date.isEmpty?'Enter OPD Visit Date':showDate,
              disableText: true,
              viewSuffix: true,
              suffixWidget: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff667085),
                size: 24.0,
              ),
              eyeCallback: (){
                _selectDate(context, typeController);
              },
            );
          }),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Doc Reg. Number',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter doc Reg. Number'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Hospital Name',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter hospital Name'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Hospital Address',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter hospital Address'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Hospital Contact Info.',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          Obx((){
            String countryCode = typeController.countryCode.value;
            String flagCode = typeController.flagCode.value;
            return AppMobileField(
              hint: 'Enter number',
              countryCode: countryCode.isEmpty?'+91':countryCode,
              textEditingController: phoneCtrl,
              inputFormatters: [
                LengthLimitingTextInputFormatter(13),
              ],
              flagUri: flagCode.isEmpty?'${mFlagUri}in.png':'$mFlagUri$flagCode.png',
              countryCallback: () async {
                // Show the country code picker when tapped.
                final picked =
                await countryPicker.showPicker(context: context);
                // Null check
                if (picked != null){
                  print(picked);
                  typeController.countryCodeChange(picked.dialCode);
                  typeController.flagCodeChange(picked.code.toLowerCase());
                }
              },
            );
          }),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Diagnosis',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          const AppEditText(hint: 'Enter diagnosis'),
          const SizedBox(height: 15.0),
          const AppTextView(
            text: 'Upload Prescription',
            size: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D2939),
          ),
          FutureBuilder(
            future: Api().getAllState(),
            builder: (context,snapshot){
              if(snapshot.data == null){
                return Container();
              }
              else{
                print(snapshot.data);
                FileTypeSizeModel fileTypeSizeModel = fileTypeSizeModelFromJson(snapshot.data);
                List<TypeSizeList> typeSizeList = fileTypeSizeModel.data;
                String mFileTypes = typeSizeList[0].fileType;
                List<String> customSizeList = mFileTypes.split(',');
                return AppBorderBox(
                  mCallback: ()async{
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowMultiple: true,
                      allowedExtensions: customSizeList,
                    );
                    if (result != null) {
                      files = result.paths.map((path) => File(path!)).toList();
                      typeController.prescriptionListChange(files);
                      print(files);
                    } else {
                      print(result);
                    }
                  },
                  myChild: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Obx((){
                      List allFiles = typeController.prescriptionList.value;
                      return allFiles.isEmpty?Column(
                        children: [
                          Image.asset(
                            'assets/images/upload.png',
                            height: 40.0,
                            width: 40.0,
                          ),
                          const SizedBox(height: 15.0),
                          const AppTextView(
                            text: 'Click to upload',
                            size: 14.0,
                            fontWeight: FontWeight.w600,
                            color: buttonColor,
                          )
                        ],
                      ):
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: allFiles.length,
                        itemBuilder: (context,index){
                          String ext = allFiles[index].path.split('.')[3];
                          return ext=='pdf'?Image.asset(
                            'assets/images/pdf_file.png',
                            height: 45.0,
                            width: 45.0,
                          ):Image.file(
                            allFiles[index],
                            height: 45.0,
                            width: 45.0,
                            fit: BoxFit.fill,
                          );
                        },
                      );
                    }),
                  ),
                  height: 100.0,
                );
              }
            },
          ),
          const SizedBox(height: 20.0),
          const AppButton(text: 'Continue'),
          const SizedBox(height: 20.0),
        ],
      ),

    );
  }

}