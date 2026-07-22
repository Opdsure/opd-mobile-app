import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'dart:async';

import 'package:opdsure/config/app_design_system.dart';
import '../../custom_ui/app_button.dart';
import '../../utils/common_methods.dart';
import 'otp_page_controller.dart';

class OtpPageView extends StatefulWidget {
  final OtpPageController controller;

  const OtpPageView(this.controller, {super.key});

  @override
  State<OtpPageView> createState() => _OtpPageViewState();
}

class _OtpPageViewState extends State<OtpPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _enterController;
  late Animation<double> _headerFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;

  final defaultPinTheme = PinTheme(
    width: 48,
    height: 54,
    textStyle: const TextStyle(
      fontFamily: AppDesign.fontFamily,
      fontSize: 22,
      color: AppDesign.textPrimary,
      fontWeight: FontWeight.w700,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      color: AppDesign.inputFill,
      border: Border.all(color: AppDesign.inputBorder, width: 1.5),
    ),
  );

  PinTheme get focusedPinTheme => defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          color: AppDesign.card,
          border: Border.all(color: AppDesign.accent, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppDesign.accent.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      );

  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final SmartAuth smartAuth = SmartAuth();

  bool isResendEnabled = false;
  Timer? _resendTimer;
  int _resendCountdown = 60;
  final TapGestureRecognizer _resendRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));

    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _enterController.forward();
    startSmsListener();
    startResendCooldown();
  }

  @override
  void dispose() {
    _enterController.dispose();
    pinController.dispose();
    focusNode.dispose();
    smartAuth.removeSmsListener();
    _resendTimer?.cancel();
    _resendRecognizer.dispose();
    super.dispose();
  }

  void startSmsListener() async {
    try {
      final appSignature = await smartAuth.getAppSignature();
      debugPrint('App Signature: $appSignature');
      smartAuth.getSmsCode(useUserConsentApi: true).then((result) {
        if (result.succeed && result.codeFound) {
          pinController.text = result.code!;
        }
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
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
        setState(() => isResendEnabled = true);
      }
    });
  }

  void resendOtp() {
    if (isResendEnabled) {
      CommonMethods.showToast("OTP sent successfully");
      widget.controller.login(widget.controller.widget.phone);
      startResendCooldown();
    }
  }

  @override
  Widget build(BuildContext context) {
    _resendRecognizer.onTap = isResendEnabled ? resendOtp : null;

    return Scaffold(
      backgroundColor: AppDesign.card,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDesign.spacing3Xl),
          child: Column(
            children: [
              const SizedBox(height: AppDesign.spacingLg),

              // Back button
              FadeTransition(
                opacity: _headerFade,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppDesign.surface,
                        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                        border: Border.all(
                          color: AppDesign.divider.withOpacity(0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppDesign.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Header
              FadeTransition(
                opacity: _headerFade,
                child: Column(
                  children: [
                    // Lock icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppDesign.accentLight,
                        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppDesign.accent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spacingXxl),
                    const Text('Verify OTP', style: AppDesign.headingLg),
                    const SizedBox(height: AppDesign.spacingSm),
                    Text(
                      'Enter the 6-digit code sent to\n+91-${widget.controller.widget.phone}',
                      style: AppDesign.bodyLg.copyWith(
                        color: AppDesign.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // PIN input + Button
              SlideTransition(
                position: _cardSlide,
                child: FadeTransition(
                  opacity: _cardFade,
                  child: Column(
                    children: [
                      Pinput(
                        controller: pinController,
                        length: 6,
                        enableSuggestions: false,
                        autofillHints: const [],
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        onSubmitted: widget.controller.onSubmit,
                        onCompleted: widget.controller.onSubmit,
                        separatorBuilder: (_) =>
                            const SizedBox(width: AppDesign.spacingSm),
                      ),
                      const SizedBox(height: AppDesign.spacing3Xl),
                      AppButton(
                        text: 'Verify OTP',
                        onClick: widget.controller.otpVerify,
                      ),
                      const SizedBox(height: AppDesign.spacingXxl),

                      // Resend
                      RichText(
                        text: TextSpan(
                          style: AppDesign.bodyMd.copyWith(
                            color: AppDesign.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: "Didn't receive the OTP? "),
                            TextSpan(
                              text: isResendEnabled
                                  ? 'Resend'
                                  : 'Resend in ${_resendCountdown}s',
                              style: AppDesign.titleMd.copyWith(
                                color: isResendEnabled
                                    ? AppDesign.accent
                                    : AppDesign.textTertiary,
                              ),
                              recognizer: _resendRecognizer,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
