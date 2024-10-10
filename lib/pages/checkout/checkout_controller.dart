import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/checkout/checkout_page_view.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_sure_app.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../model/coupon_model.dart';

enum PaymentType { buyPlan, buyHealthCheckup, planUpgrade, planRenew }

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
  double previousDiscount = 0.0;
  double gst = 0.0;
  double netAmount = 0.0;
  double netAmountWithGst = 0.0;
  String payAmount = '';
  String name = '';
  int consumeDays = 0;
  int remainDays = 0;
  TextEditingController couponCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    records = widget.records;
    options = widget.options;
    healthCheckupRecords = widget.healthCheckupRecords;
    dataAfterApplyCoupon();
    if (widget.paymentType != PaymentType.buyHealthCheckup) {
      getPlanSummary();
    } else {
      getHealthCheckUp();
    }
  }

  void getHealthCheckUp() {
    name = healthCheckupRecords!.name!;
    planCharge = healthCheckupRecords!.discountedPrice!.toDouble();
    gst = planCharge * 18 / 100;
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
    var response = await OpdSure.of(context).client.applyCoupon(couponCtrl.text,
        widget.paymentType != PaymentType.buyHealthCheckup
            ? records!.id!
            : healthCheckupRecords!.id!,
        options == null ? '' : options!.membershipId.toString(),
        widget.paymentType);
    CouponModel couponModel = CouponModel.fromJson(jsonDecode(response));
    setState(() {
      gst = double.parse('${couponModel.data!.gst!}');
      couponDiscount = double.parse('${couponModel.data!.couponDiscount!}');
      previousDiscount = double.parse(couponModel.data!.preDiscount!.toString());
      planCharge = double.parse('${couponModel.data!.planPrice!}');
      netAmount = planCharge - couponDiscount - previousDiscount;
      netAmountWithGst = netAmount + gst;
      consumeDays = couponModel.data!.consumedDays!;
      remainDays = couponModel.data!.remainingDays!;
    });
  }

  void openPaymentGateway() async {
    final opd = OpdSure.of(context);
    UserProfile? profile = await opd.client.getProfile();
    CommonMethods.showAlertDialog(context);

    final createPaymentResponse = await opd.client.createOrder(
        type: widget.paymentType,
        couponCode: couponCtrl.text,
        planId: widget.paymentType != PaymentType.buyHealthCheckup
            ? records?.id!
            : null,
        membershipId: widget.paymentType != PaymentType.buyHealthCheckup
            ? options?.membershipId!
            : null,
        healthPlanId: widget.paymentType == PaymentType.buyHealthCheckup
            ? healthCheckupRecords?.id!
            : null);

    if (createPaymentResponse!.success!) {
      if (netAmountWithGst == 0.0) {
        CommonMethods.showToast(
            widget.paymentType != PaymentType.buyHealthCheckup
                ? 'Plan purchased successfully!'
                : 'Health checkup purchased successfully!');
        await opd.client.getProfile(update: true);
        if (widget.paymentType == PaymentType.buyPlan) {
          final member = await OpdSure.of(context).client.getFamilyMember(update: true);
          if(member!.data!.length > 0){
            context.go('/home/add-members', extra: {"isUpdate" : true,  "isAddingFirstMember" : true, "member" : member.data![0]});
            await OpdSure.of(context).client.getProfile(update: true);
          }else{
            context.go('/home/add-members', extra: {"isUpdate" : false,  "isAddingFirstMember" : true});
          }
        } else {
          context.go('/home');
        }
      } else {
        Razorpay razorpay = Razorpay();
        var paymentOptions = {
          'key': 'rzp_test_sXPx4ftQc94AZA',
          'amount': createPaymentResponse.data!.amount!,
          'currency': createPaymentResponse.data!.currency!,
          'name': 'OPD Sure',
          'order_id': createPaymentResponse.data!.id,
          'description': widget.paymentType != PaymentType.buyHealthCheckup
              ? '${records!.name!} + ${options!.membershipLabel!}'
              : healthCheckupRecords!.name!,
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
        razorpay.on(
            Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
        razorpay.on(
            Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
        razorpay.open(paymentOptions);
      }

    }
    else {
      context.pop();
    }
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) async {
    context.pop();
    _showAlertDialog(context, "Failed", 'You cancel the payment');
  }

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    final opd = OpdSure.of(context);
    final verificationResponse = await opd.client.verifyOrder(
        widget.paymentType,
        response.orderId,
        response.paymentId,
        response.signature);
    if (verificationResponse!.success!) {
      CommonMethods.showToast(widget.paymentType != PaymentType.buyHealthCheckup
          ? 'Plan purchased successfully!'
          : 'Health checkup purchased successfully!');
      await opd.client.getProfile(update: true);
      if (widget.paymentType == PaymentType.buyPlan) {
       final member = await OpdSure.of(context).client.getFamilyMember(update: true);
       if(member!.data!.length > 0){
         context.go('/home/add-members', extra: {"isUpdate" : true, "isAddingFirstMember" : true, "member" : member.data![0]});
         await OpdSure.of(context).client.getProfile(update: true);
       }else{
         context.go('/home/add-members', extra: {"isUpdate" : false, "isAddingFirstMember" : true});
       }

      } else {
        context.pop();
        OpdSureApp.router.go('/home');
      }
    } else {
      context.pop();
      _showAlertDialog(
          context, "Payment Failed", verificationResponse.message!);
    }
  }

  void _handleExternalWalletSelected(ExternalWalletResponse response) async {
    context.pop();
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
