import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../custom_ui/app_button.dart';
import '../model/file_type_size_model.dart';
import '../utils/app_colors.dart';
import '../widget/opd_widget.dart';

class DisputePage extends StatelessWidget{
  List<File> documentFiles = [];
  List<String> docUrlList = [];
  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    double w = CommonMethods.deviceWidth(context);
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Raise Complaint',),
      childContent: ListView(
        children: [
          const SizedBox(height: 20.0),
          const AppTextView(
            text: 'Remark',
            size: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 5.0,),
          SizedBox(
            height: 200,
            child: AppBorderBox(
              myChild: TextField(
                style: GoogleFonts.montserrat(
                    fontSize: 15.0,
                    color: backIconCl
                ),
                maxLines: null, // Set this
                expands: true, // and this
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Write the description',
                  border: InputBorder.none,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0,),
          const AppTextView(
            text: 'Upload Document',
            size: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 5.0,),
          FutureBuilder(
            future: OpdSure.of(context).client.getFileTypeAndSize(),
            builder: (context, snapshot) {
              if(snapshot.data == null){
                return Container();
              }
              else{
                FileTypeSizeModel fileTypeSizeModel = fileTypeSizeModelFromJson(snapshot.data);
                List<TypeSizeList> typeSizeList = fileTypeSizeModel.data;
                String mFileTypes = typeSizeList[0].fileType;
                List<String> customSizeList = mFileTypes.split(',');
                return AppBorderBox(
                  mCallback: ()async{
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: customSizeList,
                    );
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      documentFiles.add(file);
                      typeController.prescriptionListChange(file);
                      CommonMethods.showAlertDialog(context);
                      var response = await OpdSure.of(context).client.uploadFiles(results: result);
                      docUrlList = docUrlList+response!.data!;
                      // filesUrl['prescription'] = docUrlList;
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
                                    docUrlList.removeAt(index);
                                    // filesUrl['prescription'] = docUrlList;
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
                );
              }
            }
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
          const SizedBox(height: 20.0),
          const AppButton(text: 'Submit'),
          const SizedBox(height: 70.0),
        ],
      ),
    );
  }

}