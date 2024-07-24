import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/view_image_page.dart';
import 'package:opdsure/utils/common_methods.dart';
import '../custom_ui/app_border_box.dart';
import '../custom_ui/app_button.dart';
import '../custom_ui/app_card_view.dart';
import '../custom_ui/app_text_view.dart';
import '../model/claim_json_model.dart';
import '../model/file_type_size_model.dart';
import '../model/single_claim_model.dart';
import '../utils/app_colors.dart';
import '../widget/opd_widget.dart';

class UploadFileClaimDoc extends StatelessWidget{
  final ClaimJsonModel? claimJsonModel;
  final bool? isUpdate;
  final String? claimId;
  final Map<String, dynamic>? documentMap;
  UploadFileClaimDoc(this.claimJsonModel,{this.isUpdate,this.claimId, this.documentMap});

  // List<File> files = [];
  List<File> prescriptionFiles = [];
  List<File> doctorFeeFiles = [];
  List<File> pharmacyFiles = [];
  List<File> labTestFiles = [];
  Map<String,dynamic> filesUrl = {};
  List<String> prescriptionUrlList = [];
  List<String> docFeeUrlList = [];
  List<String> pharmacyUrlList = [];
  List<String> testLabUrlList = [];

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    double h = CommonMethods.deviceHeight(context);
    double w = CommonMethods.deviceWidth(context);
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Upload Documents',
      ),
      childContent: ListView(
        children: [
          const SizedBox(height: 15.0),
          isUpdate!?AppCardView(
            mChaild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: OpdSure.of(context).client.getSingleClaims(claimId!),
                  builder: (context, snapshot){
                    if(snapshot.data == null){
                      return Container();
                    }
                    else{
                      SingleClaimModel singleClaimModel = SingleClaimModel.fromJson(jsonDecode(snapshot.data));
                      List<String> prescriptionImageList = singleClaimModel.data!.prescription!;
                      List<String> pharmacyImageList = singleClaimModel.data!.pharmacyReceipt!;
                      List<String> feeImageList = singleClaimModel.data!.feeReceipt!;
                      List<String> testImageList = singleClaimModel.data!.testReceipt!;
                      // prescriptionUrlList = prescriptionUrlList+documentMap!['prescription_d'];
                      // docFeeUrlList = docFeeUrlList+documentMap!['doc_fee_d'];
                      // pharmacyUrlList = pharmacyUrlList+documentMap!['pharmacy_d'];
                      // testLabUrlList = testLabUrlList+documentMap!['test_d'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppTextView(
                            text: 'Uploaded Documents',
                            size: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10.0,),
                          const AppTextView(
                            text: 'Prescription',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: h*0.1,
                            child: ListView.builder(
                              itemCount: prescriptionImageList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>ViewImagePage('Prescription', prescriptionImageList[index])),
                                          );
                                        },
                                        child: Image.network(
                                          prescriptionImageList[index],
                                          height: h*0.1,
                                          width: h*0.1,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          const AppTextView(
                            text: 'Fees Receipt',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: h*0.1,
                            child: ListView.builder(
                              itemCount: feeImageList.length,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>ViewImagePage('Fees Receipt', feeImageList[index])),
                                          );
                                        },
                                        child: Image.network(
                                          feeImageList[index],
                                          height: h*0.1,
                                          width: h*0.1,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          const AppTextView(
                            text: 'Pharmacy Receipt',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: h*0.1,
                            child: ListView.builder(
                              itemCount: pharmacyImageList.length,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>ViewImagePage('Pharmacy Receipt', pharmacyImageList[index])),
                                          );
                                        },
                                        child: Image.network(
                                          pharmacyImageList[index],
                                          height: h*0.1,
                                          width: h*0.1,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          const AppTextView(
                            text: 'Test Receipt',
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: h*0.1,
                            child: ListView.builder(
                              itemCount: testImageList.length,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>ViewImagePage('Test Receipt', testImageList[index])),
                                          );
                                        },
                                        child: Image.network(
                                          testImageList[index],
                                          height: h*0.1,
                                          width: h*0.1,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ):Container(),
          const SizedBox(height: 15.0,),
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
                          allowedExtensions: customSizeList,
                        );
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          prescriptionFiles.add(file);
                          typeController.prescriptionListChange(file);
                          CommonMethods.showAlertDialog(context);
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          prescriptionUrlList = prescriptionUrlList+response!.data!;
                          filesUrl['prescription'] = prescriptionUrlList;
                          Navigator.of(context).pop();
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
                          Row(
                            children: [
                              SizedBox(
                                width: w*0.75,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allFiles.length,
                                  itemBuilder: (context,index){
                                    String ext = allFiles[index].path.split('.')[3];
                                    return InkWell(
                                      onTap: (){
                                        typeController.removePrescription(allFiles[index]);
                                        prescriptionUrlList.removeAt(index);
                                        filesUrl['prescription'] = prescriptionUrlList;
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: ext=='pdf'?Image.asset(
                                          'assets/images/pdf_file.png',
                                          height: 45.0,
                                          width: 45.0,
                                        ):
                                        Image.file(
                                          allFiles[index],
                                          height: 45.0,
                                          width: 45.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: w*0.1,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: buttonColor,
                                    ),
                                    AppTextView(
                                      text: 'Add\nMore',
                                      size: 12.0,
                                      color: buttonColor,
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                      height: 100.0,
                    ),
                    Obx((){
                      List allFiles = typeController.prescriptionList.value;
                      return Visibility(
                        visible: allFiles.isNotEmpty,
                        child: const AppTextView(
                          text: 'Tap to remove file',
                          size: 11.0,
                        ),
                      );
                    }),
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
                          File file = File(result.files.single.path!);
                          doctorFeeFiles.add(file);
                          typeController.docFeeRcptChange(file);
                          CommonMethods.showAlertDialog(context);
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          docFeeUrlList = docFeeUrlList+response!.data!;
                          filesUrl['doc_receipt'] = docFeeUrlList;
                          Navigator.of(context).pop();
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
                          ):Row(
                            children: [
                              SizedBox(
                                width: w*0.75,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allFiles.length,
                                  itemBuilder: (context,index){
                                    String ext = allFiles[index].path.split('.')[3];
                                    return InkWell(
                                      onTap: (){
                                        typeController.removeDocFeeRcpt(allFiles[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: ext=='pdf'?Image.asset(
                                          'assets/images/pdf_file.png',
                                          height: 45.0,
                                          width: 45.0,
                                        ):
                                        Image.file(
                                          allFiles[index],
                                          height: 45.0,
                                          width: 45.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: w*0.1,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: buttonColor,
                                    ),
                                    AppTextView(
                                      text: 'Add\nMore',
                                      size: 12.0,
                                      color: buttonColor,
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                      height: 100.0,
                    ),
                    Obx((){
                      List allFiles = typeController.docFeeRcpt.value;
                      return Visibility(
                        visible: allFiles.isNotEmpty,
                        child: const AppTextView(
                          text: 'Tap to remove file',
                          size: 11.0,
                        ),
                      );
                    }),
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
                          File file = File(result.files.single.path!);
                          pharmacyFiles.add(file);
                          typeController.pharmacyRcptChange(file);
                          CommonMethods.showAlertDialog(context);
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          pharmacyUrlList = pharmacyUrlList+response!.data!;
                          filesUrl['pharmacy_receipt'] = pharmacyUrlList;
                          Navigator.of(context).pop();
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
                          Row(
                            children: [
                              SizedBox(
                                width: w*0.75,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allFiles.length,
                                  itemBuilder: (context,index){
                                    String ext = allFiles[index].path.split('.')[3];
                                    return InkWell(
                                      onTap: (){
                                        typeController.removePharmacyRcpt(allFiles[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: ext=='pdf'?Image.asset(
                                          'assets/images/pdf_file.png',
                                          height: 45.0,
                                          width: 45.0,
                                        ):
                                        Image.file(
                                          allFiles[index],
                                          height: 45.0,
                                          width: 45.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: w*0.1,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: buttonColor,
                                    ),
                                    AppTextView(
                                      text: 'Add\nMore',
                                      size: 12.0,
                                      color: buttonColor,
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                      height: 100.0,
                    ),
                    Obx((){
                      List allFiles = typeController.pharmacyRcpt.value;
                      return Visibility(
                        visible: allFiles.isNotEmpty,
                        child: const AppTextView(
                          text: 'Tap to remove file',
                          size: 11.0,
                        ),
                      );
                    }),
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
                          File file = File(result.files.single.path!);
                          prescriptionFiles.add(file);
                          typeController.labTestRcptChange(file);
                          CommonMethods.showAlertDialog(context);
                          var response = await OpdSure.of(context).client.uploadFiles(results: result);
                          testLabUrlList = testLabUrlList+response!.data!;
                          filesUrl['test_receipt'] = testLabUrlList;
                          Navigator.of(context).pop();
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
                          Row(
                            children: [
                              SizedBox(
                                width: w*0.75,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allFiles.length,
                                  itemBuilder: (context,index){
                                    String ext = allFiles[index].path.split('.')[3];
                                    return InkWell(
                                      onTap: (){
                                        typeController.removeLabTestRcpt(allFiles[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: ext=='pdf'?Image.asset(
                                          'assets/images/pdf_file.png',
                                          height: 45.0,
                                          width: 45.0,
                                        ):
                                        Image.file(
                                          allFiles[index],
                                          height: 45.0,
                                          width: 45.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: w*0.1,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: buttonColor,
                                    ),
                                    AppTextView(
                                      text: 'Add\nMore',
                                      size: 12.0,
                                      color: buttonColor,
                                    )
                                  ],
                                ),
                              )
                            ],
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
          Obx((){
            List allFiles = typeController.labTestRcpt.value;
            return Visibility(
              visible: allFiles.isNotEmpty,
              child: const AppTextView(
                text: 'Tap to remove file',
                size: 11.0,
              ),
            );
          }),
          const SizedBox(height: 20.0),
          AppButton(
            text: 'Continue',
            onClick: ()async{
              Map<String,dynamic> data = claimJsonModel!.toJson();
              data['prescription'] = filesUrl['prescription'];
              data['fee_receipt'] = filesUrl['doc_receipt'];
              data['pharmacy_receipt'] = filesUrl['pharmacy_receipt'];
              data['test_receipt'] = filesUrl['test_receipt'];
              if(filesUrl['prescription']==null && !(isUpdate!)){
                CommonMethods.showToast('Please upload Prescription');
              }
              else if(filesUrl['doc_receipt']==null && !(isUpdate!)){
                CommonMethods.showToast('Please upload Fee Receipt');
              }
              else if(filesUrl['pharmacy_receipt']==null && !(isUpdate!)){
                CommonMethods.showToast('Please upload Pharmacy Receipt');
              }
              else if(filesUrl['test_receipt']==null && !(isUpdate!)){
                CommonMethods.showToast('Please upload Test Receipt');
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
                Map<String,dynamic> resMap = jsonDecode(response);
                if(resMap['success'] && isUpdate!){
                  Navigator.of(context,rootNavigator: false).pop();
                  typeController.refreshClaimListChange(false);
                  typeController.refreshClaimListChange(true);
                  typeController.prescriptionList.clear();
                  typeController.docFeeRcpt.clear();
                  typeController.pharmacyRcpt.clear();
                  typeController.labTestRcpt.clear();
                  // typeController.memberListChange(<MemberList>[]);
                  typeController.selectClaimChange('');
                  typeController.opdVisitDateChange('');
                  CommonMethods.showOneButtonDialog(context,isUpdate!?'Claim updated successfully':'Claim submitted successfully',(){
                    Navigator.of(context,rootNavigator: true).pop();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
                else if(isUpdate! && resMap['message'] == 'Action on claim already taken'){
                  CommonMethods.showToast(resMap['message']);
                  Navigator.of(context,rootNavigator: false).pop();
                }
                else{
                  Navigator.of(context,rootNavigator: false).pop();
                  if(resMap['success']){
                    typeController.refreshClaimListChange(false);
                    typeController.refreshClaimListChange(true);
                    typeController.prescriptionList.clear();
                    typeController.docFeeRcpt.clear();
                    typeController.pharmacyRcpt.clear();
                    typeController.labTestRcpt.clear();
                    // typeController.memberListChange(<MemberList>[]);
                    typeController.selectClaimChange('');
                    typeController.opdVisitDateChange('');
                    CommonMethods.showOneButtonDialog(context,isUpdate!?'Claim updated successfully':'Claim submitted successfully',(){
                      Navigator.of(context,rootNavigator: true).pop();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                    // CommonMethods.showToast(isUpdate!?'Claim updated successfully':'Claim added successfully');
                  }
                  else{
                    CommonMethods.showToast('Something went wrong');
                  }
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