import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';

/// Display-only page shown to unsubscribed users
/// showcasing OPDSure plan benefits and included services.
class PlanBenefitsPage extends StatelessWidget {
  const PlanBenefitsPage({super.key});

  static const Color _headerColor = Color(0xFF486AB3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Section
          SliverToBoxAdapter(child: _buildHeader(context)),
          // Included Services
          SliverToBoxAdapter(child: _buildServicesSection()),
          // Stats Row
          SliverToBoxAdapter(child: _buildStatsRow()),
          // How It Works
          SliverToBoxAdapter(child: _buildHowItWorks()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _headerColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDesign.radiusXl),
          bottomRight: Radius.circular(AppDesign.radiusXl),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with greeting and plan label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome 👋',
                        style: AppDesign.bodyMd.copyWith(
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your Plan Benefits',
                        style: AppDesign.titleLg.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Free Plan',
                      style: AppDesign.caption.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Plan Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscribe to unlock',
                      style: AppDesign.bodySm.copyWith(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Family OPD Shield',
                      style: AppDesign.headingSm.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildPlanMetaItem('Members covered', 'Up to 6'),
                        _buildDivider(),
                        _buildPlanMetaItem('OPD limit', '₹15,000 / yr'),
                        _buildDivider(),
                        _buildPlanMetaItem('Coverage', '12 months'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanMetaItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppDesign.caption.copyWith(
              color: Colors.white.withOpacity(0.55),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppDesign.labelSm.copyWith(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INCLUDED SERVICES',
            style: AppDesign.caption.copyWith(
              color: AppDesign.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
            children:
                _serviceItems.map((item) => _buildServiceTile(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile(_ServiceItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppDesign.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: AppDesign.divider, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.bgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              item.emoji,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            item.label,
            style: AppDesign.caption.copyWith(
              color: AppDesign.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
        children: [
          _buildStatCard('Specialities', '30+'),
          _buildStatCard('Specialized doctors', '10,000+'),
          _buildStatCard('Years of experience', '10+'),
          _buildStatCard('Online appointments', '10,000+'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppDesign.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        boxShadow: AppDesign.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppDesign.caption.copyWith(
              color: AppDesign.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppDesign.headingMd.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppDesign.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOW IT WORKS',
            style: AppDesign.caption.copyWith(
              color: AppDesign.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildHowStep(
            icon: Icons.add_circle_outline_rounded,
            text: 'Subscribe to a plan',
            isActive: true,
          ),
          const SizedBox(height: 8),
          _buildHowStep(
            icon: Icons.description_outlined,
            text: 'Claim your OPD bills',
            isActive: false,
          ),
          const SizedBox(height: 8),
          _buildHowStep(
            icon: Icons.account_balance_wallet_outlined,
            text: 'Get reimbursed',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHowStep({
    required IconData icon,
    required String text,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: isActive ? _headerColor : AppDesign.surface,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border:
            isActive ? null : Border.all(color: AppDesign.divider, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.15)
                  : AppDesign.accentLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppDesign.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppDesign.titleMd.copyWith(
              color: isActive ? Colors.white : AppDesign.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Service Items Data ────────────────────────────────────────────────────────

class _ServiceItem {
  final String emoji;
  final String label;
  final Color bgColor;

  const _ServiceItem(this.emoji, this.label, this.bgColor);
}

const List<_ServiceItem> _serviceItems = [
  _ServiceItem('🏥', 'In-clinic\nconsultations', Color(0xFFE8F0FE)),
  _ServiceItem('📱', 'Online\nconsultations', Color(0xFFE8F7EF)),
  _ServiceItem('🔬', 'Diagnostics', Color(0xFFFEF3E2)),
  _ServiceItem('💊', 'Pharmacy', Color(0xFFFDE8F0)),
  _ServiceItem('🪪', 'Health card', Color(0xFFE8F0FE)),
  _ServiceItem('🩺', 'Health checkups', Color(0xFFE8F7EF)),
  _ServiceItem('🚑', 'Ambulance', Color(0xFFFDE8F0)),
  _ServiceItem('🏋️', 'Gym & fitness', Color(0xFFFEF3E2)),
  _ServiceItem('🧠', 'Mental wellness', Color(0xFFEDE8FE)),
  _ServiceItem('🎓', 'Special education', Color(0xFFE8F0FE)),
  _ServiceItem('💉', 'Vaccination', Color(0xFFE8F7EF)),
  _ServiceItem('🧘', 'Yoga', Color(0xFFFDE8F0)),
];
