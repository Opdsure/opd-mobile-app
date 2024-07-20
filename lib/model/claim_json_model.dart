class ClaimJsonModel {
  ClaimJsonModel({
      String? memberId, 
      String? opdDate, 
      String? docCountryCode, 
      String? docPhone, 
      String? doctorFee, 
      String? pharmacyFee, 
      String? labTestFee, 
      int? claimableDoctorFee,
      int? claimablePharmacyFee,
      int? claimableLabTestFee,
      String? claimType,
      String? docName, 
      String? id,
      String? userRemark,
      String? docEmail,
      String? docRegistration,
      String? diagonosisDetail, 
      String? hospital, 
      List<String>? prescription, 
      List<String>? pharmacyReceipt, 
      List<String>? feeReceipt, 
      List<String>? testReceipt, 
      String? billAmount,
      String? claimableAmount,
      String? claimableCombinedPharmacyTestFees,
      String? combinedPharmacyTestFees,
      String? claimCombination,
      int? state,
      String? city, 
      String? specialization,}){
    _memberId = memberId;
    _opdDate = opdDate;
    _docCountryCode = docCountryCode;
    _docPhone = docPhone;
    _doctorFee = doctorFee;
    _pharmacyFee = pharmacyFee;
    _labTestFee = labTestFee;
    _claimableDoctorFee = claimableDoctorFee;
    _claimablePharmacyFee = claimablePharmacyFee;
    _claimableLabTestFee = claimableLabTestFee;
    _claimType = claimType;
    _docName = docName;
    _id = id;
    _userRemark = userRemark;
    _docEmail = docEmail;
    _docRegistration = docRegistration;
    _diagonosisDetail = diagonosisDetail;
    _hospital = hospital;
    _prescription = prescription;
    _pharmacyReceipt = pharmacyReceipt;
    _feeReceipt = feeReceipt;
    _testReceipt = testReceipt;
    _billAmount = billAmount;
    _claimableAmount = claimableAmount;
    _claimableCombinedPharmacyTestFees = claimableCombinedPharmacyTestFees;
    _combinedPharmacyTestFees = combinedPharmacyTestFees;
    _claimCombination = claimCombination;
    _state = state;
    _city = city;
    _specialization = specialization;
}

  ClaimJsonModel.fromJson(dynamic json) {
    _memberId = json['member_id'];
    _opdDate = json['opd_date'];
    _docCountryCode = json['doc_country_code'];
    _docPhone = json['doc_phone'];
    _doctorFee = json['doctor_fee'];
    _pharmacyFee = json['pharmacy_fee'];
    _labTestFee = json['lab_test_fee'];
    _claimableDoctorFee = json['claimable_doctor_fee'];
    _claimablePharmacyFee = json['claimable_pharmacy_fee'];
    _claimableLabTestFee = json['claimable_lab_test_fee'];
    _claimType = json['claim_type'];
    _docName = json['doc_name'];
    _id = json['_id'];
    _userRemark = json['user_remark'];
    _docEmail = json['doc_email'];
    _docRegistration = json['doc_registration'];
    _diagonosisDetail = json['diagonosis_detail'];
    _hospital = json['hospital'];
    _prescription = json['prescription'] != null ? json['prescription'].cast<String>() : [];
    _pharmacyReceipt = json['pharmacy_receipt'] != null ? json['pharmacy_receipt'].cast<String>() : [];
    _feeReceipt = json['fee_receipt'] != null ? json['fee_receipt'].cast<String>() : [];
    _testReceipt = json['test_receipt'] != null ? json['test_receipt'].cast<String>() : [];
    _billAmount = json['bill_amount'];
    _claimableAmount = json['claimable_amount'];
    _combinedPharmacyTestFees = json['combined_pharmacy_test_fees'];
    _claimableCombinedPharmacyTestFees = json['claimable_combined_pharmacy_test_fees'];
    _claimCombination = json['claim_combination'];
    _state = json['state'];
    _city = json['city'];
    _specialization = json['specialization'];
  }
  String? _memberId;
  String? _opdDate;
  String? _docCountryCode;
  String? _docPhone;
  String? _doctorFee;
  String? _pharmacyFee;
  String? _labTestFee;
  int? _claimableDoctorFee;
  int? _claimablePharmacyFee;
  int? _claimableLabTestFee;
  String? _claimType;
  String? _docName;
  String? _id;
  String? _userRemark;
  String? _docEmail;
  String? _docRegistration;
  String? _diagonosisDetail;
  String? _hospital;
  List<String>? _prescription;
  List<String>? _pharmacyReceipt;
  List<String>? _feeReceipt;
  List<String>? _testReceipt;
  String? _billAmount;
  String? _claimableAmount;
  String? _combinedPharmacyTestFees;
  String? _claimableCombinedPharmacyTestFees;
  String? _claimCombination;
  int? _state;
  String? _city;
  String? _specialization;

  String? get memberId => _memberId;
  String? get opdDate => _opdDate;
  String? get docCountryCode => _docCountryCode;
  String? get docPhone => _docPhone;
  String? get doctorFee => _doctorFee;
  String? get pharmacyFee => _pharmacyFee;
  String? get labTestFee => _labTestFee;
  int? get claimableDoctorFee => _claimableDoctorFee;
  int? get claimablePharmacyFee => _claimablePharmacyFee;
  int? get claimableLabTestFee => _claimableLabTestFee;
  String? get claimType => _claimType;
  String? get docName => _docName;
  String? get id => _id;
  String? get userRemark => _userRemark;
  String? get docEmail => _docEmail;
  String? get docRegistration => _docRegistration;
  String? get diagonosisDetail => _diagonosisDetail;
  String? get hospital => _hospital;
  List<String>? get prescription => _prescription;
  List<String>? get pharmacyReceipt => _pharmacyReceipt;
  List<String>? get feeReceipt => _feeReceipt;
  List<String>? get testReceipt => _testReceipt;
  String? get billAmount => _billAmount;
  String? get claimableAmount => _claimableAmount;
  String? get combinedPharmacyTestFees => _combinedPharmacyTestFees;
  String? get claimableCombinedPharmacyTestFees => _claimableCombinedPharmacyTestFees;
  String? get claimCombination => _claimCombination;
  int? get state => _state;
  String? get city => _city;
  String? get specialization => _specialization;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_memberId != null) map['member_id'] = _memberId;
    map['opd_date'] = _opdDate;
    map['doc_country_code'] = _docCountryCode;
    map['doc_phone'] = _docPhone;
    map['doctor_fee'] = _doctorFee;
    if (_pharmacyFee != null) map['pharmacy_fee'] = _pharmacyFee;
    if (_labTestFee != null) map['lab_test_fee'] = _labTestFee;
    map['claimable_doctor_fee'] = _claimableDoctorFee;
    if (_claimablePharmacyFee != null) map['claimable_pharmacy_fee'] = _claimablePharmacyFee;
    if (_claimableLabTestFee != null) map['claimable_lab_test_fee'] = _claimableLabTestFee;
    map['claim_type'] = _claimType;
    map['doc_name'] = _docName;
    if (_id != null) map['_id'] = _id;
    if (_userRemark != null) map['user_remark'] = _userRemark;
    if (_docEmail != null) map['doc_email'] = _docEmail;
    map['doc_registration'] = _docRegistration;
    map['diagonosis_detail'] = _diagonosisDetail;
    map['hospital'] = _hospital;
    map['prescription'] = _prescription;
    map['pharmacy_receipt'] = _pharmacyReceipt;
    map['fee_receipt'] = _feeReceipt;
    map['test_receipt'] = _testReceipt;
    map['bill_amount'] = _billAmount;
    map['claimable_amount'] = _claimableAmount;
    if (_combinedPharmacyTestFees != null) map['combined_pharmacy_test_fees'] = _combinedPharmacyTestFees;
    if (_claimableCombinedPharmacyTestFees != null) map['claimable_combined_pharmacy_test_fees'] = _claimableCombinedPharmacyTestFees;
    map['claim_combination'] = _claimCombination;
    map['state'] = _state;
    map['city'] = _city;
    if(_specialization != null) map['specialization'] = _specialization;
    return map;
  }

}