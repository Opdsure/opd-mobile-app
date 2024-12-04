import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/config/route.dart';
import 'package:opdsure/pages/submit_patient_details/submit_patient_details_view.dart';

import '../../utils/common_methods.dart';
import '../../widget/opd_widget.dart';

class SubmitPatientDetails extends StatefulWidget {
  final String? healthCheckupId;

  const SubmitPatientDetails({this.healthCheckupId, super.key});

  @override
  State<SubmitPatientDetails> createState() => SubmitPatientDetailsController();
}

class SubmitPatientDetailsController extends State<SubmitPatientDetails> {
  TextEditingController patientNameCtrl = TextEditingController();
  TextEditingController patientAgeCtrl = TextEditingController();
  TextEditingController patientAddressCtrl = TextEditingController();
  TextEditingController patientPinCodeCtrl = TextEditingController();
  String gender = '';
  String appointmentDataTime = '';
  List<String> genderList = ['Male', "Female", "Other"];
  String appointmentISODataTime = '';
  DateTime _selectedDateTime = DateTime.now();

  void setGender(String value) => setState(() => gender = value);

  Future<void> selectDateTime(BuildContext context) async {
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
          appointmentDataTime =
              DateFormat('dd-mm-yyyy hh:mm a').format(_selectedDateTime);
        });
      }
    }
  }

  void onPop(){
      CommonMethods.customAlertBox(context,
          title: 'Exit',
          message:
              "Are you sure you want to exit without filling out the patient's details? You can also fill it in later from the Profile -> Health Checkup Plans section.",
          isCancelButton: true,
          negativeButton: 'Fill',
          positiveButton: 'Exit',
          okCallBack: (context1) async {
        if (widget.healthCheckupId == null) {
          context.go('/home');
          Navigator.of(context1, rootNavigator: false).pop();
        } else {
          context.pop();
          Navigator.of(context1, rootNavigator: false).pop();
        }
      },
        cancelCallBack: (context1){
          Navigator.of(context1, rootNavigator: false).pop();
        },
        shouldDismiss: true
      );
  }

  bool canPop() {
    if (patientNameCtrl.text == '') {
      return false;
    } else if (patientAgeCtrl.text == '') {
      return false;
    } else if (patientAddressCtrl.text == '') {
      return false;
    } else if (patientPinCodeCtrl.text == '') {
      return false;
    } else if (gender == '') {
      return false;
    } else if (appointmentDataTime == '') {
      return false;
    } else {
      return false;
    }
  }

  void submitPatientsDetails() async {
    if (patientNameCtrl.text == '') {
      CommonMethods.showToast('Please enter patient name');
    } else if (patientAgeCtrl.text == '') {
      CommonMethods.showToast('Please enter patient age');
    } else if (patientAddressCtrl.text == '') {
      CommonMethods.showToast('Please enter patient address');
    } else if (patientPinCodeCtrl.text == '') {
      CommonMethods.showToast('Please enter patient pincode');
    } else if (gender == '') {
      CommonMethods.showToast('Please enter patient gender');
    } else if (appointmentDataTime == '') {
      CommonMethods.showToast('Please enter appointment data time');
    } else {
      CommonMethods.showAlertDialog(context);
      try {
        final response = await OpdSure.of(context)
            .client
            .collectSampleCollectionData(
                patientName: patientNameCtrl.text,
                pinCode: int.parse(patientPinCodeCtrl.text),
                age: int.parse(patientAgeCtrl.text),
                healthPlanId: widget.healthCheckupId,
                gender: int.parse(CommonMethods.genderKey(gender)),
                address: patientAddressCtrl.text,
                appointment: appointmentISODataTime);
        Navigator.of(context).pop();
        if(response != null) {
          if (response.success!) {
            CommonMethods.showToast(response.message!);
            context.go('/home');
          }else{
            CommonMethods.showToast(response.message!);
          }

        }else{
          CommonMethods.showToast('Something went wrong');
        }

      } catch (e) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => SubmitPatientDetailsView(this);
}
