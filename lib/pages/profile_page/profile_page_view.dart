import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/pages/profile_page/family_member.dart';
import 'package:opdsure/pages/profile_page/pending_member.dart';
import 'package:opdsure/pages/profile_page/profile.dart';
import 'package:opdsure/pages/profile_page/profile_page.dart';

class ProfilePageView extends StatelessWidget {
  final ProfilePageController controller;

  ProfilePageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: AppBasePage(
        appHeader: const AppHomeHeader(
          titleUi: AppTextView(
            text: 'Profile',
            size: 22.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        childContent: Column(
          children: [
            Center(
              child: TabBar(
                unselectedLabelStyle: GoogleFonts.montserrat(
                    color: const Color(0xFF344054),
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0),
                labelStyle: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
                labelColor: Colors.black,
                tabs: const [
                  Tab(
                    child: AppTextView(text: 'Personal Info', size: 12, fontWeight: FontWeight.bold,),
                  ),
                  Tab(
                    child: AppTextView(text: 'Family Members', size: 12, fontWeight: FontWeight.bold,),
                  ),
                  Tab(
                    child: AppTextView(text: 'Pending for approval', size: 12, fontWeight: FontWeight.bold,),
                    
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Expanded(
              child: TabBarView(
                // controller: _tabController,
                children: [
                  Profile(controller),
                  FamilyMember(controller),
                  PendingFamilyMember(controller)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
