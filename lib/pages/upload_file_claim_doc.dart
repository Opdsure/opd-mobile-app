import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../custom_ui/app_border_box.dart';
import '../custom_ui/app_button.dart';
import '../custom_ui/app_text_view.dart';
import '../model/claim_json_model.dart';
import '../model/file_type_size_model.dart';
import '../utils/app_colors.dart';
import '../widget/opd_widget.dart';

class UploadFileClaimDoc extends StatelessWidget{
  final ClaimJsonModel? claimJsonModel;
  UploadFileClaimDoc(this.claimJsonModel);

  List<File> files = [];
  Map<String,dynamic> filesUrl = {};
  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Upload Documents',
      ),
      childContent: ListView(
        children: [
          const SizedBox(height: 15.0),
          FutureBuilder(
            future: OpdSure.of(context).client.getFileTypeAndSize(),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTextView(
                      text: 'Upload Prescription',
                      size: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D2939),
                    ),
                    AppBorderBox(
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
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          filesUrl['prescription'] = response?.data;
                          print(response);
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
                    ),

                    const SizedBox(height: 15.0),
                    const AppTextView(
                      text: 'Doctor Fees Receipts',
                      size: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D2939),
                    ),
                    AppBorderBox(
                      mCallback: ()async{
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: true,
                          allowedExtensions: customSizeList,
                        );
                        if (result != null) {
                          files = result.paths.map((path) => File(path!)).toList();
                          typeController.docFeeRcptChange(files);
                          print(files);
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          filesUrl['doc_receipt'] = response?.data;
                          print(response);
                        } else {
                          print(result);
                        }
                      },
                      myChild: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Obx((){
                          List allFiles = typeController.docFeeRcpt.value;
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
                    ),

                    const SizedBox(height: 15.0),
                    const AppTextView(
                      text: 'Pharmacy Receipt',
                      size: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D2939),
                    ),
                    AppBorderBox(
                      mCallback: ()async{
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: true,
                          allowedExtensions: customSizeList,
                        );
                        if (result != null) {
                          files = result.paths.map((path) => File(path!)).toList();
                          typeController.pharmacyRcptChange(files);
                          print(files);
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          filesUrl['pharmacy_receipt'] = response?.data;
                          print(response);
                        } else {
                          print(result);
                        }
                      },
                      myChild: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Obx((){
                          List allFiles = typeController.pharmacyRcpt.value;
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
                    ),

                    const SizedBox(height: 15.0),
                    const AppTextView(
                      text: 'Lab Test Receipt',
                      size: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D2939),
                    ),
                    AppBorderBox(
                      mCallback: ()async{
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: true,
                          allowedExtensions: customSizeList,
                        );
                        if (result != null) {
                          files = result.paths.map((path) => File(path!)).toList();
                          typeController.labTestRcptChange(files);
                          print(files);
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          filesUrl['test_receipt'] = response?.data;
                          print(response);
                        } else {
                          print(result);
                        }
                      },
                      myChild: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Obx((){
                          List allFiles = typeController.labTestRcpt.value;
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
                              return ext=='pdf'?Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Image.asset(
                                  'assets/images/pdf_file.png',
                                  height: 45.0,
                                  width: 45.0,
                                ),
                              ):
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Image.file(
                                  allFiles[index],
                                  height: 45.0,
                                  width: 45.0,
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      height: 100.0,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20.0),
          AppButton(
            text: 'Continue',
            onClick: ()async{
              CommonMethods.showAlertDialog(context);
              Map<String,dynamic> data = claimJsonModel!.toJson();
              data['prescription'] = filesUrl['prescription'];
              data['fee_receipt'] = filesUrl['doc_receipt'];
              data['pharmacy_receipt'] = filesUrl['pharmacy_receipt'];
              data['test_receipt'] = filesUrl['test_receipt'];
              print(jsonEncode(data));
              var response = await OpdSure.of(context).client.fileAClaim(jsonEncode(data));
              print(response);
              context.go('/home');
              if(response!.success!){
                CommonMethods.showToast('Claim added successfully');
              }
              else{
                CommonMethods.showToast('Something went wrong');
              }
            },
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

}