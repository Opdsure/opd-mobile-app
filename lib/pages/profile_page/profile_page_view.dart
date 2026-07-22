import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/pages/profile_page/family_member.dart';
import 'package:opdsure/pages/profile_page/pending_member.dart';
import 'package:opdsure/pages/profile_page/profile.dart';
import 'package:opdsure/pages/profile_page/profile_page.dart';

class ProfilePageView extends StatelessWidget {
  final ProfilePageController controller;

  const ProfilePageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AppBasePage(
        appHeader: AppHomeHeader(
          title: Text('Profile', style: AppDesign.titleLg),
        ),
        childContent: Column(
          children: [
            // Premium segmented tab bar
            Container(
              margin: const EdgeInsets.only(bottom: AppDesign.spacingMd),
              padding: const EdgeInsets.all(AppDesign.spacingXs),
              decoration: BoxDecoration(
                color: AppDesign.surface,
                borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                border: Border.all(color: AppDesign.divider.withOpacity(0.5)),
              ),
              child: TabBar(
                unselectedLabelStyle: AppDesign.labelSm.copyWith(
                  color: AppDesign.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
                labelStyle: AppDesign.labelSm.copyWith(
                  color: AppDesign.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                labelColor: AppDesign.textPrimary,
                unselectedLabelColor: AppDesign.textTertiary,
                indicator: BoxDecoration(
                  color: AppDesign.card,
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                  boxShadow: AppDesign.shadowSm,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                tabs: const [
                  Tab(text: 'Personal'),
                  Tab(text: 'Family'),
                  Tab(text: 'Pending'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Profile(controller),
                  FamilyMember(controller),
                  PendingFamilyMember(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
