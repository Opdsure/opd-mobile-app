import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/model/partnership/partnership_model.dart';
import 'package:opdsure/pages/homepage/partnership_video_card.dart';
import 'package:opdsure/utils/url_helper.dart';

class PartnershipCarousel extends StatelessWidget {
  final List<PartnershipItem> items;

  const PartnershipCarousel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.8;
    const double cardHeight = 150.0;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppDesign.spacingXs),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDesign.spacingMd),
        itemBuilder: (context, index) {
          final item = items[index];
          return _PartnershipCard(
            item: item,
            width: cardWidth,
            height: cardHeight,
          );
        },
      ),
    );
  }
}

class _PartnershipCard extends StatelessWidget {
  final PartnershipItem item;
  final double width;
  final double height;

  const _PartnershipCard({
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHelper.launchExternalUrl(item.redirectUrl),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppDesign.card,
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          boxShadow: AppDesign.shadowMd,
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildAsset(),
      ),
    );
  }

  Widget _buildAsset() {
    if (item.isVideo) {
      return PartnershipVideoCard(
        videoUrl: item.assetUrl,
        width: width,
        height: height,
      );
    }

    if (item.isImage) {
      return Image.network(
        item.assetUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    }

    return _buildErrorPlaceholder();
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppDesign.accentLight,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppDesign.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppDesign.accentLight,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppDesign.textTertiary,
          size: 32,
        ),
      ),
    );
  }
}
