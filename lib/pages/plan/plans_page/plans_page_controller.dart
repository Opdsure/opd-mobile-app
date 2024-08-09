import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/checkout/checkout_controller.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../../widget/opd_widget.dart';

class PlansPage extends StatefulWidget {
  final PlansResponse? plans;
  final PaymentType? type;

  const PlansPage({this.plans, this.type = PaymentType.buyPlan, super.key});

  @override
  State<PlansPage> createState() => PlansPageController();
}

class PlansPageController extends State<PlansPage>  with SingleTickerProviderStateMixin {
  PlanRecords? record;
  List<Tab>? plansTab;
  int? plansLength = 0;
  String planType = 'Individual';
  bool isIndividual = true;
  MembershipOptions? familyOptions;
  MembershipOptions? options;
  late TabController tabController = TabController(length: widget.plans!.data!.records!.length, vsync: this);
  void toggleIndividual(bool value) => setState(() {
        isIndividual = value;
        planType = value ? "Individual" : "Family";
      });

  List<DropdownMenuItem<MembershipOptions>> getPlanItem() {
    return record!.membershipOptions!.map((e) {
      return DropdownMenuItem<MembershipOptions>(
          value: e, child: Text(e.membershipLabel!));
    }).toList();
  }


  void setPlanItem(MembershipOptions? option) {
    setState(() {
      if (option!.membershipLabel == 'Individual') {
        isIndividual = true;
        planType = 'Individual';
        familyOptions = null;
        options = option;
      } else {
        familyOptions = option;
        isIndividual = false;
        planType = 'Family';
        options = option;
      }
    });
  }

  void _getTabs() {
    plansTab = widget.plans!.data!.records!.map((records) => Tab(text: records.name!,)).toList();
  }

  goToCheckout() {
    if (record != null) {
      // OpdSure.of(context).isPlansSelect = true;
      context.push('/view_plans/plans_payment', extra: {"records": record, "options": options, "type" : widget.type});
    } else {
      CommonMethods.showToast('Please select a plan');
    }
  }

  void getIndexedRecords({required int index}) {
    setState(() {
      record = widget.plans!.data!.records![index];
      options = widget.plans!.data!.records![index].membershipOptions![0];
      if(record!.planType == PlanType.family){
        planType = 'Family';
        isIndividual = false;
        familyOptions = options;
      }else{
        planType = 'Individual';
        isIndividual = true;
        familyOptions = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
      plansLength = widget.plans!.data!.records!.length;
      options = widget.plans!.data!.records![0].membershipOptions![0];
      _getTabs();
      getIndexedRecords(index: 0);
      if(widget.plans!.data!.records![0].planType == PlanType.family){
        planType = 'Family';
        isIndividual = false;
        familyOptions = options;
      }
  }

  @override
  Widget build(BuildContext context) => PlansPageView(this);
}
