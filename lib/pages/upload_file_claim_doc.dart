import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_bottom_sheet.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/utils/common_methods.dart';
import '../config/app_config.dart';
import '../custom_ui/app_button.dart';
import '../custom_ui/app_text_view.dart';
import '../model/claim_json_model.dart';
import '../model/single_claim_model.dart';
import '../widget/opd_widget.dart';

/// Represents a single document upload row in the table.
class _DocUploadItem {
  final String label;
  final String filesUrlKey;
  final bool isMandatory;
  final RxList fileList;
  final void Function(File) addFile;
  final void Function(File) removeFile;

  _DocUploadItem({
    required this.label,
    required this.filesUrlKey,
    required this.isMandatory,
    required this.fileList,
    required this.addFile,
    required this.removeFile,
  });
}

class UploadFileClaimDoc extends StatefulWidget {
  final ClaimJsonModel? claimJsonModel;
  final bool? isUpdate;
  final String? claimId;
  final Map<String, dynamic>? documentMap;

  const UploadFileClaimDoc({
    this.claimJsonModel,
    this.isUpdate,
    this.claimId,
    this.documentMap,
    super.key,
  });

  @override
  State<UploadFileClaimDoc> createState() => _UploadFileClaimDocState();
}

class _UploadFileClaimDocState extends State<UploadFileClaimDoc> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, dynamic> filesUrl = {};
  final Map<String, List<String>> _uploadedUrls = {};

  // Track upload status per document key
  final Map<String, String> _uploadStatus = {}; // 'success', 'failed', or null

  late TypeController typeController;
  late List<_DocUploadItem> _docItems;

  bool get _hasDoctorFee =>
      widget.claimJsonModel?.doctorFee != null &&
      widget.claimJsonModel!.doctorFee != '0' &&
      widget.claimJsonModel!.doctorFee!.isNotEmpty;

  bool get _hasPharmacyFee =>
      widget.claimJsonModel?.pharmacyFee != null &&
      widget.claimJsonModel!.pharmacyFee != '0' &&
      widget.claimJsonModel!.pharmacyFee!.isNotEmpty;

  bool get _hasDiagnosticsFee =>
      widget.claimJsonModel?.labTestFee != null &&
      widget.claimJsonModel!.labTestFee != '0' &&
      widget.claimJsonModel!.labTestFee!.isNotEmpty;

  bool get _hasVisionFee =>
      widget.claimJsonModel?.visionFee != null &&
      widget.claimJsonModel!.visionFee != '0' &&
      widget.claimJsonModel!.visionFee!.isNotEmpty;

  bool get _hasDentalFee =>
      widget.claimJsonModel?.dentalFee != null &&
      widget.claimJsonModel!.dentalFee != '0' &&
      widget.claimJsonModel!.dentalFee!.isNotEmpty;

  bool get _hasVaccinationFee =>
      widget.claimJsonModel?.vaccinationFee != null &&
      widget.claimJsonModel!.vaccinationFee != '0' &&
      widget.claimJsonModel!.vaccinationFee!.isNotEmpty;

  bool get _hasPhysioFee =>
      widget.claimJsonModel?.physioFee != null &&
      widget.claimJsonModel!.physioFee != '0' &&
      widget.claimJsonModel!.physioFee!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    typeController = Get.put(TypeController());
    _buildDocItems();
  }

  void _buildDocItems() {
    _docItems = [
      // Prescription is always mandatory
      _DocUploadItem(
        label: 'Prescription',
        filesUrlKey: 'prescription',
        isMandatory: true,
        fileList: typeController.prescriptionList,
        addFile: typeController.prescriptionListChange,
        removeFile: typeController.removePrescription,
      ),
    ];

    // Doctor Fee Bill - shown only if doctor fee entered
    if (_hasDoctorFee) {
      _docItems.add(_DocUploadItem(
        label: "Doctor's Fee Bill",
        filesUrlKey: 'fee_receipt',
        isMandatory: true,
        fileList: typeController.docFeeRcpt,
        addFile: typeController.docFeeRcptChange,
        removeFile: typeController.removeDocFeeRcpt,
      ));
    }
    // Pharmacy Bills - shown only if pharmacy fee entered
    if (_hasPharmacyFee) {
      _docItems.add(_DocUploadItem(
        label: 'Pharmacy Bills',
        filesUrlKey: 'pharmacy_receipt',
        isMandatory: true,
        fileList: typeController.pharmacyRcpt,
        addFile: typeController.pharmacyRcptChange,
        removeFile: typeController.removePharmacyRcpt,
      ));
    }
    // Diagnostics Bills - shown only if diagnostics fee entered
    if (_hasDiagnosticsFee) {
      _docItems.add(_DocUploadItem(
        label: 'Diagnostics Bills',
        filesUrlKey: 'test_receipt',
        isMandatory: true,
        fileList: typeController.labTestRcpt,
        addFile: typeController.labTestRcptChange,
        removeFile: typeController.removeLabTestRcpt,
      ));
      _docItems.add(_DocUploadItem(
        label: 'Diagnostics Reports',
        filesUrlKey: 'test_reports',
        isMandatory: true,
        fileList: typeController.testReportRcpt,
        addFile: typeController.testReportRcptChange,
        removeFile: typeController.removeTestReportRcpt,
      ));
    }
    // Vision Bill - shown only if vision fee entered
    if (_hasVisionFee) {
      _docItems.add(_DocUploadItem(
        label: 'Vision Bill',
        filesUrlKey: 'vision_receipt',
        isMandatory: true,
        fileList: typeController.visionRcpt,
        addFile: typeController.visionRcptChange,
        removeFile: typeController.removeVisionRcpt,
      ));
    }
    // Dental Bill - shown only if dental fee entered
    if (_hasDentalFee) {
      _docItems.add(_DocUploadItem(
        label: 'Dental Bill',
        filesUrlKey: 'dental_receipt',
        isMandatory: true,
        fileList: typeController.dentalRcpt,
        addFile: typeController.dentalRcptChange,
        removeFile: typeController.removeDentalRcpt,
      ));
    }
    // Vaccination Bill - shown only if vaccination fee entered
    if (_hasVaccinationFee) {
      _docItems.add(_DocUploadItem(
        label: 'Vaccination Bill',
        filesUrlKey: 'vaccination_receipt',
        isMandatory: true,
        fileList: typeController.vaccinationRcpt,
        addFile: typeController.vaccinationRcptChange,
        removeFile: typeController.removeVaccinationRcpt,
      ));
    }
    // Physiotherapy Bill - shown only if physio fee entered
    if (_hasPhysioFee) {
      _docItems.add(_DocUploadItem(
        label: 'Physiotherapy Bill',
        filesUrlKey: 'physio_receipt',
        isMandatory: true,
        fileList: typeController.physioRcpt,
        addFile: typeController.physioRcptChange,
        removeFile: typeController.removePhysioRcpt,
      ));
    }
  }

  Future<void> _pickAndUpload(_DocUploadItem item) async {
    AppBottomSheet(
      height: 200,
      mChild: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                allowMultiple: false,
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                item.addFile(file);
                _uploadFile(item, result);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              var pickedFile = await _picker.pickImage(
                  source: ImageSource.camera, imageQuality: 80);
              if (pickedFile != null) {
                FilePickerResult pf =
                    CommonMethods.xFileToFilePickerResult(pickedFile);
                File file = File(pickedFile.path);
                item.addFile(file);
                _uploadFile(item, pf);
              }
            },
          ),
        ],
      ),
    ).modalBottomSheetMenu(context);
  }

  Future<void> _uploadFile(_DocUploadItem item, FilePickerResult result) async {
    CommonMethods.showAlertDialog(context);
    try {
      var response =
          await OpdSure.of(context).client.uploadFiles(results: result);
      if (response != null) {
        _uploadedUrls[item.filesUrlKey] ??= [];
        _uploadedUrls[item.filesUrlKey] =
            _uploadedUrls[item.filesUrlKey]! + response.data!;
        filesUrl[item.filesUrlKey] = _uploadedUrls[item.filesUrlKey];
        setState(() {
          _uploadStatus[item.filesUrlKey] = 'success';
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          _uploadStatus[item.filesUrlKey] = 'failed';
        });
        CommonMethods.showToast('File not uploaded, try again');
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _uploadStatus[item.filesUrlKey] = 'failed';
      });
      CommonMethods.showToast('File not uploaded, try again');
      Navigator.of(context).pop();
    }
  }

  String _getStatusText(String key) {
    if (_uploadStatus[key] == 'success') return 'Uploaded';
    if (_uploadStatus[key] == 'failed') return 'Failed';
    return 'Yet to upload';
  }

  Color _getStatusColor(String key) {
    if (_uploadStatus[key] == 'success') return Colors.green;
    if (_uploadStatus[key] == 'failed') return Colors.red;
    return Colors.grey;
  }

  IconData? _getStatusIcon(String key) {
    if (_uploadStatus[key] == 'success') return Icons.check_circle;
    if (_uploadStatus[key] == 'failed') return Icons.cancel;
    return null;
  }

  bool _validateUploads() {
    // Prescription is always mandatory
    if (filesUrl['prescription'] == null ||
        (filesUrl['prescription'] as List).isEmpty) {
      CommonMethods.showToast('Please upload Prescription');
      return false;
    }

    // Doctor Fee Bill mandatory if doctor fee entered
    if (_hasDoctorFee &&
        (filesUrl['fee_receipt'] == null ||
            (filesUrl['fee_receipt'] as List).isEmpty)) {
      CommonMethods.showToast("Please upload Doctor's Fee Bill");
      return false;
    }

    // Pharmacy receipt mandatory if pharmacy fee entered
    if (_hasPharmacyFee &&
        (filesUrl['pharmacy_receipt'] == null ||
            (filesUrl['pharmacy_receipt'] as List).isEmpty)) {
      CommonMethods.showToast('Please upload Pharmacy Bill');
      return false;
    }

    // Diagnostics bill AND report mandatory if diagnostics fee entered
    if (_hasDiagnosticsFee) {
      if (filesUrl['test_receipt'] == null ||
          (filesUrl['test_receipt'] as List).isEmpty) {
        CommonMethods.showToast('Please upload Diagnostics Bill');
        return false;
      }
      if (filesUrl['test_reports'] == null ||
          (filesUrl['test_reports'] as List).isEmpty) {
        CommonMethods.showToast('Please upload Diagnostics Report');
        return false;
      }
    }

    // Vision receipt mandatory if vision fee entered
    if (_hasVisionFee &&
        (filesUrl['vision_receipt'] == null ||
            (filesUrl['vision_receipt'] as List).isEmpty)) {
      CommonMethods.showToast('Please upload Vision Bill');
      return false;
    }

    // Dental receipt mandatory if dental fee entered
    if (_hasDentalFee &&
        (filesUrl['dental_receipt'] == null ||
            (filesUrl['dental_receipt'] as List).isEmpty)) {
      CommonMethods.showToast('Please upload Dental Bill');
      return false;
    }

    // Vaccination receipt mandatory if vaccination fee entered
    if (_hasVaccinationFee &&
        (filesUrl['vaccination_receipt'] == null ||
            (filesUrl['vaccination_receipt'] as List).isEmpty)) {
      CommonMethods.showToast('Please upload Vaccination Bill');
      return false;
    }

    // Physio receipt mandatory if physio fee entered
    if (_hasPhysioFee &&
        (filesUrl['physio_receipt'] == null ||
            (filesUrl['physio_receipt'] as List).isEmpty)) {
      CommonMethods.showToast('Please upload Physiotherapy Bill');
      return false;
    }

    return true;
  }

  Future<void> _submitClaim() async {
    if (!_validateUploads() && !(widget.isUpdate ?? false)) return;

    Map<String, dynamic> data = widget.claimJsonModel!.toJson();

    // Attach uploaded file URLs
    if (filesUrl['prescription'] != null) {
      data['prescription'] = filesUrl['prescription'];
    }
    if (filesUrl['fee_receipt'] != null) {
      data['fee_receipt'] = filesUrl['fee_receipt'];
    }
    if (filesUrl['pharmacy_receipt'] != null) {
      data['pharmacy_receipt'] = filesUrl['pharmacy_receipt'];
    }
    if (filesUrl['test_receipt'] != null) {
      data['test_receipt'] = filesUrl['test_receipt'];
    }
    if (filesUrl['test_reports'] != null) {
      data['test_reports'] = filesUrl['test_reports'];
    }
    if (filesUrl['vision_receipt'] != null) {
      data['vision_receipt'] = filesUrl['vision_receipt'];
    }
    if (filesUrl['dental_receipt'] != null) {
      data['dental_receipt'] = filesUrl['dental_receipt'];
    }
    if (filesUrl['vaccination_receipt'] != null) {
      data['vaccination_receipt'] = filesUrl['vaccination_receipt'];
    }
    if (filesUrl['physio_receipt'] != null) {
      data['physio_receipt'] = filesUrl['physio_receipt'];
    }

    CommonMethods.showAlertDialog(context);
    try {
      var response;
      if (widget.isUpdate ?? false) {
        response = await OpdSure.of(context)
            .client
            .updateAClaim(widget.claimId!, jsonEncode(data));
      } else {
        response =
            await OpdSure.of(context).client.fileAClaim(jsonEncode(data));
      }

      Map<String, dynamic> resMap = jsonDecode(response);
      Navigator.of(context, rootNavigator: false).pop();

      if (resMap['success']) {
        typeController.refreshClaimListChange(false);
        typeController.refreshClaimListChange(true);
        typeController.prescriptionList.clear();
        typeController.docFeeRcpt.clear();
        typeController.pharmacyRcpt.clear();
        typeController.labTestRcpt.clear();
        typeController.testReportRcpt.clear();
        typeController.visionRcpt.clear();
        typeController.dentalRcpt.clear();
        typeController.vaccinationRcpt.clear();
        typeController.physioRcpt.clear();
        typeController.selectClaimChange('');
        typeController.opdVisitDateChange('');
        CommonMethods.showOneButtonDialog(
          context,
          (widget.isUpdate ?? false)
              ? 'Claim updated successfully'
              : 'Claim submitted successfully',
          () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      } else if ((widget.isUpdate ?? false) &&
          resMap['message'] == 'Action on claim already taken') {
        CommonMethods.showToast(resMap['message']);
      } else {
        CommonMethods.showToast('Something went wrong');
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: false).pop();
      CommonMethods.showToast('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Upload Medical Bills & Receipts',
      ),
      childContent: ListView(
        padding: const EdgeInsets.all(AppDesign.spacingLg),
        children: [
          // Subtitle
          Text(
            'Please upload the required medical bills and documents to settle your claim.',
            style: AppDesign.bodySm.copyWith(color: AppDesign.textSecondary),
          ),
          const SizedBox(height: AppDesign.spacingXl),

          // Document table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppDesign.divider),
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            ),
            child: Column(
              children: [
                // Table header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDesign.radiusMd),
                      topRight: Radius.circular(AppDesign.radiusMd),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text('DOCUMENT',
                            style: AppDesign.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppDesign.textSecondary)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('STATUS',
                            style: AppDesign.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppDesign.textSecondary)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('ACTION',
                            textAlign: TextAlign.end,
                            style: AppDesign.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppDesign.textSecondary)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Document rows
                ..._docItems.map((item) => _buildDocRow(item)),
              ],
            ),
          ),

          const SizedBox(height: AppDesign.spacingXl),

          // Note
          Container(
            padding: const EdgeInsets.all(AppDesign.spacingLg),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMd),
            ),
            child: RichText(
              text: TextSpan(
                style:
                    AppDesign.bodySm.copyWith(color: const Color(0xFF8D6E00)),
                children: const [
                  TextSpan(
                    text: 'Note: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        'Prescription is mandatory. Every listed document must be uploaded successfully before submitting. Diagnostics requires both bill and report.',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDesign.spacingXxl),

          // Submit button
          ElevatedButton(
            onPressed: _submitClaim,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConfig.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Submit Claim',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),

          const SizedBox(height: AppDesign.spacing3Xl),
        ],
      ),
    );
  }

  Widget _buildDocRow(_DocUploadItem item) {
    String status = _getStatusText(item.filesUrlKey);
    Color statusColor = _getStatusColor(item.filesUrlKey);
    IconData? statusIcon = _getStatusIcon(item.filesUrlKey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppDesign.divider)),
      ),
      child: Row(
        children: [
          // Document name
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (item.isMandatory)
                  Text('* ',
                      style: AppDesign.bodyMd.copyWith(
                          color: Colors.red, fontWeight: FontWeight.w600)),
                Flexible(
                  child: Text(item.label,
                      style: AppDesign.bodyMd
                          .copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (statusIcon != null) ...[
                  Icon(statusIcon, size: 16, color: statusColor),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(status,
                      style: AppDesign.bodySm.copyWith(color: statusColor)),
                ),
              ],
            ),
          ),
          // Upload action button
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _pickAndUpload(item),
                icon: const Icon(Icons.file_download_outlined, size: 16),
                label: const Text('Upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  minimumSize: const Size(0, 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
