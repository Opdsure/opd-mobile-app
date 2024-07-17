import 'package:flutter/material.dart';
import 'package:opdsure/pages/claims_page.dart';
import 'package:opdsure/pages/health_check_up/health_checkup_list/health_checkup_controller.dart';
import 'package:opdsure/pages/home_dashboard/dashboard_view.dart';
import 'package:opdsure/pages/homepage/home_page.dart';
import 'package:opdsure/pages/profile_page.dart';
import 'package:opdsure/test.dart';

enum ActiveDestination { home, claim, checkup, profile }

class DashBoardPage extends StatefulWidget {
  final bool displayNavigationRail;

  const DashBoardPage({this.displayNavigationRail = false, super.key});

  @override
  State<DashBoardPage> createState() => DashBoardPageController();
}

class DashBoardPageController extends State<DashBoardPage> {
  ActiveDestination activeDestination = ActiveDestination.home;

  ActiveDestination getActiveDestinationByIndex(int? i) {
    switch (i) {
      case 0:
        return ActiveDestination.home;
      case 1:
        return ActiveDestination.claim;
      case 2:
        return ActiveDestination.checkup;
      case 3:
        return ActiveDestination.profile;
      default:
        return ActiveDestination.home;
    }
  }

  void onDestinationSelected(int index){
    setState((){
      activeDestination = getActiveDestinationByIndex(index);
    });
  }


  int get selectedIndex {
    switch (activeDestination) {
      case ActiveDestination.home:
        return 0;
      case ActiveDestination.claim:
        return 1;
      case ActiveDestination.checkup:
        return 2;
      case ActiveDestination.profile:
        return 3;
      default:
        return 0;
    }
  }

  Widget getBodyByActiveDestination() {
    switch (activeDestination) {
      case ActiveDestination.home:
        return HomePage(callback: (index){
          onDestinationSelected(index);
        },);
      case ActiveDestination.claim:
        return ClaimsPage();
      case ActiveDestination.checkup:
        return const HealthCheckup();
      case ActiveDestination.profile:
        return ProfilePage();
      default:
        return HomePage(callback: (index){
          onDestinationSelected(index);
        },);
    }
  }

  @override
  Widget build(BuildContext context) => DashboardPageView(this);
}
