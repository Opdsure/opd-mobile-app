import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/custom_ui/login_scafold.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../custom_ui/app_text_view.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_var.dart';
import 'checkout_controller.dart';

class CheckoutPageView extends StatelessWidget{
  final CheckoutController controller;

  const CheckoutPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      enforceMobileMode: !OpdSure.of(context).client.isLogged,
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
                      SizedBox(
                        width: CommonMethods.deviceWidth(context)*0.8,
                        child: AppTextView(
                          text: controller.name,
                          color: Colors.black,
                          size: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF8A48B3),
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))
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
                          ),
                        ),
                      )
                    ],
                  ),

                  if(controller.widget.paymentType == PaymentType.buyPlan)...[
                    AppTextView(
                      text: '$rupeeSymbol ${controller.options!.charges!}/${CommonMethods.getPlanFrequency(controller.records!.frequency!, isBilled: false)}',
                      color: const Color(0xFF667085),
                    ),
                    const SizedBox(height: 15.0,),
                    const AppTextView(
                      text: 'Users',
                      color: Colors.black,
                      size: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    AppTextView(
                      text: controller.options!.membershipLabel!,
                      color: const Color(0xFF667085),
                    ),
                  ],


                ],
              ),
            ),
            const SizedBox(height: 15.0,),
            AppCardView(
              mChaild: Column(
                children: [
                  const Row(
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
                  const SizedBox(height: 15.0,),
                  // Plan Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextView(
                        text: 'Plan Charge',
                        color: Colors.black,
                        size: 16.0,
                      ),
                      AppTextView(
                        text: '$rupeeSymbol ${controller.planCharge.toStringAsFixed(2)}',
                        color: Colors.black,
                        size: 16.0,
                      ),
                    ],
                  ),
                  // Coupon discount
                  controller.couponDiscount == 0.0 ? Container() :Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextView(
                        text: 'Coupon discount',
                        color: Colors.black,
                        size: 16.0,
                      ),
                      AppTextView(
                        text: '$rupeeSymbol ${controller.couponDiscount.toStringAsFixed(2)}',
                        color: Colors.black,
                        size: 16.0,
                      ),
                    ],
                  ),
                  //GST
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextView(
                        text: 'GST(18)%',
                        color: Colors.black,
                        size: 16.0,
                      ),
                      AppTextView(
                        text: '$rupeeSymbol ${controller.gst.toStringAsFixed(2)}',
                        color: Colors.black,
                        size: 16.0,
                      ),
                    ],
                  ),
                  //net amount
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const AppTextView(
                  //       text: 'Net amount',
                  //       color: Colors.black,
                  //       size: 16.0,
                  //     ),
                  //     AppTextView(
                  //       text: '$rupeeSymbol ${controller.netAmount.toStringAsFixed(2)}',
                  //       color: Colors.black,
                  //       size: 16.0,
                  //     ),
                  //   ],
                  // ),
                  // // total amount
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const AppTextView(
                  //       text: 'Net amount(with GST)',
                  //       color: Colors.black,
                  //       size: 16.0,
                  //     ),
                  //     AppTextView(
                  //       text: '$rupeeSymbol ${controller.netAmountWithGst.toStringAsFixed(2)}',
                  //       color: Colors.black,
                  //       size: 16.0,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 10.0,),
                  const Divider(height: 1.0,color: Color(0xFFEAECF0),),
                  const SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextView(
                        text: 'Total Payment',
                        color: Colors.black,
                        size: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      AppTextView(
                        text: '$rupeeSymbol ${controller.netAmountWithGst.toStringAsFixed(2)}',
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
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const SizedBox(height: 30.0,),
            AppButton(text: 'Pay Now',
              onClick: controller.openPaymentGateway,
            )
         ],
        ),
      ),
    );
  }

}