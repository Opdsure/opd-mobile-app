import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/config/themes.dart';
import 'package:opdsure/custom_ui/navi_rail_item.dart';
import 'package:opdsure/pages/home_dashboard/dash_board.dart';

class DashboardPageView extends StatelessWidget {
  final DashBoardPageController controller;

  const DashboardPageView(this.controller, {super.key});

  List<_NavItem> get _navItems => [
        _NavItem(
          icon: 'assets/images/bottom_home.png',
          label: 'Home',
        ),
        _NavItem(
          icon: 'assets/images/bottom_claim.png',
          label: 'Claims',
        ),
        _NavItem(
          icon: 'assets/images/referral.png',
          label: 'Referral',
          iconSize: 22,
        ),
        _NavItem(
          icon: 'assets/images/bottom_appointment.png',
          label: 'Plan Usage',
        ),
        _NavItem(
          icon: 'assets/images/bottom_profile.png',
          label: 'Profile',
        ),
      ];

  List<NavigationDestination> getNavigationDestinations() {
    return _navItems
        .map((item) => NavigationDestination(
              selectedIcon: Image.asset(
                item.icon,
                height: item.iconSize.toDouble(),
                width: item.iconSize.toDouble(),
                color: AppDesign.primary,
              ),
              icon: Image.asset(
                item.icon,
                height: item.iconSize.toDouble(),
                width: item.iconSize.toDouble(),
                color: AppDesign.textTertiary,
              ),
              label: item.label,
            ))
        .toList();
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
              },
            ),
          )
        ],
        Expanded(
          child: GestureDetector(
            onTap: FocusManager.instance.primaryFocus?.unfocus,
            excludeFromSemantics: true,
            behavior: HitTestBehavior.translucent,
            child: Scaffold(
              backgroundColor: AppDesign.background,
              body: PageTransitionSwitcher(
                transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                ) {
                  return FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    fillColor: AppDesign.background,
                    child: child,
                  );
                },
                child: controller.getBodyByActiveDestination(),
              ),
              bottomNavigationBar: controller.widget.displayNavigationRail
                  ? null
                  : _PremiumBottomNav(
                      items: _navItems,
                      selectedIndex: controller.selectedIndex,
                      onTap: controller.onDestinationSelected,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final String icon;
  final String label;
  final int iconSize;

  _NavItem({
    required this.icon,
    required this.label,
    this.iconSize = 24,
  });
}

/// Premium floating bottom navigation bar with glass effect
class _PremiumBottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _PremiumBottomNav({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        bottom: bottomPadding + AppDesign.spacingSm,
        top: AppDesign.spacingSm,
        left: AppDesign.spacingLg,
        right: AppDesign.spacingLg,
      ),
      decoration: BoxDecoration(
        color: AppDesign.card.withOpacity(0.92),
        border: const Border(
          top: BorderSide(
            color: Color(0x0F000000),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final isSelected = index == selectedIndex;
                return _NavBarItem(
                  item: items[index],
                  isSelected: isSelected,
                  onTap: () => onTap(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppDesign.animFast,
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacingMd,
          vertical: AppDesign.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppDesign.accentLight : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.icon,
              height: item.iconSize.toDouble(),
              width: item.iconSize.toDouble(),
              color: isSelected ? AppDesign.primary : AppDesign.textTertiary,
            ),
            if (isSelected) ...[
              const SizedBox(width: AppDesign.spacingSm),
              Text(
                item.label,
                style: AppDesign.labelSm.copyWith(
                  color: AppDesign.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
