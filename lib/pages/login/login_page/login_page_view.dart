import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/pages/login/login_page/login_controller.dart';

import '../../../custom_ui/app_button.dart';
import '../../../custom_ui/app_mobile_field.dart';

class LoginView extends StatefulWidget {
  final LoginPageController controller;

  const LoginView(this.controller, {super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _floatController;

  late Animation<double> _bgFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _logoFade;
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

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: const Interval(0.1, 0.45, curve: Curves.easeOutCubic),
    ));

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
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
                  top: -80,
                  right: -60,
                  child: AnimatedBuilder(
                    animation: _float,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, _float.value),
                      child: child,
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppDesign.accent.withOpacity(0.08),
                            AppDesign.accent.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.25,
                  left: -100,
                  child: AnimatedBuilder(
                    animation: _float,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, -_float.value * 0.7),
                      child: child,
                    ),
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppDesign.primary.withOpacity(0.05),
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
                      const Spacer(flex: 2),

                      // Logo Section
                      SlideTransition(
                        position: _logoSlide,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _float,
                                builder: (context, child) =>
                                    Transform.translate(
                                  offset: Offset(0, _float.value * 0.5),
                                  child: child,
                                ),
                                child: Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    gradient: AppDesign.heroGradient,
                                    borderRadius: BorderRadius.circular(
                                        AppDesign.radiusXxl),
                                    boxShadow: AppDesign.shadowXl,
                                  ),
                                  padding:
                                      const EdgeInsets.all(AppDesign.spacingLg),
                                  child: Image.asset(
                                    'assets/images/app_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDesign.spacing3Xl),
                              Text(
                                'Welcome Back',
                                style: AppDesign.headingLg.copyWith(
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: AppDesign.spacingSm),
                              Text(
                                'Sign in to access your healthcare benefits',
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

                      // Input Card
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
                                AppMobileField(
                                  hint: 'Enter your number',
                                  countryCode: widget.controller.countryCode,
                                  flagUri: widget.controller.flagUri,
                                  focusNode: widget.controller.focusNode,
                                  textEditingController:
                                      widget.controller.phoneTextController,
                                  errorMessage: widget.controller.phoneError,
                                  showErrorMessage:
                                      widget.controller.isMobileError,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  countryCallback: () =>
                                      widget.controller.getCountryCode(),
                                ),
                                const SizedBox(height: AppDesign.spacingXxl),
                                AppButton(
                                  text: 'Continue',
                                  isLoading: widget.controller.loading,
                                  onClick: () => widget.controller
                                      .login(widget.controller),
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
                                      text: "Don\u2019t have an account?  "),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: AppDesign.titleMd.copyWith(
                                      color: AppDesign.accent,
                                    ),
                                    recognizer:
                                        widget.controller.signupRecognizer,
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
