import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';

class DashboardPageView extends StatelessWidget {
  final DashBoardPageController controller;

  const DashboardPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: controller.onDestinationSelected,
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        selectedIndex: controller.selectedIndex,
        destinations: <Widget>[
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
        ],
      ),
    );
  }
}
