import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/claim_count_tile.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/claim_status_model.dart';
import 'package:opdsure/pages/claim_pages/claim_tile.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../model/my_claim/my_claims_model.dart';

class ClaimsPage extends StatefulWidget {
  const ClaimsPage({super.key});

  @override
  State<ClaimsPage> createState() => _ClaimsPageState();
}

class _ClaimsPageState extends State<ClaimsPage> {
  // Client-side pagination. get-claims returns every record in one response,
  // so we reveal them in pages of [_pageSize] and grow [_visibleCount] as the
  // user scrolls to the bottom — keeping the list cheap to build for large
  // datasets without changing the API.
  static const int _pageSize = 10;
  int _visibleCount = _pageSize;

  final ScrollController _scrollController = ScrollController();
  int _loadedTotal = 0; // total records available in the current response

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // When near the bottom, reveal the next page (if any remain).
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_visibleCount < _loadedTotal) {
        setState(() {
          _visibleCount = (_visibleCount + _pageSize).clamp(0, _loadedTotal);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    return DefaultTabController(
      length: 2,
      child: AppBasePage(
        appHeader: AppHomeHeader(
          title: Text('Claims', style: AppDesign.titleLg),
        ),
        childContent: Obx(() {
          bool refresh = typeController.refreshClaimList.value;
          return refresh
              ? FutureBuilder<MyClaimsModel?>(
                  future: OpdSure.of(context).client.getAllClaims(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return _buildLoadingState();
                    }
                    MyClaimsModel myClaimsModel = snapshot.data!;
                    final List<ClaimRecords> records =
                        myClaimsModel.data?.records ?? [];
                    _loadedTotal = records.length;
                    // Clamp in case a refresh returned fewer records.
                    final int visible = _visibleCount.clamp(0, records.length);

                    return RefreshIndicator(
                      color: AppDesign.primary,
                      onRefresh: () async {
                        // Reset pagination on manual refresh.
                        _visibleCount = _pageSize;
                        typeController.refreshClaimListChange(false);
                        typeController.refreshClaimListChange(true);
                      },
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          // Claims dashboard (Total / Pending / Settled)
                          _buildClaimsDashboard(myClaimsModel),
                          const SizedBox(height: AppDesign.spacingXl),
                          // Single action button
                          _buildActionButton(context),
                          const SizedBox(height: AppDesign.spacingXl),
                          // Paginated claims list — each card shows its status.
                          _buildClaimsList(records, visible),
                        ],
                      ),
                    );
                  },
                )
              : _buildLoadingState();
        }),
      ),
    );
  }

  // Total / Pending / Settled count tiles shown at the top of the Claims page.
  Widget _buildClaimsDashboard(MyClaimsModel myClaimsModel) {
    return Row(
      children: [
        Expanded(
          child: ClaimCountTile(
            count: myClaimsModel.data!.getTotalClaim,
            title: 'Total',
          ),
        ),
        Expanded(
          child: ClaimCountTile(
            count: myClaimsModel.data!.getPendingClaim,
            title: 'Pending',
          ),
        ),
        Expanded(
          child: ClaimCountTile(
            count: myClaimsModel.data!.getSettledClaim,
            title: 'Settled',
          ),
        ),
      ],
    );
  }

  // The paginated list of claim cards. Only [visible] of [records] are built;
  // a footer shows progress and lets the user reveal the next page (also
  // triggered automatically on scroll-to-bottom).
  Widget _buildClaimsList(List<ClaimRecords> records, int visible) {
    if (records.isEmpty) {
      return _buildEmptyClaims();
    }
    final bool hasMore = visible < records.length;
    return Column(
      children: [
        ListView.separated(
          itemCount: visible,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppDesign.spacingMd),
          itemBuilder: (context, index) {
            final ClaimRecords claim = records[index];
            final ClaimStatusModel claimStatus = ClaimStatusModel()
                .getClaimBuStatus(claim.status!, reSubmit: claim.resubmission!);
            final ClaimStatusModel disputeClaimStatus = ClaimStatusModel()
                .getDisputeClaimBuStatus(claim.disputeDetails!);
            return ClaimTile(
              records: claim,
              claimStatus: claimStatus,
              disputeClaimStatus: disputeClaimStatus,
            );
          },
        ),
        if (hasMore) ...[
          const SizedBox(height: AppDesign.spacingLg),
          _buildLoadMore(records.length),
        ],
      ],
    );
  }

  Widget _buildLoadMore(int total) {
    return Column(
      children: [
        AppButton(
          text: 'Load more',
          variant: AppButtonVariant.outline,
          size: AppButtonSize.small,
          onClick: () {
            setState(() {
              _visibleCount = (_visibleCount + _pageSize).clamp(0, total);
            });
          },
        ),
        const SizedBox(height: AppDesign.spacingSm),
        Text(
          'Showing ${_visibleCount.clamp(0, total)} of $total',
          style: AppDesign.caption.copyWith(color: AppDesign.textTertiary),
        ),
      ],
    );
  }

  Widget _buildEmptyClaims() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesign.spacingXl),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppDesign.accentLight,
                borderRadius: BorderRadius.circular(AppDesign.radiusFull),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 32,
                color: AppDesign.accent,
              ),
            ),
            const SizedBox(height: AppDesign.spacingLg),
            Text(
              'No Claims Found',
              style: AppDesign.titleLg.copyWith(color: AppDesign.textSecondary),
            ),
            const SizedBox(height: AppDesign.spacingSm),
            const Text(
              'Your filed claims will appear here',
              style: AppDesign.bodySm,
            ),
          ],
        ),
      ),
    );
  }

  // One blue button below the dashboard. Plan holders file a claim; others are
  // routed to plan benefits (behaviour preserved from the previous banner).
  Widget _buildActionButton(BuildContext context) {
    return OpdSure.of(context).client.isPlanPurchased
        ? AppButton(
            text: 'File a claim',
            onClick: () {
              context.push('/home/file_claim', extra: {
                'isUpdate': false,
                'records': null,
              });
            },
          )
        : AppButton(
            text: 'View Plan Benefits',
            onClick: () {
              context.push('/home/plan-benefits');
            },
          );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppDesign.accent.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: AppDesign.spacingMd),
          Text(
            'Loading claims...',
            style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
          ),
        ],
      ),
    );
  }
}
