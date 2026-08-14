import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/model/partnership/partnership_model.dart';
import 'package:opdsure/utils/url_helper.dart';

class PartnershipIcons extends StatelessWidget {
  final List<PartnershipItem> items;

  const PartnershipIcons({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Partnerships', style: AppDesign.headingSm),
        const SizedBox(height: AppDesign.spacingMd),
        GridView.builder(
          itemCount: items.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: AppDesign.spacingMd,
            mainAxisSpacing: AppDesign.spacingMd,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return _PartnershipIconCard(item: items[index]);
          },
        ),
      ],
    );
  }
}

class _PartnershipIconCard extends StatelessWidget {
  final PartnershipItem item;

  const _PartnershipIconCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHelper.launchExternalUrl(item.redirectUrl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppDesign.card,
                borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                boxShadow: AppDesign.shadowSm,
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildIcon(),
            ),
          ),
          const SizedBox(height: AppDesign.spacingXs),
          Text(
            item.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppDesign.labelSm.copyWith(
              fontWeight: FontWeight.w600,
              color: AppDesign.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (item.isImage) {
      return Image.network(
        item.assetUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppDesign.primary,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppDesign.textTertiary,
              size: 24,
            ),
          );
        },
      );
    }

    return const Center(
      child: Icon(
        Icons.link,
        color: AppDesign.textTertiary,
        size: 24,
      ),
    );
  }
}
