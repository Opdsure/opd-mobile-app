import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';

class ClaimsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            const SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    AppTextView(
                      text: 'Claims',
                      size: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    )
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/wallet_icon.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                    const SizedBox(width: 15.0,),
                    Image.asset(
                      'assets/images/bell_icon.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}