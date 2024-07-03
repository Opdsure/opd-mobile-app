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

  void _getTabs(){
    plansTab  = widget.plans!.data!.plansName!.map((name) => Tab(text: name,)).toList();
  }

  void getIndexedRecords({required int index}){
    setState(() => record = widget.plans!.data!.records![index]);
  }

  @override
  void initState() {
    plans = widget.plans;
    plansLength = widget.plans!.data!.plansName!.length;
    _getTabs();
    getIndexedRecords(index : 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PlansPageView(this);
}
