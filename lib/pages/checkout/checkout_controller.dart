import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/checkout/checkout_page_view.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final Records? records;
  final MembershipOptions? options;
  const CheckoutPage({this.records, this.options, super.key});

  @override
  State<CheckoutPage> createState() => CheckoutController();
}

class CheckoutController extends State<CheckoutPage> {

  Records? records;
  MembershipOptions? options;

  double planCharge = 0.0;
  double couponDiscount = 0.0;
  double gst = 0.0;
  double netAmount = 0.0;
  double netAmountWithGst = 0.0;
  String payAmount = '';

  @override
  void initState() {
    super.initState();
    records = widget.records;
    options = widget.options;
    getPlanSummary();
  }

  void getPlanSummary(){
    planCharge = double.parse(options!.charges!.toString());
    gst = planCharge * 18 / 100;
    netAmount = planCharge - couponDiscount;
    netAmountWithGst = netAmount + gst;
    payAmount = (netAmountWithGst * 100).toString();
  }

  void openPaymentGateway() async {
    if(PlatformInfos.isWeb){
      final opd = OpdSure.of(context);
      await opd.client.updateUserProfile(plan: {
        "purchased" : true,
        "membership_id": options!.membershipId!,
        "id" :records!.id!});
      await opd.client.updatePlanPurchasedStatus(true);
      context.go('/home/view_plans/add_members');
      return;
    }
    UserProfile? profile = await OpdSure.of(context).client.getProfile();
    Razorpay razorpay = Razorpay();
    var paymentOptions = {
      'key': 'rzp_test_xru9wqPRtdHFOO',
      'amount': payAmount,
      'currency': "INR",
      'name': 'OPD Sure',
      'order_id': '',
      'description': '',
      'retry': {'enabled': false, 'max_count': 1},
      'send_sms_hash': true,
      'model': {
        'backdropclose': false,
        'escape': false,
        'handleback': true,
        'confirm_close': true
      },
      'prefill': {
        'contact':
        "+91${profile.data!.phone!}",
        "email": profile.data!.email!,
        "name": profile.data!.name!

      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
    razorpay.open(paymentOptions);
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) async  {
    _showAlertDialog(context, "failed", response.toString());
  }

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    final opd = OpdSure.of(context);
    await opd.client.updateUserProfile(plan: {
      "purchased" : true,
      "membership_id": options!.membershipId!,
    "id" :records!.id!});
    await opd.client.updatePlanPurchasedStatus(true);
    context.go('/home/view_plans/add_members');
    //_showAlertDialog(context, "Success", response.toString());
  }

  void _handleExternalWalletSelected(ExternalWalletResponse response) async {
    _showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
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
  Widget build(BuildContext context) =>  CheckoutPageView(this);
}
