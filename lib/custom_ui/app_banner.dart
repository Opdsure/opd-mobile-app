import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  final GestureTapCallback onTap;
  const AppBanner({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
            child: Image.asset('assets/images/doctor-con-banner.png')),
      ),
    );
  }
}
