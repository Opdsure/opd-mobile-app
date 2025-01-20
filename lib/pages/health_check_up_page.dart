import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multiselect/multiselect.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/add_checkup_model.dart';
import 'package:opdsure/model/free_health_test_model/free_health_test_model.dart';
import 'package:opdsure/model/tests_model.dart';
import 'package:opdsure/utils/common_methods.dart';
import '../config/app_config.dart';
import '../custom_ui/app_border_box.dart';
import '../custom_ui/app_bottom_sheet.dart';
import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_header.dart';
import '../custom_ui/app_rich_text.dart';
import '../custom_ui/app_text_view.dart';
import '../model/my_member_model.dart';
import '../utils/app_colors.dart';
import '../widget/opd_widget.dart';

class HealthCheckUpPage extends StatefulWidget {
  const HealthCheckUpPage({super.key});

  @override
  State<HealthCheckUpPage> createState() => _HealthCheckUpPageState();
}

class _HealthCheckUpPageState extends State<HealthCheckUpPage> {
  List<String> selected = [];
  TextEditingController messageCtrl = TextEditingController();
  final MultiSelectController<FreeHealthTestRecords> _controller = MultiSelectController();
  List<ValueItem<FreeHealthTestRecords>> allValueList = [];
  String appointmentDataTime = '';
  String appointmentISODataTime = '';
  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now().add(const Duration(days: 3)),
      lastDate: DateTime.now().add(const Duration(days: 10)),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          appointmentISODataTime = _selectedDateTime.toUtc().toIso8601String();
          appointmentDataTime = DateFormat('dd-mm-yyyy hh:mm a').format(_selectedDateTime);
        });
      }
    }
  }

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
    TypeController typeController = Get.put(TypeController());
    return AppBasePage(
      appHeader: const AppHeader(
        headerName: 'Free Health Check-up',
      ),
      childContent: ListView(
        children: [
          compulsoryField('Patient Name'),
          Obx(() {
            bool refresh = typeController.refreshMemberList.value;
            return refresh
                ? FutureBuilder(
                    future: OpdSure.of(context)
                        .client
                        .getFamilyMember(update: true),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const AppEditText(
                          hint: 'getting users...',
                          disableText: true,
                          viewSuffix: true,
                          suffixWidget: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Color(0xff667085),
                            size: 24.0,
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            MyMemberModel myMemberModel = snapshot.data!;
                            List<MemberList>? memberList = myMemberModel.data;
                            AppBottomSheet(
                                    height: 600,
                                    mChild: memberList!.isEmpty
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              context.push('/home/add-members',
                                                  extra: {
                                                    "isUpdate": false,
                                                    "isAddingFirstMember": false
                                                  });
                                            },
                                            child: const Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  AppTextView(
                                                    text:
                                                        'No Family member added',
                                                    color:
                                                        AppConfig.primaryColor,
                                                    size: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Icon(
                                                    Icons.add_circle,
                                                    color:
                                                        AppConfig.primaryColor,
                                                  ),
                                                  AppTextView(
                                                    text: 'Add Member',
                                                    color:
                                                        AppConfig.primaryColor,
                                                    size: 12.0,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: memberList.length,
                                            itemBuilder: (context, index) {
                                              return Visibility(
                                                visible: (memberList[index]
                                                        .planStatus ==
                                                    1),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (typeController
                                                          .memberList
                                                          .value
                                                          .isNotEmpty) {
                                                        typeController
                                                            .memberList.value
                                                            .clear();
                                                      }
                                                      typeController
                                                          .memberListChange(
                                                              memberList[
                                                                  index]);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppTextView(
                                                              text: memberList[
                                                                      index]
                                                                  .name!,
                                                              size: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            AppTextView(
                                                              text:
                                                                  '${memberList[index].phone!}',
                                                              size: 14.0,
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          height: 1,
                                                          color:
                                                              Color(0x1A101828),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ))
                                .modalBottomSheetMenu(context);
                          },
                          child: AppBorderBox(
                            myChild: Obx(() {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppTextView(
                                    text: typeController
                                            .memberList.value.isEmpty
                                        ? 'Select User'
                                        : typeController.memberList.first.name!,
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
                        );
                      }
                    },
                  )
                : Container();
          }),
          const SizedBox(
            height: 15.0,
          ),
          compulsoryField('Test'),
          FutureBuilder<FreeHealthTestModel?>(
            future: OpdSure.of(context).client.getHealthTest(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              } else {
                FreeHealthTestModel? data = snapshot.data;
                for(var value in data!.data!.records!){
                  allValueList.add(ValueItem<FreeHealthTestRecords>(label: value.name!, value: value));
                }

                return AppBorderBox(
                  myChild: MultiSelectDropDown<FreeHealthTestRecords>(
                    controller: _controller,
                    inputDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // <= No more error here :)
                      color: Colors.transparent,
                    ),
                    onOptionSelected: (options) {
                      selected.clear();
                      for(var item in options){
                        selected.add(item.value!.id!);
                      }
                    },
                    options: allValueList,
                    selectionType: SelectionType.multi,
                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                    dropdownHeight: 200,
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          compulsoryField('Appointment Date and Time'),
          InkWell(
            onTap: () {
              _selectDateTime(context);
            },
            child: AppEditText(
              hint: appointmentDataTime == '' ? 'Select appointment date and time' : appointmentDataTime,
              disableText: true,
              viewSuffix: true,
              suffixWidget: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xff667085),
                size: 24.0,
              ),
              eyeCallback: () {
                _selectDateTime(context);
              },
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          compulsoryField('Message'),
          SizedBox(
            height: 100,
            child: AppBorderBox(
              myChild: TextField(
                controller: messageCtrl,
                style:
                    GoogleFonts.montserrat(fontSize: 15.0, color: backIconCl),
                maxLines: null,
                // Set this
                expands: true,
                // and this
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Write the message here...',
                  border: InputBorder.none,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const AppTextView(
            text:
                '*Kindly note that post submitting this form, our team will connect with you shortly.',
            color: AppConfig.primaryColor,
          ),
          const SizedBox(
            height: 15.0,
          ),
          AppButton(
            text: 'Submit',
            onClick: () async {
              if (typeController.memberList.value.isEmpty) {
                CommonMethods.showToast('Please select Patient');
              } else if (selected.isEmpty) {
                CommonMethods.showToast('Please select Test');
              } else if (messageCtrl.text.isEmpty) {
                CommonMethods.showToast('Please type your message');
              } else if (appointmentDataTime == '') {
                CommonMethods.showToast(
                    'Please select an appointment data and time');
              } else {
                CommonMethods.showAlertDialog(context);
                try {
                  final response = await OpdSure
                      .of(context)
                      .client
                      .addHealthCheckup(
                      memberId: typeController.memberList.value.first.id,
                      checkupFor: selected,
                      message: messageCtrl.text,
                      appointmentDataTime: appointmentISODataTime);
                  Navigator.of(context).pop();
                  AddCheckupModel addCheckupModel =
                  AddCheckupModel.fromJson(jsonDecode(response));
                  if (addCheckupModel.success!) {






                    setState(() {
                      typeController.memberList.value.clear();
                      messageCtrl.text = '';
                      allValueList.clear();
                      selected.clear();
                      _controller.clearAllSelection();
                      Navigator.pop(context);
                    });
                    CommonMethods.showToast('Your request added successfully!');
                  }
                }catch(e){

                  Navigator.of(context).pop();
                  CommonMethods.showToast(e.toString());
                }

              }
            },
          )
        ],
      ),
    );
  }
}
