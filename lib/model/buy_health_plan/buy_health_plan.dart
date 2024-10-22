class BuyHealthPlan {
  BuyHealthPlan({
      BuyHealthPlanData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  BuyHealthPlan.fromJson(dynamic json) {
    _data = json['data'] != null ? BuyHealthPlanData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  BuyHealthPlanData? _data;
  bool? _success;
  String? _message;

  BuyHealthPlanData? get data => _data ??  BuyHealthPlanData();
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

class BuyHealthPlanData {
  BuyHealthPlanData({
      List<BuyHealthPlanRecords>? records,
      Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
}

  BuyHealthPlanData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(BuyHealthPlanRecords.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<BuyHealthPlanRecords>? _records;
  Pagination? _pagination;

  List<BuyHealthPlanRecords>? get records => _records ?? [];
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

class BuyHealthPlanRecords {
  BuyHealthPlanRecords({
      String? id, 
      HealthPlan? healthPlan, 
      String? user, 
      bool? completed, 
      int? paidPrice, 
      bool? detailsSubmitted, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _healthPlan = healthPlan;
    _user = user;
    _completed = completed;
    _paidPrice = paidPrice;
    _detailsSubmitted = detailsSubmitted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  BuyHealthPlanRecords.fromJson(dynamic json) {
    _id = json['_id'];
    _healthPlan = json['health_plan'] != null ? HealthPlan.fromJson(json['health_plan']) : null;
    _user = json['user'];
    _completed = json['completed'];
    _paidPrice = json['paid_price'];
    _detailsSubmitted = json['details_submitted'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  HealthPlan? _healthPlan;
  String? _user;
  bool? _completed;
  int? _paidPrice;
  bool? _detailsSubmitted;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id ?? '';
  HealthPlan? get healthPlan => _healthPlan ?? HealthPlan();
  String? get user => _user ?? "";
  bool? get completed => _completed ?? false;
  int? get paidPrice => _paidPrice ?? 0;
  bool? get detailsSubmitted => _detailsSubmitted ?? false;
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_healthPlan != null) {
      map['health_plan'] = _healthPlan?.toJson();
    }
    map['user'] = _user;
    map['completed'] = _completed;
    map['paid_price'] = _paidPrice;
    map['details_submitted'] = _detailsSubmitted;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

class HealthPlan {
  HealthPlan({
      String? id, 
      String? name, 
      int? basePrice, 
      int? discountedPrice, 
      int? parameters, 
      List<TestDetails>? testDetails,}){
    _id = id;
    _name = name;
    _basePrice = basePrice;
    _discountedPrice = discountedPrice;
    _parameters = parameters;
    _testDetails = testDetails;
}

  HealthPlan.fromJson(dynamic json) {
    _id = json['_id'];
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
  }
  String? _id;
  String? _name;
  int? _basePrice;
  int? _discountedPrice;
  int? _parameters;
  List<TestDetails>? _testDetails;

  String? get id => _id ?? "";
  String? get name => _name ?? "";
  int? get basePrice => _basePrice ?? 0;
  int? get discountedPrice => _discountedPrice ?? 0;
  int? get parameters => _parameters ?? 0;
  List<TestDetails>? get testDetails => _testDetails ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['base_price'] = _basePrice;
    map['discounted_price'] = _discountedPrice;
    map['parameters'] = _parameters;
    if (_testDetails != null) {
      map['test_details'] = _testDetails?.map((v) => v.toJson()).toList();
    }
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