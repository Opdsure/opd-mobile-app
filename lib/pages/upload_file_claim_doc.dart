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
import 'package:path_provider/path_provider.dart';

import '../custom_ui/app_border_box.dart';
import '../custom_ui/app_button.dart';
import '../custom_ui/app_text_view.dart';
import '../model/claim_json_model.dart';
import '../model/file_type_size_model.dart';
import '../utils/app_colors.dart';
import '../widget/opd_widget.dart';
import 'package:http/http.dart' as http;

class UploadFileClaimDoc extends StatelessWidget{
  final ClaimJsonModel? claimJsonModel;
  final bool? isUpdate;
  final String? claimId;
  UploadFileClaimDoc(this.claimJsonModel,{this.isUpdate,this.claimId});

  List<File> files = [];
  Map<String,dynamic> filesUrl = {};

  Future<File> asyncMethod() async {
    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.
    var url = "https://opdsurexintileo.s3.ap-south-1.amazonaws.com/user/08a6db82-31c0-4bb0-86d3-93dcd8f064d7/IMG-20240610-WA0005.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4MUSEL74CQEBWZ6R%2F20240713%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20240713T113528Z&X-Amz-Expires=900&X-Amz-Signature=814c08b199c20c5e1930a41c30819cd9060b5e7168820dd6e15bc78f82097a09&X-Amz-SignedHeaders=host&response-content-disposition=inline&x-id=GetObject"; // <-- 1
    var response = await http.get(Uri.parse(url)); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName = '${documentDirectory.path}/images/pic.jpg';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName);
    return file2;// <-- 2
    // file2.writeAsBytesSync(response.bodyBytes);         // <-- 3
    // print(filePathAndName);
  }

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
                asyncMethod();
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
                    // FutureBuilder(
                    //   future: asyncMethod(),
                    //   builder: (context, snapshot){
                    //     if(snapshot.data == null){
                    //       return Container();
                    //     }
                    //     else{
                    //       return Image.file(
                    //         snapshot.data!,
                    //         height: 100,
                    //         width: 100,
                    //       );
                    //     }
                    //   },
                    // ),
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
              Map<String,dynamic> data = claimJsonModel!.toJson();
              data['prescription'] = filesUrl['prescription'];
              data['fee_receipt'] = filesUrl['doc_receipt'];
              data['pharmacy_receipt'] = filesUrl['pharmacy_receipt'];
              data['test_receipt'] = filesUrl['test_receipt'];
              if(filesUrl['prescription']==null){
                CommonMethods.showToast('Please upload one Prescription');
              }
              else if(filesUrl['doc_receipt']==null){
                CommonMethods.showToast('Please upload one Fee Receipt');
              }
              else if(filesUrl['pharmacy_receipt']==null){
                CommonMethods.showToast('Please upload one Pharmacy Receipt');
              }
              else if(filesUrl['test_receipt']==null){
                CommonMethods.showToast('Please upload one Test Receipt');
              }
              else{
                CommonMethods.showAlertDialog(context);
                print(jsonEncode(data));
                var response;
                if(isUpdate!){
                  response = await OpdSure.of(context).client.updateAClaim(claimId!,jsonEncode(data));
                }
                else{
                  response = await OpdSure.of(context).client.fileAClaim(jsonEncode(data));
                }
                print(response);
                Navigator.of(context,rootNavigator: false).pop();
                if(response!.success!){
                  typeController.refreshClaimListChange(false);
                  typeController.refreshClaimListChange(true);
                  typeController.prescriptionListChange([]);
                  typeController.docFeeRcptChange([]);
                  typeController.pharmacyRcptChange([]);
                  typeController.labTestRcptChange([]);
                  // typeController.memberListChange(<MemberList>[]);
                  typeController.selectClaimChange('');
                  typeController.opdVisitDateChange('');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  CommonMethods.showToast(isUpdate!?'Claim added successfully':'Claim added successfully');
                }
                else{
                  CommonMethods.showToast('Something went wrong');
                }
              }
            },
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

}