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
  TextEditingController specialCtrl = TextEditingController();
  TextEditingController hsptlNameCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController diagnosisCtrl = TextEditingController();
  TextEditingController remarkCtrl = TextEditingController();
  TextEditingController docFeeCtrl = TextEditingController();
  TextEditingController docFeeClCtrl = TextEditingController();
  TextEditingController billAmntPhrCtrl = TextEditingController();
  TextEditingController billAmntPhrClCtrl = TextEditingController();
  TextEditingController billAmntDiaCtrl = TextEditingController();
  TextEditingController billAmntDiaClCtrl = TextEditingController();
  TextEditingController pinCodeCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();

  double _value1 = 0.0;
  double _value2 = 0.0;
  double _value3 = 0.0;
  double _value11 = 0.0;
  double _value12 = 0.0;
  double _value13 = 0.0;
  String totalBillAmnt = '';
  String totalClaimableAmnt = '';
  String claimId = '';
  String claimCombination = '';

  PlanRecords? records;
  ClaimRecords? cRecords;
  SingleClaimModel? singleClaimModel;

  void _calculateSum() {
    setState(() {
      totalClaimableAmnt =
          double.parse((_value11 + _value12 + _value13).toString())
              .toStringAsFixed(0);
      totalBillAmnt = double.parse((_value1 + _value2 + _value3).toString())
          .toStringAsFixed(0);
    });
  }

  void docFee({String? value = '0'}) async {
    var data = await OpdSure.of(context)
        .client
        .calculateClaimPrice('0', double.parse(value!));
    CalculateClaimModel calculateClaimModel =
        CalculateClaimModel.fromJson(jsonDecode(data));
    setState(() {
      _value11 =
          double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
      _value1 = double.tryParse(value.toString()) ?? 0.0;
      docFeeClCtrl.text = _value11.toStringAsFixed(0);
      _calculateSum();
    });
  }

  void pharmaBill({String? value = '0'}) async {
    String calculator = claimCombination == '1' ? '1' : '3';
    var data = await OpdSure.of(context)
        .client
        .calculateClaimPrice(calculator, double.parse(value!));
    CalculateClaimModel calculateClaimModel =
        CalculateClaimModel.fromJson(jsonDecode(data));
    setState(() {
      _value12 =
          double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
      _value2 = double.tryParse(value.toString()) ?? 0.0;
      billAmntPhrClCtrl.text = _value12.toStringAsFixed(0);
      _calculateSum();
    });
  }

  void labBill({String? value = '0'}) async {
    var data = await OpdSure.of(context)
        .client
        .calculateClaimPrice('2', double.parse(value!));
    CalculateClaimModel calculateClaimModel =
        CalculateClaimModel.fromJson(jsonDecode(data));
    setState(() {
      _value13 =
          double.parse('${calculateClaimModel.data!.finalPrice ?? '0.0'}');
      _value3 = double.tryParse(value.toString()) ?? 0.0;
      billAmntDiaClCtrl.text = _value13.toStringAsFixed(0);
      _calculateSum();
    });
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
      hsptlNameCtrl.text = cRecords!.hospital!;
      addressCtrl.text = cRecords!.docAddress!;
      cityCtrl.text = cRecords!.city!;
      emailCtrl.text = cRecords!.docEmail!;
      diagnosisCtrl.text = cRecords!.diagonosisDetail!;
      remarkCtrl.text = cRecords!.userRemark!;
      docFeeCtrl.text = '${cRecords!.doctorFee!}';
      docFeeClCtrl.text = '${cRecords!.claimableDoctorFee!}';
      pinCodeCtrl.text = cRecords!.pincode.toString();
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

                // Hospital Name
                _buildLabel('Hospital/Clinic Name', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter hospital Name',
                    textEditingController: hsptlNameCtrl,
                    textInputType: TextInputType.name),
                const SizedBox(height: AppDesign.spacingXl),

                // City
                _buildLabel('City', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter the city', textEditingController: cityCtrl),
                const SizedBox(height: AppDesign.spacingXl),

                // Pin Code
                _buildLabel('Pin Code', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter Pin Code',
                    textEditingController: pinCodeCtrl,
                    textInputType: TextInputType.number,
                    maxLength: 6),
                const SizedBox(height: AppDesign.spacingXl),

                // Address
                _buildLabel('Address', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter Address', textEditingController: addressCtrl),
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
                _buildLabel('Doctor/Clinic/Hospital Number', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                _buildPhoneField(typeController),
                const SizedBox(height: AppDesign.spacingXl),

                // Diagnosis
                _buildLabel('Reason for Doctor Consultation', isRequired: true),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter Reason',
                    textEditingController: diagnosisCtrl,
                    textInputType: TextInputType.name),
                const SizedBox(height: AppDesign.spacingXl),

                // Remark
                _buildLabel('Additional Information (if any)'),
                const SizedBox(height: AppDesign.spacingSm),
                AppEditText(
                    hint: 'Enter Additional Information',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fee Details', style: AppDesign.headingSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDesign.spacingSm,
                          vertical: AppDesign.spacingXs),
                      decoration: BoxDecoration(
                        color: AppDesign.accentLight,
                        borderRadius:
                            BorderRadius.circular(AppDesign.radiusFull),
                      ),
                      child: Text('Claimable',
                          style: AppDesign.caption.copyWith(
                              color: AppDesign.accent,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppDesign.spacingXl),

                // Doctor Fees
                _buildFeeRow('Doctor Fees', docFeeCtrl, docFeeClCtrl,
                    (v) => docFee(value: v)),
                const SizedBox(height: AppDesign.spacingMd),

                // Pharmacy
                _buildFeeRow(
                  claimCombination == '2'
                      ? 'Pharma + Diagnostics'
                      : 'Bill Amt. for Pharmacy',
                  billAmntPhrCtrl,
                  billAmntPhrClCtrl,
                  (v) => pharmaBill(value: v),
                ),

                if (claimCombination != '2') ...[
                  const SizedBox(height: AppDesign.spacingMd),
                  _buildFeeRow('Bill Amt. for Diagnostics', billAmntDiaCtrl,
                      billAmntDiaClCtrl, (v) => labBill(value: v)),
                ],

                const SizedBox(height: AppDesign.spacingLg),
                Divider(height: 1, color: AppDesign.divider.withOpacity(0.5)),
                const SizedBox(height: AppDesign.spacingLg),

                // Grand Total
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Bill', style: AppDesign.labelSm),
                          const SizedBox(height: AppDesign.spacingXs),
                          Text(
                            totalBillAmnt.isEmpty
                                ? '$rupeeSymbol 0'
                                : '$rupeeSymbol $totalBillAmnt',
                            style: AppDesign.titleLg,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Claimable', style: AppDesign.labelSm),
                          const SizedBox(height: AppDesign.spacingXs),
                          Text(
                            totalClaimableAmnt.isEmpty
                                ? '$rupeeSymbol 0'
                                : '$rupeeSymbol $totalClaimableAmnt',
                            style: AppDesign.titleLg
                                .copyWith(color: AppDesign.success),
                          ),
                        ],
                      ),
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
      onTap: () async {
        var data = await OpdSure.of(context).client.getSpecialization();
        SpecializationModel? sModel = data;
        List<SpclRecords> records = sModel!.data!.records!;
        AppBottomSheet(
          height: 300,
          mChild: ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (typeController.spclModel.value.isNotEmpty) {
                    typeController.spclModel.value.clear();
                  }
                  typeController.spclModelChange(records[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppDesign.spacingMd),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppDesign.divider.withOpacity(0.5)))),
                  child: Text(records[index].name!,
                      style: AppDesign.bodyMd.copyWith(
                          color: AppDesign.textPrimary,
                          fontWeight: FontWeight.w500)),
                ),
              );
            },
          ),
        ).modalBottomSheetMenu(context);
      },
      child: _buildDropdownField(
        child: Obx(() {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppDesign.labelSm),
        const SizedBox(height: AppDesign.spacingSm),
        Row(
          children: [
            Expanded(
              child: AppEditText(
                  hint: 'Amount',
                  textEditingController: amountCtrl,
                  textInputType: TextInputType.number,
                  mOnChanged: onChanged),
            ),
            const SizedBox(width: AppDesign.spacingMd),
            Expanded(
              child: AppEditText(
                  hint: '-',
                  textEditingController: claimableCtrl,
                  textInputType: TextInputType.number,
                  disableText: true),
            ),
          ],
        ),
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
    if (hsptlNameCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter Hospital Name');
      return;
    }
    if (cityCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter City');
      return;
    }
    if (pinCodeCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter Pincode');
      return;
    }
    if (pinCodeCtrl.text.length < 6) {
      CommonMethods.showToast('Pincode Should Be 6 Digit');
      return;
    }
    if (addressCtrl.text.isEmpty) {
      CommonMethods.showToast('Enter Address');
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
    if (docFeeClCtrl.text.isEmpty) {
      docFeeClCtrl.text = '0';
    }
    if (billAmntPhrClCtrl.text.isEmpty) {
      billAmntPhrClCtrl.text = '0';
    }
    if (billAmntDiaClCtrl.text.isEmpty) {
      billAmntDiaClCtrl.text = '0';
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
      pharmacyFee: claimCombination == '1' ? billAmntPhrCtrl.text : null,
      labTestFee: claimCombination == '1' ? billAmntDiaCtrl.text : null,
      claimableDoctorFee: int.tryParse(docFeeClCtrl.text),
      claimablePharmacyFee:
          claimCombination == '1' ? int.tryParse(billAmntPhrClCtrl.text) : null,
      claimableLabTestFee:
          claimCombination == '1' ? int.tryParse(billAmntDiaClCtrl.text) : null,
      approvedClaimableAmount: int.tryParse(totalClaimableAmnt),
      approvedClaimableDoctorFee: int.tryParse(docFeeClCtrl.text),
      approvedClaimablePharmacyFee:
          claimCombination == '1' ? int.tryParse(billAmntPhrClCtrl.text) : null,
      approvedClaimableLabTestFee:
          claimCombination == '1' ? int.tryParse(billAmntDiaClCtrl.text) : null,
      approvedClaimableCombinedPharmacyTestFees:
          claimCombination == '1' ? int.tryParse(billAmntDiaClCtrl.text) : null,
      docName: docNameCtrl.text,
      docRegistration: regNumCtrl.text,
      diagonosisDetail: diagnosisCtrl.text,
      hospital: hsptlNameCtrl.text,
      pinCode: pinCodeCtrl.text,
      docAddress: addressCtrl.text,
      city: cityCtrl.text,
      specialization: specialCtrl.text.isEmpty ? null : specialCtrl.text,
      billAmount: totalBillAmnt,
      claimableAmount: totalClaimableAmnt,
      prescription:
          widget.isUpdate! ? singleClaimModel!.data!.prescription : [],
      claimCombination: claimCombination.isEmpty ? '1' : claimCombination,
      combinedPharmacyTestFees:
          claimCombination == '2' ? billAmntPhrCtrl.text : null,
      claimableCombinedPharmacyTestFees:
          claimCombination == '2' ? billAmntPhrClCtrl.text : null,
    );
    typeController.prescriptionList.clear();
    typeController.docFeeRcpt.clear();
    typeController.pharmacyRcpt.clear();
    typeController.labTestRcpt.clear();
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
