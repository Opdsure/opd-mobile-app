import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/checkout/checkout_page_view.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    records = widget.records;
    options = widget.options;
    healthCheckupRecords = widget.healthCheckupRecords;
    if (widget.paymentType == PaymentType.buyPlan) {
      getPlanSummary();
    } else {
      getHealthCheckUp();
    }
  }

  void getHealthCheckUp() {
    name = healthCheckupRecords!.name!;
    planCharge = double.parse(healthCheckupRecords!.basePrice!.toString());
    couponDiscount = double.parse(healthCheckupRecords!.basePrice!.toString()) -
        double.parse(healthCheckupRecords!.discountedPrice!.toString());
    gst = planCharge * 18 / 100;
    netAmount = double.parse(healthCheckupRecords!.discountedPrice!.toString());
    netAmountWithGst = netAmount + gst;
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

  void openPaymentGateway() async {
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
    final createPaymentResponse = await opd.client.createOrder(
        type: widget.paymentType.index,
        planId: widget.paymentType == PaymentType.buyPlan ? records?.id! : null,
        membershipId: widget.paymentType == PaymentType.buyPlan ? options?.membershipId! : null,
        healthId: widget.paymentType == PaymentType.buyPlan ? null : healthCheckupRecords?.id!);
    Razorpay razorpay = Razorpay();
    var paymentOptions = {
      'key': 'rzp_test_sXPx4ftQc94AZA',
      'amount': createPaymentResponse!.data!.amount!,
      'currency': createPaymentResponse.data!.currency!,
      'name': 'OPD Sure',
      'order_id': createPaymentResponse.data!.id,
      'description': createPaymentResponse.data!.description,
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
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) async {
    _showAlertDialog(context, "failed", response.toString());
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
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [continueButton],
    );
    // show the dialog
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
