class MyClaimsModel {
  MyClaimsModel({
      Data? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  MyClaimsModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  Data? _data;
  bool? _success;
  String? _message;

  Data? get data => _data;
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

class Data {
  Data({
      List<ClaimRecords>? records,
      Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
}

  Data.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(ClaimRecords.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<ClaimRecords>? _records;
  Pagination? _pagination;

  List<ClaimRecords>? get records => _records;
  Pagination? get pagination => _pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_records != null) {
      map['records'] = _records?.map((v) => v.toJson()).toList();
    }
    if (_pagination != null) {
      map['pagination'] = _pagination?.toJson();
    }
    return map;
  }

}

class Pagination {
  Pagination({
      int? totalRecords, 
      int? pageSize, 
      int? totalPages, 
      int? currentPage, 
      dynamic nextPage, 
      dynamic prevPage,}){
    _totalRecords = totalRecords;
    _pageSize = pageSize;
    _totalPages = totalPages;
    _currentPage = currentPage;
    _nextPage = nextPage;
    _prevPage = prevPage;
}

  Pagination.fromJson(dynamic json) {
    _totalRecords = json['totalRecords'];
    _pageSize = json['pageSize'];
    _totalPages = json['totalPages'];
    _currentPage = json['currentPage'];
    _nextPage = json['nextPage'];
    _prevPage = json['prevPage'];
  }
  int? _totalRecords;
  int? _pageSize;
  int? _totalPages;
  int? _currentPage;
  dynamic _nextPage;
  dynamic _prevPage;

  int? get totalRecords => _totalRecords;
  int? get pageSize => _pageSize;
  int? get totalPages => _totalPages;
  int? get currentPage => _currentPage;
  dynamic get nextPage => _nextPage;
  dynamic get prevPage => _prevPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalRecords'] = _totalRecords;
    map['pageSize'] = _pageSize;
    map['totalPages'] = _totalPages;
    map['currentPage'] = _currentPage;
    map['nextPage'] = _nextPage;
    map['prevPage'] = _prevPage;
    return map;
  }

}

class ClaimRecords {
  ClaimRecords({
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
      double? claimableAmount, 
      String? specialization, 
      int? claimType, 
      String? hospital, 
      List<String>? feeReceipt, 
      List<String>? prescription, 
      List<String>? pharmacyReceipt, 
      List<String>? testReceipt, 
      int? status, 
      MemberId? memberId, 
      String? userId, 
      bool? subscriberReaction, 
      bool? resubmission, 
      List<dynamic>? subscriberRemark, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
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
    _subscriberReaction = subscriberReaction;
    _resubmission = resubmission;
    _subscriberRemark = subscriberRemark;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  ClaimRecords.fromJson(dynamic json) {
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
    _memberId = json['member_id'] != null ? MemberId.fromJson(json['member_id']) : null;
    _userId = json['user_id'];
    _subscriberReaction = json['subscriber_reaction'];
    _resubmission = json['resubmission'];
    if (json['subscriber_remark'] != null) {
      _subscriberRemark = [];
      json['subscriber_remark'].forEach((v) {
        // _subscriberRemark?.add(dynamic.fromJson(v));
      });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
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
  MemberId? _memberId;
  String? _userId;
  bool? _subscriberReaction;
  bool? _resubmission;
  List<dynamic>? _subscriberRemark;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

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
  MemberId? get memberId => _memberId;
  String? get userId => _userId;
  bool? get subscriberReaction => _subscriberReaction;
  bool? get resubmission => _resubmission;
  List<dynamic>? get subscriberRemark => _subscriberRemark;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;

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
    if (_memberId != null) {
      map['member_id'] = _memberId?.toJson();
    }
    map['user_id'] = _userId;
    map['subscriber_reaction'] = _subscriberReaction;
    map['resubmission'] = _resubmission;
    if (_subscriberRemark != null) {
      map['subscriber_remark'] = _subscriberRemark?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

class MemberId {
  MemberId({
      String? id, 
      String? name, 
      int? relation,}){
    _id = id;
    _name = name;
    _relation = relation;
}

  MemberId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _relation = json['relation'];
  }
  String? _id;
  String? _name;
  int? _relation;

  String? get id => _id;
  String? get name => _name;
  int? get relation => _relation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['relation'] = _relation;
    return map;
  }

}