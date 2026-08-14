// Hospital API response model
// GET /api/v1/user/hospitals
// POST /api/v1/user/hospital

class HospitalListResponse {
  HospitalListResponse({
    HospitalListData? data,
    bool? success,
    String? message,
  }) {
    _data = data;
    _success = success;
    _message = message;
  }

  HospitalListResponse.fromJson(dynamic json) {
    _data = json['data'] != null
        ? HospitalListData.fromJson(json['data'])
        : null;
    _success = json['success'];
    _message = json['message'];
  }

  HospitalListData? _data;
  bool? _success;
  String? _message;

  HospitalListData? get data => _data;
  bool get success => _success ?? false;
  String get message => _message ?? '';

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

class HospitalListData {
  HospitalListData({
    List<HospitalRecord>? records,
    HospitalPagination? pagination,
  }) {
    _records = records;
    _pagination = pagination;
  }

  HospitalListData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(HospitalRecord.fromJson(v));
      });
    }
    if (json['pagination'] != null) {
      _pagination = HospitalPagination.fromJson(json['pagination']);
    }
  }

  List<HospitalRecord>? _records;
  HospitalPagination? _pagination;

  List<HospitalRecord> get records => _records ?? [];
  HospitalPagination? get pagination => _pagination;

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

class HospitalRecord {
  HospitalRecord({
    String? id,
    String? name,
    String? address,
    String? email,
    String? phone,
    String? countryCode,
    String? userId,
    int? status,
    String? rejectionReason,
    String? reviewedBy,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _address = address;
    _email = email;
    _phone = phone;
    _countryCode = countryCode;
    _userId = userId;
    _status = status;
    _rejectionReason = rejectionReason;
    _reviewedBy = reviewedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  HospitalRecord.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _address = json['address'];
    _email = json['email'];
    _phone = json['phone'];
    _countryCode = json['country_code'];
    _userId = json['user_id'];
    _status = json['status'];
    _rejectionReason = json['rejection_reason'];
    _reviewedBy = json['reviewed_by'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  String? _id;
  String? _name;
  String? _address;
  String? _email;
  String? _phone;
  String? _countryCode;
  String? _userId;
  int? _status;
  String? _rejectionReason;
  String? _reviewedBy;
  String? _createdAt;
  String? _updatedAt;

  String get id => _id ?? '';
  String get name => _name ?? '';
  String get address => _address ?? '';
  String get email => _email ?? '';
  String get phone => _phone ?? '';
  String get countryCode => _countryCode ?? '';
  String get userId => _userId ?? '';
  int get status => _status ?? 0;
  String get rejectionReason => _rejectionReason ?? '';
  String get reviewedBy => _reviewedBy ?? '';
  String get createdAt => _createdAt ?? '';
  String get updatedAt => _updatedAt ?? '';

  /// status 1 = Approved, status 0 = Pending/Rejected
  bool get isApproved => _status == 1;
  bool get isRejected => _status == 0 && _rejectionReason != null && _rejectionReason!.isNotEmpty;
  bool get isPending => _status == 0 && (_rejectionReason == null || _rejectionReason!.isEmpty);

  String get statusLabel {
    if (isApproved) return 'Approved';
    if (isRejected) return 'Rejected';
    return 'Pending';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['address'] = _address;
    map['email'] = _email;
    map['phone'] = _phone;
    map['country_code'] = _countryCode;
    map['user_id'] = _userId;
    map['status'] = _status;
    map['rejection_reason'] = _rejectionReason;
    map['reviewed_by'] = _reviewedBy;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

class HospitalPagination {
  HospitalPagination({
    int? totalRecords,
    int? pageSize,
    int? totalPages,
    int? currentPage,
  }) {
    _totalRecords = totalRecords;
    _pageSize = pageSize;
    _totalPages = totalPages;
    _currentPage = currentPage;
  }

  HospitalPagination.fromJson(dynamic json) {
    _totalRecords = json['totalRecords'];
    _pageSize = json['pageSize'];
    _totalPages = json['totalPages'];
    _currentPage = json['currentPage'];
  }

  int? _totalRecords;
  int? _pageSize;
  int? _totalPages;
  int? _currentPage;

  int get totalRecords => _totalRecords ?? 0;
  int get pageSize => _pageSize ?? 10;
  int get totalPages => _totalPages ?? 0;
  int get currentPage => _currentPage ?? 1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalRecords'] = _totalRecords;
    map['pageSize'] = _pageSize;
    map['totalPages'] = _totalPages;
    map['currentPage'] = _currentPage;
    return map;
  }
}

/// Response for POST /api/v1/user/hospital
class AddHospitalResponse {
  AddHospitalResponse({
    bool? success,
    String? message,
  }) {
    _success = success;
    _message = message;
  }

  AddHospitalResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
  }

  bool? _success;
  String? _message;

  bool get success => _success ?? false;
  String get message => _message ?? '';
}
