import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/claim_count_tile.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../model/my_claim/my_claims_model.dart';

class ClaimsPage extends StatelessWidget {
  const ClaimsPage({super.key});

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
                    return RefreshIndicator(
                      color: AppDesign.primary,
                      onRefresh: () async {
                        typeController.refreshClaimListChange(false);
                        typeController.refreshClaimListChange(true);
                      },
                      child: ListView(
                        children: [
                          // Claims dashboard (Total / Pending / Settled)
                          _buildClaimsDashboard(myClaimsModel),
                          const SizedBox(height: AppDesign.spacingXl),
                          // Single action button
                          _buildActionButton(context),
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
