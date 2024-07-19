import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plan_page.dart';

import '../../../widget/opd_widget.dart';

class ViewPlansPage extends StatefulWidget {
  const ViewPlansPage({super.key});

  @override
  State<ViewPlansPage> createState() => ViewPlansPageController();
}

class ViewPlansPageController extends State<ViewPlansPage> {

  PlansResponse? plansResponse;
  @override
  void initState() {
    super.initState();
    getAllPlans();
  }

  void getAllPlans() async {
    plansResponse = await OpdSure.of(context).client.getAllPlans(update: true);
  }

  void selectPlans(BuildContext context){
    if(plansResponse != null) {
      OpdSure
          .of(context)
          .isSelectPlans = true;
      context.pushReplacement('/home/view_plans/select_plans', extra: plansResponse);
    }else{

    }
  }

  @override
  Widget build(BuildContext context) => ViewPlanPageView(this);
}
