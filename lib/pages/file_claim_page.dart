import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/claim/calculate_claim_model.dart';
import 'package:opdsure/model/claim_json_model.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/single_claim_model.dart';
import 'package:opdsure/model/subscribed_plan_model.dart';
import 'package:opdsure/pages/upload_file_claim_doc.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../config/app_config.dart';
import '../custom_ui/app_bottom_sheet.dart';
import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_mobile_field.dart';
import '../model/hospital/hospital_model.dart';
import '../model/my_claim/my_claims_model.dart';
import '../model/plans/plans_response.dart';
import '../model/specialization_model.dart';
import '../utils/common_methods.dart';

class FileClaimPage extends StatefulWidget {
  final ClaimRecords? records;
  final bool? isUpdate;

  const FileClaimPage({super.key, this.records, this.isUpdate});

  @override
  State<FileClaimPage> createState() => _FileClaimPageState();
}

class _FileClaimPageState extends State<FileClaimPage> {
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController docNameCtrl = TextEditingController();
  TextEditingController regNumCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController diagnosisCtrl = TextEditingController();
  TextEditingController remarkCtrl = TextEditingController();
  TextEditingController docFeeCtrl = TextEditingController();
  TextEditingController docFeeClCtrl = TextEditingController();
  TextEditingController billAmntPhrCtrl = TextEditingController();
  TextEditingController billAmntPhrClCtrl = TextEditingController();
  TextEditingController billAmntDiaCtrl = TextEditingController();
  TextEditingController billAmntDiaClCtrl = TextEditingController();
  TextEditingController billAmntVisionCtrl = TextEditingController();
  TextEditingController billAmntVisionClCtrl = TextEditingController();
  TextEditingController billAmntDentalCtrl = TextEditingController();
  TextEditingController billAmntDentalClCtrl = TextEditingController();
  TextEditingController billAmntVaccinationCtrl = TextEditingController();
  TextEditingController billAmntVaccinationClCtrl = TextEditingController();
  TextEditingController billAmntPhysioCtrl = TextEditingController();
  TextEditingController billAmntPhysioClCtrl = TextEditingController();

  // Bill amounts
  double _value1 = 0.0; // doctor
  double _value2 = 0.0; // pharmacy
  double _value3 = 0.0; // diagnostics
  double _value4 = 0.0; // vision
  double _value5 = 0.0; // dental
  double _value6 = 0.0; // vaccination
  double _value7 = 0.0; // physiotherapy

  // Claimable amounts
  double _value11 = 0.0; // doctor
  double _value12 = 0.0; // pharmacy
  double _value13 = 0.0; // diagnostics
  double _value14 = 0.0; // vision
  double _value15 = 0.0; // dental
  double _value16 = 0.0; // vaccination
  double _value17 = 0.0; // physiotherapy

  // Applied rule labels per category
  String? _docFeeRuleLabel;
  String? _pharmacyRuleLabel;
  String? _diagnosticsRuleLabel;
  String? _visionRuleLabel;
  String? _dentalRuleLabel;
  String? _vaccinationRuleLabel;
  String? _physioRuleLabel;

  String totalBillAmnt = '';
  String totalClaimableAmnt = '';
  String claimId = '';
  String claimCombination = '';

  PlanRecords? records;
  ClaimRecords? cRecords;
  SingleClaimModel? singleClaimModel;

  // Cached reference data, fetched ONCE in initState. Previously the hospital
  // list was fetched inside build() via a FutureBuilder, so every setState
  // (e.g. typing a bill amount) re-fired getHospitals() and caused the field
  // to "reload then select again". Specialization is cached the same way.
  List<HospitalRecord> _approvedHospitals = [];
  bool _hospitalsLoading = true;
  List<SpclRecords> _specializations = [];
  bool _specializationsLoading = true;

  // Per-category "calculating claimable amount" flags, so each amount row can
  // show an inline spinner while its calculate-claim API call is in flight.
  bool _calcDocFee = false;
  bool _calcPharmacy = false;
  bool _calcDiagnostics = false;
  bool _calcVision = false;
  bool _calcDental = false;
  bool _calcVaccination = false;
  bool _calcPhysio = false;

  void _calculateSum() {
    setState(() {
      totalClaimableAmnt = (_value11 +
              _value12 +
              _value13 +
              _value14 +
              _value15 +
              _value16 +
              _value17)
          .toStringAsFixed(2);
      totalBillAmnt =
          (_value1 + _value2 + _value3 + _value4 + _value5 + _value6 + _value7)
              .toStringAsFixed(2);
    });
  }

  void docFee({String? value = '0'}) async {
    if (value == null || value.isEmpty) value = '0';
    final input = value;
    setState(() => _calcDocFee = true);
    try {
      var data = await OpdSure.of(context)
          .client
          .calculateClaimPrice('0', double.parse(input));
      CalculateClaimModel calculateClaimModel =
          CalculateClaimModel.fromJson(jsonDecode(data));
      setState(() {
        _value11 =
            double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
        _value1 = double.tryParse(input) ?? 0.0;
        docFeeClCtrl.text = _value11.toStringAsFixed(2);
        _docFeeRuleLabel = calculateClaimModel.data!.appliedRuleLabel;
        _calculateSum();
      });
    } catch (_) {
      _onCalcFailed("Doctor's Fees", () => docFee(value: input));
    } finally {
      if (mounted) setState(() => _calcDocFee = false);
    }
  }

  void pharmaBill({String? value = '0'}) async {
    if (value == null || value.isEmpty) value = '0';
    final input = value;
    String calculator = claimCombination == '1' ? '1' : '3';
    setState(() => _calcPharmacy = true);
    try {
      var data = await OpdSure.of(context)
          .client
          .calculateClaimPrice(calculator, double.parse(input));
      CalculateClaimModel calculateClaimModel =
          CalculateClaimModel.fromJson(jsonDecode(data));
      setState(() {
        _value12 =
            double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
        _value2 = double.tryParse(input) ?? 0.0;
        billAmntPhrClCtrl.text = _value12.toStringAsFixed(2);
        _pharmacyRuleLabel = calculateClaimModel.data!.appliedRuleLabel;
        _calculateSum();
      });
    } catch (_) {
      _onCalcFailed('Pharmacy', () => pharmaBill(value: input));
    } finally {
      if (mounted) setState(() => _calcPharmacy = false);
    }
  }

  void labBill({String? value = '0'}) async {
    if (value == null || value.isEmpty) value = '0';
    final input = value;
    setState(() => _calcDiagnostics = true);
    try {
      var data = await OpdSure.of(context)
          .client
          .calculateClaimPrice('2', double.parse(input));
      CalculateClaimModel calculateClaimModel =
          CalculateClaimModel.fromJson(jsonDecode(data));
      setState(() {
        _value13 =
            double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
        _value3 = double.tryParse(input) ?? 0.0;
        billAmntDiaClCtrl.text = _value13.toStringAsFixed(2);
        _diagnosticsRuleLabel = calculateClaimModel.data!.appliedRuleLabel;
        _calculateSum();
      });
    } catch (_) {
      _onCalcFailed('Diagnostics', () => labBill(value: input));
    } finally {
      if (mounted) setState(() => _calcDiagnostics = false);
    }
  }

  void visionBill({String? value = '0'}) async {
    if (value == null || value.isEmpty) value = '0';
    final input = value;
    setState(() => _calcVision = true);
    try {
      var data = await OpdSure.of(context)
          .client
          .calculateClaimPrice('4', double.parse(input));
      CalculateClaimModel calculateClaimModel =
          CalculateClaimModel.fromJson(jsonDecode(data));
      setState(() {
        _value14 =
            double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
        _value4 = double.tryParse(input) ?? 0.0;
        billAmntVisionClCtrl.text = _value14.toStringAsFixed(2);
        _visionRuleLabel = calculateClaimModel.data!.appliedRuleLabel;
        _calculateSum();
      });
    } catch (_) {
      _onCalcFailed('Vision', () => visionBill(value: input));
    } finally {
      if (mounted) setState(() => _calcVision = false);
    }
  }

  void dentalBill({String? value = '0'}) async {
    if (value == null || value.isEmpty) value = '0';
    final input = value;
    setState(() => _calcDental = true);
    try {
      var data = await OpdSure.of(context)
          .client
          .calculateClaimPrice('5', double.parse(input));
      CalculateClaimModel calculateClaimModel =
          CalculateClaimModel.fromJson(jsonDecode(data));
      setState(() {
        _value15 =
            double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
        _value5 = double.tryParse(input) ?? 0.0;
        billAmntDentalClCtrl.text = _value15.toStringAsFixed(2);
        _dentalRuleLabel = calculateClaimModel.data!.appliedRuleLabel;
        _calculateSum();
      });
    } catch (_) {
      _onCalcFailed('Dental', () => dentalBill(value: input));
    } finally {
      if (mounted) setState(() => _calcDental = false);
    }
  }

  void vaccinationBill({String? value = '0'}) async {
    if (value == null || value.isEmpty) value = '0';
    final input = value;
    setState(() => _calcVaccination = true);
    try {
      var data = await OpdSure.of(context)
          .client
          .calculateClaimPrice('6', double.parse(input));
      CalculateClaimModel calculateClaimModel =
          CalculateClaimModel.fromJson(jsonDecode(data));
      setState(() {
        _value16 =
            double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
        _value6 = double.tryParse(input) ?? 0.0;
        billAmntVaccinationClCtrl.text = _value16.toStringAsFixed(2);
        _vaccinationRuleLabel = calculateClaimModel.data!.appliedRuleLabel;
        _calculateSum();
      });
    } catch (_) {
      _onCalcFailed('Vaccination', () => vaccinationBill(value: input));
    } finally {
      if (mounted) setState(() => _calcVaccination = false);
    }
  }

  void physioBill({String? value = '0'}) async {
    if (value == null || value.isEmpty) value = '0';
    final input = value;
    setState(() => _calcPhysio = true);
    try {
      var data = await OpdSure.of(context)
          .client
          .calculateClaimPrice('7', double.parse(input));
      CalculateClaimModel calculateClaimModel =
          CalculateClaimModel.fromJson(jsonDecode(data));
      setState(() {
        _value17 =
            double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
        _value7 = double.tryParse(input) ?? 0.0;
        billAmntPhysioClCtrl.text = _value17.toStringAsFixed(2);
        _physioRuleLabel = calculateClaimModel.data!.appliedRuleLabel;
        _calculateSum();
      });
    } catch (_) {
      _onCalcFailed('Physiotherapy', () => physioBill(value: input));
    } finally {
      if (mounted) setState(() => _calcPhysio = false);
    }
  }

  // Shared failure handler for the per-category claimable calculation. Shows a
  // clear, retry-friendly message (the user can simply re-type/blur the field
  // to retry); [retry] is provided for a future inline retry affordance.
  void _onCalcFailed(String label, VoidCallback retry) {
    CommonMethods.showToast(
        'Could not calculate the claimable amount for $label. Please check your connection and try again.');
  }

  @override
  void initState() {
    super.initState();
    TypeController typeController = Get.put(TypeController());
    typeController.opdVisitDateChange('');
    typeController.selectClaimChange('');
    typeController.memberList.clear();
    typeController.stateList.clear();
    _getInitState();
    if (widget.isUpdate!) {
      cRecords = widget.records!;
      claimId = cRecords!.id!;
      MemberList memberList = MemberList(
          id: cRecords!.memberId!.id,
          name: cRecords!.memberId!.name,
          relation: cRecords!.memberId!.relation);
      typeController.memberListChange(memberList);
      typeController.opdVisitDateChange(cRecords!.opdDate!);
      phoneCtrl.text = '${cRecords!.docPhone!}';
      docNameCtrl.text = cRecords!.docName!;
      regNumCtrl.text = cRecords!.docRegistration!;
      emailCtrl.text = cRecords!.docEmail!;
      diagnosisCtrl.text = cRecords!.diagonosisDetail!;
      remarkCtrl.text = cRecords!.userRemark!;
      docFeeCtrl.text = '${cRecords!.doctorFee!}';
      docFeeClCtrl.text = '${cRecords!.claimableDoctorFee!}';
      OpdSure.of(context).client.getSingleClaims(cRecords!.id!).then((value) {
        singleClaimModel = SingleClaimModel.fromJson(jsonDecode(value));
      });
    }
    OpdSure.of(context).client.getSubscribedPlan().then((value) {
      SubscribedPlanModel subscribedPlanModel = value;
      setState(() {
        claimCombination = '${subscribedPlanModel.data!.claimCombination}';
        if (widget.isUpdate!) {
          if (claimCombination == '2') {
            totalBillAmnt = double.parse(cRecords!.billAmount.toString())
                .toStringAsFixed(0);
            totalClaimableAmnt =
                double.parse(cRecords!.claimableAmount.toString())
                    .toStringAsFixed(0);
            billAmntPhrCtrl.text = totalBillAmnt;
            billAmntPhrClCtrl.text = totalClaimableAmnt;
          } else {
            billAmntPhrCtrl.text = cRecords!.pharmacyFee == null
                ? ''
                : '${cRecords!.pharmacyFee!}';
            billAmntPhrClCtrl.text = cRecords!.claimablePharmacyFee == null
                ? ''
                : '${cRecords!.claimablePharmacyFee!}';
            billAmntDiaCtrl.text =
                cRecords!.labTestFee == null ? '' : '${cRecords!.labTestFee!}';
            billAmntDiaClCtrl.text = cRecords!.claimableLabTestFee == null
                ? ''
                : '${cRecords!.claimableLabTestFee!}';
            totalBillAmnt = double.parse(cRecords!.billAmount!.toString())
                .toStringAsFixed(0);
            totalClaimableAmnt =
                double.parse(cRecords!.claimableAmount!.toString())
                    .toStringAsFixed(0);
          }
        }
      });
    });
  }

  _getInitState() async {
    final opd = OpdSure.of(context);
    final profile = await opd.client.getProfile();
    records = await opd.client.getPlanById(
        planId: profile.data!.plan!.id!,
        memberShipId: profile.data!.plan!.membershipId!);
    // Load reference data once (not on every rebuild).
    _loadApprovedHospitals();
    _loadSpecializations();
  }

  Future<void> _loadApprovedHospitals() async {
    try {
      final resp = await OpdSure.of(context).client.getHospitals();
      final list = (resp.success && resp.data != null)
          ? resp.data!.records.where((h) => h.isApproved).toList()
          : <HospitalRecord>[];
      if (mounted) {
        setState(() {
          _approvedHospitals = list;
          _hospitalsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _hospitalsLoading = false);
    }
  }

  Future<void> _loadSpecializations() async {
    try {
      final SpecializationModel? sModel =
          await OpdSure.of(context).client.getSpecialization();
      final list = sModel?.data?.records ?? <SpclRecords>[];
      if (mounted) {
        setState(() {
          _specializations = list;
          _specializationsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _specializationsLoading = false);
    }
  }

  final countryPicker = const FlCountryCodePicker();
  List<File> files = [];
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(
      BuildContext context, TypeController typeController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().add(const Duration(days: -6)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppDesign.primary,
              onPrimary: Colors.white,
              surface: AppDesign.card,
              onSurface: AppDesign.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      typeController.opdVisitDateChange(formattedDate);
    }
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    if (!isRequired) {
      return Text(text, style: AppDesign.labelLg);
    }
    return RichText(
      text: TextSpan(
        style: AppDesign.labelLg,
        children: [
          TextSpan(text: text),
          TextSpan(
              text: ' *',
              style: AppDesign.labelLg.copyWith(color: AppDesign.error)),
        ],
      ),
    );
  }

  Widget _buildDropdownField({required Widget child, IconData? icon}) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spacingLg),
      decoration: BoxDecoration(
        color: AppDesign.inputFill,
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        border: Border.all(color: AppDesign.inputBorder),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          Icon(icon ?? Icons.keyboard_arrow_down_rounded,
              color: AppDesign.textTertiary, size: 22),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    return AppBasePage(
      appHeader: const AppHeader(headerName: 'File a Claim'),
      childContent: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: AppDesign.spacingLg),
        children: [
          // Form Card
          Container(
            padding: const EdgeInsets.all(AppDesign.spacingXl),
            decoration: BoxDecoration(
              color: AppDesign.card,
              borderRadius: BorderRadius.circular(AppDesign.radiusXl),
              boxShadow: AppDesign.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Name
                _buildLabel('Patient Name', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                _buildPatientSelector(typeController),
                const SizedBox(height: AppDesign.spacingXl),

                // OPD Visit Date
                _buildLabel('OPD Visit Date', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                _buildDateSelector(typeController),
                const SizedBox(height: AppDesign.spacingXl),

                // Doctor Name
                _buildLabel('Doctor Name', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter the name',
                    textEditingController: docNameCtrl,
                    textInputType: TextInputType.name),
                const SizedBox(height: AppDesign.spacingXl),

                // Doc Reg Number
                _buildLabel('Doc Reg. Number', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                  hint: 'Enter doc Reg. Number',
                  textEditingController: regNumCtrl,
                  textInputType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]"))
                  ],
                ),
                const SizedBox(height: AppDesign.spacingXl),

                // Specialization
                _buildLabel('Specialization'),
                const SizedBox(height: AppDesign.spacingSm),
                _buildSpecializationSelector(typeController),
                const SizedBox(height: AppDesign.spacingXl),

                // Approved Hospital
                _buildLabel('Approved Hospital', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                _buildApprovedHospitalSelector(typeController),
                const SizedBox(height: AppDesign.spacingXl),

                // Email
                _buildLabel('Email'),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter email',
                    textEditingController: emailCtrl,
                    textInputType: TextInputType.emailAddress),
                const SizedBox(height: AppDesign.spacingXl),

                // Doctor Phone
                _buildLabel('Mobile', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                _buildPhoneField(typeController),
                const SizedBox(height: AppDesign.spacingXl),

                // Diagnosis
                _buildLabel('Reason for Doctor Consultation', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter Diagnosis Details',
                    textEditingController: diagnosisCtrl,
                    textInputType: TextInputType.name),
                const SizedBox(height: AppDesign.spacingXl),

                // Remark
                _buildLabel('Additional Information (if any)'),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Add Remarks',
                    textEditingController: remarkCtrl,
                    textInputType: TextInputType.name),
              ],
            ),
          ),

          const SizedBox(height: AppDesign.spacingXl),

          // Fees Section Card
          Container(
            padding: const EdgeInsets.all(AppDesign.spacingXl),
            decoration: BoxDecoration(
              color: AppDesign.card,
              borderRadius: BorderRadius.circular(AppDesign.radiusXl),
              boxShadow: AppDesign.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                Text('Fee Details',
                    style: AppDesign.titleLg
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Enter your bill amounts to see claimable coverage',
                    style: AppDesign.bodySm
                        .copyWith(color: AppDesign.textSecondary)),
                const SizedBox(height: AppDesign.spacingXl),

                // Column headers
                Row(
                  children: [
                    Expanded(
                      child: Text('Actual Bill Amounts',
                          style: AppDesign.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppDesign.textSecondary,
                              letterSpacing: 0.3)),
                    ),
                    const SizedBox(width: AppDesign.spacingMd),
                    Expanded(
                      child: Text('Claimable Amounts',
                          style: AppDesign.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppDesign.textSecondary,
                              letterSpacing: 0.3)),
                    ),
                  ],
                ),
                const SizedBox(height: AppDesign.spacingLg),

                // Doctor Fees
                _buildFeeRowWithRule("Doctor's Fees", docFeeCtrl, docFeeClCtrl,
                    (v) => docFee(value: v), _docFeeRuleLabel,
                    isCalculating: _calcDocFee),
                const SizedBox(height: AppDesign.spacingLg),

                // Pharmacy
                _buildFeeRowWithRule(
                  'Bill Amt. For Pharmacy',
                  billAmntPhrCtrl,
                  billAmntPhrClCtrl,
                  (v) => pharmaBill(value: v),
                  _pharmacyRuleLabel,
                  isCalculating: _calcPharmacy,
                ),
                const SizedBox(height: AppDesign.spacingLg),

                // Diagnostics
                _buildFeeRowWithRule(
                    'Bill Amt. For Diagnostics',
                    billAmntDiaCtrl,
                    billAmntDiaClCtrl,
                    (v) => labBill(value: v),
                    _diagnosticsRuleLabel,
                    isCalculating: _calcDiagnostics),
                const SizedBox(height: AppDesign.spacingLg),

                // Vision
                _buildFeeRowWithRule(
                    'Bill Amt. For Vision',
                    billAmntVisionCtrl,
                    billAmntVisionClCtrl,
                    (v) => visionBill(value: v),
                    _visionRuleLabel,
                    isCalculating: _calcVision),
                const SizedBox(height: AppDesign.spacingLg),

                // Dental
                _buildFeeRowWithRule(
                    'Bill Amt. For Dental',
                    billAmntDentalCtrl,
                    billAmntDentalClCtrl,
                    (v) => dentalBill(value: v),
                    _dentalRuleLabel,
                    isCalculating: _calcDental),
                const SizedBox(height: AppDesign.spacingLg),

                // Vaccination
                _buildFeeRowWithRule(
                    'Bill Amt. For Vaccination',
                    billAmntVaccinationCtrl,
                    billAmntVaccinationClCtrl,
                    (v) => vaccinationBill(value: v),
                    _vaccinationRuleLabel,
                    isCalculating: _calcVaccination),
                const SizedBox(height: AppDesign.spacingLg),

                // Physiotherapy
                _buildFeeRowWithRule(
                    'Bill Amt. For Physiotherapy',
                    billAmntPhysioCtrl,
                    billAmntPhysioClCtrl,
                    (v) => physioBill(value: v),
                    _physioRuleLabel,
                    isCalculating: _calcPhysio),

                const SizedBox(height: AppDesign.spacingXl),
                // Grand Total separator
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppDesign.divider.withOpacity(0),
                        AppDesign.divider,
                        AppDesign.divider.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDesign.spacingLg),

                // Grand Total
                Text('Grand Total',
                    style: AppDesign.titleMd
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppDesign.spacingSm),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          border: Border.all(
                              color: AppDesign.divider.withOpacity(0.7),
                              width: 1),
                        ),
                        child: Text(
                          totalBillAmnt.isEmpty ? '0.00' : totalBillAmnt,
                          style: AppDesign.titleMd
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDesign.spacingMd),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          border: Border.all(
                              color: AppDesign.divider.withOpacity(0.7),
                              width: 1),
                        ),
                        child: Text(
                          totalClaimableAmnt.isEmpty
                              ? '0.00'
                              : totalClaimableAmnt,
                          style: AppDesign.titleMd
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDesign.spacingMd),
                // Note about mandatory fields
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 14, color: Colors.red.shade400),
                    const SizedBox(width: 6),
                    Text(
                      'All * marked fields are mandatory',
                      style: AppDesign.caption.copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDesign.spacingXxl),

          // Next Button
          AppButton(
            text: 'Next',
            onClick: () => _onNext(typeController),
          ),

          const SizedBox(height: AppDesign.spacingXl),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(AppDesign.spacingLg),
            decoration: BoxDecoration(
              color: AppDesign.warningLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppDesign.warning, size: 18),
                const SizedBox(width: AppDesign.spacingSm),
                Expanded(
                  child: Text(
                    'All documents uploaded will be used only for claim settlement and not for any other purpose.',
                    style: AppDesign.bodySm
                        .copyWith(color: AppDesign.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDesign.spacing5Xl),
        ],
      ),
    );
  }

  Widget _buildPatientSelector(TypeController typeController) {
    return Obx(() {
      bool refresh = typeController.refreshMemberList.value;
      return refresh
          ? FutureBuilder(
              future: OpdSure.of(context).client.getFamilyMember(update: true),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return _buildDropdownField(
                    child: Text('Getting users...',
                        style: AppDesign.bodyMd
                            .copyWith(color: AppDesign.textTertiary)),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    MyMemberModel myMemberModel = snapshot.data!;
                    List<MemberList>? memberList = myMemberModel.data;
                    AppBottomSheet(
                      height: 600,
                      mChild: memberList!.isEmpty
                          ? Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/home/add-members', extra: {
                                    "isUpdate": false,
                                    "isAddingFirstMember": false
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No Family member added',
                                        style: AppDesign.titleLg
                                            .copyWith(color: AppDesign.accent)),
                                    const SizedBox(height: AppDesign.spacingMd),
                                    Container(
                                      padding: const EdgeInsets.all(
                                          AppDesign.spacingMd),
                                      decoration: BoxDecoration(
                                          color: AppDesign.accentLight,
                                          borderRadius: BorderRadius.circular(
                                              AppDesign.radiusFull)),
                                      child: const Icon(Icons.add,
                                          color: AppDesign.accent),
                                    ),
                                    const SizedBox(height: AppDesign.spacingSm),
                                    Text('Add Member',
                                        style: AppDesign.labelSm
                                            .copyWith(color: AppDesign.accent)),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: memberList.length,
                              itemBuilder: (context, index) {
                                return Visibility(
                                  visible: (memberList[index].planStatus == 1),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (typeController
                                          .memberList.value.isNotEmpty) {
                                        typeController.memberList.value.clear();
                                      }
                                      typeController
                                          .memberListChange(memberList[index]);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppDesign.spacingMd),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: AppDesign.divider
                                                      .withOpacity(0.5)))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(memberList[index].name!,
                                              style: AppDesign.titleMd),
                                          const SizedBox(height: 2),
                                          Text('${memberList[index].phone!}',
                                              style: AppDesign.bodySm.copyWith(
                                                  color:
                                                      AppDesign.textTertiary)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ).modalBottomSheetMenu(context);
                  },
                  child: _buildDropdownField(
                    child: Obx(() {
                      return Text(
                        typeController.memberList.value.isEmpty
                            ? 'Select User'
                            : typeController.memberList.first.name!,
                        style: AppDesign.bodyMd.copyWith(
                          color: typeController.memberList.value.isEmpty
                              ? AppDesign.textTertiary
                              : AppDesign.textPrimary,
                        ),
                      );
                    }),
                  ),
                );
              },
            )
          : const SizedBox.shrink();
    });
  }

  Widget _buildDateSelector(TypeController typeController) {
    return Obx(() {
      String date = typeController.opdVisitDate.value;
      String showDate = '';
      if (date != '') {
        showDate = CommonMethods.changeDateFormat(date,
            from: 'yyyy-MM-dd', to: 'dd/MM/yyyy');
      }
      return GestureDetector(
        onTap: () => _selectDate(context, typeController),
        child: _buildDropdownField(
          icon: Icons.calendar_today_outlined,
          child: Text(
            date.isEmpty ? 'Enter OPD Visit Date' : showDate,
            style: AppDesign.bodyMd.copyWith(
                color: date.isEmpty
                    ? AppDesign.textTertiary
                    : AppDesign.textPrimary),
          ),
        ),
      );
    });
  }

  Widget _buildSpecializationSelector(TypeController typeController) {
    return GestureDetector(
      onTap: () {
        if (_specializationsLoading || _specializations.isEmpty) return;
        _showSpecializationSearchSheet(_specializations, typeController);
      },
      child: _buildDropdownField(
        child: _specializationsLoading
            ? Text('Loading specializations...',
                style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary))
            : Obx(() {
                return Text(
                  typeController.spclModel.value.isEmpty
                      ? 'Select Specialization'
                      : typeController.spclModel.value.first.name!,
                  style: AppDesign.bodyMd.copyWith(
                    color: typeController.spclModel.value.isEmpty
                        ? AppDesign.textTertiary
                        : AppDesign.textPrimary,
                  ),
                );
              }),
      ),
    );
  }

  // Searchable specialization picker — mirrors the hospital search sheet so the
  // user can type to filter a long specialization list (client-side search).
  void _showSpecializationSearchSheet(
      List<SpclRecords> specializations, TypeController typeController) {
    final searchCtrl = TextEditingController();
    List<SpclRecords> filtered = List.from(specializations);
    // Client-side pagination within the sheet: reveal [visibleCount] of the
    // filtered results and grow in pages as the user scrolls. Keeps a large
    // specialization list fast to render without any API change.
    const int pageSize = 20;
    int visibleCount = pageSize;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                color: AppDesign.card,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDesign.radiusXl)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppDesign.spacingMd),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppDesign.divider,
                      borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDesign.spacingLg),
                    child: TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search specialization...',
                        hintStyle: AppDesign.bodyMd
                            .copyWith(color: AppDesign.textTertiary),
                        prefixIcon: const Icon(Icons.search,
                            color: AppDesign.textTertiary, size: 20),
                        filled: true,
                        fillColor: AppDesign.inputFill,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDesign.spacingLg,
                            vertical: AppDesign.spacingMd),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          borderSide:
                              const BorderSide(color: AppDesign.inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          borderSide:
                              const BorderSide(color: AppDesign.inputBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          borderSide:
                              const BorderSide(color: AppDesign.primary),
                        ),
                      ),
                      onChanged: (query) {
                        setSheetState(() {
                          filtered = specializations
                              .where((s) => (s.name ?? '')
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                          // Reset pagination whenever the filter changes.
                          visibleCount = pageSize;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            'No specializations found',
                            style: AppDesign.bodyMd
                                .copyWith(color: AppDesign.textTertiary),
                          ),
                        );
                      }
                      final int visible =
                          visibleCount.clamp(0, filtered.length);
                      final bool hasMore = visible < filtered.length;
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >=
                                  notification.metrics.maxScrollExtent - 120 &&
                              hasMore) {
                            setSheetState(() {
                              visibleCount = (visibleCount + pageSize)
                                  .clamp(0, filtered.length);
                            });
                          }
                          return false;
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDesign.spacingLg),
                          // +1 for the trailing "load more" row when applicable.
                          itemCount: visible + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= visible) {
                              // Load-more footer.
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppDesign.spacingMd),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setSheetState(() {
                                        visibleCount = (visibleCount + pageSize)
                                            .clamp(0, filtered.length);
                                      });
                                    },
                                    child: Text(
                                      'Load more (${filtered.length - visible} remaining)',
                                      style: AppDesign.bodySm.copyWith(
                                          color: AppDesign.primary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              );
                            }
                            final spcl = filtered[index];
                            return GestureDetector(
                              onTap: () {
                                if (typeController.spclModel.value.isNotEmpty) {
                                  typeController.spclModel.value.clear();
                                }
                                typeController.spclModelChange(spcl);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppDesign.spacingMd),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color:
                                            AppDesign.divider.withOpacity(0.5)),
                                  ),
                                ),
                                child: Text(
                                  spcl.name ?? '',
                                  style: AppDesign.bodyMd.copyWith(
                                      color: AppDesign.textPrimary,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildApprovedHospitalSelector(TypeController typeController) {
    // Uses the cached _approvedHospitals (loaded once in initState). No network
    // call happens here, so typing in another field no longer reloads this
    // selector or causes a reselect flicker.
    if (_hospitalsLoading) {
      return _buildDropdownField(
        child: Text('Loading hospitals...',
            style: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary)),
      );
    }

    final approvedHospitals = _approvedHospitals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (approvedHospitals.isEmpty) return;
            _showHospitalSearchSheet(approvedHospitals, typeController);
          },
          child: _buildDropdownField(
            child: Obx(() {
              final selected = typeController.selectedHospital.value;
              return Text(
                selected != null ? selected.name : 'Select approved hospital',
                style: AppDesign.bodyMd.copyWith(
                  color: selected != null
                      ? AppDesign.textPrimary
                      : AppDesign.textTertiary,
                ),
              );
            }),
          ),
        ),
        if (approvedHospitals.isEmpty) ...[
          const SizedBox(height: AppDesign.spacingSm),
          GestureDetector(
            onTap: () => context.push('/home/hospitals/add'),
            child: RichText(
              text: TextSpan(
                style: AppDesign.bodySm.copyWith(color: AppDesign.textTertiary),
                children: [
                  const TextSpan(text: 'No approved hospitals yet. '),
                  TextSpan(
                    text: 'Add a hospital',
                    style: AppDesign.bodySm.copyWith(
                      color: AppDesign.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and wait for admin approval.'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showHospitalSearchSheet(
      List<HospitalRecord> hospitals, TypeController typeController) {
    final searchCtrl = TextEditingController();
    List<HospitalRecord> filtered = List.from(hospitals);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                color: AppDesign.card,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDesign.radiusXl)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppDesign.spacingMd),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppDesign.divider,
                      borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDesign.spacingLg),
                    child: TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search hospital...',
                        hintStyle: AppDesign.bodyMd
                            .copyWith(color: AppDesign.textTertiary),
                        prefixIcon: const Icon(Icons.search,
                            color: AppDesign.textTertiary, size: 20),
                        filled: true,
                        fillColor: AppDesign.inputFill,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDesign.spacingLg,
                            vertical: AppDesign.spacingMd),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          borderSide:
                              const BorderSide(color: AppDesign.inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          borderSide:
                              const BorderSide(color: AppDesign.inputBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMd),
                          borderSide:
                              const BorderSide(color: AppDesign.primary),
                        ),
                      ),
                      onChanged: (query) {
                        setSheetState(() {
                          filtered = hospitals
                              .where((h) => h.name
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'No approved hospitals',
                              style: AppDesign.bodyMd
                                  .copyWith(color: AppDesign.textTertiary),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDesign.spacingLg),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final hospital = filtered[index];
                              return GestureDetector(
                                onTap: () {
                                  typeController
                                      .selectedHospitalChange(hospital);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppDesign.spacingMd),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: AppDesign.divider
                                              .withOpacity(0.5)),
                                    ),
                                  ),
                                  child: Text(
                                    hospital.name,
                                    style: AppDesign.bodyMd.copyWith(
                                        color: AppDesign.textPrimary,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhoneField(TypeController typeController) {
    return Obx(() {
      String countryCode = typeController.countryCode.value;
      String flagCode = typeController.flagCode.value;
      return AppMobileField(
        hint: 'Enter number',
        countryCode: countryCode.isEmpty ? '+91' : countryCode,
        textEditingController: phoneCtrl,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        flagUri:
            flagCode.isEmpty ? '${mFlagUri}in.png' : '$mFlagUri$flagCode.png',
        countryCallback: () async {},
      );
    });
  }

  Widget _buildFeeRow(String label, TextEditingController amountCtrl,
      TextEditingController claimableCtrl, ValueChanged<String> onChanged) {
    return _buildFeeRowWithRule(
        label, amountCtrl, claimableCtrl, onChanged, null);
  }

  Widget _buildFeeRowWithRule(
      String label,
      TextEditingController amountCtrl,
      TextEditingController claimableCtrl,
      ValueChanged<String> onChanged,
      String? appliedRuleLabel,
      {bool isCalculating = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppDesign.bodyMd.copyWith(
                fontWeight: FontWeight.w600, color: AppDesign.textPrimary)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AppEditText(
                  hint: '0.00',
                  textEditingController: amountCtrl,
                  textInputType: TextInputType.number,
                  mOnChanged: onChanged),
            ),
            const SizedBox(width: 12),
            Expanded(
              // Overlay an inline spinner on the (read-only) claimable field
              // while its calculate-claim API call is in flight.
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  AppEditText(
                      hint: '0.00',
                      textEditingController: claimableCtrl,
                      textInputType: TextInputType.number,
                      disableText: true),
                  if (isCalculating)
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppDesign.primary),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (appliedRuleLabel != null && appliedRuleLabel.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFFFE082), width: 0.5),
            ),
            child: Text(
              appliedRuleLabel,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8D6E00),
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _onNext(TypeController typeController) {
    if (typeController.memberList.value.isEmpty) {
      CommonMethods.showToast('Select User');
      return;
    }
    if (typeController.opdVisitDate.value.isEmpty) {
      CommonMethods.showToast('Select Opd Visit Date');
      return;
    }
    if (docNameCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter Doctor Name');
      return;
    }
    if (regNumCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter Doctor Regs No.');
      return;
    }
    if (regNumCtrl.text.length < 4) {
      CommonMethods.showToast('Doctor Regs No Should Be 4 Digit');
      return;
    }
    if (typeController.selectedHospital.value == null) {
      CommonMethods.showToast('Select Approved Hospital');
      return;
    }
    if (phoneCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter Phone No.');
      return;
    }
    if (diagnosisCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter Diagnosis Details');
      return;
    }
    if (docFeeCtrl.text.isEmpty) {
      docFeeCtrl.text = "0";
    }
    if (billAmntPhrCtrl.text.isEmpty) {
      billAmntPhrCtrl.text = '0';
    }
    if (billAmntDiaCtrl.text.isEmpty) {
      billAmntDiaCtrl.text = '0';
    }
    if (billAmntVisionCtrl.text.isEmpty) {
      billAmntVisionCtrl.text = '0';
    }
    if (billAmntDentalCtrl.text.isEmpty) {
      billAmntDentalCtrl.text = '0';
    }
    if (billAmntVaccinationCtrl.text.isEmpty) {
      billAmntVaccinationCtrl.text = '0';
    }
    if (billAmntPhysioCtrl.text.isEmpty) {
      billAmntPhysioCtrl.text = '0';
    }
    if (docFeeClCtrl.text.isEmpty) {
      docFeeClCtrl.text = '0';
    }
    if (billAmntPhrClCtrl.text.isEmpty) {
      billAmntPhrClCtrl.text = '0';
    }
    if (billAmntDiaClCtrl.text.isEmpty) {
      billAmntDiaClCtrl.text = '0';
    }
    if (billAmntVisionClCtrl.text.isEmpty) {
      billAmntVisionClCtrl.text = '0';
    }
    if (billAmntDentalClCtrl.text.isEmpty) {
      billAmntDentalClCtrl.text = '0';
    }
    if (billAmntVaccinationClCtrl.text.isEmpty) {
      billAmntVaccinationClCtrl.text = '0';
    }
    if (billAmntPhysioClCtrl.text.isEmpty) {
      billAmntPhysioClCtrl.text = '0';
    }

    ClaimJsonModel claimJsonModel = ClaimJsonModel(
      memberId: typeController.memberList.value.first.id,
      opdDate: typeController.opdVisitDate.value,
      docCountryCode: typeController.countryCode.value,
      docPhone: phoneCtrl.text,
      doctorFee: docFeeCtrl.text,
      userRemark: remarkCtrl.text.isEmpty ? null : remarkCtrl.text,
      id: widget.isUpdate! ? singleClaimModel!.data!.id : null,
      docEmail: emailCtrl.text.isEmpty ? null : emailCtrl.text,
      pharmacyFee: billAmntPhrCtrl.text,
      labTestFee: billAmntDiaCtrl.text,
      visionFee: billAmntVisionCtrl.text,
      dentalFee: billAmntDentalCtrl.text,
      vaccinationFee: billAmntVaccinationCtrl.text,
      physioFee: billAmntPhysioCtrl.text,
      claimableDoctorFee: double.tryParse(docFeeClCtrl.text)?.toInt() ?? 0,
      claimablePharmacyFee:
          double.tryParse(billAmntPhrClCtrl.text)?.toInt() ?? 0,
      claimableLabTestFee:
          double.tryParse(billAmntDiaClCtrl.text)?.toInt() ?? 0,
      claimableVisionFee:
          double.tryParse(billAmntVisionClCtrl.text)?.toInt() ?? 0,
      claimableDentalFee:
          double.tryParse(billAmntDentalClCtrl.text)?.toInt() ?? 0,
      claimableVaccinationFee:
          double.tryParse(billAmntVaccinationClCtrl.text)?.toInt() ?? 0,
      claimablePhysioFee:
          double.tryParse(billAmntPhysioClCtrl.text)?.toInt() ?? 0,
      approvedClaimableAmount:
          double.tryParse(totalClaimableAmnt)?.toInt() ?? 0,
      approvedClaimableDoctorFee:
          double.tryParse(docFeeClCtrl.text)?.toInt() ?? 0,
      approvedClaimablePharmacyFee:
          double.tryParse(billAmntPhrClCtrl.text)?.toInt() ?? 0,
      approvedClaimableLabTestFee:
          double.tryParse(billAmntDiaClCtrl.text)?.toInt() ?? 0,
      approvedClaimableCombinedPharmacyTestFees: 0,
      approvedClaimableVisionFee:
          double.tryParse(billAmntVisionClCtrl.text)?.toInt() ?? 0,
      approvedClaimableDentalFee:
          double.tryParse(billAmntDentalClCtrl.text)?.toInt() ?? 0,
      approvedClaimableVaccinationFee:
          double.tryParse(billAmntVaccinationClCtrl.text)?.toInt() ?? 0,
      approvedClaimablePhysioFee:
          double.tryParse(billAmntPhysioClCtrl.text)?.toInt() ?? 0,
      docName: docNameCtrl.text,
      docRegistration: regNumCtrl.text,
      diagonosisDetail: diagnosisCtrl.text,
      hospital: typeController.selectedHospital.value!.name,
      hospitalId: typeController.selectedHospital.value!.id,
      pinCode: '',
      docAddress: typeController.selectedHospital.value!.address,
      city: '',
      specialization: typeController.spclModel.value.isEmpty
          ? null
          : typeController.spclModel.value.first.name,
      billAmount: totalBillAmnt,
      claimableAmount: totalClaimableAmnt,
      prescription:
          widget.isUpdate! ? singleClaimModel!.data!.prescription : [],
      claimCombination: '1',
    );
    typeController.prescriptionList.clear();
    typeController.docFeeRcpt.clear();
    typeController.pharmacyRcpt.clear();
    typeController.labTestRcpt.clear();
    typeController.visionRcpt.clear();
    typeController.dentalRcpt.clear();
    typeController.vaccinationRcpt.clear();
    typeController.physioRcpt.clear();
    typeController.testReportRcpt.clear();
    Map<String, dynamic>? docMap;
    if (widget.isUpdate!) {
      docMap = {
        'prescription_d': cRecords!.prescription,
        'doc_fee_d': cRecords!.feeReceipt,
        'pharmacy_d': cRecords!.pharmacyReceipt,
        'test_d': cRecords!.testReceipt,
      };
    }
    context.push('/home/file_claim/upload_image', extra: {
      'claimId': claimId,
      'documentMap': docMap,
      'isUpdate': widget.isUpdate,
      'claimJsonModel': claimJsonModel,
    });
  }
}
