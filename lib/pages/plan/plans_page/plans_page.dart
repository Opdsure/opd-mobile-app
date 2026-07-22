import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_drop_down.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page_controller.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

class PlansPageView extends StatefulWidget {
  final PlansPageController controller;

  const PlansPageView(this.controller, {super.key});

  @override
  State<PlansPageView> createState() => _PlansPageViewState();
}

class _PlansPageViewState extends State<PlansPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<Offset> _priceSlide;
  late Animation<double> _listFade;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _priceSlide = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
    ));

    _listFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.controller.plansLength!,
      child: AppBasePage(
        appHeader: const AppHeader(headerName: 'Choose Your Plan'),
        childContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDesign.spacingMd),

            // Animated Tab Bar
            FadeTransition(
              opacity: _headerFade,
              child: ButtonsTabBar(
                controller: widget.controller.tabController,
                backgroundColor: AppDesign.primary,
                unselectedBackgroundColor: AppDesign.card,
                labelStyle: const TextStyle(
                  fontFamily: AppDesign.fontFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                borderColor: AppDesign.primary,
                height: 44,
                contentCenter: true,
                unselectedLabelStyle: TextStyle(
                  fontFamily: AppDesign.fontFamily,
                  color: AppDesign.textSecondary,
                  fontSize: 13,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                borderWidth: 1.5,
                unselectedBorderColor: AppDesign.divider,
                radius: AppDesign.radiusFull,
                tabs: widget.controller.plansTab!,
                onTap: (index) {
                  widget.controller.getIndexedRecords(index: index);
                },
              ),
            ),

            const SizedBox(height: AppDesign.spacingXl),

            // Animated Price Card
            SlideTransition(
              position: _priceSlide,
              child: FadeTransition(
                opacity: _headerFade,
                child: _buildPriceCard(),
              ),
            ),

            const SizedBox(height: AppDesign.spacingLg),

            // Wallet Balance
            FadeTransition(
              opacity: _listFade,
              child: _buildWalletBanner(),
            ),

            const SizedBox(height: AppDesign.spacingXl),

            // Benefits Header + Family Dropdown
            FadeTransition(
              opacity: _listFade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan Benefits',
                    style: AppDesign.headingSm.copyWith(
                      color: AppDesign.textPrimary,
                    ),
                  ),
                  if (_showFamilyDropdown()) ...[
                    const SizedBox(height: AppDesign.spacingMd),
                    AppDropDown<MembershipOptions>(
                      hint: const AppTextView(text: "Select plan type"),
                      items: widget.controller.getPlanItem(),
                      onChanged: widget.controller.setPlanItem,
                      value: widget.controller.familyOptions,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppDesign.spacingMd),

            // Animated Benefits List
            Expanded(
              child: FadeTransition(
                opacity: _listFade,
                child: _buildBenefitsList(),
              ),
            ),

            const SizedBox(height: AppDesign.spacingLg),

            // CTA Button
            _buildSelectButton(),

            const SizedBox(height: AppDesign.spacingLg),
          ],
        ),
      ),
    );
  }

  bool _showFamilyDropdown() {
    final ctrl = widget.controller;
    return ctrl.record != null &&
        (ctrl.record!.planType == PlanType.family ||
            ctrl.record!.planType == PlanType.both) &&
        !ctrl.isIndividual;
  }

  Widget _buildPriceCard() {
    final ctrl = widget.controller;
    return Container(
      padding: const EdgeInsets.all(AppDesign.spacingXl),
      decoration: BoxDecoration(
        gradient: AppDesign.heroGradient,
        borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        boxShadow: AppDesign.shadowXl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (!ctrl.isIndividual && ctrl.familyOptions == null)
                    ? 'Select Member'
                    : '\u20B9 ${CommonMethods.amountFormater((ctrl.options?.charges ?? 0).toStringAsFixed(0))}',
                style: AppDesign.headingLg.copyWith(
                  color: Colors.white,
                  fontSize: (!ctrl.isIndividual && ctrl.familyOptions == null)
                      ? 18
                      : 32,
                ),
              ),
              const SizedBox(height: AppDesign.spacingXs),
              Text(
                ctrl.record != null
                    ? '${CommonMethods.getPlanFrequency(ctrl.record!.frequency!)} \u2022 incl. GST'
                    : '',
                style: AppDesign.bodySm.copyWith(
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
            ],
          ),
          if (ctrl.record?.planType == PlanType.both) ...[
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spacingMd,
                    vertical: AppDesign.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        ctrl.isIndividual
                            ? Icons.person_rounded
                            : Icons.family_restroom_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: AppDesign.spacingXs),
                      Text(
                        ctrl.planType,
                        style: AppDesign.labelSm.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDesign.spacingSm),
                GestureDetector(
                  onTap: () => ctrl.toggleIndividual(!ctrl.isIndividual),
                  child: Text(
                    'Switch',
                    style: AppDesign.labelSm.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletBanner() {
    final ctrl = widget.controller;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacingLg,
        vertical: AppDesign.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppDesign.accentLight,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(
          color: AppDesign.accent.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppDesign.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppDesign.radiusSm),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppDesign.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: AppDesign.spacingMd),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Wallet Balance: ',
                    style: AppDesign.bodyMd.copyWith(color: AppDesign.primary),
                  ),
                  TextSpan(
                    text:
                        '$rupeeSymbol${CommonMethods.amountFormater(ctrl.options!.walletBalance!.toString())}',
                    style: AppDesign.titleLg.copyWith(color: AppDesign.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList() {
    final ctrl = widget.controller;
    if (ctrl.record == null || ctrl.record!.planBenefits == null) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: ctrl.record!.planBenefits!.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final benefit = ctrl.record!.planBenefits![index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: AppDesign.spacingMd),
            padding: const EdgeInsets.all(AppDesign.spacingLg),
            decoration: BoxDecoration(
              color: AppDesign.card,
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
              border: Border.all(color: AppDesign.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppDesign.success.withOpacity(0.15),
                        AppDesign.success.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppDesign.success,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppDesign.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        benefit.planLabel ?? '',
                        style: AppDesign.titleMd,
                      ),
                      const SizedBox(height: AppDesign.spacingXs),
                      Text(
                        benefit.planFeature ?? '',
                        style: AppDesign.bodyMd.copyWith(
                          color: AppDesign.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectButton() {
    final ctrl = widget.controller;
    final isDisabled = ctrl.buttonColors != AppDesign.primary &&
        ctrl.buttonColors.value == const Color(0xFFD9D7D7).value;

    return GestureDetector(
      onTap: isDisabled ? null : ctrl.onPlanSelect,
      child: AnimatedContainer(
        duration: AppDesign.animNormal,
        curve: Curves.easeOut,
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: isDisabled ? null : AppDesign.primaryGradient,
          color: isDisabled ? const Color(0xFFE5E5E5) : null,
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          boxShadow: isDisabled ? [] : AppDesign.shadowXl,
        ),
        child: Center(
          child: Text(
            'Select Plan',
            style: AppDesign.button.copyWith(
              color: isDisabled ? AppDesign.textTertiary : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
