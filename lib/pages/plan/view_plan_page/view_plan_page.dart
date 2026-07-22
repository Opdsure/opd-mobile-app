import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';

class ViewPlanPageView extends StatefulWidget {
  final ViewPlansPageController controller;

  const ViewPlanPageView(this.controller, {super.key});

  @override
  State<ViewPlanPageView> createState() => _ViewPlanPageViewState();
}

class _ViewPlanPageViewState extends State<ViewPlanPageView>
    with TickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;

  late Animation<double> _logoFade;
  late Animation<double> _illustrationScale;
  late Animation<double> _illustrationFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _ctaFade;
  late Animation<double> _ctaScale;
  late Animation<double> _float;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );

    _illustrationScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.1, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _illustrationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
    ));

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.4, 0.65, curve: Curves.easeOut),
      ),
    );

    _ctaFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.65, 0.9, curve: Curves.easeOut),
      ),
    );

    _ctaScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _float = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _shimmer = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    _enterController.forward();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) _shimmerController.repeat();
    });
  }

  @override
  void dispose() {
    _enterController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.card,
      body: Stack(
        children: [
          // Background blobs
          _buildBackgroundShapes(),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spacing3Xl,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppDesign.spacingXxl),

                  // Logo
                  FadeTransition(
                    opacity: _logoFade,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppDesign.accentSoft,
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusMd),
                          ),
                          padding: const EdgeInsets.all(AppDesign.spacingMd),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: AppDesign.spacingMd),
                        const Text(
                          'OPDSure',
                          style: TextStyle(
                            fontFamily: AppDesign.fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppDesign.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Floating Illustration
                  AnimatedBuilder(
                    animation: _float,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, _float.value),
                      child: child,
                    ),
                    child: ScaleTransition(
                      scale: _illustrationScale,
                      child: FadeTransition(
                        opacity: _illustrationFade,
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 240),
                          child: Image.asset(
                            'assets/images/view_plans.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Text
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          const Text(
                            'Your Health,\nOur Priority',
                            style: AppDesign.headingLg,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDesign.spacingLg),
                          Text(
                            'Get unlimited doctor consultations, pharmacy discounts, and comprehensive health coverage.',
                            style: AppDesign.bodyLg.copyWith(
                              color: AppDesign.textTertiary,
                              height: 1.7,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // CTA Button with shimmer
                  FadeTransition(
                    opacity: _ctaFade,
                    child: ScaleTransition(
                      scale: _ctaScale,
                      child: _buildShimmerButton(),
                    ),
                  ),

                  const SizedBox(height: AppDesign.spacing5Xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundShapes() {
    return FadeTransition(
      opacity: _logoFade,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -80,
            child: AnimatedBuilder(
              animation: _float,
              builder: (context, child) => Transform.translate(
                offset: Offset(_float.value * 0.3, -_float.value * 0.5),
                child: child,
              ),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppDesign.accent.withOpacity(0.06),
                      AppDesign.accent.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: -60,
            child: AnimatedBuilder(
              animation: _float,
              builder: (context, child) => Transform.translate(
                offset: Offset(-_float.value * 0.4, _float.value * 0.3),
                child: child,
              ),
              child: Container(
                width: 180,
                height: 180,
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
    );
  }

  Widget _buildShimmerButton() {
    return GestureDetector(
      onTap: () => widget.controller.selectPlans(context),
      child: Container(
        width: double.infinity,
        height: 60,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: AppDesign.heroGradient,
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          boxShadow: AppDesign.shadowXl,
        ),
        child: Stack(
          children: [
            // Shimmer overlay
            AnimatedBuilder(
              animation: _shimmer,
              builder: (context, child) {
                return Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    alignment: Alignment(_shimmer.value, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Button content
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Explore Plans',
                    style: AppDesign.button.copyWith(
                      fontSize: 17,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: AppDesign.spacingMd),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                    ),
                    child: const Icon(
                      Icons.east_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
