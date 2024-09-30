import 'package:flutter/material.dart';

import '../../custom_ui/app_text_view.dart';
import 'home_page.dart';

class HomeServiceTile extends StatelessWidget {
  final int index;
  final VoidCallback onTap;
  final double width;
  final double height;
  final OpdService title;

  const HomeServiceTile(
      {required this.title,
      required this.index,
      required this.width,
      required this.height,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              customBorder: const CircleBorder(),
               onTap: onTap,
              child: Material(
                type: MaterialType.card,
                shape: const CircleBorder(),
                elevation: 2,
                color: Colors.white,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          HomePage.serviceTittle(context)[index].image,
                        ),
                        fit: BoxFit.contain,
                      ),
                      shape: BoxShape.circle),
                ),
              ),
            ),
            AppTextView(
              text: title.title,
              mTextAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
              size: 12,
            )
          ],
        ),
      ),
    );
  }
}
