import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/custom_ui/navi_rail_item.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';

class DashboardPageView extends StatelessWidget {
  final DashBoardPageController controller;

  const DashboardPageView(this.controller, {super.key});


  List<NavigationDestination> getNavigationDestinations() {
    return [
      NavigationDestination(
        // selectedIcon: Image.asset('assets/images/bottom_home.png'),
        icon: Image.asset(
          'assets/images/bottom_home.png',
          height: 30.0,
          width: 30.0,
        ),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Image.asset(
          'assets/images/bottom_claim.png',
          height: 30.0,
          width: 30.0,
        ),
        label: 'Claims',
      ),
      NavigationDestination(
        icon: Image.asset(
          'assets/images/bottom_appointment.png',
          height: 30.0,
          width: 30.0,
        ),
        label: 'Health Check-up',
      ),
      NavigationDestination(
        icon: Image.asset(
          'assets/images/bottom_profile.png',
          height: 30.0,
          width: 30.0,
        ),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final destinations = getNavigationDestinations();
    return PopScope(
      child: Row(
        children: [
          if (controller.widget.displayNavigationRail) ...[
            SizedBox(
              width: OpdThemes.navRailWidth,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: getNavigationDestinations().length,
                  itemBuilder: (context, i) {
                    return NaviRailItem(toolTip: destinations[i].label,
                        isSelected: i == controller.selectedIndex,
                        onTap: (){ controller.onDestinationSelected(i);},
                        icon: destinations[i].icon);
                  }

              ),
            )
          ],
          Expanded(
            child: GestureDetector(
              onTap: FocusManager.instance.primaryFocus?.unfocus,
              excludeFromSemantics: true,
              behavior: HitTestBehavior.translucent,
              child: Scaffold(
                body: PageTransitionSwitcher(
                  transitionBuilder: (Widget child,
                      Animation<double> primaryAnimation,
                      Animation<double> secondaryAnimation,) {
                    return SharedAxisTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.vertical,
                      fillColor: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
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
                    shadowColor:
                    Theme
                        .of(context)
                        .colorScheme
                        .onSurface,
                    backgroundColor:
                    Theme
                        .of(context)
                        .colorScheme
                        .surface,
                    surfaceTintColor:
                    Theme
                        .of(context)
                        .colorScheme
                        .surface,
                    onDestinationSelected: controller.onDestinationSelected,
                    indicatorColor: Colors.transparent,
                    selectedIndex: controller.selectedIndex,
                    destinations: getNavigationDestinations()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
