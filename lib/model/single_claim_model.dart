class SingleClaimModel {
  SingleClaimModel({
      SingleClaimData? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  SingleClaimModel.fromJson(dynamic json) {
    _data = json['data'] != null ? SingleClaimData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  SingleClaimData? _data;
  bool? _success;
  String? _message;

  SingleClaimData? get data => _data;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

class SingleClaimData {
  SingleClaimData({
      String? id, 
      String? opdDate, 
      String? docName, 
      String? docCountryCode, 
      int? docPhone, 
      String? claimId, 
      String? docRegistration, 
      int? state, 
      String? city, 
      String? diagonosisDetail, 
      int? doctorFee, 
      int? pharmacyFee, 
      int? labTestFee, 
      int? claimableDoctorFee, 
      int? claimablePharmacyFee, 
      int? claimableLabTestFee, 
      int? billAmount, 
      dynamic claimableAmount,
      String? specialization, 
      int? claimType, 
      String? hospital, 
      List<String>? feeReceipt, 
      List<String>? prescription, 
      List<String>? pharmacyReceipt, 
      List<String>? testReceipt, 
      int? status, 
      String? memberId, 
      UserId? userId, 
      dynamic manager, 
      bool? subscriberReaction, 
      bool? resubmission, 
      List<dynamic>? remark, 
      List<dynamic>? subscriberRemark, 
      String? createdAt, 
      String? updatedAt, 
      int? v, 
      MemberDetails? memberDetails,}){
    _id = id;
    _opdDate = opdDate;
    _docName = docName;
    _docCountryCode = docCountryCode;
    _docPhone = docPhone;
    _claimId = claimId;
    _docRegistration = docRegistration;
    _state = state;
    _city = city;
    _diagonosisDetail = diagonosisDetail;
    _doctorFee = doctorFee;
    _pharmacyFee = pharmacyFee;
    _labTestFee = labTestFee;
    _claimableDoctorFee = claimableDoctorFee;
    _claimablePharmacyFee = claimablePharmacyFee;
    _claimableLabTestFee = claimableLabTestFee;
    _billAmount = billAmount;
    _claimableAmount = claimableAmount;
    _specialization = specialization;
    _claimType = claimType;
    _hospital = hospital;
    _feeReceipt = feeReceipt;
    _prescription = prescription;
    _pharmacyReceipt = pharmacyReceipt;
    _testReceipt = testReceipt;
    _status = status;
    _memberId = memberId;
    _userId = userId;
    _manager = manager;
    _subscriberReaction = subscriberReaction;
    _resubmission = resubmission;
    _remark = remark;
    _subscriberRemark = subscriberRemark;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _memberDetails = memberDetails;
}

  SingleClaimData.fromJson(dynamic json) {
    _id = json['_id'];
    _opdDate = json['opd_date'];
    _docName = json['doc_name'];
    _docCountryCode = json['doc_country_code'];
    _docPhone = json['doc_phone'];
    _claimId = json['claim_id'];
    _docRegistration = json['doc_registration'];
    _state = json['state'];
    _city = json['city'];
    _diagonosisDetail = json['diagonosis_detail'];
    _doctorFee = json['doctor_fee'];
    _pharmacyFee = json['pharmacy_fee'];
    _labTestFee = json['lab_test_fee'];
    _claimableDoctorFee = json['claimable_doctor_fee'];
    _claimablePharmacyFee = json['claimable_pharmacy_fee'];
    _claimableLabTestFee = json['claimable_lab_test_fee'];
    _billAmount = json['bill_amount'];
    _claimableAmount = json['claimable_amount'];
    _specialization = json['specialization'];
    _claimType = json['claim_type'];
    _hospital = json['hospital'];
    _feeReceipt = json['fee_receipt'] != null ? json['fee_receipt'].cast<String>() : [];
    _prescription = json['prescription'] != null ? json['prescription'].cast<String>() : [];
    _pharmacyReceipt = json['pharmacy_receipt'] != null ? json['pharmacy_receipt'].cast<String>() : [];
    _testReceipt = json['test_receipt'] != null ? json['test_receipt'].cast<String>() : [];
    _status = json['status'];
    _memberId = json['member_id'];
    _userId = json['user_id'] != null ? UserId.fromJson(json['user_id']) : null;
    _manager = json['manager'];
    _subscriberReaction = json['subscriber_reaction'];
    _resubmission = json['resubmission'];
    if (json['remark'] != null) {
      _remark = [];
      // json['remark'].forEach((v) {
      //   _remark?.add(Dynamic.fromJson(v));
      // });
    }
    if (json['subscriber_remark'] != null) {
      _subscriberRemark = [];
      // json['subscriber_remark'].forEach((v) {
      //   _subscriberRemark?.add(Dynamic.fromJson(v));
      // });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _memberDetails = json['member_details'] != null ? MemberDetails.fromJson(json['member_details']) : null;
  }
  String? _id;
  String? _opdDate;
  String? _docName;
  String? _docCountryCode;
  int? _docPhone;
  String? _claimId;
  String? _docRegistration;
  int? _state;
  String? _city;
  String? _diagonosisDetail;
  int? _doctorFee;
  int? _pharmacyFee;
  int? _labTestFee;
  int? _claimableDoctorFee;
  int? _claimablePharmacyFee;
  int? _claimableLabTestFee;
  int? _billAmount;
  dynamic _claimableAmount;
  String? _specialization;
  int? _claimType;
  String? _hospital;
  List<String>? _feeReceipt;
  List<String>? _prescription;
  List<String>? _pharmacyReceipt;
  List<String>? _testReceipt;
  int? _status;
  String? _memberId;
  UserId? _userId;
  dynamic _manager;
  bool? _subscriberReaction;
  bool? _resubmission;
  List<dynamic>? _remark;
  List<dynamic>? _subscriberRemark;
  String? _createdAt;
  String? _updatedAt;
  int? _v;
  MemberDetails? _memberDetails;

  String? get id => _id;
  String? get opdDate => _opdDate;
  String? get docName => _docName;
  String? get docCountryCode => _docCountryCode;
  int? get docPhone => _docPhone;
  String? get claimId => _claimId;
  String? get docRegistration => _docRegistration;
  int? get state => _state;
  String? get city => _city;
  String? get diagonosisDetail => _diagonosisDetail;
  int? get doctorFee => _doctorFee;
  int? get pharmacyFee => _pharmacyFee;
  int? get labTestFee => _labTestFee;
  int? get claimableDoctorFee => _claimableDoctorFee;
  int? get claimablePharmacyFee => _claimablePharmacyFee;
  int? get claimableLabTestFee => _claimableLabTestFee;
  int? get billAmount => _billAmount;
  dynamic get claimableAmount => _claimableAmount;
  String? get specialization => _specialization;
  int? get claimType => _claimType;
  String? get hospital => _hospital;
  List<String>? get feeReceipt => _feeReceipt;
  List<String>? get prescription => _prescription;
  List<String>? get pharmacyReceipt => _pharmacyReceipt;
  List<String>? get testReceipt => _testReceipt;
  int? get status => _status;
  String? get memberId => _memberId;
  UserId? get userId => _userId;
  dynamic get manager => _manager;
  bool? get subscriberReaction => _subscriberReaction;
  bool? get resubmission => _resubmission;
  List<dynamic>? get remark => _remark;
  List<dynamic>? get subscriberRemark => _subscriberRemark;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;
  MemberDetails? get memberDetails => _memberDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['opd_date'] = _opdDate;
    map['doc_name'] = _docName;
    map['doc_country_code'] = _docCountryCode;
    map['doc_phone'] = _docPhone;
    map['claim_id'] = _claimId;
    map['doc_registration'] = _docRegistration;
    map['state'] = _state;
    map['city'] = _city;
    map['diagonosis_detail'] = _diagonosisDetail;
    map['doctor_fee'] = _doctorFee;
    map['pharmacy_fee'] = _pharmacyFee;
    map['lab_test_fee'] = _labTestFee;
    map['claimable_doctor_fee'] = _claimableDoctorFee;
    map['claimable_pharmacy_fee'] = _claimablePharmacyFee;
    map['claimable_lab_test_fee'] = _claimableLabTestFee;
    map['bill_amount'] = _billAmount;
    map['claimable_amount'] = _claimableAmount;
    map['specialization'] = _specialization;
    map['claim_type'] = _claimType;
    map['hospital'] = _hospital;
    map['fee_receipt'] = _feeReceipt;
    map['prescription'] = _prescription;
    map['pharmacy_receipt'] = _pharmacyReceipt;
    map['test_receipt'] = _testReceipt;
    map['status'] = _status;
    map['member_id'] = _memberId;
    if (_userId != null) {
      map['user_id'] = _userId?.toJson();
    }
    map['manager'] = _manager;
    map['subscriber_reaction'] = _subscriberReaction;
    map['resubmission'] = _resubmission;
    if (_remark != null) {
      map['remark'] = _remark?.map((v) => v.toJson()).toList();
    }
    if (_subscriberRemark != null) {
      map['subscriber_remark'] = _subscriberRemark?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    if (_memberDetails != null) {
      map['member_details'] = _memberDetails?.toJson();
    }
    return map;
  }

}

class MemberDetails {
  MemberDetails({
      String? name, 
      String? memberId, 
      int? phone,}){
    _name = name;
    _memberId = memberId;
    _phone = phone;
}

  MemberDetails.fromJson(dynamic json) {
    _name = json['name'];
    _memberId = json['member_id'];
    _phone = json['phone'];
  }
  String? _name;
  String? _memberId;
  int? _phone;

  String? get name => _name;
  String? get memberId => _memberId;
  int? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['member_id'] = _memberId;
    map['phone'] = _phone;
    return map;
  }

}

class UserId {
  UserId({
      String? id, 
      String? email, 
      String? name,}){
    _id = id;
    _email = email;
    _name = name;
}

  UserId.fromJson(dynamic json) {
    _id = json['_id'];
    _email = json['email'];
    _name = json['name'];
  }
  String? _id;
  String? _email;
  String? _name;

  String? get id => _id;
  String? get email => _email;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['email'] = _email;
    map['name'] = _name;
    return map;
  }

}