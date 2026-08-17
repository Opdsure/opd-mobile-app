class ClaimJsonModel {
  ClaimJsonModel({
    String? memberId,
    String? opdDate,
    String? docCountryCode,
    String? docPhone,
    String? docAddress,
    String? pinCode,
    String? doctorFee,
    String? pharmacyFee,
    String? labTestFee,
    String? visionFee,
    String? dentalFee,
    String? vaccinationFee,
    String? physioFee,
    int? claimableDoctorFee,
    int? claimablePharmacyFee,
    int? claimableLabTestFee,
    int? claimableVisionFee,
    int? claimableDentalFee,
    int? claimableVaccinationFee,
    int? claimablePhysioFee,
    String? docName,
    String? id,
    String? userRemark,
    String? docEmail,
    String? docRegistration,
    String? diagonosisDetail,
    String? hospital,
    String? hospitalId,
    List<String>? prescription,
    List<String>? pharmacyReceipt,
    List<String>? feeReceipt,
    List<String>? testReceipt,
    List<String>? testReports,
    List<String>? visionReceipt,
    List<String>? dentalReceipt,
    List<String>? vaccinationReceipt,
    List<String>? physioReceipt,
    String? billAmount,
    String? claimableAmount,
    String? claimableCombinedPharmacyTestFees,
    String? combinedPharmacyTestFees,
    String? claimCombination,
    String? city,
    String? specialization,
    dynamic approvedClaimablePharmacyFee,
    dynamic approvedClaimableLabTestFee,
    dynamic approvedClaimableCombinedPharmacyTestFees,
    dynamic approvedClaimableAmount,
    dynamic approvedClaimableDoctorFee,
    dynamic approvedClaimableVisionFee,
    dynamic approvedClaimableDentalFee,
    dynamic approvedClaimableVaccinationFee,
    dynamic approvedClaimablePhysioFee,
  }) {
    _memberId = memberId;
    _opdDate = opdDate;
    _docCountryCode = docCountryCode;
    _docPhone = docPhone;
    _docAddress = docAddress;
    _pinCode = pinCode;
    _doctorFee = doctorFee;
    _pharmacyFee = pharmacyFee;
    _labTestFee = labTestFee;
    _visionFee = visionFee;
    _dentalFee = dentalFee;
    _vaccinationFee = vaccinationFee;
    _physioFee = physioFee;
    _claimableDoctorFee = claimableDoctorFee;
    _claimablePharmacyFee = claimablePharmacyFee;
    _claimableLabTestFee = claimableLabTestFee;
    _claimableVisionFee = claimableVisionFee;
    _claimableDentalFee = claimableDentalFee;
    _claimableVaccinationFee = claimableVaccinationFee;
    _claimablePhysioFee = claimablePhysioFee;
    _docName = docName;
    _id = id;
    _userRemark = userRemark;
    _docEmail = docEmail;
    _docRegistration = docRegistration;
    _diagonosisDetail = diagonosisDetail;
    _hospital = hospital;
    _hospitalId = hospitalId;
    _prescription = prescription;
    _pharmacyReceipt = pharmacyReceipt;
    _feeReceipt = feeReceipt;
    _testReceipt = testReceipt;
    _testReports = testReports;
    _visionReceipt = visionReceipt;
    _dentalReceipt = dentalReceipt;
    _vaccinationReceipt = vaccinationReceipt;
    _physioReceipt = physioReceipt;
    _billAmount = billAmount;
    _claimableAmount = claimableAmount;
    _claimableCombinedPharmacyTestFees = claimableCombinedPharmacyTestFees;
    _combinedPharmacyTestFees = combinedPharmacyTestFees;
    _claimCombination = claimCombination;
    _city = city;
    _specialization = specialization;
    _approvedClaimablePharmacyFee = approvedClaimablePharmacyFee;
    _approvedClaimableLabTestFee = approvedClaimableLabTestFee;
    _approvedClaimableCombinedPharmacyTestFees =
        approvedClaimableCombinedPharmacyTestFees;
    _approvedClaimableAmount = approvedClaimableAmount;
    _approvedClaimableDoctorFee = approvedClaimableDoctorFee;
    _approvedClaimableVisionFee = approvedClaimableVisionFee;
    _approvedClaimableDentalFee = approvedClaimableDentalFee;
    _approvedClaimableVaccinationFee = approvedClaimableVaccinationFee;
    _approvedClaimablePhysioFee = approvedClaimablePhysioFee;
  }

  ClaimJsonModel.fromJson(dynamic json) {
    _memberId = json['member_id'];
    _opdDate = json['opd_date'];
    _docCountryCode = json['doc_country_code'];
    _docPhone = json['doc_phone'];
    _docAddress = json['doc_address'];
    _pinCode = json['pincode'];
    _doctorFee = json['doctor_fee'];
    _pharmacyFee = json['pharmacy_fee'];
    _labTestFee = json['lab_test_fee'];
    _visionFee = json['vision_fee'];
    _dentalFee = json['dental_fee'];
    _vaccinationFee = json['vaccination_fee'];
    _physioFee = json['physio_fee'];
    _claimableDoctorFee = json['claimable_doctor_fee'];
    _claimablePharmacyFee = json['claimable_pharmacy_fee'];
    _claimableLabTestFee = json['claimable_lab_test_fee'];
    _claimableVisionFee = json['claimable_vision_fee'];
    _claimableDentalFee = json['claimable_dental_fee'];
    _claimableVaccinationFee = json['claimable_vaccination_fee'];
    _claimablePhysioFee = json['claimable_physio_fee'];
    _docName = json['doc_name'];
    _id = json['_id'];
    _userRemark = json['user_remark'];
    _docEmail = json['doc_email'];
    _docRegistration = json['doc_registration'];
    _diagonosisDetail = json['diagonosis_detail'];
    _hospital = json['hospital'];
    _hospitalId = json['hospital_id'];
    _prescription =
        json['prescription'] != null ? json['prescription'].cast<String>() : [];
    _pharmacyReceipt = json['pharmacy_receipt'] != null
        ? json['pharmacy_receipt'].cast<String>()
        : [];
    _feeReceipt =
        json['fee_receipt'] != null ? json['fee_receipt'].cast<String>() : [];
    _testReceipt =
        json['test_receipt'] != null ? json['test_receipt'].cast<String>() : [];
    _testReports =
        json['test_reports'] != null ? json['test_reports'].cast<String>() : [];
    _visionReceipt = json['vision_receipt'] != null
        ? json['vision_receipt'].cast<String>()
        : [];
    _dentalReceipt = json['dental_receipt'] != null
        ? json['dental_receipt'].cast<String>()
        : [];
    _vaccinationReceipt = json['vaccination_receipt'] != null
        ? json['vaccination_receipt'].cast<String>()
        : [];
    _physioReceipt = json['physio_receipt'] != null
        ? json['physio_receipt'].cast<String>()
        : [];
    _billAmount = json['bill_amount'];
    _claimableAmount = json['claimable_amount'];
    _combinedPharmacyTestFees = json['combined_pharmacy_test_fees'];
    _claimableCombinedPharmacyTestFees =
        json['claimable_combined_pharmacy_test_fees'];
    _claimCombination = json['claim_combination'];
    _city = json['city'];
    _specialization = json['specialization'];
    _approvedClaimablePharmacyFee = json['approved_claimable_pharmacy_fee'];
    _approvedClaimableLabTestFee = json['approved_claimable_lab_test_fee'];
    _approvedClaimableCombinedPharmacyTestFees =
        json['approved_claimable_combined_pharmacy_test_fees'];
    _approvedClaimableAmount = json['approved_claimable_amount'];
    _approvedClaimableDoctorFee = json['approved_claimable_doctor_fee'];
    _approvedClaimableVisionFee = json['approved_claimable_vision_fee'];
    _approvedClaimableDentalFee = json['approved_claimable_dental_fee'];
    _approvedClaimableVaccinationFee =
        json['approved_claimable_vaccination_fee'];
    _approvedClaimablePhysioFee = json['approved_claimable_physio_fee'];
  }

  String? _memberId;
  String? _opdDate;
  String? _docCountryCode;
  String? _docPhone;
  String? _docAddress;
  String? _pinCode;
  String? _doctorFee;
  String? _pharmacyFee;
  String? _labTestFee;
  String? _visionFee;
  String? _dentalFee;
  String? _vaccinationFee;
  String? _physioFee;
  int? _claimableDoctorFee;
  int? _claimablePharmacyFee;
  int? _claimableLabTestFee;
  int? _claimableVisionFee;
  int? _claimableDentalFee;
  int? _claimableVaccinationFee;
  int? _claimablePhysioFee;
  String? _docName;
  String? _id;
  String? _userRemark;
  String? _docEmail;
  String? _docRegistration;
  String? _diagonosisDetail;
  String? _hospital;
  String? _hospitalId;
  List<String>? _prescription;
  List<String>? _pharmacyReceipt;
  List<String>? _feeReceipt;
  List<String>? _testReceipt;
  List<String>? _testReports;
  List<String>? _visionReceipt;
  List<String>? _dentalReceipt;
  List<String>? _vaccinationReceipt;
  List<String>? _physioReceipt;
  String? _billAmount;
  String? _claimableAmount;
  String? _combinedPharmacyTestFees;
  String? _claimableCombinedPharmacyTestFees;
  String? _claimCombination;
  String? _city;
  String? _specialization;
  dynamic _approvedClaimablePharmacyFee;
  dynamic _approvedClaimableLabTestFee;
  dynamic _approvedClaimableCombinedPharmacyTestFees;
  dynamic _approvedClaimableAmount;
  dynamic _approvedClaimableDoctorFee;
  dynamic _approvedClaimableVisionFee;
  dynamic _approvedClaimableDentalFee;
  dynamic _approvedClaimableVaccinationFee;
  dynamic _approvedClaimablePhysioFee;

  String? get memberId => _memberId;
  String? get opdDate => _opdDate;
  String? get docCountryCode => _docCountryCode;
  String? get docPhone => _docPhone;
  String? get docAddress => _docAddress;
  String? get pinCode => _pinCode;
  String? get doctorFee => _doctorFee;
  String? get pharmacyFee => _pharmacyFee;
  String? get labTestFee => _labTestFee;
  String? get visionFee => _visionFee;
  String? get dentalFee => _dentalFee;
  String? get vaccinationFee => _vaccinationFee;
  String? get physioFee => _physioFee;
  int? get claimableDoctorFee => _claimableDoctorFee;
  int? get claimablePharmacyFee => _claimablePharmacyFee;
  int? get claimableLabTestFee => _claimableLabTestFee;
  int? get claimableVisionFee => _claimableVisionFee;
  int? get claimableDentalFee => _claimableDentalFee;
  int? get claimableVaccinationFee => _claimableVaccinationFee;
  int? get claimablePhysioFee => _claimablePhysioFee;
  String? get docName => _docName;
  String? get id => _id;
  String? get userRemark => _userRemark;
  String? get docEmail => _docEmail;
  String? get docRegistration => _docRegistration;
  String? get diagonosisDetail => _diagonosisDetail;
  String? get hospital => _hospital;
  String? get hospitalId => _hospitalId;
  List<String>? get prescription => _prescription;
  List<String>? get pharmacyReceipt => _pharmacyReceipt;
  List<String>? get feeReceipt => _feeReceipt;
  List<String>? get testReceipt => _testReceipt;
  List<String>? get testReports => _testReports;
  List<String>? get visionReceipt => _visionReceipt;
  List<String>? get dentalReceipt => _dentalReceipt;
  List<String>? get vaccinationReceipt => _vaccinationReceipt;
  List<String>? get physioReceipt => _physioReceipt;
  String? get billAmount => _billAmount;
  String? get claimableAmount => _claimableAmount;
  String? get combinedPharmacyTestFees => _combinedPharmacyTestFees;
  String? get claimableCombinedPharmacyTestFees =>
      _claimableCombinedPharmacyTestFees;
  String? get claimCombination => _claimCombination;
  String? get city => _city;
  String? get specialization => _specialization;
  dynamic get approvedClaimablePharmacyFee => _approvedClaimablePharmacyFee;
  dynamic get approvedClaimableLabTestFee => _approvedClaimableLabTestFee;
  dynamic get approvedClaimableCombinedPharmacyTestFees =>
      _approvedClaimableCombinedPharmacyTestFees;
  dynamic get approvedClaimableAmount => _approvedClaimableAmount;
  dynamic get approvedClaimableDoctorFee => _approvedClaimableDoctorFee;
  dynamic get approvedClaimableVisionFee => _approvedClaimableVisionFee;
  dynamic get approvedClaimableDentalFee => _approvedClaimableDentalFee;
  dynamic get approvedClaimableVaccinationFee =>
      _approvedClaimableVaccinationFee;
  dynamic get approvedClaimablePhysioFee => _approvedClaimablePhysioFee;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_memberId != null) map['member_id'] = _memberId;
    map['opd_date'] = _opdDate;
    map['doc_country_code'] = _docCountryCode;
    map['doc_phone'] = _docPhone;
    map['doc_address'] = _docAddress;
    map['pincode'] = _pinCode;
    map['doctor_fee'] = _doctorFee;
    if (_pharmacyFee != null) map['pharmacy_fee'] = _pharmacyFee;
    if (_labTestFee != null) map['lab_test_fee'] = _labTestFee;
    if (_visionFee != null) map['vision_fee'] = _visionFee;
    if (_dentalFee != null) map['dental_fee'] = _dentalFee;
    if (_vaccinationFee != null) map['vaccination_fee'] = _vaccinationFee;
    if (_physioFee != null) map['physio_fee'] = _physioFee;
    map['claimable_doctor_fee'] = _claimableDoctorFee;
    if (_claimablePharmacyFee != null)
      map['claimable_pharmacy_fee'] = _claimablePharmacyFee;
    if (_claimableLabTestFee != null)
      map['claimable_lab_test_fee'] = _claimableLabTestFee;
    if (_claimableVisionFee != null)
      map['claimable_vision_fee'] = _claimableVisionFee;
    if (_claimableDentalFee != null)
      map['claimable_dental_fee'] = _claimableDentalFee;
    if (_claimableVaccinationFee != null)
      map['claimable_vaccination_fee'] = _claimableVaccinationFee;
    if (_claimablePhysioFee != null)
      map['claimable_physio_fee'] = _claimablePhysioFee;
    map['doc_name'] = _docName;
    if (_id != null) map['_id'] = _id;
    if (_userRemark != null) map['user_remark'] = _userRemark;
    if (_docEmail != null) map['doc_email'] = _docEmail;
    map['doc_registration'] = _docRegistration;
    map['diagonosis_detail'] = _diagonosisDetail;
    if (_hospital != null) map['hospital'] = _hospital;
    if (_hospitalId != null) map['hospital_id'] = _hospitalId;
    map['prescription'] = _prescription;
    if (_pharmacyReceipt != null) map['pharmacy_receipt'] = _pharmacyReceipt;
    if (_feeReceipt != null) map['fee_receipt'] = _feeReceipt;
    if (_testReceipt != null) map['test_receipt'] = _testReceipt;
    if (_testReports != null) map['test_reports'] = _testReports;
    if (_visionReceipt != null) map['vision_receipt'] = _visionReceipt;
    if (_dentalReceipt != null) map['dental_receipt'] = _dentalReceipt;
    if (_vaccinationReceipt != null)
      map['vaccination_receipt'] = _vaccinationReceipt;
    if (_physioReceipt != null) map['physio_receipt'] = _physioReceipt;
    map['bill_amount'] = _billAmount;
    map['claimable_amount'] = _claimableAmount;
    if (_combinedPharmacyTestFees != null)
      map['combined_pharmacy_test_fees'] = _combinedPharmacyTestFees;
    if (_claimableCombinedPharmacyTestFees != null)
      map['claimable_combined_pharmacy_test_fees'] =
          _claimableCombinedPharmacyTestFees;
    map['claim_combination'] = _claimCombination;
    map['city'] = _city;
    if (_specialization != null) map['specialization'] = _specialization;
    if (_approvedClaimablePharmacyFee != null)
      map['approved_claimable_pharmacy_fee'] = _approvedClaimablePharmacyFee;
    if (_approvedClaimableLabTestFee != null)
      map['approved_claimable_lab_test_fee'] = _approvedClaimableLabTestFee;
    if (_approvedClaimableCombinedPharmacyTestFees != null)
      map['approved_claimable_combined_pharmacy_test_fees'] =
          _approvedClaimableCombinedPharmacyTestFees;
    if (_approvedClaimableAmount != null)
      map['approved_claimable_amount'] = _approvedClaimableAmount;
    if (_approvedClaimableDoctorFee != null)
      map['approved_claimable_doctor_fee'] = _approvedClaimableDoctorFee;
    if (_approvedClaimableVisionFee != null)
      map['approved_claimable_vision_fee'] = _approvedClaimableVisionFee;
    if (_approvedClaimableDentalFee != null)
      map['approved_claimable_dental_fee'] = _approvedClaimableDentalFee;
    if (_approvedClaimableVaccinationFee != null)
      map['approved_claimable_vaccination_fee'] =
          _approvedClaimableVaccinationFee;
    if (_approvedClaimablePhysioFee != null)
      map['approved_claimable_physio_fee'] = _approvedClaimablePhysioFee;
    return map;
  }
}
