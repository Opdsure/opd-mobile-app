import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/claim_count_tile.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/claim_pages/claim_tile.dart';
import 'package:opdsure/pages/homepage/home_service_tile.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/app_config.dart';
import '../../model/claim_status_model.dart';
import '../../model/my_claim/my_claims_model.dart';

typedef ValueCallback = void Function(int value);

class OpdService {
  String image;
  String title;
  VoidCallback onTap;

  OpdService({required this.title, required this.onTap, required this.image});
}

class HomePage extends StatefulWidget {
  final ValueCallback callback;

  const HomePage({required this.callback, super.key});

  static const List<IconData> icons = [
    Icons.chat,
    Icons.phone,
    Icons.group_add
  ];

  Future<void> launchDynamicUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  static List<OpdService> serviceTittle(BuildContext context,
          {ValueCallback? callBack}) =>
      [
        OpdService(
            title: 'In-Clinic Doctor',
            image: 'assets/images/offline_doc.png',
            onTap: () {
              CommonMethods.customAlertBox2(context,
                  title: 'In-Clinic Consultation',
                  message:
                      '\u{1F3E5} Freedom to visit any Clinic or Hospital\n\u{1F4CD} No Network Restrictions\n\u{1F468}\u{200D}\u{2695}\u{FE0F} Consult with Specialist Doctors\n\u{23F0} 24/7 Doctor Access\n\u{1F33F} Allopathy, Homeopathy, Ayurveda & Unani',
                  text2: "Term & Condition apply*");
            }),
        OpdService(
            title: 'Online Doctor',
            image: 'assets/images/online_doc.png',
            onTap: () async {
              CommonMethods.showAlertDialog(context);
              final opd = OpdSure.of(context);
              if (opd.profileData!.plan!.purchased!) {
                try {
                  final mfine = await opd.client.mFine();
                  Navigator.of(context).pop();
                  if (Platform.isIOS) {
                    context.push('/home/web_view',
                        extra: mfine.data!.redirectUrl!);
                  } else {
                    final Uri uri = Uri.parse(mfine.data!.redirectUrl!);
                    if (!await launchUrl(uri,
                        mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch the mfine URL');
                    }
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  CommonMethods.customAlertBox(
                    context,
                    title: 'Alert',
                    message: "Service coming soon",
                  );
                }
              } else {
                Navigator.of(context).pop();
                CommonMethods.customAlertBox(
                  context,
                  title: 'Alert',
                  message:
                      "You don't have a valid plan to consult a doctor. Please purchase a plan first.",
                );
              }
            }),
        OpdService(
            title: 'Pharmacy',
            image: 'assets/images/pharma.png',
            onTap: () async {
              CommonMethods.customAlertBox(
                context,
                negativeButton: 'PharmEasy',
                positiveButton: 'Apollo 24/7',
                okCallBack: (context1) {
                  Navigator.of(context1, rootNavigator: true).pop();
                  context.push('/home/web_view',
                      extra: AppConfig.apolloPharmaUrll);
                },
                cancelCallBack: (context1) {
                  Navigator.of(context1, rootNavigator: true).pop();
                  context.push('/home/web_view',
                      extra: AppConfig.pharmaEasyUrl);
                },
                isCancelButton: true,
                message: "Please select one",
                title: "Pharmacy",
                shouldDismiss: true,
              );
            }),
        OpdService(
            title: 'Diagnostic',
            image: 'assets/images/diag.png',
            onTap: () {
              context.push('/home/web_view', extra: AppConfig.apolloPharmaUrl);
            }),
        OpdService(
            title: 'Free Health Checkups',
            image: 'assets/images/health.png',
            onTap: () {
              final opd = OpdSure.of(context);
              if (opd.profileData!.plan!.purchased!) {
                context.push('/home/book_checkup/add_health_checkup');
              } else {
                Navigator.of(context).pop();
                CommonMethods.customAlertBox(
                  context,
                  title: 'Alert',
                  message:
                      "You don't have a valid plan to book. Please purchase a plan first.",
                );
              }
            }),
        OpdService(
            title: 'Ambulance',
            image: 'assets/images/ambu.png',
            onTap: () {
              launchUrl(Uri(scheme: 'tel', path: '102'));
            }),
        OpdService(
            title: 'Simplify Insurance',
            image: 'assets/images/insurance.png',
            onTap: () {
              context.push('/home/web_view',
                  extra: AppConfig.simplyfiyInsurenceUrl);
            }),
      ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppDesign.animSlow,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: AppDesign.animCurve,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());

    return AppBasePage(
      appHeader: AppHomeHeader(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hi, ',
                style: AppDesign.titleLg.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppDesign.textSecondary,
                ),
              ),
              TextSpan(
                text: OpdSure.of(context).profileData!.name ?? 'User',
                style: AppDesign.titleLg,
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      childContent: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDesign.spacingLg),

              // Hero Gradient Card
              _buildHeroCard(context),

              const SizedBox(height: AppDesign.spacingXxl),

              // Services Section
              const Text('Services', style: AppDesign.headingSm),
              const SizedBox(height: AppDesign.spacingMd),

              GridView.builder(
                itemCount: HomePage.serviceTittle(context).length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return HomeServiceTile(
                    width: 100,
                    height: 100,
                    index: index,
                    title: HomePage.serviceTittle(context)[index],
                    onTap: HomePage.serviceTittle(context, callBack: (value) {
                      widget.callback(value);
                    })[index]
                        .onTap,
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppDesign.spacingMd,
                  mainAxisSpacing: AppDesign.spacingMd,
                  childAspectRatio: 0.78,
                ),
              ),

              const SizedBox(height: AppDesign.spacingXxl),

              // My Claims Section
              _buildClaimsSection(typeController),

              const SizedBox(height: AppDesign.spacing3Xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final opd = OpdSure.of(context);
    final hasPlan = opd.profileData?.plan?.purchased ?? false;

    return AppGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spacingMd,
                  vertical: AppDesign.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                ),
                child: Text(
                  hasPlan ? 'Active Plan' : 'No Active Plan',
                  style: AppDesign.labelSm.copyWith(color: Colors.white),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spacingXl),
          Text(
            'Total Coverage',
            style: AppDesign.bodySm.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppDesign.spacingXs),
          Text(
            hasPlan ? '\u20B9 ${_getPlanAmount(opd)}' : '\u20B9 0.00',
            style: AppDesign.headingLg.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: AppDesign.spacingXl),
          GestureDetector(
            onTap: () => context.push('/home/plans'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spacingLg,
                vertical: AppDesign.spacingMd,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDesign.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hasPlan ? 'View Plan' : 'Get a Plan',
                    style: AppDesign.titleMd.copyWith(
                      color: AppDesign.primary,
                    ),
                  ),
                  const SizedBox(width: AppDesign.spacingSm),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppDesign.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPlanAmount(dynamic opd) {
    try {
      final amount = opd.profileData?.plan?.walletBalance ?? 0;
      return CommonMethods.amountFormater(amount.toString());
    } catch (_) {
      return '0.00';
    }
  }

  Widget _buildClaimsSection(TypeController typeController) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Claims', style: AppDesign.headingSm),
            GestureDetector(
              onTap: () => widget.callback.call(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spacingMd,
                  vertical: AppDesign.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: AppDesign.accentLight,
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: AppDesign.labelSm.copyWith(
                        color: AppDesign.primary,
                      ),
                    ),
                    const SizedBox(width: AppDesign.spacingXs),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppDesign.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesign.spacingMd),
        Obx(() {
          bool refresh = typeController.refreshClaimList.value;
          return refresh
              ? FutureBuilder<MyClaimsModel?>(
                  future: OpdSure.of(context).client.getAllClaims(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return _buildClaimsLoading();
                    } else {
                      MyClaimsModel? myClaimsModel = snapshot.data;
                      List<ClaimRecords> listData =
                          myClaimsModel!.data!.records!;
                      return listData.isEmpty
                          ? _buildEmptyClaims()
                          : _buildClaimsList(myClaimsModel, listData);
                    }
                  },
                )
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildClaimsLoading() {
    return AppCardView(
      mChaild: Padding(
        padding: const EdgeInsets.all(AppDesign.spacingXl),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppDesign.primary.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: AppDesign.spacingMd),
              Text(
                'Loading claims...',
                style: AppDesign.bodySm.copyWith(color: AppDesign.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyClaims() {
    return AppCardView(
      mChaild: Padding(
        padding: const EdgeInsets.all(AppDesign.spacingXl),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.description_outlined,
                size: 40,
                color: AppDesign.textTertiary.withOpacity(0.5),
              ),
              const SizedBox(height: AppDesign.spacingMd),
              Text(
                'No claims yet',
                style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClaimsList(
      MyClaimsModel myClaimsModel, List<ClaimRecords> listData) {
    return Column(
      children: [
        // Claim count grid
        Row(
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
        ),
        const SizedBox(height: AppDesign.spacingLg),

        // Recent claims list
        ListView.separated(
          itemCount: listData.length > 3 ? 3 : listData.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppDesign.spacingMd),
          itemBuilder: (context, index) {
            ClaimRecords records = listData[index];
            ClaimStatusModel claimStatusModel = ClaimStatusModel()
                .getClaimBuStatus(records.status!,
                    reSubmit: records.resubmission!);
            ClaimStatusModel disputeClaimStatus = ClaimStatusModel()
                .getDisputeClaimBuStatus(records.disputeDetails!);
            return ClaimTile(
              records: records,
              claimStatus: claimStatusModel,
              disputeClaimStatus: disputeClaimStatus,
            );
          },
        ),
      ],
    );
  }
}
