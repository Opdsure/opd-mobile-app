import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/custom_ui/app_shimmer.dart';
import 'package:opdsure/pages/profile_page/profile_page.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../checkout/checkout_controller.dart';

class Profile extends StatelessWidget {
  final ProfilePageController controller;

  const Profile(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.userProfile == null) {
      return const AppShimmerList(itemCount: 4);
    }

    String actualDob = '';
    if (controller.userProfile!.data!.dob!.isNotEmpty) {
      actualDob =
          CommonMethods.formatIsoDateString(controller.userProfile!.data!.dob!);
    }

    return RefreshIndicator(
      color: AppDesign.primary,
      onRefresh: () async {
        controller.getProfileData();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(top: AppDesign.spacingSm),
        children: [
          // Personal Information Section
          _buildSectionCard(
            title: 'Personal Information',
            icon: Icons.person_outline_rounded,
            trailing: _buildEditButton(() => controller.updateProfile()),
            children: [
              AppKeyValue(
                mKey: 'Name',
                value: controller.userProfile!.data!.name!,
                showDivider: true,
              ),
              AppKeyValue(
                mKey: 'Age',
                value: actualDob.isEmpty
                    ? '-'
                    : CommonMethods.calculateAge(
                        DateFormat("dd/MM/yyyy").parse(actualDob)),
                showDivider: true,
              ),
              AppKeyValue(
                mKey: 'Gender',
                value: CommonMethods.getGenderByKey(
                    controller.userProfile!.data!.gender!),
                showDivider: true,
              ),
              AppKeyValue(
                mKey: 'Date of Birth',
                value: actualDob.isEmpty ? '-' : actualDob,
                showDivider: true,
              ),
              AppKeyValue(
                mKey: 'Mobile',
                value:
                    '${controller.userProfile!.data!.countryCode!} ${controller.userProfile!.data!.phone!}',
              ),
            ],
          ),

          const SizedBox(height: AppDesign.spacingMd),

          // Address Section
          _buildSectionCard(
            title: 'Address',
            icon: Icons.location_on_outlined,
            children: [
              AppKeyValue(
                mKey: 'Address',
                value: controller.userProfile!.data!.address!.isEmpty
                    ? '-'
                    : controller.userProfile!.data!.address!,
                showDivider: true,
              ),
              AppKeyValue(
                mKey: 'City',
                value: controller.userProfile!.data!.city!.isEmpty
                    ? '-'
                    : controller.userProfile!.data!.city!,
                showDivider: true,
              ),
              AppKeyValue(
                mKey: 'Pin Code',
                value: '${controller.userProfile!.data!.pinCode!}' == '0'
                    ? '-'
                    : '${controller.userProfile!.data!.pinCode!}',
              ),
            ],
          ),

          const SizedBox(height: AppDesign.spacingMd),

          // Quick Actions Section
          _buildSectionCard(
            title: 'Subscription & Plans',
            icon: Icons.card_membership_rounded,
            children: [
              _buildActionTile(
                icon: Icons.verified_outlined,
                title: 'Subscribed Plan',
                onTap: () async {
                  final plan = await OpdSure.of(context).client.getPlanById(
                        planId: controller.userProfile!.data!.plan!.id,
                        memberShipId:
                            controller.userProfile!.data!.plan!.membershipId,
                      );
                  context.push('/home/opd-plan', extra: {
                    'records': plan,
                    'option': plan!.membershipOptions![0],
                    'buyDate': controller.userProfile!.data!,
                    'isSub': true,
                    'active': true
                  });
                },
              ),
              _buildActionTile(
                icon: Icons.autorenew_rounded,
                title: 'Renew Plans',
                onTap: () {
                  context.push('/home/view_plans',
                      extra: PaymentType.planRenew);
                },
              ),
              _buildActionTile(
                icon: Icons.medical_services_outlined,
                title: 'Health Checkup Plans',
                onTap: () {
                  context.push('/home/health-plan');
                },
              ),
              _buildActionTile(
                icon: Icons.health_and_safety_outlined,
                title: 'Booked Free Health Checkup',
                onTap: () {
                  context.push('/home/free-health-plan');
                },
              ),
              _buildActionTile(
                icon: Icons.people_outline_rounded,
                title: 'Referral Members',
                onTap: () {
                  context.push('/home/referral-member');
                },
                showDivider: false,
              ),
            ],
          ),

          const SizedBox(height: AppDesign.spacingMd),

          // Account Actions
          _buildSectionCard(
            title: 'Account',
            icon: Icons.settings_outlined,
            children: [
              _buildActionTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                color: AppDesign.warning,
                onTap: () {
                  CommonMethods.showLogoutAlertDialog(
                    context,
                    'Are you sure want to logout',
                    'Logout',
                    'Yes',
                    'Cancel',
                  );
                },
              ),
              _buildActionTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Account',
                color: AppDesign.error,
                showDivider: false,
                onTap: () {
                  CommonMethods.showLogoutAlertDialog(
                    context,
                    'Are you sure want to Delete your account',
                    'Account Deletion',
                    'Yes',
                    'Cancel',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: AppDesign.spacing3Xl),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? trailing,
  }) {
    return AppCardView(
      padding: const EdgeInsets.all(AppDesign.spacingXl),
      mChaild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppDesign.accentLight,
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                ),
                child: Icon(icon, color: AppDesign.accent, size: 18),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              Expanded(
                child: Text(title, style: AppDesign.titleLg),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: AppDesign.spacingLg),
          ...children,
        ],
      ),
    );
  }

  Widget _buildEditButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppDesign.accentLight,
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
        ),
        child: const Icon(
          Icons.edit_outlined,
          size: 16,
          color: AppDesign.accent,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDesign.spacingMd),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: color ?? AppDesign.textSecondary,
                ),
                const SizedBox(width: AppDesign.spacingMd),
                Expanded(
                  child: Text(
                    title,
                    style: AppDesign.bodyMd.copyWith(
                      color: color ?? AppDesign.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: color ?? AppDesign.textTertiary,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: AppDesign.divider.withOpacity(0.5),
          ),
      ],
    );
  }
}
