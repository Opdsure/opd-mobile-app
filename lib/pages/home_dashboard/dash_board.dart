import 'package:flutter/material.dart';
import 'package:opdsure/pages/claims_page.dart';
import 'package:opdsure/pages/home_dashboard/dashboard_view.dart';
import 'package:opdsure/pages/homepage/home_page.dart';
import 'package:opdsure/pages/profile_page.dart';

enum ActiveDestination {
  home,
  claim,
  checkup,
  profile
}

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

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

  void onDestinationSelected(int index) =>
      setState(() => activeDestination = getActiveDestinationByIndex(index));

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

  Widget getBodyByActiveDestination(){
    switch(activeDestination){
      case ActiveDestination.home:
        return HomePage();
      case ActiveDestination.claim:
        return ClaimsPage();
      case ActiveDestination.checkup:
        return HomePage();
      case ActiveDestination.profile:
        return ProfilePage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) => DashboardPageView(this);
}
