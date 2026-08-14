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
import 'package:opdsure/model/partnership/partnership_model.dart';
import 'package:opdsure/pages/claim_pages/claim_tile.dart';
import 'package:opdsure/pages/homepage/partnership_carousel.dart';
import 'package:opdsure/pages/homepage/partnership_icons.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/logs/logs.dart';
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

  // Partnership state
  bool _isPartnershipLoading = true;
  List<PartnershipItem> _carouselItems = [];
  List<PartnershipItem> _iconItems = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPartnerships();
    });
  }

  Future<void> _fetchPartnerships() async {
    if (!mounted) return;
    try {
      final opd = OpdSure.of(context);
      final response = await opd.client.getPartnerships();
      if (!mounted) return;
      if (response.success && response.data != null) {
        final carousel = List<PartnershipItem>.from(response.data!.carousel)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        final icons = List<PartnershipItem>.from(response.data!.icons)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        setState(() {
          _carouselItems = carousel;
          _iconItems = icons;
          _isPartnershipLoading = false;
        });
      } else {
        setState(() {
          _isPartnershipLoading = false;
        });
      }
    } catch (e) {
      Logs().w('HomePage: Failed to fetch partnerships: $e');
      if (mounted) {
        setState(() {
          _isPartnershipLoading = false;
        });
      }
    }
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
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppDesign.primaryGradient,
                borderRadius: BorderRadius.circular(AppDesign.radiusSm),
              ),
              child: Center(
                child: Text(
                  _getGreetingEmoji(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: AppDesign.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getTimeGreeting(),
                    style: AppDesign.bodySm.copyWith(
                      color: AppDesign.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    OpdSure.of(context).profileData?.name ?? 'User',
                    style: AppDesign.titleLg.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      childContent: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDesign.spacingMd),

              // Partnership Carousel
              _buildPartnershipCarousel(),

              // Services Section (horizontal scroll for compact height)
              const Text('Services', style: AppDesign.headingSm),
              const SizedBox(height: AppDesign.spacingMd),

              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: HomePage.serviceTittle(context).length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppDesign.spacingMd),
                  itemBuilder: (context, index) {
                    final service =
                        HomePage.serviceTittle(context, callBack: (value) {
                      widget.callback(value);
                    })[index];
                    return GestureDetector(
                      onTap: service.onTap,
                      child: SizedBox(
                        width: 80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppDesign.accentLight,
                                borderRadius:
                                    BorderRadius.circular(AppDesign.radiusMd),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppDesign.radiusMd),
                                child: Image.asset(
                                  service.image,
                                  fit: BoxFit.contain,
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDesign.spacingXs),
                            Text(
                              service.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppDesign.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppDesign.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppDesign.spacingXxl),

              // Partnership Icons
              _buildPartnershipIcons(),

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

  Widget _buildPartnershipCarousel() {
    if (_isPartnershipLoading) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppDesign.spacingLg),
        child: _buildCarouselSkeleton(),
      );
    }
    if (_carouselItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppDesign.spacingLg),
        child: _buildCarouselPlaceholder(),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spacingLg),
      child: PartnershipCarousel(items: _carouselItems),
    );
  }

  Widget _buildPartnershipIcons() {
    if (_isPartnershipLoading) {
      return const SizedBox.shrink();
    }
    if (_iconItems.isEmpty) {
      return _buildIconsPlaceholder();
    }
    return PartnershipIcons(items: _iconItems);
  }

  Widget _buildCarouselPlaceholder() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.92;

    return Container(
      width: cardWidth,
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppDesign.heroGradient,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        boxShadow: AppDesign.shadowMd,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesign.spacingXl,
              vertical: AppDesign.spacingLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spacingSm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  ),
                  child: Text(
                    'Partnerships',
                    style: AppDesign.caption.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDesign.spacingSm),
                Text(
                  'Exclusive Partner Offers',
                  style: AppDesign.titleLg.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Coming soon \u2014 health & wellness deals from our partners',
                  style: AppDesign.bodySm.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSkeleton() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.75;
    const cardHeight = 150.0;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppDesign.spacingXs),
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: AppDesign.spacingMd),
        itemBuilder: (context, index) {
          return _ShimmerCard(width: cardWidth, height: cardHeight);
        },
      ),
    );
  }

  Widget _buildIconsPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Partnerships', style: AppDesign.headingSm),
        const SizedBox(height: AppDesign.spacingMd),
        GridView.builder(
          itemCount: 4,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: AppDesign.spacingMd,
            mainAxisSpacing: AppDesign.spacingMd,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppDesign.accentLight,
                      borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                    ),
                    child: Center(
                      child: Icon(
                        _placeholderIcons[index % _placeholderIcons.length],
                        color: AppDesign.primary.withValues(alpha: 0.4),
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDesign.spacingXs),
                Text(
                  _placeholderLabels[index % _placeholderLabels.length],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppDesign.labelSm.copyWith(
                    color: AppDesign.textTertiary,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  static const List<IconData> _placeholderIcons = [
    Icons.handshake_outlined,
    Icons.local_offer_outlined,
    Icons.health_and_safety_outlined,
    Icons.card_giftcard_outlined,
  ];

  static const List<String> _placeholderLabels = [
    'Partner 1',
    'Partner 2',
    'Partner 3',
    'Partner 4',
  ];

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return '\u2600\uFE0F'; // sun
    } else if (hour >= 12 && hour < 17) {
      return '\u{1F324}\uFE0F'; // sun behind cloud
    } else {
      return '\u{1F319}'; // crescent moon
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

/// Animated shimmer card for loading skeleton
class _ShimmerCard extends StatefulWidget {
  final double width;
  final double height;

  const _ShimmerCard({required this.width, required this.height});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.radiusLg),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFFEEF0FF),
                Color(0xFFF8F9FF),
                Color(0xFFEEF0FF),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
