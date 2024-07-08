import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/opd_widget.dart';

class DashboardPage extends StatefulWidget{
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          OpdSure.of(context).client.logout();
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        selectedIndex: 1,
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
            label: 'Appointment',
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