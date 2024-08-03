import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class DisputePage extends StatefulWidget{
  final String? claimId;
  DisputePage(this.claimId);

  @override
  State<DisputePage> createState() => _DisputePageState();
}

class _DisputePageState extends State<DisputePage> {
  List<File> documentFiles = [];

  List<String> docUrlList = [];

  TextEditingController remarkCtrl = TextEditingController();

  Widget compulsoryField(String text){
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: text,
              style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D2939)
              )),
          TextSpan(
            text: ' *',
            style: GoogleFonts.montserrat(
                color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    double w = CommonMethods.deviceWidth(context);
    TypeController typeController = Get.put(TypeController());
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        compulsoryField('Remark'),
        const SizedBox(height: 5.0,),
        SizedBox(
          height: 150,
          child: AppBorderBox(
            myChild: TextField(
              controller: remarkCtrl,
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
        compulsoryField('Upload Document'),
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
        AppButton(
          text: 'Submit',
          onClick: () async {
            if(remarkCtrl.text.isEmpty){
              CommonMethods.showToast('Please enter remark');
            }
            else{
              CommonMethods.showAlertDialog(context);
              var response = await OpdSure.of(context).client.addDispute(
                  widget.claimId,
                  userRemark: remarkCtrl.text,
                  allDocs: docUrlList
              );
              CommonMethods.showToast('Send successfully!');
              Navigator.of(context).pop();
              Navigator.pop(context);
            }
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}