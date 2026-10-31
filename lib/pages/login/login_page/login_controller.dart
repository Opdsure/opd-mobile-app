import 'dart:convert';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/pages/login/login_page/login_page_view.dart';
import 'package:opdsure/utils/opd_extension/string_extension.dart';

import '../../../utils/common_methods.dart';
import '../../../widget/opd_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageController();
}

class LoginPageController extends State<LoginPage> {
  TextEditingController phoneTextController = TextEditingController();
  String phoneError = '';
  bool isMobileError = false;

  String countryCode = '+91';

  FocusNode focusNode = FocusNode();
  bool loading = false;
  bool isPasswordObscure = true;
  final countryPicker = const FlCountryCodePicker();
  late TapGestureRecognizer signupRecognizer;
  String flagUri = 'packages/fl_country_code_picker/assets/flags/in.png';

  @override
  void initState() {
    super.initState();
    signupRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push('/signup');
        // _signUp();
      };
  }

  void togglePassword() {
    setState(() => isPasswordObscure = !isPasswordObscure);
  }

  _signUp() {
    context.push('/signup');
  }

  // Detects the backend's "this phone is not a registered user" response so
  // login can redirect to signup. Tolerant to wording variations.
  bool _isNotRegistered(String message) {
    final m = message.toLowerCase();
    return (m.contains('not') &&
            (m.contains('user') ||
                m.contains('registered') ||
                m.contains('exist') ||
                m.contains('found') ||
                m.contains('account'))) ||
        m.contains('no user') ||
        m.contains("doesn't exist") ||
        m.contains('does not exist');
  }

  // The backend sometimes returns the error as (nested) JSON instead of plain
  // text. This extracts the human-readable message so a raw JSON blob is never
  // shown. Returns the input unchanged when it isn't JSON.
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

  getCountryCode() async {
    final picked = await countryPicker.showPicker(context: context);
    if (picked != null) {
      flagUri =
          'packages/fl_country_code_picker/assets/flags/${picked.code.toLowerCase()}.png';
      countryCode = picked.dialCode;
      setState(() {});
    }
  }

  void login(LoginPageController? controller) async {
    print("this is controller $controller");
    final opdSure = OpdSure.of(context);
    if (phoneTextController.text.isEmpty) {
      setState(() {
        phoneError = 'Enter a valid phone no';
        isMobileError = true;
      });
      return;
    } else if (!phoneTextController.text.isValidPhoneNumber) {
      setState(() {
        phoneError = 'Enter a valid phone no';
        isMobileError = true;
      });
      return;
    } else {
      setState(() {
        isMobileError = false;
      });
    }

    setState(() => loading = true);

    try {
      focusNode.unfocus();
      final response = await opdSure.client
          .loginOtp(countryCode: countryCode, phone: phoneTextController.text);
      if (!mounted) return;
      if (response.success!) {
        context.push('/login/otp', extra: {
          'otp_type': 2,
          'phone': phoneTextController.text,
          'country_code': countryCode
        });
      } else {
        final message = _cleanMessage(response.message ?? '');
        if (_isNotRegistered(message)) {
          // Non-registered number: tell the user they don't have an account yet
          // and send them to the Create User (signup) page.
          CommonMethods.showToast(
              'You are not a user. Please create an account.');
          context.go('/signup');
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

  @override
  Widget build(BuildContext context) => LoginView(this);
}
