import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../../widget/opd_widget.dart';

class PlansPage extends StatefulWidget {
  final PlansResponse? plans;

  const PlansPage({this.plans, super.key});

  @override
  State<PlansPage> createState() => PlansPageController();
}

class PlansPageController extends State<PlansPage> {
  PlanRecords? record;
  List<Tab>? plansTab;
  int? plansLength = 0;
  PlansResponse? plans;
  String planType = 'Individual';
  bool isIndividual = true;
  MembershipOptions? familyOptions;
  MembershipOptions? options;

  void toggleIndividual(bool value) => setState(() {
        isIndividual = value;
        planType = value ? "Individual" : "Family";
        if(value){
          int index = Get.put(TypeController()).planIndex.value;
          getIndexedRecords(index: index);
        }
      });

  List<DropdownMenuItem<MembershipOptions>> getPlanItem() {
    //record.membershipOptions?.insert(0, MembershipOptions(membershipLabel: "Select plan type"));
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
        options = plans!.data!.records![0].membershipOptions![0];
      } else {
        familyOptions = option;
        options = option;
      }
    });
  }

  void _getTabs() {
    plansTab = widget.plans!.data!.records!
        .map((records) => Tab(
              text: records.name!,
            ))
        .toList();
  }

  goToCheckout() {
    if (record != null) {
      OpdSure.of(context).isPlansSelect = true;

      context.pushReplacement('/home/view_plans/plans_payment',
          extra: {"records": record, "options": options});
    } else {
      CommonMethods.showToast('Please select a plan');
    }
  }

  void getIndexedRecords({required int index}) {
    TypeController typeController = Get.put(TypeController());
    setState(() {
      record = widget.plans!.data!.records![index];
      typeController.planNameChange(widget.plans!.data!.records![index].name!);
      typeController.planIndexChange(index);
      options = plans!.data!.records![index].membershipOptions![0];
      isIndividual = true;
      planType = 'Individual';
      familyOptions = null;
    });
  }

  @override
  void initState() {
    super.initState();
    plans = widget.plans;
    if(plans == null){
      OpdSure.of(context).client.getAllPlans(update: true).then((value){
        setState(() {
          print(value);
          PlansResponse plansResponse = value as PlansResponse;
          plansLength = plansResponse.data!.records!.length;
          options = plansResponse.data!.records![0].membershipOptions![0];
          _getTabs();
          getIndexedRecords(index: 0);
        });
      });
    }
    else{
      plansLength = widget.plans!.data!.records!.length;
      options = plans!.data!.records![0].membershipOptions![0];
      _getTabs();
      getIndexedRecords(index: 0);
    }
  }

  @override
  Widget build(BuildContext context) => PlansPageView(this);
}
