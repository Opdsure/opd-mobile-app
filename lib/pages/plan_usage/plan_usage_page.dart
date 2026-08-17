import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/model/plan_usage/plan_usage_model.dart';
import 'package:opdsure/widget/opd_widget.dart';

class PlanUsagePage extends StatefulWidget {
  const PlanUsagePage({super.key});

  @override
  State<PlanUsagePage> createState() => _PlanUsagePageState();
}

class _PlanUsagePageState extends State<PlanUsagePage> {
  late Future<PlanUsageResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = OpdSure.of(context).client.getPlanUsage();
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final dt = DateTime.parse(iso);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return iso;
    }
  }

  String _formatDateTime(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Plan Usage'),
      childContent: FutureBuilder<PlanUsageResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppDesign.primary),
            );
          }
          if (snapshot.hasError || snapshot.data?.data == null) {
            return Center(
              child: Text(
                'Unable to load plan usage',
                style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
              ),
            );
          }

          final data = snapshot.data!.data!;
          final wallet = data.wallet!;

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: AppDesign.spacingMd,
              bottom: AppDesign.spacing5Xl,
            ),
            children: [
              // Active Plan Card
              _buildActivePlanCard(data),
              const SizedBox(height: AppDesign.spacingLg),

              // Wallet Summary
              _buildWalletSummary(wallet),
              const SizedBox(height: AppDesign.spacingLg),

              // Pending Amount
              _buildPendingAmount(wallet),
              const SizedBox(height: AppDesign.spacingLg),

              // Category-wise Claim Limits
              _buildCategoryLimits(data.categoryLimits),
              const SizedBox(height: AppDesign.spacingLg),

              // Overall Balance Summary
              _buildOverallBalance(data.balanceTotals),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivePlanCard(PlanUsageData data) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      decoration: BoxDecoration(
        color: AppDesign.card,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        boxShadow: AppDesign.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppDesign.successLight,
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                ),
                child: const Icon(Icons.verified_user_outlined,
                    color: AppDesign.success, size: 20),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Plan',
                        style: AppDesign.titleMd
                            .copyWith(color: AppDesign.success)),
                    Text('Your plan is active and in good standing.',
                        style: AppDesign.bodySm
                            .copyWith(color: AppDesign.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingLg),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: AppDesign.textTertiary),
              const SizedBox(width: 6),
              Text(
                'Plan Period',
                style:
                    AppDesign.caption.copyWith(color: AppDesign.textTertiary),
              ),
              const Spacer(),
              const Icon(Icons.access_time_outlined,
                  size: 14, color: AppDesign.textTertiary),
              const SizedBox(width: 6),
              Text(
                'As of',
                style:
                    AppDesign.caption.copyWith(color: AppDesign.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${_formatDate(data.planStartDate)} \u2013 ${_formatDate(data.planEndDate)}',
                style: AppDesign.labelSm.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  _formatDateTime(data.asOf),
                  style:
                      AppDesign.labelSm.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSummary(WalletUsage wallet) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      decoration: BoxDecoration(
        color: AppDesign.card,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        boxShadow: AppDesign.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                ),
                child: const Icon(Icons.account_balance_wallet_outlined,
                    color: AppDesign.primary, size: 18),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Wallet Summary', style: AppDesign.titleMd),
                    Text('Monitor your plan wallet usage',
                        style: AppDesign.bodySm
                            .copyWith(color: AppDesign.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingXl),

          // Balance & Utilised row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallet Balance',
                        style: AppDesign.caption
                            .copyWith(color: AppDesign.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      '\u20B9${wallet.balance.toStringAsFixed(2)}',
                      style: AppDesign.headingSm
                          .copyWith(color: AppDesign.primary),
                    ),
                    Text(
                      'of \u20B9${wallet.grantedAmount.toStringAsFixed(2)} credited',
                      style: AppDesign.caption
                          .copyWith(color: AppDesign.textTertiary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Utilised Amount',
                        style: AppDesign.caption
                            .copyWith(color: AppDesign.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      '\u20B9${wallet.utilisedAmount.toStringAsFixed(2)}',
                      style:
                          AppDesign.headingSm.copyWith(color: AppDesign.error),
                    ),
                    Text(
                      '${wallet.utilisedPercentage.toStringAsFixed(2)}% of total',
                      style: AppDesign.caption
                          .copyWith(color: AppDesign.textTertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingLg),

          // Settled & Pending row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settled Payouts',
                        style: AppDesign.caption
                            .copyWith(color: AppDesign.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      '\u20B9${wallet.settledAmount.toStringAsFixed(2)}',
                      style:
                          AppDesign.titleLg.copyWith(color: AppDesign.success),
                    ),
                    Text('Already paid out to you',
                        style: AppDesign.caption
                            .copyWith(color: AppDesign.textTertiary)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pending Payout',
                        style: AppDesign.caption
                            .copyWith(color: AppDesign.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      '\u20B9${wallet.pendingPayoutAmount.toStringAsFixed(2)}',
                      style:
                          AppDesign.titleLg.copyWith(color: AppDesign.warning),
                    ),
                    Text('Approved, payment in progress',
                        style: AppDesign.caption
                            .copyWith(color: AppDesign.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingXl),

          // Wallet utilised progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Wallet Utilised', style: AppDesign.labelSm),
              Text('${wallet.utilisedPercentage.toStringAsFixed(2)}%',
                  style: AppDesign.labelSm),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: wallet.utilisedPercentage / 100,
              minHeight: 8,
              backgroundColor: AppDesign.divider,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppDesign.primary),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\u20B9${wallet.utilisedAmount.toStringAsFixed(2)} of \u20B9${wallet.grantedAmount.toStringAsFixed(2)} utilised',
                style:
                    AppDesign.caption.copyWith(color: AppDesign.textTertiary),
              ),
              Text(
                '\u20B9${wallet.balance.toStringAsFixed(2)} remaining',
                style:
                    AppDesign.caption.copyWith(color: AppDesign.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingAmount(WalletUsage wallet) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacingLg, vertical: AppDesign.spacingMd),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFF57C00), size: 22),
          const SizedBox(width: AppDesign.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pending Amount',
                    style: AppDesign.titleMd
                        .copyWith(color: const Color(0xFFF57C00))),
                Text('Amount pending settlement',
                    style: AppDesign.caption
                        .copyWith(color: AppDesign.textSecondary)),
              ],
            ),
          ),
          Text(
            '\u20B9${wallet.pendingPayoutAmount.toStringAsFixed(2)}',
            style: AppDesign.headingSm.copyWith(color: const Color(0xFFF57C00)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLimits(List<CategoryLimit> categories) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      decoration: BoxDecoration(
        color: AppDesign.card,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        boxShadow: AppDesign.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                ),
                child: const Icon(Icons.category_outlined,
                    color: AppDesign.primary, size: 18),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category-wise Claim Limits',
                        style: AppDesign.titleMd),
                    Text(
                        'Track your usage and remaining limits for each category',
                        style: AppDesign.bodySm
                            .copyWith(color: AppDesign.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingLg),
          ...categories.map((cat) => _buildCategoryRow(cat)),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(CategoryLimit cat) {
    final IconData icon;
    switch (cat.key) {
      case 'opd':
        icon = Icons.medical_services_outlined;
        break;
      case 'pharmacy':
        icon = Icons.local_pharmacy_outlined;
        break;
      case 'lab':
        icon = Icons.biotech_outlined;
        break;
      case 'vision':
        icon = Icons.visibility_outlined;
        break;
      case 'dental':
        icon = Icons.health_and_safety_outlined;
        break;
      case 'vaccination':
        icon = Icons.vaccines_outlined;
        break;
      case 'physio':
        icon = Icons.accessibility_new_outlined;
        break;
      default:
        icon = Icons.receipt_long_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDesign.spacingMd),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppDesign.divider.withOpacity(0.5))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppDesign.textSecondary),
          const SizedBox(width: AppDesign.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat.shortLabel,
                    style: AppDesign.titleMd
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(
                  '${cat.coveragePercentage}% coverage  \u2022  Per Claim: \u20B9${cat.perClaimLimit}',
                  style:
                      AppDesign.caption.copyWith(color: AppDesign.textTertiary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cat.usedPercentage.toStringAsFixed(0)}% used',
                  style: AppDesign.caption.copyWith(
                    color: cat.usedPercentage > 75
                        ? AppDesign.error
                        : AppDesign.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\u20B9${cat.remainingLimit}',
                style: AppDesign.titleMd.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'of \u20B9${cat.totalLimit} left',
                style:
                    AppDesign.caption.copyWith(color: AppDesign.textTertiary),
              ),
            ],
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right,
              size: 18, color: AppDesign.textTertiary),
        ],
      ),
    );
  }

  Widget _buildOverallBalance(BalanceTotals? totals) {
    if (totals == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                ),
                child: const Icon(Icons.pie_chart_outline,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Balance Summary',
                      style: AppDesign.titleMd.copyWith(color: Colors.white)),
                  Text('Total policy limit across all categories',
                      style: AppDesign.caption.copyWith(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingXl),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Total Limit',
                        style:
                            AppDesign.caption.copyWith(color: Colors.white60)),
                    const SizedBox(height: 4),
                    Text('\u20B9${totals.totalLimit}',
                        style: AppDesign.headingSm.copyWith(
                            color: AppDesign.success,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Consumed Limit',
                        style:
                            AppDesign.caption.copyWith(color: Colors.white60)),
                    const SizedBox(height: 4),
                    Text('\u20B9${totals.consumedLimit}',
                        style: AppDesign.headingSm.copyWith(
                            color: AppDesign.error,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Remaining Limit',
                        style:
                            AppDesign.caption.copyWith(color: Colors.white60)),
                    const SizedBox(height: 4),
                    Text('\u20B9${totals.remainingLimit}',
                        style: AppDesign.headingSm.copyWith(
                            color: AppDesign.success,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
