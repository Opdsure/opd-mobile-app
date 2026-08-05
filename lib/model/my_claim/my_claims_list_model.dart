// class MyClaimsListModel {
//   MyClaimsListModel({
//     ClaimData? data,
//       bool? success,
//       String? message,}){
//     _data = data;
//     _success = success;
//     _message = message;
// }
//
//   MyClaimsListModel.fromJson(dynamic json) {
//     _data = json['data'] != null ? ClaimData.fromJson(json['data']) : null;
//     _success = json['success'];
//     _message = json['message'];
//   }
//   ClaimData? _data;
//   bool? _success;
//   String? _message;
//
//   ClaimData? get data => _data;
//   bool? get success => _success;
//   String? get message => _message;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     map['success'] = _success;
//     map['message'] = _message;
//     return map;
//   }
//
// }
//
// class ClaimData {
//   ClaimData({
//       List<ClaimRecords>? records,
//       Pagination? pagination,}){
//     _records = records;
//     _pagination = pagination;
// }
//
//   ClaimData.fromJson(dynamic json) {
//     if (json['records'] != null) {
//       _records = [];
//       json['records'].forEach((v) {
//         _records?.add(ClaimRecords.fromJson(v));
//       });
//     }
//     _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
//   }
//   List<ClaimRecords>? _records;
//   Pagination? _pagination;
//
//   List<ClaimRecords>? get records => _records;
//   Pagination? get pagination => _pagination??Pagination();
//
//
//   int get getTotalClaim => records!.length;
//   int get getPendingClaim => records!.where((c) => c.status! == 0 || c.status! == 4 || c.status! == 6).toList().length;
//   int get getRejectedClaim => records!.where((c) => c.status! == 2 || c.status! == 3 || c.status! == 7).toList().length;
//   int get getSettledClaim => records!.where((c) => c.status! == 1 || c.status! == 12).toList().length;
//
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_records != null) {
//       map['records'] = _records?.map((v) => v.toJson()).toList();
//     }
//     if (_pagination != null) {
//       map['pagination'] = _pagination?.toJson();
//     }
//     return map;
//   }
//
// }
//
// class Pagination {
//   Pagination({
//       int? totalRecords,
//       int? pageSize,
//       int? totalPages,
//       int? currentPage,
//       dynamic nextPage,
//       dynamic prevPage,}){
//     _totalRecords = totalRecords;
//     _pageSize = pageSize;
//     _totalPages = totalPages;
//     _currentPage = currentPage;
//     _nextPage = nextPage;
//     _prevPage = prevPage;
// }
//
//   Pagination.fromJson(dynamic json) {
//     _totalRecords = json['totalRecords'];
//     _pageSize = json['pageSize'];
//     _totalPages = json['totalPages'];
//     _currentPage = json['currentPage'];
//     _nextPage = json['nextPage'];
//     _prevPage = json['prevPage'];
//   }
//   int? _totalRecords;
//   int? _pageSize;
//   int? _totalPages;
//   int? _currentPage;
//   dynamic _nextPage;
//   dynamic _prevPage;
//
//   int? get totalRecords => _totalRecords;
//   int? get pageSize => _pageSize;
//   int? get totalPages => _totalPages;
//   int? get currentPage => _currentPage;
//   dynamic get nextPage => _nextPage;
//   dynamic get prevPage => _prevPage;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['totalRecords'] = _totalRecords;
//     map['pageSize'] = _pageSize;
//     map['totalPages'] = _totalPages;
//     map['currentPage'] = _currentPage;
//     map['nextPage'] = _nextPage;
//     map['prevPage'] = _prevPage;
//     return map;
//   }
//
// }
//
// class ClaimRecords {
//   ClaimRecords({
//       String? id,
//       String? opdDate,
//       String? docName,
//       String? docEmail,
//       String? docCountryCode,
//       int? docPhone,
//       String? claimId,
//       String? docRegistration,
//       String? pincode,
//       String? docAddress,
//       String? city,
//       String? diagonosisDetail,
//       int? doctorFee,
//       int? pharmacyFee,
//       int? labTestFee,
//       int? claimableDoctorFee,
//       int? claimablePharmacyFee,
//       int? claimableLabTestFee,
//       int? billAmount,
//       int? claimableAmount,
//       int? claimType,
//       int? claimCombination,
//       String? hospital,
//       String? userRemark,
//       List<String>? feeReceipt,
//       List<String>? prescription,
//       List<String>? pharmacyReceipt,
//       List<String>? testReceipt,
//       List<dynamic>? testReports,
//       int? status,
//       MemberId? memberId,
//       UserId? userId,
//       bool? subscriberReaction,
//       bool? resubmission,
//       bool? dispute,
//       List<SubscriberRemark>? subscriberRemark,
//       String? createdAt,
//       String? updatedAt,
//       int? v,
//       dynamic claimClosureDate,
//       dynamic disputeDetails,}){
//     _id = id;
//     _opdDate = opdDate;
//     _docName = docName;
//     _docEmail = docEmail;
//     _docCountryCode = docCountryCode;
//     _docPhone = docPhone;
//     _claimId = claimId;
//     _docRegistration = docRegistration;
//     _pincode = pincode;
//     _docAddress = docAddress;
//     _city = city;
//     _diagonosisDetail = diagonosisDetail;
//     _doctorFee = doctorFee;
//     _pharmacyFee = pharmacyFee;
//     _labTestFee = labTestFee;
//     _claimableDoctorFee = claimableDoctorFee;
//     _claimablePharmacyFee = claimablePharmacyFee;
//     _claimableLabTestFee = claimableLabTestFee;
//     _billAmount = billAmount;
//     _claimableAmount = claimableAmount;
//     _claimType = claimType;
//     _claimCombination = claimCombination;
//     _hospital = hospital;
//     _userRemark = userRemark;
//     _feeReceipt = feeReceipt;
//     _prescription = prescription;
//     _pharmacyReceipt = pharmacyReceipt;
//     _testReceipt = testReceipt;
//     _testReports = testReports;
//     _status = status;
//     _memberId = memberId;
//     _userId = userId;
//     _subscriberReaction = subscriberReaction;
//     _resubmission = resubmission;
//     _dispute = dispute;
//     _subscriberRemark = subscriberRemark;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _v = v;
//     _claimClosureDate = claimClosureDate;
//     _disputeDetails = disputeDetails;
// }
//
//   ClaimRecords.fromJson(dynamic json) {
//     _id = json['_id'];
//     _opdDate = json['opd_date'];
//     _docName = json['doc_name'];
//     _docEmail = json['doc_email'];
//     _docCountryCode = json['doc_country_code'];
//     _docPhone = json['doc_phone'];
//     _claimId = json['claim_id'];
//     _docRegistration = json['doc_registration'];
//     _pincode = json['pincode'];
//     _docAddress = json['doc_address'];
//     _city = json['city'];
//     _diagonosisDetail = json['diagonosis_detail'];
//     _doctorFee = json['doctor_fee'];
//     _pharmacyFee = json['pharmacy_fee'];
//     _labTestFee = json['lab_test_fee'];
//     _claimableDoctorFee = json['claimable_doctor_fee'];
//     _claimablePharmacyFee = json['claimable_pharmacy_fee'];
//     _claimableLabTestFee = json['claimable_lab_test_fee'];
//     _billAmount = json['bill_amount'];
//     _claimableAmount = json['claimable_amount'];
//     _claimType = json['claim_type'];
//     _claimCombination = json['claim_combination'];
//     _hospital = json['hospital'];
//     _userRemark = json['user_remark'];
//     _feeReceipt = json['fee_receipt'] != null ? json['fee_receipt'].cast<String>() : [];
//     _prescription = json['prescription'] != null ? json['prescription'].cast<String>() : [];
//     _pharmacyReceipt = json['pharmacy_receipt'] != null ? json['pharmacy_receipt'].cast<String>() : [];
//     _testReceipt = json['test_receipt'] != null ? json['test_receipt'].cast<String>() : [];
//     // if (json['test_reports'] != null) {
//     //   _testReports = [];
//     //   json['test_reports'].forEach((v) {
//     //     _testReports?.add(Dynamic.fromJson(v));
//     //   });
//     // }
//     _status = json['status'];
//     _memberId = json['member_id'] != null ? MemberId.fromJson(json['member_id']) : null;
//     _userId = json['user_id'] != null ? UserId.fromJson(json['user_id']) : null;
//     _subscriberReaction = json['subscriber_reaction'];
//     _resubmission = json['resubmission'];
//     _dispute = json['dispute'];
//     if (json['subscriber_remark'] != null) {
//       _subscriberRemark = [];
//       json['subscriber_remark'].forEach((v) {
//         _subscriberRemark?.add(SubscriberRemark.fromJson(v));
//       });
//     }
//     _createdAt = json['createdAt'];
//     _updatedAt = json['updatedAt'];
//     _v = json['__v'];
//     _claimClosureDate = json['claim_closure_Date'];
//     _disputeDetails = json['dispute_details'];
//   }
//   String? _id;
//   String? _opdDate;
//   String? _docName;
//   String? _docEmail;
//   String? _docCountryCode;
//   int? _docPhone;
//   String? _claimId;
//   String? _docRegistration;
//   String? _pincode;
//   String? _docAddress;
//   String? _city;
//   String? _diagonosisDetail;
//   int? _doctorFee;
//   int? _pharmacyFee;
//   int? _labTestFee;
//   int? _claimableDoctorFee;
//   int? _claimablePharmacyFee;
//   int? _claimableLabTestFee;
//   int? _billAmount;
//   int? _claimableAmount;
//   int? _claimType;
//   int? _claimCombination;
//   String? _hospital;
//   String? _userRemark;
//   List<String>? _feeReceipt;
//   List<String>? _prescription;
//   List<String>? _pharmacyReceipt;
//   List<String>? _testReceipt;
//   List<dynamic>? _testReports;
//   int? _status;
//   MemberId? _memberId;
//   UserId? _userId;
//   bool? _subscriberReaction;
//   bool? _resubmission;
//   bool? _dispute;
//   List<SubscriberRemark>? _subscriberRemark;
//   String? _createdAt;
//   String? _updatedAt;
//   int? _v;
//   dynamic _claimClosureDate;
//   dynamic _disputeDetails;
//
//   String? get id => _id;
//   String? get opdDate => _opdDate;
//   String? get docName => _docName;
//   String? get docEmail => _docEmail;
//   String? get docCountryCode => _docCountryCode;
//   int? get docPhone => _docPhone;
//   String? get claimId => _claimId;
//   String? get docRegistration => _docRegistration;
//   String? get pincode => _pincode;
//   String? get docAddress => _docAddress;
//   String? get city => _city;
//   String? get diagonosisDetail => _diagonosisDetail;
//   int? get doctorFee => _doctorFee;
//   int? get pharmacyFee => _pharmacyFee;
//   int? get labTestFee => _labTestFee;
//   int? get claimableDoctorFee => _claimableDoctorFee;
//   int? get claimablePharmacyFee => _claimablePharmacyFee;
//   int? get claimableLabTestFee => _claimableLabTestFee;
//   int? get billAmount => _billAmount;
//   int? get claimableAmount => _claimableAmount;
//   int? get claimType => _claimType;
//   int? get claimCombination => _claimCombination;
//   String? get hospital => _hospital;
//   String? get userRemark => _userRemark;
//   List<String>? get feeReceipt => _feeReceipt;
//   List<String>? get prescription => _prescription;
//   List<String>? get pharmacyReceipt => _pharmacyReceipt;
//   List<String>? get testReceipt => _testReceipt;
//   List<dynamic>? get testReports => _testReports;
//   int? get status => _status;
//   MemberId? get memberId => _memberId;
//   UserId? get userId => _userId;
//   bool? get subscriberReaction => _subscriberReaction;
//   bool? get resubmission => _resubmission;
//   bool? get dispute => _dispute;
//   List<SubscriberRemark>? get subscriberRemark => _subscriberRemark;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   int? get v => _v;
//   dynamic get claimClosureDate => _claimClosureDate;
//   dynamic get disputeDetails => _disputeDetails;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['opd_date'] = _opdDate;
//     map['doc_name'] = _docName;
//     map['doc_email'] = _docEmail;
//     map['doc_country_code'] = _docCountryCode;
//     map['doc_phone'] = _docPhone;
//     map['claim_id'] = _claimId;
//     map['doc_registration'] = _docRegistration;
//     map['pincode'] = _pincode;
//     map['doc_address'] = _docAddress;
//     map['city'] = _city;
//     map['diagonosis_detail'] = _diagonosisDetail;
//     map['doctor_fee'] = _doctorFee;
//     map['pharmacy_fee'] = _pharmacyFee;
//     map['lab_test_fee'] = _labTestFee;
//     map['claimable_doctor_fee'] = _claimableDoctorFee;
//     map['claimable_pharmacy_fee'] = _claimablePharmacyFee;
//     map['claimable_lab_test_fee'] = _claimableLabTestFee;
//     map['bill_amount'] = _billAmount;
//     map['claimable_amount'] = _claimableAmount;
//     map['claim_type'] = _claimType;
//     map['claim_combination'] = _claimCombination;
//     map['hospital'] = _hospital;
//     map['user_remark'] = _userRemark;
//     map['fee_receipt'] = _feeReceipt;
//     map['prescription'] = _prescription;
//     map['pharmacy_receipt'] = _pharmacyReceipt;
//     map['test_receipt'] = _testReceipt;
//     if (_testReports != null) {
//       map['test_reports'] = _testReports?.map((v) => v.toJson()).toList();
//     }
//     map['status'] = _status;
//     if (_memberId != null) {
//       map['member_id'] = _memberId?.toJson();
//     }
//     if (_userId != null) {
//       map['user_id'] = _userId?.toJson();
//     }
//     map['subscriber_reaction'] = _subscriberReaction;
//     map['resubmission'] = _resubmission;
//     map['dispute'] = _dispute;
//     if (_subscriberRemark != null) {
//       map['subscriber_remark'] = _subscriberRemark?.map((v) => v.toJson()).toList();
//     }
//     map['createdAt'] = _createdAt;
//     map['updatedAt'] = _updatedAt;
//     map['__v'] = _v;
//     map['claim_closure_Date'] = _claimClosureDate;
//     map['dispute_details'] = _disputeDetails;
//     return map;
//   }
//
// }
//
// class SubscriberRemark {
//   SubscriberRemark({
//       dynamic designation,
//       dynamic approverId,
//       String? message,
//       dynamic messageClaimInternalStatus,
//       String? id,
//       String? createdAt,}){
//     _designation = designation;
//     _approverId = approverId;
//     _message = message;
//     _messageClaimInternalStatus = messageClaimInternalStatus;
//     _id = id;
//     _createdAt = createdAt;
// }
//
//   SubscriberRemark.fromJson(dynamic json) {
//     _designation = json['designation'];
//     _approverId = json['approver_id'];
//     _message = json['message'];
//     _messageClaimInternalStatus = json['message_claim_internal_status'];
//     _id = json['_id'];
//     _createdAt = json['createdAt'];
//   }
//   dynamic _designation;
//   dynamic _approverId;
//   String? _message;
//   dynamic _messageClaimInternalStatus;
//   String? _id;
//   String? _createdAt;
//
//   dynamic get designation => _designation;
//   dynamic get approverId => _approverId;
//   String? get message => _message;
//   dynamic get messageClaimInternalStatus => _messageClaimInternalStatus;
//   String? get id => _id;
//   String? get createdAt => _createdAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['designation'] = _designation;
//     map['approver_id'] = _approverId;
//     map['message'] = _message;
//     map['message_claim_internal_status'] = _messageClaimInternalStatus;
//     map['_id'] = _id;
//     map['createdAt'] = _createdAt;
//     return map;
//   }
//
// }
//
// class UserId {
//   UserId({
//       String? id,
//       int? subscriberType,
//       String? email,
//       String? name,}){
//     _id = id;
//     _subscriberType = subscriberType;
//     _email = email;
//     _name = name;
// }
//
//   UserId.fromJson(dynamic json) {
//     _id = json['_id'];
//     _subscriberType = json['subscriber_type'];
//     _email = json['email'];
//     _name = json['name'];
//   }
//   String? _id;
//   int? _subscriberType;
//   String? _email;
//   String? _name;
//
//
//   String? get id => _id;
//   int? get subscriberType => _subscriberType;
//   String? get email => _email;
//   String? get name => _name;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['subscriber_type'] = _subscriberType;
//     map['email'] = _email;
//     map['name'] = _name;
//     return map;
//   }
//
// }
//
// class MemberId {
//   MemberId({
//       String? id,
//       String? name,
//       int? relation,}){
//     _id = id;
//     _name = name;
//     _relation = relation;
// }
//
//   MemberId.fromJson(dynamic json) {
//     _id = json['_id'];
//     _name = json['name'];
//     _relation = json['relation'];
//   }
//   String? _id;
//   String? _name;
//   int? _relation;
//
//   String? get id => _id;
//   String? get name => _name;
//   int? get relation => _relation;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['_id'] = _id;
//     map['name'] = _name;
//     map['relation'] = _relation;
//     return map;
//   }
//
// }