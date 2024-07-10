import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/widget/opd_widget.dart';

import 'name_email_number_view.dart';

class NameEmailNumber extends StatefulWidget {
  const NameEmailNumber({super.key});

  @override
  State<NameEmailNumber> createState() => NameEmailNumberController();
}

class NameEmailNumberController extends State<NameEmailNumber> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController middleNameTextController = TextEditingController();
  TextEditingController lastNameControllerTextController =
      TextEditingController();
  TextEditingController phoneTextController = TextEditingController();

  String? emailError;
  String? phoneError;
  String? nameError;
  bool loading = false;

  final countryPicker = const FlCountryCodePicker();
  bool isWithEmail = false;
  String countryCode = '+91';

  InputType inputType = InputType.firstName;

  String flagUri = 'packages/fl_country_code_picker/assets/flags/in.png';

  @override
  void initState() {
    super.initState();
    isWithEmail = OpdSure.of(context).isWithEmail;
  }

  String? _getFullName() {
    List<String> nameParts = [];

    if (firstNameTextController.text.isNotEmpty) {
      nameParts.add(firstNameTextController.text);
    }
    if (middleNameTextController.text.isNotEmpty) {
      nameParts.add(middleNameTextController.text);
    }
    if (lastNameControllerTextController.text.isNotEmpty) {
      nameParts.add(lastNameControllerTextController.text);
    }

    if (nameParts.join(' ').isEmpty) {
      return null;
    }
    return nameParts.join(' ');
  }

  getCountryCode() async {
    final picked = await countryPicker.showPicker(context: context);
    if (picked != null) {
      flagUri =
          'packages/fl_country_code_picker/assets/flags/${picked.code.toLowerCase()}.png';
      countryCode = picked.dialCode;
      setState(() {});
    }
  }

  void updateProfile() async {
    final opd = OpdSure.of(context);
    final response = await opd.client.updateUserProfile(
      name: _getFullName(),
      phone: isWithEmail ? null : phoneTextController.text,
      email: isWithEmail ? emailTextController.text : null
    );
    if (response != null) {
      context.pushReplacement('/home');
    } else {}
  }

  @override
  Widget build(BuildContext context) => NameEmailNumberView(this);
}
