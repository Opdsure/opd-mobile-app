import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/custom_ui/navi_rail_item.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';



class DashboardPageView extends StatelessWidget {
  final DashBoardPageController controller;

  const DashboardPageView(this.controller, {super.key});

  List<NavigationDestination> getNavigationDestinations() {
    return [
      NavigationDestination(
        selectedIcon: Image.asset(
          'assets/images/bottom_home.png',
          height: 30.0,
          width: 30.0,
          color: AppConfig.primaryColor,
        ),
        icon: Image.asset(
          'assets/images/bottom_home.png',
          height: 30.0,
          width: 30.0,
          color: Colors.white,
        ),
        label: 'Home',
      ),
      NavigationDestination(
        selectedIcon: Image.asset(
          'assets/images/bottom_claim.png',
          height: 30.0,
          width: 30.0,
          color: AppConfig.primaryColor,
        ),
        icon: Image.asset(
          'assets/images/bottom_claim.png',
          height: 30.0,
          width: 30.0,
          color: Colors.white,
        ),
        label: 'Claims',
      ),
      NavigationDestination(
        selectedIcon: Image.asset(
          'assets/images/referral.png',
          height: 25.0,
          width: 25.0,
          color: AppConfig.primaryColor,
        ),
        icon: Image.asset(
          'assets/images/referral.png',
          height: 25.0,
          width: 25.0,
          color: Colors.white,
        ),
        label: 'Referral',
      ),
      NavigationDestination(
        selectedIcon: Image.asset(
          'assets/images/bottom_appointment.png',
          height: 30.0,
          width: 30.0,
          color: AppConfig.primaryColor,
        ),
        icon: Image.asset(
          'assets/images/bottom_appointment.png',
          height: 30.0,
          width: 30.0,
          color: Colors.white,
        ),
        label: 'CheckUp ',

      ),
      NavigationDestination(
        selectedIcon: Image.asset(
          'assets/images/bottom_profile.png',
          height: 30.0,
          width: 30.0,
          color: AppConfig.primaryColor,
        ),
        icon: Image.asset(
          'assets/images/bottom_profile.png',
          height: 30.0,
          width: 30.0,
          color: Colors.white,
        ),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final destinations = getNavigationDestinations();
    return Row(
      children: [
        if (controller.widget.displayNavigationRail) ...[
          SizedBox(
            width: OpdThemes.navRailWidth,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: destinations.length,
                itemBuilder: (context, i) {
                  return NaviRailItem(
                    toolTip: destinations[i].label,
                    isSelected: i == controller.selectedIndex,
                    onTap: () {
                      controller.onDestinationSelected(i);
                    },
                    icon: destinations[i].icon,
                  );
                }),
          )
        ],
        Expanded(
          child: GestureDetector(
            onTap: FocusManager.instance.primaryFocus?.unfocus,
            excludeFromSemantics: true,
            behavior: HitTestBehavior.translucent,
            child: Scaffold(
              body: PageTransitionSwitcher(
                transitionBuilder: (
                    Widget child,
                    Animation<double> primaryAnimation,
                    Animation<double> secondaryAnimation,
                    ) {
                  return SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.vertical,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    child: child,
                  );
                },
                child: controller.getBodyByActiveDestination(),
              ),
              bottomNavigationBar: controller.widget.displayNavigationRail
                  ? null
                  : NavigationBar(
                elevation: 4,
                labelBehavior:
                NavigationDestinationLabelBehavior.alwaysShow,
                shadowColor: AppConfig.primaryColor,
                backgroundColor: AppConfig.primaryColor,
                surfaceTintColor: AppConfig.primaryColorLight,
                onDestinationSelected: controller.onDestinationSelected,
                indicatorColor: AppConfig.primaryColorLight,
                selectedIndex: controller.selectedIndex,
                destinations: destinations,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
