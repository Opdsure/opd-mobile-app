import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/model/marketplace/marketplace_model.dart';
import 'package:opdsure/widget/opd_widget.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  static const Color _blue = AppConfig.primaryColor; // #486AB3
  static const Color _headingBlue = Color(0xFF1D4E9C);
  static const Color _bannerGreen = Color(0xFFE7F7EF);
  static const Color _bannerGreenBorder = Color(0xFFB6E4CE);
  static const Color _greenText = Color(0xFF0F7B4F);
  static const Color _labelDark = Color(0xFF2B2F36);

  bool _isLoading = true;
  List<MarketplaceCategory> _categories = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    try {
      final opd = OpdSure.of(context);
      final response = await opd.client.getMarketplace();
      if (!mounted) return;
      if (response.success && response.data != null) {
        final cats = List<MarketplaceCategory>.from(response.data!.categories)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        for (final cat in cats) {
          cat.subcategories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        }
        setState(() {
          _categories = cats;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Unable to load marketplace';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Unable to load marketplace';
          _isLoading = false;
        });
      }
    }
  }

  void _onSubcategoryTap(MarketplaceSubcategory sub) {
    // Open the items page for this subcategory.
    context.push(
      '/home/marketplace/items',
      extra: {'id': sub.id, 'name': sub.name},
    );
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

  // ─── Blue banner header ─────────────────────────────────────────────────────
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
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const Text(
                'MARKETPLACE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
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
      return const Center(
        child: CircularProgressIndicator(color: _blue),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < _categories.length; i++) ...[
            _buildCategorySection(_categories[i]),
            const SizedBox(height: 22),
          ],
          const SizedBox(height: 4),
          _buildBottomBanner(),
        ],
      ),
    );
  }

  // ─── Category section (flat, no card) ───────────────────────────────────────
  Widget _buildCategorySection(MarketplaceCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Text(
          category.name,
          style: const TextStyle(
            color: _headingBlue,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        // Short underline
        Container(
          height: 2.5,
          width: 44,
          decoration: BoxDecoration(
            color: _headingBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        // Icon grid — 4 columns, flat icons
        GridView.builder(
          itemCount: category.subcategories.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 18,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            return _SubcategoryTile(
              subcategory: category.subcategories[index],
              onTap: () => _onSubcategoryTap(category.subcategories[index]),
              labelColor: _labelDark,
              accent: _blue,
            );
          },
        ),
      ],
    );
  }

  // ─── Bottom green banner ────────────────────────────────────────────────────
  Widget _buildBottomBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _bannerGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _bannerGreenBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _greenText,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'One Marketplace. Complete Health.',
                  style: TextStyle(
                    color: _greenText,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Curated products & services in one place.',
                  style: TextStyle(
                    color: Color(0xFF3D6B54),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              Icons.storefront_outlined,
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

// ─── Subcategory tile (flat icon + 2-line label) ─────────────────────────────
class _SubcategoryTile extends StatelessWidget {
  final MarketplaceSubcategory subcategory;
  final VoidCallback onTap;
  final Color labelColor;
  final Color accent;

  const _SubcategoryTile({
    required this.subcategory,
    required this.onTap,
    required this.labelColor,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: _buildIcon(),
          ),
          const SizedBox(height: 8),
          _buildLabel(),
        ],
      ),
    );
  }

  /// Renders the label so that each word stays intact on its own line.
  /// A single long word (e.g. "Supplements", "Physiotherapy") is scaled down
  /// to fit the tile width instead of breaking mid-word, while multi-word
  /// names (e.g. "Nutrition Consultation") wrap naturally at the space.
  Widget _buildLabel() {
    final words = subcategory.name.trim().split(RegExp(r'\s+'));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final word in words)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              word,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                color: labelColor,
                fontSize: 11.5,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIcon() {
    if (!subcategory.hasIcon) {
      return Icon(Icons.category_rounded, color: accent, size: 34);
    }
    return Image.network(
      subcategory.iconUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: accent.withValues(alpha: 0.4),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.category_rounded, color: accent, size: 34);
      },
    );
  }
}
