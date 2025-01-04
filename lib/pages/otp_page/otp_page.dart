// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import 'package:smart_auth/smart_auth.dart';
// import '../../../custom_ui/app_button.dart';
// import '../../../custom_ui/app_text_view.dart';
// import '../../../utils/app_colors.dart';
// import '../../config/app_config.dart';
// import '../../custom_ui/app_rich_text.dart';
// import 'otp_page_controller.dart';
//
// class OtpPageView extends StatefulWidget{
//
//   final OtpPageController controller;
//
//    OtpPageView(this.controller, {super.key});
//
//   @override
//   State<OtpPageView> createState() => _OtpPageViewState();
// }
//
// class _OtpPageViewState extends State<OtpPageView> {
//   TextStyle? createStyle() {
//     return GoogleFonts.montserrat(
//         fontSize: 20.0,
//         fontWeight: FontWeight.w700
//     );
//   }
//
//
//   final defaultPinTheme = PinTheme(
//     width: 56,
//     height: 60,
//     textStyle: const TextStyle(
//       fontSize: 22,
//       color: Colors.black, fontWeight: FontWeight.w700
//     ),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(8),
//       color: Colors.white,
//       border: Border.all(color: AppConfig.primaryColor,  width: 2),
//     ),
//   );
//
//
//
//   final TextEditingController pinController = TextEditingController();
//   final FocusNode focusNode = FocusNode();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final SmartAuth smartAuth = SmartAuth();
//
//   @override
//   void initState() {
//     super.initState();
//     startSmsListener();
//   }
//
//   @override
//   void dispose() {
//     pinController.dispose();
//     focusNode.dispose();
//     smartAuth.removeSmsListener();
//     super.dispose();
//   }
//
//   void startSmsListener() async {
//     try {
//       final appSignature = await smartAuth.getAppSignature();
//       debugPrint('App Signature: $appSignature');
//
//       smartAuth.getSmsCode(useUserConsentApi: true).then((result) {
//         if (result.succeed && result.codeFound) {
//           pinController.text = result.code!;
//         }
//       });
//     } catch (e) {
//       debugPrint('Error in SMS listener: $e');
//     }
//   }
//
//
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppConfig.primaryColorLight,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: ListView(
//           children: [
//             const SizedBox(height: 16.0,),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: (){
//                     Navigator.pop(context);
//                   },
//                   child: const SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: Icon(
//                       Icons.arrow_back_ios,
//                       color: backIconCl,
//                     ),
//                   ),
//                 ),
//                 Image.asset(
//                   'assets/images/app_logo.png',
//                   height: 100.0,
//                   width: 100.0,
//                 ),
//                 Container()
//               ],
//             ),
//             const SizedBox(height: 24.0,),
//             const Center(
//               child: AppTextView(
//                 text: 'Enter OTP',
//                 color: Colors.black,
//                 size: 22.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Center(
//               child: AppTextView(
//                 text: 'Enter the 6-digit code that we have sent\non the +91-${widget.controller.widget.phone} ',
//                 color: const Color(0xff475467),
//                 size: 16.0,
//                 mTextAlign: TextAlign.center,
//               ),
//             ),
//
//             const SizedBox(height: 24.0,),
//
//
//
//             Pinput(
//               controller: pinController,
//               length: 6,
//               enableSuggestions : false,
//               autofillHints: [],
//               defaultPinTheme: defaultPinTheme,
//               onSubmitted: widget.controller.onSubmit,
//               onCompleted: widget.controller.onSubmit,
//               onChanged: (value) {
//                 debugPrint('onChanged: $value');
//               },
//             ),
//
//             const SizedBox(height: 24.0,),
//             AppButton(onClick: (){
//               widget.controller.otpVerify();
//             },text: 'Verify OTP'),
//
//             const SizedBox(height: 24.0,),
//             Center(
//               child: AppRichText(
//                 textSpan: TextSpan(
//                   children: [
//                     TextSpan(
//                         text: "Didn't receive the OTP? ",
//                         style: GoogleFonts.montserrat()
//                     ),
//                     TextSpan(
//                       text: 'Resend',
//                       style: GoogleFonts.montserrat(
//                           fontWeight: FontWeight.w600,
//                           color: AppConfig.primaryColor,
//
//                       ), recognizer: widget.controller.otpRecognizer
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'dart:async';
import '../../../custom_ui/app_button.dart';
import '../../../custom_ui/app_text_view.dart';
import '../../../utils/app_colors.dart';
import '../../config/app_config.dart';
import '../../custom_ui/app_rich_text.dart';
import '../../utils/common_methods.dart';
import 'otp_page_controller.dart';

class OtpPageView extends StatefulWidget {
  final OtpPageController controller;

  const OtpPageView(this.controller, {super.key});

  @override
  State<OtpPageView> createState() => _OtpPageViewState();
}

class _OtpPageViewState extends State<OtpPageView> {
  TextStyle? createStyle() {
    return GoogleFonts.montserrat(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      border: Border.all(color: AppConfig.primaryColor, width: 2),
    ),
  );

  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SmartAuth smartAuth = SmartAuth();

  bool isResendEnabled = false;
  Timer? _resendTimer;
  int _resendCountdown = 60; // 2 minutes
  final TapGestureRecognizer _resendRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    startSmsListener();
    startResendCooldown();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    smartAuth.removeSmsListener();
    _resendTimer?.cancel();
    _resendRecognizer.dispose(); // Dispose the recognizer
    super.dispose();
  }

  void startSmsListener() async {
    try {
      final appSignature = await smartAuth.getAppSignature();
      debugPrint('App Signature: $appSignature');

      smartAuth.getSmsCode(useUserConsentApi: true).then((result) {
        if (result.succeed && result.codeFound) {
          pinController.text = result.code!;}
      });
    } catch (e) {
      debugPrint('Error in SMS listener: $e');
    }
  }

  void startResendCooldown() {
    setState(() {
      isResendEnabled = false;
      _resendCountdown = 60;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          isResendEnabled = true;
        });
      }
    });
  }

  void resendOtp() {
    if (isResendEnabled) {
      CommonMethods.showToast("resend succesfully");

      widget.controller.login(widget.controller.widget.phone);
      startResendCooldown();
    }
  }

  @override
  Widget build(BuildContext context) {
    _resendRecognizer.onTap = isResendEnabled ? resendOtp : null;

    return Scaffold(
      backgroundColor: AppConfig.primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: backIconCl,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 100.0,
                  width: 100.0,
                ),
                Container(),
              ],
            ),
            const SizedBox(height: 24.0),
            const Center(
              child: AppTextView(
                text: 'Enter OTP',
                color: Colors.black,
                size: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Center(
              child: AppTextView(
                text:
                'Enter the 6-digit code that we have sent\non the +91-${widget.controller.widget.phone} ',
                color: const Color(0xff475467),
                size: 16.0,
                mTextAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),
            Pinput(
              controller: pinController,
              length: 6,
              enableSuggestions: false,
              autofillHints: [],
              defaultPinTheme: defaultPinTheme,
              onSubmitted: widget.controller.onSubmit,
              onCompleted: widget.controller.onSubmit,
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
            ),
            const SizedBox(height: 24.0),
            AppButton(
              onClick: widget.controller.otpVerify,
              text: 'Verify OTP',
            ),
            const SizedBox(height: 24.0),
            Center(
              child: AppRichText(
                textSpan: TextSpan(
                  children: [
                    TextSpan(
                      text: "Didn't receive the OTP? ",
                      style: GoogleFonts.montserrat(),
                    ),
                    TextSpan(
                      text: isResendEnabled
                          ? 'Resend'
                          : 'Resend in $_resendCountdown seconds',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: isResendEnabled ? AppConfig.primaryColor : Colors.grey,
                      ),
                      recognizer: _resendRecognizer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
