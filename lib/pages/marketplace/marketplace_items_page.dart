import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/model/marketplace/marketplace_items_model.dart';
import 'package:opdsure/pages/homepage/partnership_video_card.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/url_helper.dart';
import 'package:opdsure/widget/opd_widget.dart';

class MarketplaceItemsPage extends StatefulWidget {
  final String subcategoryId;
  final String subcategoryName;

  const MarketplaceItemsPage({
    super.key,
    required this.subcategoryId,
    required this.subcategoryName,
  });

  @override
  State<MarketplaceItemsPage> createState() => _MarketplaceItemsPageState();
}

class _MarketplaceItemsPageState extends State<MarketplaceItemsPage> {
  static const Color _blue = AppConfig.primaryColor; // #486AB3
  static const Color _labelDark = Color(0xFF2B2F36);

  bool _isLoading = true;
  List<MarketplaceItem> _items = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    try {
      final opd = OpdSure.of(context);
      final response = await opd.client.getMarketplaceItems(widget.subcategoryId);
      if (!mounted) return;
      if (response.success) {
        final items = List<MarketplaceItem>.from(response.items)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        setState(() {
          _items = items;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Unable to load items';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Unable to load items';
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTap(MarketplaceItem item) {
    if (item.hasRedirect) {
      UrlHelper.launchExternalUrl(item.redirectUrl);
    } else {
      CommonMethods.customAlertBox(
        context,
        title: item.title.isNotEmpty ? item.title : widget.subcategoryName,
        message:
            'This feature is coming soon. Stay tuned — we\'re working on it!',
        positiveButton: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 52),
                child: Text(
                  widget.subcategoryName.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _blue));
    }
    if (_error != null) {
      return _buildErrorState();
    }
    if (_items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _ItemCard(
          item: _items[index],
          onTap: () => _onItemTap(_items[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 44,
              color: _blue.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 14),
            const Text(
              'No items available yet',
              style: TextStyle(
                color: _labelDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Check back soon for ${widget.subcategoryName}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8A8F98),
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 44,
              color: _blue.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 14),
            Text(
              _error ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _labelDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _fetchData();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Item card (image/video with title + subtitle at bottom) ─────────────────
class _ItemCard extends StatelessWidget {
  final MarketplaceItem item;
  final VoidCallback onTap;

  const _ItemCard({required this.item, required this.onTap});

  static const double _cardHeight = 200;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32; // page horizontal pad

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Media
            SizedBox(
              width: double.infinity,
              height: _cardHeight,
              child: _buildMedia(width),
            ),
            // Bottom gradient scrim for legibility
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                  ),
                ),
              ),
            ),
            // Title + subtitle at bottom
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.title.isNotEmpty)
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 12.5,
                        height: 1.25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Video play indicator
            if (item.isVideo)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia(double width) {
    if (item.isVideo) {
      return PartnershipVideoCard(
        videoUrl: item.assetUrl,
        width: width,
        height: _cardHeight,
      );
    }
    if (item.isImage) {
      return Image.network(
        item.assetUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _placeholder(loading: true);
        },
        errorBuilder: (context, error, stackTrace) =>
            _placeholder(loading: false),
      );
    }
    return _placeholder(loading: false);
  }

  Widget _placeholder({required bool loading}) {
    return Container(
      color: const Color(0xFFEFF2F7),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppConfig.primaryColor,
                ),
              )
            : Icon(
                Icons.image_outlined,
                size: 34,
                color: AppConfig.primaryColor.withValues(alpha: 0.4),
              ),
      ),
    );
  }
}
