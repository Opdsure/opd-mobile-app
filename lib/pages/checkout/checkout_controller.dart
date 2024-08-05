import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/checkout/checkout_page_view.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../model/coupon_model.dart';

enum PaymentType { buyPlan, buyHealthCheckup }

class CheckoutPage extends StatefulWidget {
  final HealthCheckupRecords? healthCheckupRecords;
  final PlanRecords? records;
  final MembershipOptions? options;
  final PaymentType paymentType;

  const CheckoutPage(
      {required this.paymentType,
      this.healthCheckupRecords,
      this.records,
      this.options,
      super.key});

  @override
  State<CheckoutPage> createState() => CheckoutController();
}

class CheckoutController extends State<CheckoutPage> {
  PlanRecords? records;
  MembershipOptions? options;
  HealthCheckupRecords? healthCheckupRecords;
  double planCharge = 0.0;
  double couponDiscount = 0.0;
  double gst = 0.0;
  double netAmount = 0.0;
  double netAmountWithGst = 0.0;
  String payAmount = '';
  String name = '';
  TextEditingController couponCtrl = TextEditingController();
  String myRequest = '';

  @override
  void initState() {
    super.initState();
    records = widget.records;
    options = widget.options;
    healthCheckupRecords = widget.healthCheckupRecords;
    if (widget.paymentType == PaymentType.buyPlan) {
      myRequest = 'basic_plan';
      getPlanSummary();
    } else {
      myRequest = 'health';
      getHealthCheckUp();
    }
  }

  void getHealthCheckUp() {
    name = healthCheckupRecords!.name!;
    planCharge = healthCheckupRecords!.discountedPrice!.toDouble();
    // couponDiscount = double.parse(healthCheckupRecords!.basePrice!.toString()) -
    //     double.parse(healthCheckupRecords!.discountedPrice!.toString());
    gst = planCharge * 18 / 100;
    // netAmount = double.parse(healthCheckupRecords!.discountedPrice!.toString());
    netAmountWithGst = planCharge + gst;
    payAmount = (netAmountWithGst * 100).toString();
  }

  void getPlanSummary() {
    name = records!.name!;
    planCharge = double.parse(options!.charges!.toString());
    gst = planCharge * 18 / 100;
    netAmount = planCharge - couponDiscount;
    netAmountWithGst = netAmount + gst;
    payAmount = (netAmountWithGst * 100).toString();
  }

  dataAfterApplyCoupon() async {
    var response = await OpdSure.of(context).client.applyCoupon(
      couponCtrl.text,
        myRequest=='basic_plan'?records!.id!:healthCheckupRecords!.id!,
        options==null?'':'${options!.membershipId}',
      requestFor: myRequest
    );
    CouponModel couponModel = CouponModel.fromJson(jsonDecode(response));
    setState(() {
      gst = double.parse('${couponModel.data!.gst!}');
      couponDiscount = double.parse('${couponModel.data!.couponDiscount!}');
      planCharge = double.parse('${couponModel.data!.planPrice!}');
      netAmount = planCharge - couponDiscount;
      netAmountWithGst = netAmount + gst;
      print(response);
    });
  }

  void openPaymentGateway() async {
    if(netAmountWithGst<=0){
      // CommonMethods.showToast('Amt. should be greater then 0');
      final opd = OpdSure.of(context);
      await opd.client.updateUserProfile(plan: {
        "purchased": true,
        "membership_id": options!.membershipId!,
        "id": records!.id!
      });
      await opd.client.updatePlanPurchasedStatus(true);
      opd.client.createOrder(
          type: widget.paymentType.index,
          couponCode: couponCtrl.text,
          planId: widget.paymentType == PaymentType.buyPlan ? records?.id! : null,
          membershipId: widget.paymentType == PaymentType.buyPlan ? options?.membershipId! : null,
          // healthId: widget.paymentType == PaymentType.buyPlan ? null : healthCheckupRecords?.id!,
          healthPlanId: widget.paymentType == PaymentType.buyHealthCheckup ? healthCheckupRecords?.id! : null
      ).then((value){
        CommonMethods.showToast('Plan purchased successfully!');
        context.pushReplacement('/home/view_plans/add_members');
      });

    }
    else{
      final opd = OpdSure.of(context);
      if (PlatformInfos.isWeb) {
        final opd = OpdSure.of(context);
        await opd.client.updateUserProfile(plan: {
          "purchased": true,
          "membership_id": options!.membershipId!,
          "id": records!.id!
        });
        await opd.client.updatePlanPurchasedStatus(true);
        context.go('/home/view_plans/add_members');
        return;
      }
      UserProfile? profile = await opd.client.getProfile();
      CommonMethods.showAlertDialog(context);
      final createPaymentResponse = await opd.client.createOrder(
          type: widget.paymentType.index,
          couponCode: couponCtrl.text,
          planId: widget.paymentType == PaymentType.buyPlan ? records?.id! : null,
          membershipId: widget.paymentType == PaymentType.buyPlan ? options?.membershipId! : null,
          // healthId: widget.paymentType == PaymentType.buyPlan ? null : healthCheckupRecords?.id!,
          healthPlanId: widget.paymentType == PaymentType.buyHealthCheckup ? healthCheckupRecords?.id! : null
      );

      Razorpay razorpay = Razorpay();
      var paymentOptions = {
        'key': 'rzp_test_sXPx4ftQc94AZA',
        'amount': createPaymentResponse!.data!.amount!,
        'currency': createPaymentResponse.data!.currency!,
        'name': 'OPD Sure',
        'order_id': createPaymentResponse.data!.id,
        'description': widget.paymentType == PaymentType.buyPlan ? '${records!.name!} + ${options!.membershipLabel!}' : healthCheckupRecords!.name!,
        'retry': {'enabled': false, 'max_count': 1},
        'send_sms_hash': true,
        'model': {
          'backdropclose': false,
          'escape': false,
          'handleback': true,
          'confirm_close': true
        },
        'prefill': {
          'contact': "+91${profile.data!.phone!}",
          "email": profile.data!.email!,
          "name": profile.data!.name!
        }
      };
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentErrorResponse);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
      razorpay.open(paymentOptions);
      Navigator.of(context).pop();
    }
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) async {
    _showAlertDialog(context, "Failed", 'You cancel the payment');
  }

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    final opd = OpdSure.of(context);
     await opd.client.updateUserProfile(plan: {
      "purchased": false,
      "membership_id": options!.membershipId!,
      "id": records!.id!
    });

    final verificationResponse = await opd.client
        .verifyOrder(response.orderId, response.paymentId, response.signature);
    if (verificationResponse!.success!) {
      await opd.client.updatePlanPurchasedStatus(true);
      context.pushReplacement('/home/view_plans/add_members');
    } else {
      _showAlertDialog(
          context, "Payment Failed", verificationResponse.message!);
    }
  }

  void _handleExternalWalletSelected(ExternalWalletResponse response) async {
    _showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [continueButton],
    );
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) => CheckoutPageView(this);
}
