import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/model/hospital/hospital_model.dart';
import 'package:opdsure/pages/profile_page/profile_page.dart';

/// Lists the hospitals a user has added, each with its approval status
/// (Approved / Pending / Rejected). Approved hospitals are shown first.
class HospitalsTab extends StatelessWidget {
  final ProfilePageController controller;

  const HospitalsTab(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final hospitals = controller.hospitals;

    // Still loading.
    if (hospitals == null) {
      return const Center(
        child: SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    if (hospitals.isEmpty) {
      return _buildEmptyState();
    }

    // Approved hospitals first, then the rest (pending/rejected).
    final sorted = [...hospitals]
      ..sort((a, b) {
        if (a.isApproved == b.isApproved) return 0;
        return a.isApproved ? -1 : 1;
      });

    return RefreshIndicator(
      color: AppDesign.primary,
      onRefresh: () => controller.getHospitals(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppDesign.spacingXl),
        itemCount: sorted.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDesign.spacingMd),
        itemBuilder: (context, index) => _HospitalTile(sorted[index]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppDesign.accentLight,
              borderRadius: BorderRadius.circular(AppDesign.radiusFull),
            ),
            child: const Icon(
              Icons.local_hospital_outlined,
              size: 32,
              color: AppDesign.accent,
            ),
          ),
          const SizedBox(height: AppDesign.spacingLg),
          Text(
            'No Hospitals Found',
            style: AppDesign.titleLg.copyWith(color: AppDesign.textSecondary),
          ),
          const SizedBox(height: AppDesign.spacingSm),
          const Text(
            'Hospitals you add will appear here',
            style: AppDesign.bodySm,
          ),
        ],
      ),
    );
  }
}

class _HospitalTile extends StatelessWidget {
  final HospitalRecord hospital;

  const _HospitalTile(this.hospital);

  @override
  Widget build(BuildContext context) {
    return AppCardView(
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      mChaild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppDesign.accentLight,
                  borderRadius: BorderRadius.circular(AppDesign.radiusMd),
                ),
                child: const Icon(
                  Icons.local_hospital_outlined,
                  size: 22,
                  color: AppDesign.accent,
                ),
              ),
              const SizedBox(width: AppDesign.spacingMd),
              Expanded(
                child: Text(
                  hospital.name.isNotEmpty ? hospital.name : 'Hospital',
                  style: AppDesign.titleLg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDesign.spacingSm),
              _StatusChip(hospital),
            ],
          ),
          if (hospital.address.isNotEmpty) ...[
            const SizedBox(height: AppDesign.spacingMd),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppDesign.textTertiary,
                ),
                const SizedBox(width: AppDesign.spacingXs),
                Expanded(
                  child: Text(
                    hospital.address,
                    style: AppDesign.bodySm,
                  ),
                ),
              ],
            ),
          ],
          // Show the reason when a hospital was rejected so the user knows why.
          if (hospital.isRejected && hospital.rejectionReason.isNotEmpty) ...[
            const SizedBox(height: AppDesign.spacingSm),
            Text(
              'Reason: ${hospital.rejectionReason}',
              style: AppDesign.caption.copyWith(color: AppDesign.error),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final HospitalRecord hospital;

  const _StatusChip(this.hospital);

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    if (hospital.isApproved) {
      color = AppDesign.success;
      icon = Icons.check_circle_outline_rounded;
    } else if (hospital.isRejected) {
      color = AppDesign.error;
      icon = Icons.cancel_outlined;
    } else {
      color = AppDesign.warning;
      icon = Icons.schedule_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacingSm,
        vertical: AppDesign.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            hospital.statusLabel,
            style: AppDesign.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
