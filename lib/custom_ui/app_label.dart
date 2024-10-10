import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_rich_text.dart';

class AppLabel extends StatelessWidget{
  final String? label;
  final bool isCompulsory;
  AppLabel({
   this.label,
   this.isCompulsory = false,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppRichText(
      textSpan: TextSpan(
        children: [
          TextSpan(
              text: label,
              style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D2939)
              )),
          TextSpan(
            text: isCompulsory?' *':'',
            style: GoogleFonts.montserrat(
                color: Colors.red),
          ),
        ],
      ),
    );
  }

}