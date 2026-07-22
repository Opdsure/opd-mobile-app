import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_edit_text.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../custom_ui/app_button.dart';
import '../../utils/app_var.dart';
import 'checkout_controller.dart';

class CheckoutPageView extends StatefulWidget {
  final CheckoutController controller;

  const CheckoutPageView(this.controller, {super.key});

  @override
  State<CheckoutPageView> createState() => _CheckoutPageViewState();
}

class _CheckoutPageViewState extends State<CheckoutPageView>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late Animation<double> _summaryFade;
  late Animation<Offset> _summarySlide;
  late Animation<double> _paymentFade;
  late Animation<Offset> _paymentSlide;
  late Animation<double> _couponFade;
  late Animation<double> _buttonScale;
  late Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _summaryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _summarySlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
    ));

    _paymentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    _paymentSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.2, 0.55, curve: Curves.easeOutCubic),
    ));

    _couponFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    _buttonScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;

    return AppBasePage(
      appHeader: const AppHeader(headerName: 'Checkout'),
      childContent: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: AppDesign.spacingXl),

          // Plan Summary Card
          SlideTransition(
            position: _summarySlide,
            child: FadeTransition(
              opacity: _summaryFade,
              child: _buildPlanSummary(ctrl),
            ),
          ),

          const SizedBox(height: AppDesign.spacingLg),

          // Payment Summary Card
          SlideTransition(
            position: _paymentSlide,
            child: FadeTransition(
              opacity: _paymentFade,
              child: _buildPaymentSummary(ctrl),
            ),
          ),

          const SizedBox(height: AppDesign.spacingLg),

          // Coupon Section
          FadeTransition(
            opacity: _couponFade,
            child: _buildCouponSection(ctrl),
          ),

          const SizedBox(height: AppDesign.spacing3Xl),

          // Pay Now Button
          FadeTransition(
            opacity: _buttonFade,
            child: ScaleTransition(
              scale: _buttonScale,
              child: _buildPayButton(ctrl),
            ),
          ),

          const SizedBox(height: AppDesign.spacing3Xl),
        ],
      ),
    );
  }

  Widget _buildPlanSummary(CheckoutController ctrl) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spacingXl),
      decoration: BoxDecoration(
        gradient: AppDesign.heroGradient,
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        boxShadow: AppDesign.shadowXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Plan',
                      style: AppDesign.bodySm.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: AppDesign.spacingXs),
                    Text(
                      ctrl.name,
                      style: AppDesign.headingSm.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spacingMd,
                    vertical: AppDesign.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'Change',
                    style: AppDesign.labelSm.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (ctrl.widget.paymentType != PaymentType.buyHealthCheckup) ...[
            const SizedBox(height: AppDesign.spacingLg),
            Container(
              padding: const EdgeInsets.all(AppDesign.spacingMd),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: AppDesign.spacingMd),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctrl.options!.membershipLabel!,
                        style: AppDesign.titleMd.copyWith(color: Colors.white),
                      ),
                      Text(
                        '$rupeeSymbol ${CommonMethods.amountFormater(ctrl.options!.charges!.toStringAsFixed(0))}/${CommonMethods.getPlanFrequency(ctrl.records!.frequency!, isBilled: false)}',
                        style: AppDesign.bodySm.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(CheckoutController ctrl) {
    return AppCardView(
      padding: const EdgeInsets.all(AppDesign.spacingXl),
      shadow: AppDesign.shadowMd,
      borderRadius: AppDesign.radiusXl,
      mChaild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppDesign.accentLight,
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppDesign.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              const Text('Payment Summary', style: AppDesign.titleLg),
            ],
          ),

          const SizedBox(height: AppDesign.spacingXl),

          // Line items
          _buildLineItem('Plan Base Price',
              '$rupeeSymbol ${CommonMethods.amountFormater(ctrl.planCharge.toStringAsFixed(2), isDouble: true)}'),

          if (ctrl.couponDiscount != 0.0)
            _buildLineItem(
              'Coupon Discount',
              '-$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, ctrl.couponDiscount.toStringAsFixed(2))}',
              valueColor: AppDesign.success,
            ),

          if (ctrl.previousDiscount != 0.0)
            _buildLineItem(
              'Previous Paid',
              '-$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, ctrl.previousDiscount.toStringAsFixed(2))}',
              valueColor: AppDesign.success,
            ),

          if (ctrl.previousDiscount != 0.0)
            _buildLineItem('Net Amount',
                '$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, ctrl.netAmount.toStringAsFixed(2))}'),

          _buildLineItem('GST (18%)',
              '$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, roundOff: true, ctrl.gst.toStringAsFixed(2))}'),

          const SizedBox(height: AppDesign.spacingMd),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppDesign.divider.withOpacity(0),
                  AppDesign.divider,
                  AppDesign.divider.withOpacity(0),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDesign.spacingMd),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: AppDesign.titleLg),
              Text(
                '$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, roundOff: true, ctrl.netAmountWithGst.toStringAsFixed(2))}',
                style: AppDesign.headingSm.copyWith(color: AppDesign.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineItem(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppDesign.bodyMd),
          Text(
            value,
            style: AppDesign.titleMd.copyWith(
              color: valueColor ?? AppDesign.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection(CheckoutController ctrl) {
    return AppCardView(
      padding: const EdgeInsets.all(AppDesign.spacingXl),
      shadow: AppDesign.shadowSm,
      borderRadius: AppDesign.radiusXl,
      mChaild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppDesign.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                ),
                child: Icon(
                  Icons.local_offer_outlined,
                  color: AppDesign.warning,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              const Text('Have a Coupon?', style: AppDesign.titleLg),
            ],
          ),
          const SizedBox(height: AppDesign.spacingLg),
          Row(
            children: [
              Expanded(
                child: AppEditText(
                  hint: 'Enter coupon code',
                  textEditingController: ctrl.couponCtrl,
                ),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              SizedBox(
                width: 100,
                child: AppButton(
                  text: 'Apply',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                  fullWidth: true,
                  onClick: () => ctrl.dataAfterApplyCoupon(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(CheckoutController ctrl) {
    return GestureDetector(
      onTap: ctrl.openPaymentGateway,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppDesign.heroGradient,
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          boxShadow: AppDesign.shadowXl,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppDesign.radiusSm),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppDesign.spacingMd),
            Text(
              'Pay $rupeeSymbol${CommonMethods.amountFormater(isDouble: true, roundOff: true, ctrl.netAmountWithGst.toStringAsFixed(2))}',
              style: AppDesign.button.copyWith(fontSize: 17),
            ),
            const SizedBox(width: AppDesign.spacingSm),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
