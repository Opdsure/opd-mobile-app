/// data : {"records":[{"_id":"67175b2087020cdef7ad4395","health_checkup_id":"HCR000000292-0001","message":"dhrj","checkup_for":["668d0a6285008b0162954189","668d0c1985008b016295421e"],"user_id":"671643a187020cdef7ad29e6","member_id":"671643ae87020cdef7ad2a6c","status":0,"appointment":"2024-10-30T07:58:00.000Z","createdAt":"2024-10-22T07:58:24.189Z","updatedAt":"2024-10-22T07:58:24.189Z","__v":0,"member_details":{"_id":"671643ae87020cdef7ad2a6c","name":"sahil","phone":2207262816,"country_code":"+91","user_id":"671643a187020cdef7ad29e6","relation":0,"plan_status":1,"review_status":1,"createdAt":"2024-10-21T12:06:06.352Z","updatedAt":"2024-10-21T12:35:30.947Z","__v":0},"checkup_details":[{"_id":"668d0c1985008b016295421e","name":"Intech","plan":"668d026685008b0162953fcf","details":"Thyriod testing ","createdAt":"2024-07-09T10:08:25.037Z","updatedAt":"2024-07-09T10:08:25.037Z","__v":0},{"_id":"668d0a6285008b0162954189","name":"TSH","plan":"668d026685008b0162953fcf","details":"Thyriod test","createdAt":"2024-07-09T10:01:06.575Z","updatedAt":"2024-07-09T10:01:06.575Z","__v":0}]}],"pagination":{"totalRecords":1,"pageSize":10,"totalPages":1,"currentPage":1,"nextPage":null,"prevPage":null}}
/// success : true
/// message : "API executed successfully"

class FreeHealthCheckupsModel {
  FreeHealthCheckupsModel({
    FreeHealthCheckupData? data,
    bool? success,
    String? message,}){
    _data = data;
    _success = success;
    _message = message;
  }

  FreeHealthCheckupsModel.fromJson(dynamic json) {
    _data = json['data'] != null ? FreeHealthCheckupData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  FreeHealthCheckupData? _data;
  bool? _success;
  String? _message;

  FreeHealthCheckupData? get data => _data ?? FreeHealthCheckupData();
  bool? get success => _success ?? false;
  String? get message => _message ?? '';

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

/// records : [{"_id":"67175b2087020cdef7ad4395","health_checkup_id":"HCR000000292-0001","message":"dhrj","checkup_for":["668d0a6285008b0162954189","668d0c1985008b016295421e"],"user_id":"671643a187020cdef7ad29e6","member_id":"671643ae87020cdef7ad2a6c","status":0,"appointment":"2024-10-30T07:58:00.000Z","createdAt":"2024-10-22T07:58:24.189Z","updatedAt":"2024-10-22T07:58:24.189Z","__v":0,"member_details":{"_id":"671643ae87020cdef7ad2a6c","name":"sahil","phone":2207262816,"country_code":"+91","user_id":"671643a187020cdef7ad29e6","relation":0,"plan_status":1,"review_status":1,"createdAt":"2024-10-21T12:06:06.352Z","updatedAt":"2024-10-21T12:35:30.947Z","__v":0},"checkup_details":[{"_id":"668d0c1985008b016295421e","name":"Intech","plan":"668d026685008b0162953fcf","details":"Thyriod testing ","createdAt":"2024-07-09T10:08:25.037Z","updatedAt":"2024-07-09T10:08:25.037Z","__v":0},{"_id":"668d0a6285008b0162954189","name":"TSH","plan":"668d026685008b0162953fcf","details":"Thyriod test","createdAt":"2024-07-09T10:01:06.575Z","updatedAt":"2024-07-09T10:01:06.575Z","__v":0}]}]
/// pagination : {"totalRecords":1,"pageSize":10,"totalPages":1,"currentPage":1,"nextPage":null,"prevPage":null}

class FreeHealthCheckupData {
  FreeHealthCheckupData({
    List<FreeHealthCheckupRecords>? records,
    Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
  }

  FreeHealthCheckupData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(FreeHealthCheckupRecords.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<FreeHealthCheckupRecords>? _records;
  Pagination? _pagination;

  List<FreeHealthCheckupRecords>? get records => _records ?? [];
  Pagination? get pagination => _pagination ?? Pagination();

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

/// totalRecords : 1
/// pageSize : 10
/// totalPages : 1
/// currentPage : 1
/// nextPage : null
/// prevPage : null

class Pagination {
  Pagination({
    int? totalRecords,
    int? pageSize,
    int? totalPages,
    int? currentPage,
    int? nextPage,
    int? prevPage,}){
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
  int? _nextPage;
  int? _prevPage;

  int? get totalRecords => _totalRecords ?? 0;
  int? get pageSize => _pageSize ?? 0;
  int? get totalPages => _totalPages ?? 0;
  int? get currentPage => _currentPage ?? 0;
  int? get nextPage => _nextPage ?? 0;
  int? get prevPage => _prevPage ?? 0;

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

/// _id : "67175b2087020cdef7ad4395"
/// health_checkup_id : "HCR000000292-0001"
/// message : "dhrj"
/// checkup_for : ["668d0a6285008b0162954189","668d0c1985008b016295421e"]
/// user_id : "671643a187020cdef7ad29e6"
/// member_id : "671643ae87020cdef7ad2a6c"
/// status : 0
/// appointment : "2024-10-30T07:58:00.000Z"
/// createdAt : "2024-10-22T07:58:24.189Z"
/// updatedAt : "2024-10-22T07:58:24.189Z"
/// __v : 0
/// member_details : {"_id":"671643ae87020cdef7ad2a6c","name":"sahil","phone":2207262816,"country_code":"+91","user_id":"671643a187020cdef7ad29e6","relation":0,"plan_status":1,"review_status":1,"createdAt":"2024-10-21T12:06:06.352Z","updatedAt":"2024-10-21T12:35:30.947Z","__v":0}
/// checkup_details : [{"_id":"668d0c1985008b016295421e","name":"Intech","plan":"668d026685008b0162953fcf","details":"Thyriod testing ","createdAt":"2024-07-09T10:08:25.037Z","updatedAt":"2024-07-09T10:08:25.037Z","__v":0},{"_id":"668d0a6285008b0162954189","name":"TSH","plan":"668d026685008b0162953fcf","details":"Thyriod test","createdAt":"2024-07-09T10:01:06.575Z","updatedAt":"2024-07-09T10:01:06.575Z","__v":0}]

class FreeHealthCheckupRecords {
  FreeHealthCheckupRecords({
    String? id,
    String? healthCheckupId,
    String? message,
    List<String>? checkupFor,
    String? userId,
    String? memberId,
    int? status,
    String? appointment,
    String? createdAt,
    String? updatedAt,
    int? v,
    MemberDetails? memberDetails,
    List<CheckupDetails>? checkupDetails,}){
    _id = id;
    _healthCheckupId = healthCheckupId;
    _message = message;
    _checkupFor = checkupFor;
    _userId = userId;
    _memberId = memberId;
    _status = status;
    _appointment = appointment;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _memberDetails = memberDetails;
    _checkupDetails = checkupDetails;
  }

  FreeHealthCheckupRecords.fromJson(dynamic json) {
    _id = json['_id'];
    _healthCheckupId = json['health_checkup_id'];
    _message = json['message'];
    _checkupFor = json['checkup_for'] != null ? json['checkup_for'].cast<String>() : [];
    _userId = json['user_id'];
    _memberId = json['member_id'];
    _status = json['status'];
    _appointment = json['appointment'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _memberDetails = json['member_details'] != null ? MemberDetails.fromJson(json['member_details']) : null;
    if (json['checkup_details'] != null) {
      _checkupDetails = [];
      json['checkup_details'].forEach((v) {
        _checkupDetails?.add(CheckupDetails.fromJson(v));
      });
    }
  }
  String? _id;
  String? _healthCheckupId;
  String? _message;
  List<String>? _checkupFor;
  String? _userId;
  String? _memberId;
  int? _status;
  String? _appointment;
  String? _createdAt;
  String? _updatedAt;
  int? _v;
  MemberDetails? _memberDetails;
  List<CheckupDetails>? _checkupDetails;

  String? get id => _id ?? '';
  String? get healthCheckupId => _healthCheckupId ?? '';
  String? get message => _message ?? "";
  List<String>? get checkupFor => _checkupFor ?? [];
  String? get userId => _userId ?? "";
  String? get memberId => _memberId ?? "";
  int? get status => _status ?? 0;
  String? get appointment => _appointment ?? "";
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;
  MemberDetails? get memberDetails => _memberDetails ?? MemberDetails();
  List<CheckupDetails>? get checkupDetails => _checkupDetails ?? [];

  String get tests{
    String tests = '';
    if(checkupDetails!.isEmpty){
      return tests;
    }else{
      for(var i = 0; i <= checkupDetails!.length-1; i++ ){
        tests = '$tests${checkupDetails![i].name}${i == checkupDetails!.length-1 ? '' : ', '}';
      }
      return tests;
    }

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['health_checkup_id'] = _healthCheckupId;
    map['message'] = _message;
    map['checkup_for'] = _checkupFor;
    map['user_id'] = _userId;
    map['member_id'] = _memberId;
    map['status'] = _status;
    map['appointment'] = _appointment;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    if (_memberDetails != null) {
      map['member_details'] = _memberDetails?.toJson();
    }
    if (_checkupDetails != null) {
      map['checkup_details'] = _checkupDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "668d0c1985008b016295421e"
/// name : "Intech"
/// plan : "668d026685008b0162953fcf"
/// details : "Thyriod testing "
/// createdAt : "2024-07-09T10:08:25.037Z"
/// updatedAt : "2024-07-09T10:08:25.037Z"
/// __v : 0

class CheckupDetails {
  CheckupDetails({
    String? id,
    String? name,
    String? plan,
    String? details,
    String? createdAt,
    String? updatedAt,
    int? v,}){
    _id = id;
    _name = name;
    _plan = plan;
    _details = details;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  CheckupDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _plan = json['plan'];
    _details = json['details'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  String? _plan;
  String? _details;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id ?? "";
  String? get name => _name ?? "";
  String? get plan => _plan ?? "";
  String? get details => _details ?? "";
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['plan'] = _plan;
    map['details'] = _details;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

/// _id : "671643ae87020cdef7ad2a6c"
/// name : "sahil"
/// phone : 2207262816
/// country_code : "+91"
/// user_id : "671643a187020cdef7ad29e6"
/// relation : 0
/// plan_status : 1
/// review_status : 1
/// createdAt : "2024-10-21T12:06:06.352Z"
/// updatedAt : "2024-10-21T12:35:30.947Z"
/// __v : 0

class MemberDetails {
  MemberDetails({
    String? id,
    String? name,
    int? phone,
    String? countryCode,
    String? userId,
    int? relation,
    int? planStatus,
    int? reviewStatus,
    String? createdAt,
    String? updatedAt,
    String? address,
    int? gender,
    String? dateOfBirth,
    int? v,}){
    _id = id;
    _name = name;
    _phone = phone;
    _countryCode = countryCode;
    _userId = userId;
    _relation = relation;
    _planStatus = planStatus;
    _reviewStatus = reviewStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _address = address;
    _gender = gender;
    _dateOfBirth = dateOfBirth;
    _v = v;
  }

  MemberDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _phone = json['phone'];
    _countryCode = json['country_code'];
    _userId = json['user_id'];
    _relation = json['relation'];
    _planStatus = json['plan_status'];
    _reviewStatus = json['review_status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _gender = json['gender'];
    _address = json['address'];
    _dateOfBirth = json['dob'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  int? _phone;
  String? _countryCode;
  String? _userId;
  int? _relation;
  int? _planStatus;
  int? _reviewStatus;
  String? _createdAt;
  String? _updatedAt;
  String? _address;
  int? _gender;
  String? _dateOfBirth;
  int? _v;

  String? get id => _id ?? "";
  String? get name => _name ?? "";
  int? get phone => _phone ?? 0;
  String? get countryCode => _countryCode ?? "";
  String? get userId => _userId ?? "";
  int? get relation => _relation ?? 0;
  int? get planStatus => _planStatus ?? 0;
  int? get reviewStatus => _reviewStatus ?? 0;
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get gender => _gender ?? 0;
  String? get dateOfBirth => _dateOfBirth ?? "";
  String? get address => _address ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['phone'] = _phone;
    map['country_code'] = _countryCode;
    map['user_id'] = _userId;
    map['relation'] = _relation;
    map['plan_status'] = _planStatus;
    map['review_status'] = _reviewStatus;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['address'] = _address;
    map['dob'] = _dateOfBirth;
    map['gender'] = _gender;
    map['__v'] = _v;
    return map;
  }

}