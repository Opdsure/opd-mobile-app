class AllCheckupModel {
  AllCheckupModel({
      AllCheckupData? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  AllCheckupModel.fromJson(dynamic json) {
    _data = json['data'] != null ? AllCheckupData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  AllCheckupData? _data;
  bool? _success;
  String? _message;

  AllCheckupData? get data => _data;
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

class AllCheckupData {
  AllCheckupData({
      List<AllCheckupRecords>? records,
      Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
}

  AllCheckupData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(AllCheckupRecords.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<AllCheckupRecords>? _records;
  Pagination? _pagination;

  List<AllCheckupRecords>? get records => _records;
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

class AllCheckupRecords {
  AllCheckupRecords({
      String? id, 
      String? healthCheckupId, 
      String? message, 
      List<int>? checkupFor, 
      String? userId, 
      String? memberId, 
      int? status, 
      String? createdAt, 
      String? updatedAt, 
      int? v, 
      MemberDetails? memberDetails,}){
    _id = id;
    _healthCheckupId = healthCheckupId;
    _message = message;
    _checkupFor = checkupFor;
    _userId = userId;
    _memberId = memberId;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _memberDetails = memberDetails;
}

  AllCheckupRecords.fromJson(dynamic json) {
    _id = json['_id'];
    _healthCheckupId = json['health_checkup_id'];
    _message = json['message'];
    _checkupFor = json['checkup_for'] != null ? json['checkup_for'].cast<int>() : [];
    _userId = json['user_id'];
    _memberId = json['member_id'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _memberDetails = json['member_details'] != null ? MemberDetails.fromJson(json['member_details']) : null;
  }
  String? _id;
  String? _healthCheckupId;
  String? _message;
  List<int>? _checkupFor;
  String? _userId;
  String? _memberId;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _v;
  MemberDetails? _memberDetails;

  String? get id => _id;
  String? get healthCheckupId => _healthCheckupId;
  String? get message => _message;
  List<int>? get checkupFor => _checkupFor;
  String? get userId => _userId;
  String? get memberId => _memberId;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;
  MemberDetails? get memberDetails => _memberDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['health_checkup_id'] = _healthCheckupId;
    map['message'] = _message;
    map['checkup_for'] = _checkupFor;
    map['user_id'] = _userId;
    map['member_id'] = _memberId;
    map['status'] = _status;
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
      String? id, 
      String? name, 
      int? phone, 
      String? countryCode, 
      int? gender, 
      String? dob, 
      String? userId, 
      String? address, 
      int? relation, 
      int? planStatus, 
      int? reviewStatus, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _name = name;
    _phone = phone;
    _countryCode = countryCode;
    _gender = gender;
    _dob = dob;
    _userId = userId;
    _address = address;
    _relation = relation;
    _planStatus = planStatus;
    _reviewStatus = reviewStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  MemberDetails.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _phone = json['phone'];
    _countryCode = json['country_code'];
    _gender = json['gender'];
    _dob = json['dob'];
    _userId = json['user_id'];
    _address = json['address'];
    _relation = json['relation'];
    _planStatus = json['plan_status'];
    _reviewStatus = json['review_status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  int? _phone;
  String? _countryCode;
  int? _gender;
  String? _dob;
  String? _userId;
  String? _address;
  int? _relation;
  int? _planStatus;
  int? _reviewStatus;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id;
  String? get name => _name;
  int? get phone => _phone;
  String? get countryCode => _countryCode;
  int? get gender => _gender;
  String? get dob => _dob;
  String? get userId => _userId;
  String? get address => _address;
  int? get relation => _relation;
  int? get planStatus => _planStatus;
  int? get reviewStatus => _reviewStatus;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['phone'] = _phone;
    map['country_code'] = _countryCode;
    map['gender'] = _gender;
    map['dob'] = _dob;
    map['user_id'] = _userId;
    map['address'] = _address;
    map['relation'] = _relation;
    map['plan_status'] = _planStatus;
    map['review_status'] = _reviewStatus;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}