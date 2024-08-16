class ReferralMember {
  ReferralMember({
      ReferralMemberData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  ReferralMember.fromJson(dynamic json) {
    _data = json['data'] != null ? ReferralMemberData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  ReferralMemberData? _data;
  bool? _success;
  String? _message;

  ReferralMemberData? get data => _data;
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

class ReferralMemberData {
  ReferralMemberData({
      List<ReferralMemberRecords>? records,
      Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
}

  ReferralMemberData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(ReferralMemberRecords.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<ReferralMemberRecords>? _records;
  Pagination? _pagination;

  List<ReferralMemberRecords>? get records {
    if(_records != null){
      return _records!.reversed.toList();
    }
    return [];
  }
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

  int? get totalRecords => _totalRecords;
  int? get pageSize => _pageSize;
  int? get totalPages => _totalPages;
  int? get currentPage => _currentPage;
  int? get nextPage => _nextPage;
  int? get prevPage => _prevPage;

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

class ReferralMemberRecords {
  ReferralMemberRecords({
      String? id, 
      UserId? userId, 
      String? referName, 
      String? referPhone, 
      String? referEmail, 
      bool? actionTaken, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _userId = userId;
    _referName = referName;
    _referPhone = referPhone;
    _referEmail = referEmail;
    _actionTaken = actionTaken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  ReferralMemberRecords.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['user_id'] != null ? UserId.fromJson(json['user_id']) : null;
    _referName = json['refer_name'];
    _referPhone = json['refer_phone'];
    _referEmail = json['refer_email'];
    _actionTaken = json['action_taken'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  UserId? _userId;
  String? _referName;
  String? _referPhone;
  String? _referEmail;
  bool? _actionTaken;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id ?? '';
  UserId? get userId => _userId ?? UserId();
  String? get referName => _referName ?? "";
  String? get referPhone => _referPhone ?? "";
  String? get referEmail => _referEmail ?? "";
  bool? get actionTaken => _actionTaken ?? false;
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_userId != null) {
      map['user_id'] = _userId?.toJson();
    }
    map['refer_name'] = _referName;
    map['refer_phone'] = _referPhone;
    map['refer_email'] = _referEmail;
    map['action_taken'] = _actionTaken;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

class UserId {
  UserId({
      String? id, 
      String? phone, 
      String? countryCode, 
      String? email, 
      String? name,}){
    _id = id;
    _phone = phone;
    _countryCode = countryCode;
    _email = email;
    _name = name;
}

  UserId.fromJson(dynamic json) {
    _id = json['_id'];
    _phone = json['phone'];
    _countryCode = json['country_code'];
    _email = json['email'];
    _name = json['name'];
  }
  String? _id;
  String? _phone;
  String? _countryCode;
  String? _email;
  String? _name;

  String? get id => _id ?? '';
  String? get phone => _phone ?? '';
  String? get countryCode => _countryCode ?? '';
  String? get email => _email ?? "";
  String? get name => _name ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['phone'] = _phone;
    map['country_code'] = _countryCode;
    map['email'] = _email;
    map['name'] = _name;
    return map;
  }

}