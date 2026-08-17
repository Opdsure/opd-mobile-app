import 'package:flutter/material.dart';
import 'package:opdsure/pages/claims_page.dart';
import 'package:opdsure/pages/health_check_up/health_checkup_list/health_checkup_controller.dart';
import 'package:opdsure/pages/home_dashboard/dashboard_view.dart';
import 'package:opdsure/pages/homepage/home_page.dart';
import 'package:opdsure/pages/plan_usage/plan_usage_page.dart';
import 'package:opdsure/pages/profile_page/profile_page.dart';
import 'package:opdsure/pages/referral_page.dart';
import 'package:opdsure/widget/opd_widget.dart';

enum ActiveDestination { home, claim, referral, checkup, profile }

class DashBoardPage extends StatefulWidget {
  final bool displayNavigationRail;
  final ActiveDestination destination;

  const DashBoardPage(
      {this.displayNavigationRail = false,
      this.destination = ActiveDestination.home,
      super.key});

  @override
  State<DashBoardPage> createState() => DashBoardPageController();
}

class DashBoardPageController extends State<DashBoardPage> {
  ActiveDestination? activeDestination;

  ActiveDestination getActiveDestinationByIndex(int? i) {
    switch (i) {
      case 0:
        return ActiveDestination.home;
      case 1:
        return ActiveDestination.claim;
      case 2:
        return ActiveDestination.referral;
      case 3:
        return ActiveDestination.checkup;
      case 4:
        return ActiveDestination.profile;
      default:
        return ActiveDestination.home;
    }
  }

  int getActiveIndexByDestination() {
    switch (activeDestination) {
      case ActiveDestination.home:
        return 0;
      case ActiveDestination.claim:
        return 1;
      case ActiveDestination.referral:
        return 2;
      case ActiveDestination.checkup:
        return 3;
      case ActiveDestination.profile:
        return 4;
      default:
        return 0;
    }
  }

  void onDestinationSelected(int index) {
    OpdSureState opd = OpdSure.of(context);
    opd.setPage(index, (page) {
      if (mounted) {
        setState(() {
          activeDestination = getActiveDestinationByIndex(page);
        });
      }
    });
  }

  int get selectedIndex => OpdSure.of(context).selectedPage;

  Widget getBodyByActiveDestination() {
    switch (activeDestination) {
      case ActiveDestination.home:
        return HomePage(
          callback: (index) {
            onDestinationSelected(index);
          },
        );
      case ActiveDestination.claim:
        return ClaimsPage();
      case ActiveDestination.referral:
        return ReferralPage();
      case ActiveDestination.checkup:
        return OpdSure.of(context).client.isPlanPurchased
            ? const PlanUsagePage()
            : const HealthCheckup();
      case ActiveDestination.profile:
        return const ProfilePage();
      default:
        return HomePage(
          callback: (index) {
            onDestinationSelected(index);
          },
        );
    }
  }

  void setDestinationIndex() {
    activeDestination = widget.destination;
    onDestinationSelected(getActiveIndexByDestination());
  }

  @override
  void initState() {
    setDestinationIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DashboardPageView(this);
}
