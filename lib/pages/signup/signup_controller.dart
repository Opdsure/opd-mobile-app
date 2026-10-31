import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/name_email_number/name_email_number_view.dart';
import 'package:opdsure/pages/signup/sign_up_page_view.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import 'package:opdsure/utils/opd_extension/string_extension.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpController();
}

class SignUpController extends State<SignUpPage> {
  late TapGestureRecognizer loginRecognizer;
  TextEditingController phoneTextController = TextEditingController();

  final countryPicker = const FlCountryCodePicker();
  bool isTermAndConditions = false;

  FocusNode focusNode = FocusNode();

  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';
  String phoneError = '';
  String? nameError = '';
  bool loading = false;
  bool isShowErrorMobile = false;

  String countryCode = '+91';
  String isoCode = 'IN';

  InputType inputType = InputType.firstName;

  String flagUri = 'packages/fl_country_code_picker/assets/flags/in.png';

  onChanged(String? value) {
    setState(() {
      emailError = '';
      passwordError = '';
      confirmPasswordError = '';
      phoneError = '';
      nameError;
      isShowErrorMobile = false;
    });
  }

  onTermAndConditions(bool? value) =>
      setState(() => isTermAndConditions = value ?? false);

  @override
  void initState() {
    super.initState();
    loginRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _login();
      };
  }

  _login() {
    context.go('/login');
  }

  // Detects the backend's "this phone already belongs to a user" rejection so
  // signup can redirect to Login. Kept tolerant to wording variations.
  bool _isAlreadyRegistered(String message) {
    final m = message.toLowerCase();
    return m.contains('already') &&
        (m.contains('user') ||
            m.contains('registered') ||
            m.contains('exist') ||
            m.contains('account'));
  }

  // The backend sometimes returns the error as (nested) JSON instead of plain
  // text, e.g. '{"data":[],"success":false,"message":"User already exists"}'.
  // This extracts the human-readable message so a raw JSON blob is never shown
  // to the user. Returns the input unchanged when it isn't JSON.
  String _cleanMessage(String raw) {
    var current = raw.trim();
    for (var i = 0; i < 3; i++) {
      if (!(current.startsWith('{') || current.startsWith('"'))) break;
      try {
        final decoded = jsonDecode(current);
        if (decoded is String) {
          current = decoded;
          continue;
        }
        if (decoded is Map) {
          final inner =
              (decoded['message'] ?? decoded['error'] ?? decoded['msg'] ?? '')
                  .toString();
          if (inner.isEmpty) break;
          current = inner;
          continue;
        }
        break;
      } catch (_) {
        break;
      }
    }
    return current;
  }

  void register() async {
    final opdSure = OpdSure.of(context);
    if (phoneTextController.text.isEmpty) {
      setState(() {
        phoneError = 'Phone no is empty';
        isShowErrorMobile = true;
      });
      return;
    }
    if (!phoneTextController.text.isValidPhoneNumber) {
      setState(() {
        phoneError = 'Enter a valid phone no';
        isShowErrorMobile = true;
      });
      return;
    } else {
      setState(() {
        isShowErrorMobile = false;
      });
    }
    if (!isTermAndConditions) {
      CommonMethods.showToast('Please accept term and conditions.');
      return;
    }

    setState(() => loading = true);

    try {
      focusNode.unfocus();
      final response = await opdSure.client.registerOtp(
        phone: phoneTextController.text,
        countryCode: countryCode,
      );

      if (!mounted) return;
      if (response.success!) {
        context.push('/signup/otp', extra: {
          'otp_type': 1,
          'phone': phoneTextController.text.toString(),
          'country_code': countryCode
        });
      } else {
        // Clean any (nested) JSON so a raw blob is never shown in the toast.
        final message = _cleanMessage(response.message ?? '');
        if (_isAlreadyRegistered(message)) {
          // Existing user tried to sign up: match the web behaviour — show a
          // clear, fixed message and send them to the Login page.
          CommonMethods.showToast(
              'You are already a user, please go to Login.');
          context.go('/login');
        } else {
          CommonMethods.showToast(
            message.isNotEmpty
                ? message
                : 'Something went wrong. Please try again.',
          );
        }
      }
    } catch (e) {
      CommonMethods.showToast('Something went wrong. Please try again.');
    }

    if (mounted) setState(() => loading = false);
  }

  getCountryCode() async {
    final picked = await countryPicker.showPicker(context: context);
    if (picked != null) {
      flagUri =
          'packages/fl_country_code_picker/assets/flags/${picked.code.toLowerCase()}.png';
      isoCode = picked.code;
      countryCode = picked.dialCode;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => SignUpView(this);
}
