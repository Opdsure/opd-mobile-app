import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_header.dart';

import '../custom_ui/app_text_view.dart';
import '../utils/app_colors.dart';
import '../utils/app_var.dart';

class CheckoutPage extends StatelessWidget{
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
            AppHeader(headerName: 'Checkout',),
            const SizedBox(height: 24.0,),
            const AppTextView(
              text: 'Plan Summary',
              color: Colors.black,
              size: 18.0,
              fontWeight: FontWeight.w600,
            ),
            Container(
              width: 342,
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F101828).withOpacity(0.05), // Adjust opacity if necessary
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color(0x1A101828).withOpacity(0.05), // Adjust opacity if necessary
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextView(
                        text: 'Health Plan',
                        color: Colors.black,
                        size: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF8A48B3),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: AppTextView(
                                text: 'Change Plan',
                                size: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8A48B3),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                  const AppTextView(
                    text: '$rupeeSymbol 1000/mo',
                    color: Color(0xFF667085),
                  ),
                  const SizedBox(height: 15.0,),
                  const AppTextView(
                    text: 'Users',
                    color: Colors.black,
                    size: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  const Row(
                    children: [
                      AppTextView(
                        text: 'Number of Members',
                        color: Color(0xFF667085),
                      ),

                    ],
                  ),
                ],
              ),
            )
         ],
        ),
      ),
    );
  }

}