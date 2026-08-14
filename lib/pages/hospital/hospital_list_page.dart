import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/model/hospital/hospital_model.dart';
import 'package:opdsure/widget/opd_widget.dart';

class HospitalListPage extends StatefulWidget {
  const HospitalListPage({super.key});

  @override
  State<HospitalListPage> createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<HospitalRecord> _hospitals = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHospitals();
    });
  }

  Future<void> _fetchHospitals() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final opd = OpdSure.of(context);
      final response = await opd.client.getHospitals();
      if (!mounted) return;
      if (response.success && response.data != null) {
        setState(() {
          _hospitals = response.data!.records;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hospitals = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'My Hospitals',
        onBackTap: () => context.pop(),
      ),
      childContent: Column(
        children: [
          // Subtitle + Add button
          Padding(
            padding: const EdgeInsets.only(
              top: AppDesign.spacingMd,
              bottom: AppDesign.spacingLg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Only approved hospitals can be used when raising a claim.',
                    style: AppDesign.bodySm.copyWith(
                      color: AppDesign.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: AppDesign.spacingMd),
                _buildAddButton(),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () async {
        final result = await context.push('/home/hospitals/add');
        if (result == true) {
          _fetchHospitals();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacingLg,
          vertical: AppDesign.spacingSm,
        ),
        decoration: BoxDecoration(
          gradient: AppDesign.primaryGradient,
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
          boxShadow: AppDesign.shadowSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 16),
            const SizedBox(width: AppDesign.spacingXs),
            Text(
              'Add Hospital',
              style: AppDesign.labelSm.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppDesign.primary,
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppDesign.textTertiary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDesign.spacingLg),
            Text(
              'Failed to load hospitals',
              style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
            ),
            const SizedBox(height: AppDesign.spacingLg),
            GestureDetector(
              onTap: _fetchHospitals,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spacingXl,
                  vertical: AppDesign.spacingMd,
                ),
                decoration: BoxDecoration(
                  color: AppDesign.accentLight,
                  borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                ),
                child: Text(
                  'Retry',
                  style: AppDesign.titleMd.copyWith(color: AppDesign.primary),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_hospitals.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _fetchHospitals,
      color: AppDesign.primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: AppDesign.spacing3Xl),
        itemCount: _hospitals.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDesign.spacingMd),
        itemBuilder: (context, index) {
          return _HospitalCard(hospital: _hospitals[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppDesign.accentLight,
              borderRadius: BorderRadius.circular(AppDesign.radiusXl),
            ),
            child: const Icon(
              Icons.local_hospital_outlined,
              size: 40,
              color: AppDesign.primary,
            ),
          ),
          const SizedBox(height: AppDesign.spacingXl),
          const Text(
            'No Hospitals Found',
            style: AppDesign.headingSm,
          ),
          const SizedBox(height: AppDesign.spacingSm),
          Text(
            'Add a hospital to get started with claims.',
            style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDesign.spacingXxl),
          GestureDetector(
            onTap: () async {
              final result = await context.push('/home/hospitals/add');
              if (result == true) {
                _fetchHospitals();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spacingXxl,
                vertical: AppDesign.spacingMd,
              ),
              decoration: BoxDecoration(
                gradient: AppDesign.primaryGradient,
                borderRadius: BorderRadius.circular(AppDesign.radiusSm),
                boxShadow: AppDesign.shadowMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 20),
                  const SizedBox(width: AppDesign.spacingSm),
                  Text(
                    'Add Hospital',
                    style: AppDesign.titleMd.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final HospitalRecord hospital;

  const _HospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return AppCardView(
      padding: const EdgeInsets.all(AppDesign.spacingLg),
      mChaild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name + Status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  hospital.name,
                  style: AppDesign.titleLg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDesign.spacingSm),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: AppDesign.spacingMd),

          // Contact info
          if (hospital.email.isNotEmpty)
            _buildInfoRow(Icons.email_outlined, hospital.email),
          if (hospital.phone.isNotEmpty)
            _buildInfoRow(Icons.phone_outlined, hospital.phone),
          if (hospital.address.isNotEmpty)
            _buildInfoRow(Icons.location_on_outlined, hospital.address),

          // Submitted date
          if (hospital.createdAt.isNotEmpty) ...[
            const SizedBox(height: AppDesign.spacingSm),
            Text(
              'Submitted: ${_formatDate(hospital.createdAt)}',
              style: AppDesign.caption.copyWith(color: AppDesign.textTertiary),
            ),
          ],

          // Rejection reason
          if (hospital.isRejected && hospital.rejectionReason.isNotEmpty) ...[
            const SizedBox(height: AppDesign.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDesign.spacingMd),
              decoration: BoxDecoration(
                color: AppDesign.errorLight,
                borderRadius: BorderRadius.circular(AppDesign.radiusSm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: AppDesign.error),
                  const SizedBox(width: AppDesign.spacingSm),
                  Expanded(
                    child: Text(
                      hospital.rejectionReason,
                      style: AppDesign.bodySm.copyWith(color: AppDesign.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;

    if (hospital.isApproved) {
      bgColor = AppDesign.successLight;
      textColor = AppDesign.success;
    } else if (hospital.isRejected) {
      bgColor = AppDesign.errorLight;
      textColor = AppDesign.error;
    } else {
      bgColor = AppDesign.warningLight;
      textColor = AppDesign.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacingMd,
        vertical: AppDesign.spacingXs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      child: Text(
        hospital.statusLabel,
        style: AppDesign.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spacingXs),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppDesign.textTertiary),
          const SizedBox(width: AppDesign.spacingSm),
          Expanded(
            child: Text(
              text,
              style: AppDesign.bodySm,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
