import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/checkout/checkout_controller.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plan_page.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../../widget/opd_widget.dart';

class ViewPlansPage extends StatefulWidget {
  final PaymentType? type;

  const ViewPlansPage({super.key, this.type = PaymentType.buyPlan});

  @override
  State<ViewPlansPage> createState() => ViewPlansPageController();
}

class ViewPlansPageController extends State<ViewPlansPage> {
  PlansResponse? plansResponse;

  @override
  void initState() {
    super.initState();
    final database = OpdSure.of(context).client.database;
    database?.deletePlans();
    getAllPlans();
  }

  void getAllPlans() async {
    plansResponse = await OpdSure.of(context).client.getAllPlans(
        update: true, isUpgrade: widget.type == PaymentType.planUpgrade);
  }

  void selectPlans(BuildContext context) {
    final opd = OpdSure.of(context);
    if (plansResponse!.data!.records != null && plansResponse!.data!.records!.isNotEmpty) {
      // opd.isSelectPlans = true;
      // opd.isPlansSelect = false;
      context.pushReplacement('/view_plans/select_plans',
          extra: {"plans": plansResponse, "type": widget.type});
    }else{
      // opd.isSelectPlans = false;
      // opd.isPlansSelect = false;
      // opd.isPlanUpgrade = false;
      CommonMethods.showToast('You already on highest plan');
      context.pushReplacement('/home');
    }
  }

  @override
  Widget build(BuildContext context) => ViewPlanPageView(this);
}
