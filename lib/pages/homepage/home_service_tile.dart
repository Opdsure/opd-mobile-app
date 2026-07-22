import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

import 'home_page.dart';

class HomeServiceTile extends StatefulWidget {
  final int index;
  final VoidCallback onTap;
  final double width;
  final double height;
  final OpdService title;

  const HomeServiceTile({
    super.key,
    required this.title,
    required this.index,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  State<HomeServiceTile> createState() => _HomeServiceTileState();
}

class _HomeServiceTileState extends State<HomeServiceTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppDesign.spacingMd),
          decoration: BoxDecoration(
            color: AppDesign.card,
            borderRadius: BorderRadius.circular(AppDesign.radiusLg),
            boxShadow: AppDesign.shadowSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppDesign.accentLight,
                  borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                  child: Image.asset(
                    HomePage.serviceTittle(context)[widget.index].image,
                    fit: BoxFit.contain,
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
              const SizedBox(height: AppDesign.spacingSm),
              Text(
                widget.title.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppDesign.labelSm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppDesign.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
