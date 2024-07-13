class HealthCheckup {
  HealthCheckup({
      HealthCheckUpData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  HealthCheckup.fromJson(dynamic json) {
    _data = json['data'] != null ? HealthCheckUpData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  HealthCheckUpData? _data;
  bool? _success;
  String? _message;

  HealthCheckUpData? get data => _data ?? HealthCheckUpData();
  bool? get success => _success ?? false;
  String? get message => _message ?? "";

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

class HealthCheckUpData {
  HealthCheckUpData({
      List<Records>? records, 
      Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
}

  HealthCheckUpData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(Records.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<Records>? _records;
  Pagination? _pagination;

  List<Records>? get records => _records ?? [];
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

class Records {
  Records({
      String? id, 
      String? checkupCode, 
      String? name, 
      int? basePrice, 
      int? discountedPrice, 
      int? parameters, 
      List<TestDetails>? testDetails, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _checkupCode = checkupCode;
    _name = name;
    _basePrice = basePrice;
    _discountedPrice = discountedPrice;
    _parameters = parameters;
    _testDetails = testDetails;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Records.fromJson(dynamic json) {
    _id = json['_id'];
    _checkupCode = json['checkup_code'];
    _name = json['name'];
    _basePrice = json['base_price'];
    _discountedPrice = json['discounted_price'];
    _parameters = json['parameters'];
    if (json['test_details'] != null) {
      _testDetails = [];
      json['test_details'].forEach((v) {
        _testDetails?.add(TestDetails.fromJson(v));
      });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _checkupCode;
  String? _name;
  int? _basePrice;
  int? _discountedPrice;
  int? _parameters;
  List<TestDetails>? _testDetails;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id ?? "";
  String? get checkupCode => _checkupCode ?? "";
  String? get name => _name ?? 'Test';
  int? get basePrice => _basePrice ?? 0;
  int? get discountedPrice => _discountedPrice ?? 0;
  int? get parameters => _parameters ?? 0;
  List<TestDetails>? get testDetails => _testDetails ?? [];
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['checkup_code'] = _checkupCode;
    map['name'] = _name;
    map['base_price'] = _basePrice;
    map['discounted_price'] = _discountedPrice;
    map['parameters'] = _parameters;
    if (_testDetails != null) {
      map['test_details'] = _testDetails?.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

class TestDetails {
  TestDetails({
      String? testsName, 
      String? subParameter, 
      int? subParameterCount,}){
    _testsName = testsName;
    _subParameter = subParameter;
    _subParameterCount = subParameterCount;
}

  TestDetails.fromJson(dynamic json) {
    _testsName = json['tests_name'];
    _subParameter = json['sub_parameter'];
    _subParameterCount = json['sub_parameter_count'];
  }
  String? _testsName;
  String? _subParameter;
  int? _subParameterCount;

  String? get testsName => _testsName ?? "";
  String? get subParameter => _subParameter ?? "";
  int? get subParameterCount => _subParameterCount ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tests_name'] = _testsName;
    map['sub_parameter'] = _subParameter;
    map['sub_parameter_count'] = _subParameterCount;
    return map;
  }

}