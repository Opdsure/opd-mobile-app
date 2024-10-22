import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/config/route.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/pages/submit_patient_details/submit_patient_details.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../custom_ui/app_border_box.dart';
import '../../custom_ui/app_bottom_sheet.dart';
import '../../custom_ui/app_edit_text.dart';
import '../../custom_ui/app_header.dart';
import '../../custom_ui/app_rich_text.dart';
import '../../custom_ui/app_text_view.dart';

class SubmitPatientDetailsView extends StatelessWidget {
  final SubmitPatientDetailsController controller;

  const SubmitPatientDetailsView(this.controller, {super.key});

  Widget compulsoryField(String text) {
    return AppRichText(
      textSpan: TextSpan(
        children: [
          TextSpan(
              text: text,
              style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D2939))),
          TextSpan(
            text: ' *',
            style: GoogleFonts.montserrat(color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult:(canPop, _) => controller.onPop() ,
      child: AppBasePage(
          appHeader: AppHeader(
            onBackTap: controller.onPop,
            headerName: 'Submit Patient Details',
          ),
          childContent: ListView(
            children: [
              const SizedBox(height: 15.0),
              compulsoryField('Patient Name'),
              AppEditText(
                hint: 'Enter patient name',
                textEditingController: controller.patientNameCtrl,
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: 15.0),
              compulsoryField('Patient Age'),
              AppEditText(
                hint: 'Enter patient age',
                textEditingController: controller.patientAgeCtrl,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 15.0),
              compulsoryField('Patient Address'),
              AppEditText(
                hint: 'Enter patient address',
                maxLines: 5,
                minLines: 1,
                textEditingController: controller.patientAddressCtrl,
                textInputType: TextInputType.multiline,
              ),
              const SizedBox(height: 15.0),
              compulsoryField('Patient Pincode'),
              AppEditText(
                hint: 'Enter patient pincode',
                textEditingController: controller.patientPinCodeCtrl,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 15.0),
              compulsoryField('Patient Pincode'),
              InkWell(
                onTap: () async {
                  AppBottomSheet(
                      height: 200,
                      mChild: ListView.builder(
                        itemCount: controller.genderList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller
                                  .setGender(controller.genderList[index]);
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: AppTextView(
                                    text: controller.genderList[index],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: Color(0x1A101828),
                                ),
                              ],
                            ),
                          );
                        },
                      )).modalBottomSheetMenu(context);
                },
                child: AppBorderBox(
                  myChild: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: controller.gender == ''
                            ? 'Select Gender'
                            : controller.gender,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Color(0xff667085),
                        size: 24.0,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              compulsoryField('Patient Pincode'),
              InkWell(
                onTap: () {
                  controller.selectDateTime(context);
                },
                child: AppEditText(
                  hint: controller.appointmentDataTime == ''
                      ? 'Select appointment date and time'
                      : controller.appointmentDataTime,
                  disableText: true,
                  viewSuffix: true,
                  suffixWidget: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xff667085),
                    size: 24.0,
                  ),
                  eyeCallback: () {
                    controller.selectDateTime(context);
                  },
                ),
              ),
              const SizedBox(height: 15.0),
              AppButton(
                text: 'Submit',
                onClick: controller.submitPatientsDetails,
              )
            ],
          )),
    );
  }
}
