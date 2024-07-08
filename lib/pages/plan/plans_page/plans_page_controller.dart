import 'package:flutter/material.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page.dart';

class PlansPage extends StatefulWidget {
  final PlansResponse? plans;

  const PlansPage({this.plans, super.key});

  @override
  State<PlansPage> createState() => PlansPageController();
}

class PlansPageController extends State<PlansPage> {
  late Records record;
  late List<Tab> plansTab;
  int? plansLength = 0;
  PlansResponse? plans;
  String? plansPrice;
  String planType = 'Individual';
  bool isIndividual = true;
  MembershipOptions? options;

  void toggleIndividual(bool value) =>
      setState(() {
        isIndividual = value;
        planType = value ? "Individual" : "Family";
      });

  List<DropdownMenuItem<MembershipOptions>> getPlanItem() {
    //record.membershipOptions?.insert(0, MembershipOptions(membershipLabel: "Select plan type"));
    return record.membershipOptions!.map((e) {
      return DropdownMenuItem<MembershipOptions>(
          value: e,
          child: Text(e.membershipLabel!));
    }).toList();
  }

  void setPlanItem(MembershipOptions? option) {
    setState(() {
      if(option!.membershipLabel == 'Individual'){
        isIndividual = true;
        planType = 'Individual';
        options = null;
        plansPrice = option.charges!.toString();
      }else{
        options = option;
        plansPrice = option.charges!.toString();
      }

    });
  }

  void _getTabs() {
    plansTab = widget.plans!.data!.records!
        .map((records) => Tab(text: records.name!,))
        .toList();
  }

  String getPlanFrequency() {
    switch (record.frequency!) {
      case 1:
        return 'Billed yearly';
      case 2:
        return 'Billed half yearly';
      case 3:
        return 'Billed quarterly';
      case 4:
        return 'Billed monthly';
      default:
        return '';
    }
  }

  void getIndexedRecords({required int index}) {
    setState(() {
      record = widget.plans!.data!.records![index];
      plansPrice = plans!.data!.records![index].membershipOptions![0].charges!
          .toString();
    });
  }

  @override
  void initState() {
    plans = widget.plans;
    plansLength = widget.plans!.data!.records!.length;
    plansPrice =
        plans!.data!.records![0].membershipOptions![0].charges!.toString();
    _getTabs();
    getIndexedRecords(index: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PlansPageView(this);
}
