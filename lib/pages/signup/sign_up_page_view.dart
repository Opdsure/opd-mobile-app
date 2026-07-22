import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/pages/signup/signup_controller.dart';

import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_mobile_field.dart';

class SignUpView extends StatefulWidget {
  final SignUpController controller;

  const SignUpView(this.controller, {super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with TickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _floatController;

  late Animation<double> _bgFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _headerFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;
  late Animation<double> _bottomFade;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: const Interval(0.1, 0.45, curve: Curves.easeOutCubic),
    ));

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
      ),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: const Interval(0.35, 0.7, curve: Curves.easeOutCubic),
    ));

    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    _bottomFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _float = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _enterController.forward();
  }

  @override
  void dispose() {
    _enterController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppDesign.card,
      body: Stack(
        children: [
          // Background decorative shapes
          FadeTransition(
            opacity: _bgFade,
            child: Stack(
              children: [
                Positioned(
                  top: -60,
                  left: -80,
                  child: AnimatedBuilder(
                    animation: _float,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(_float.value * 0.4, -_float.value * 0.6),
                      child: child,
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppDesign.accent.withOpacity(0.07),
                            AppDesign.accent.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.3,
                  right: -80,
                  child: AnimatedBuilder(
                    animation: _float,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(-_float.value * 0.5, _float.value * 0.4),
                      child: child,
                    ),
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppDesign.primary.withOpacity(0.04),
                            AppDesign.primary.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spacing3Xl,
                ),
                child: SizedBox(
                  height: size.height - MediaQuery.of(context).padding.top - 40,
                  child: Column(
                    children: [
                      const SizedBox(height: AppDesign.spacingLg),

                      // Back button
                      SlideTransition(
                        position: _headerSlide,
                        child: FadeTransition(
                          opacity: _headerFade,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                if (context.canPop()) context.pop();
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppDesign.surface,
                                  borderRadius:
                                      BorderRadius.circular(AppDesign.radiusMd),
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
                      ),

                      const Spacer(flex: 1),

                      // Header section
                      SlideTransition(
                        position: _headerSlide,
                        child: FadeTransition(
                          opacity: _headerFade,
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _float,
                                builder: (context, child) =>
                                    Transform.translate(
                                  offset: Offset(0, _float.value * 0.4),
                                  child: child,
                                ),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: AppDesign.accentGradient,
                                    borderRadius: BorderRadius.circular(
                                        AppDesign.radiusXxl),
                                    boxShadow: AppDesign.shadowGlow,
                                  ),
                                  padding:
                                      const EdgeInsets.all(AppDesign.spacingLg),
                                  child: Image.asset(
                                    'assets/images/app_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDesign.spacingXxl),
                              const Text(
                                'Create Account',
                                style: AppDesign.headingLg,
                              ),
                              const SizedBox(height: AppDesign.spacingSm),
                              Text(
                                'Join us and start your wellness journey',
                                style: AppDesign.bodyLg.copyWith(
                                  color: AppDesign.textTertiary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // Form Card
                      SlideTransition(
                        position: _cardSlide,
                        child: FadeTransition(
                          opacity: _cardFade,
                          child: Container(
                            padding: const EdgeInsets.all(AppDesign.spacingXxl),
                            decoration: BoxDecoration(
                              color: AppDesign.card,
                              borderRadius:
                                  BorderRadius.circular(AppDesign.radiusXxl),
                              border: Border.all(
                                color: AppDesign.divider.withOpacity(0.5),
                              ),
                              boxShadow: AppDesign.shadowLg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Label
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppDesign.accent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: AppDesign.spacingSm),
                                    Text(
                                      'MOBILE NUMBER',
                                      style: AppDesign.caption.copyWith(
                                        color: AppDesign.textTertiary,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDesign.spacingLg),

                                // Phone input
                                AppMobileField(
                                  hint: 'Enter your number',
                                  countryCode: widget.controller.countryCode,
                                  flagUri: widget.controller.flagUri,
                                  focusNode: widget.controller.focusNode,
                                  textEditingController:
                                      widget.controller.phoneTextController,
                                  errorMessage: widget.controller.phoneError,
                                  showErrorMessage:
                                      widget.controller.isShowErrorMobile,
                                  mOnChanged: widget.controller.onChanged,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  countryCallback: () =>
                                      widget.controller.getCountryCode(),
                                ),

                                const SizedBox(height: AppDesign.spacingXl),

                                // Terms checkbox
                                GestureDetector(
                                  onTap: () => widget.controller
                                      .onTermAndConditions(!widget
                                          .controller.isTermAndConditions),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: AppDesign.animFast,
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: widget.controller
                                                  .isTermAndConditions
                                              ? AppDesign.accent
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: widget.controller
                                                    .isTermAndConditions
                                                ? AppDesign.accent
                                                : AppDesign.inputBorder,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: widget
                                                .controller.isTermAndConditions
                                            ? const Icon(
                                                Icons.check_rounded,
                                                size: 14,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(
                                          width: AppDesign.spacingMd),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => context.push(
                                              '/signup/terms',
                                              extra: 'SIGNUP'),
                                          child: RichText(
                                            text: TextSpan(
                                              style: AppDesign.bodyMd.copyWith(
                                                color: AppDesign.textSecondary,
                                              ),
                                              children: [
                                                const TextSpan(
                                                    text: 'I agree to the '),
                                                TextSpan(
                                                  text: 'Terms & Conditions',
                                                  style: AppDesign.titleMd
                                                      .copyWith(
                                                    color: AppDesign.accent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: AppDesign.spacingXxl),

                                // Button
                                AppButton(
                                  text: 'Get Started',
                                  isLoading: widget.controller.loading,
                                  onClick: () => widget.controller.register(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // Bottom section
                      FadeTransition(
                        opacity: _bottomFade,
                        child: Column(
                          children: [
                            // Gradient divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppDesign.divider.withOpacity(0),
                                          AppDesign.divider,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDesign.spacingXl,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: AppDesign.caption.copyWith(
                                      letterSpacing: 1.5,
                                      color: AppDesign.textTertiary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppDesign.divider,
                                          AppDesign.divider.withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDesign.spacingXxl),
                            RichText(
                              text: TextSpan(
                                style: AppDesign.bodyMd.copyWith(
                                  color: AppDesign.textSecondary,
                                ),
                                children: [
                                  const TextSpan(
                                      text: 'Already have an account?  '),
                                  TextSpan(
                                    text: 'Log In',
                                    style: AppDesign.titleMd.copyWith(
                                      color: AppDesign.accent,
                                    ),
                                    recognizer:
                                        widget.controller.loginRecognizer,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
