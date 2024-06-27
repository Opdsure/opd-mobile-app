import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';

import '../utils/app_colors.dart';

class PlansPage extends StatelessWidget{

  Widget commonRow(){
    return Row(
      children: [
        Image.asset('assets/images/unlimited_doctor.png'),
        const SizedBox(width: 10.0,),
        AppTextView(text: 'Unlimited Doctor Consultations across India - Online/Offline')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              const SizedBox(height: 16.0,),
              const Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: backIconCl,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AppTextView(
                      text: 'Plans & Pricing',
                      size: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0,),
              const AppTextView(
                text: 'Select Plan',
                size: 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              const SizedBox(height: 15.0,),
              ButtonsTabBar(
                backgroundColor: Colors.transparent,
                unselectedBackgroundColor: Colors.white,
                labelStyle: GoogleFonts.montserrat(
                  color: buttonColor,
                ),
                borderColor: buttonColor,
                height: 40.0,
                width: 100.0,
                contentCenter: true,
                unselectedLabelStyle: GoogleFonts.montserrat(
                  color: Colors.black,
                ),
                borderWidth: 1,
                unselectedBorderColor: const Color(0xFFEAECF0),
                radius: 15,
                tabs: const [
                  Tab(
                    text: "Care",
                  ),
                  Tab(
                    text: "Health",
                  ),
                  Tab(
                    text: 'Pro',
                  ),
                  Tab(
                    text: 'Exclusive',
                  ),
                ],
              ),
              const SizedBox(height: 15.0,),
              const AppTextView(
                text: '₹ 333/mo',
                color: Color(0xFF8A48B3),
                size: 40.0,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 15.0,),
              const AppTextView(
                text: 'Billed annually',
                size: 16.0,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 15.0,),
              const AppTextView(
                text: 'Benefits',
                size: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10.0,),
              commonRow()
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            // setState(() {
            //   currentPageIndex = index;
            // });
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
      ),
    );
  }
}