import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/checkout/checkout_controller.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../../config/app_config.dart';
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
  Color buttonColors = AppConfig.primaryColor;
  Color textColors = Colors.white;
  Color borderColors = AppConfig.primaryColor;
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

  Future<bool> isAbleToBuy(MembershipOptions? option) async {
    if(widget.type! != PaymentType.planUpgrade){
      return true;
    }else{
    final opdClient = OpdSure.of(context).client;
    final userProfile = await opdClient.getProfile();
    final currentPlan = userProfile.data!.plan!;
    PlanRecords? plan = await opdClient.getPlanById(
        planId: currentPlan.id!, memberShipId: currentPlan.membershipId);
    if (option!.charges! <= plan!.membershipOptions![0].charges!) {
      return false;
    } else {
      return true;
    }
    }
  }


  void setPlanItem(MembershipOptions? option) async {
    if(!await isAbleToBuy(option!)){
      buttonColors = Color(0xFFD9D7D7);
      textColors = Colors.black;
      borderColors = Color(0xFFD9D7D7);
    }else{
      buttonColors = AppConfig.primaryColor;
      textColors = Colors.white;
      borderColors = AppConfig.primaryColor;
    }
    setState(() {
      if (option.membershipLabel == 'Individual') {
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

     goToCheckout() async {
    if (record != null) {
      /*final result = await */context.push(widget.type == PaymentType.buyPlan ? '/view_plans/plans_payment' : '/home/view_plans/plans_payment', extra: {"records": record, "options": options, "type" : widget.type});
      // if(result != null && result == true){
      //   context.pushReplacement('/');
      // }
    } else {
      CommonMethods.showToast('Please select a plan');
    }
  }


  void getIndexedRecords({required int index}) async {

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

      if(!await isAbleToBuy(options!)){
        buttonColors = const Color(0xFFD9D7D7);
        textColors = Colors.black;
        borderColors = const Color(0xFFD9D7D7);
      }else{
        buttonColors = AppConfig.primaryColor;
        textColors = Colors.white;
        borderColors = AppConfig.primaryColor;
      }
      setState(() {});
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

  void onPlanSelect() async {
    if(!await isAbleToBuy(options!)){
      CommonMethods.showToast('Plan cannot be downgrade');
    }else{
      goToCheckout();
    }

  }


}
