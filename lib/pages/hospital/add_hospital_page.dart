import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

class AddHospitalPage extends StatefulWidget {
  const AddHospitalPage({super.key});

  @override
  State<AddHospitalPage> createState() => _AddHospitalPageState();
}

class _AddHospitalPageState extends State<AddHospitalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitHospital() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty && phone.isEmpty) {
      CommonMethods.showToast('Please provide either email or phone number');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final opd = OpdSure.of(context);
      final response = await opd.client.addHospital(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        email: email.isNotEmpty ? email : null,
        phone: phone.isNotEmpty ? phone : null,
      );

      if (!mounted) return;

      if (response.success) {
        CommonMethods.showToast(response.message.isNotEmpty
            ? response.message
            : 'Hospital added successfully');
        context.pop(true);
      } else {
        CommonMethods.showToast(response.message.isNotEmpty
            ? response.message
            : 'Failed to add hospital');
        setState(() => _isSubmitting = false);
      }
    } catch (e) {
      if (mounted) {
        CommonMethods.showToast('Something went wrong. Please try again.');
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Add Hospital',
        onBackTap: () => context.pop(),
      ),
      childContent: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDesign.spacingXl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hospital Name
                _buildLabel('Hospital Name', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Enter hospital name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Hospital name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppDesign.spacingXl),

                // Address
                _buildLabel('Address', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                _buildTextField(
                  controller: _addressController,
                  hint: 'Enter hospital address',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppDesign.spacingXl),

                // Email
                _buildLabel('Email',
                    isRequired: false, suffix: '(email or phone required)'),
                const SizedBox(height: AppDesign.spacingSm),
                _buildTextField(
                  controller: _emailController,
                  hint: 'hospital@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$')
                          .hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppDesign.spacingXl),

                // Phone
                _buildLabel('Phone', isRequired: false, suffix: '(optional)'),
                const SizedBox(height: AppDesign.spacingSm),
                _buildTextField(
                  controller: _phoneController,
                  hint: 'Phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 7) {
                        return 'Enter a valid phone number';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppDesign.spacing3Xl),

                // Buttons
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: GestureDetector(
                        onTap: _isSubmitting ? null : () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDesign.spacingLg,
                          ),
                          decoration: BoxDecoration(
                            color: AppDesign.surface,
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusSm),
                            border: Border.all(color: AppDesign.divider),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: AppDesign.titleMd.copyWith(
                                color: AppDesign.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDesign.spacingMd),
                    // Submit
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: _isSubmitting ? null : _submitHospital,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDesign.spacingLg,
                          ),
                          decoration: BoxDecoration(
                            gradient: _isSubmitting
                                ? null
                                : AppDesign.primaryGradient,
                            color:
                                _isSubmitting ? AppDesign.textTertiary : null,
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusSm),
                            boxShadow:
                                _isSubmitting ? null : AppDesign.shadowSm,
                          ),
                          child: Center(
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Submit for Approval',
                                    style: AppDesign.titleMd.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDesign.spacingXl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false, String? suffix}) {
    return Row(
      children: [
        if (isRequired)
          Text('* ', style: AppDesign.bodyMd.copyWith(color: AppDesign.error)),
        Text(text, style: AppDesign.titleMd),
        if (suffix != null) ...[
          const SizedBox(width: AppDesign.spacingXs),
          Text(
            suffix,
            style: AppDesign.caption.copyWith(color: AppDesign.textTertiary),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: AppDesign.bodyMd.copyWith(color: AppDesign.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
        filled: true,
        fillColor: AppDesign.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacingLg,
          vertical: AppDesign.spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
          borderSide: const BorderSide(color: AppDesign.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
          borderSide: const BorderSide(color: AppDesign.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
          borderSide: const BorderSide(color: AppDesign.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
          borderSide: const BorderSide(color: AppDesign.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusSm),
          borderSide: const BorderSide(color: AppDesign.error, width: 1.5),
        ),
      ),
    );
  }
}
