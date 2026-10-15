import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/widget/opd_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2500), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final opd = OpdSure.of(context);
    final hasSeenOnboarding = opd.store.getBool(AppKey.onBoardScreen) ?? false;

    if (hasSeenOnboarding) {
      if (opd.client.isLogged) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    } else {
      context.go('/on_board_screen');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 260,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
