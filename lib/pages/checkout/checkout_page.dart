import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';

import '../../custom_ui/app_text_view.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_var.dart';

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
            AppCardView(
              mChaild: Column(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: 'Number of Members',
                        color: Color(0xFF667085),
                      ),
                      Row(
                        children: [
                          AppRoundView(
                            mChild: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.remove,
                                color: Color(0xFF667085),
                              ),
                            ),
                            color: Color(0xFFF5F5F5),
                            corner: 5.0,
                          ),
                          SizedBox(width: 10.0,),
                          AppTextView(
                            text: '4',
                            size: 16.0,
                          ),
                          SizedBox(width: 10.0,),
                          AppRoundView(
                            mChild: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: Color(0xFF667085),
                              ),
                            ),
                            color: Color(0xFFF5F5F5),
                            corner: 5.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0,),
            AppCardView(
              mChaild: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: 'Payment Summary',
                        color: Colors.black,
                        size: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      Icon(Icons.keyboard_arrow_up)
                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: 'Plan Charge',
                        color: Color(0xFF667085),
                        size: 16.0,
                      ),
                      AppTextView(
                        text: '$rupeeSymbol 4000/mo',
                        color: Color(0xFF667085),
                        size: 16.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Divider(height: 1.0,color: Color(0xFFEAECF0),),
                  SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: 'Total Payment',
                        color: Colors.black,
                        size: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      AppTextView(
                        text: '$rupeeSymbol 4000/mo',
                        color: Colors.black,
                        size: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0,),
            AppCardView(
              mChaild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/coupon.png',
                            height: 20.0,
                          ),
                          const SizedBox(width: 10.0,),
                          const AppTextView(
                            text: 'Apply Coupon',
                            color: Colors.black,
                            size: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                  const SizedBox(height: 10.0,),
                  const AppTextView(
                    text: 'Use it and save up to $rupeeSymbol 500',
                    size: 12.0,
                    color: Color(0xFF667085),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30.0,),
            AppButton(text: 'Pay Now')
         ],
        ),
      ),
    );
  }

}