class QueuedPlans {
  QueuedPlans({
      QueuedPlanData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  QueuedPlans.fromJson(dynamic json) {
    _data = json['data'] != null ? QueuedPlanData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  QueuedPlanData? _data;
  bool? _success;
  String? _message;

  QueuedPlanData? get data => _data ?? QueuedPlanData();
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

class QueuedPlanData {
  QueuedPlanData({
      List<Records>? records, 
      Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
}

  QueuedPlanData.fromJson(dynamic json) {
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
      dynamic pageSize, 
      dynamic totalPages, 
      dynamic currentPage, 
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
  dynamic _pageSize;
  dynamic _totalPages;
  dynamic _currentPage;
  dynamic _nextPage;
  dynamic _prevPage;

  int? get totalRecords => _totalRecords ?? 0;
  dynamic get pageSize => _pageSize ?? 0;
  dynamic get totalPages => _totalPages ?? 0;
  dynamic get currentPage => _currentPage ?? 0;
  dynamic get nextPage => _nextPage ?? 0;
  dynamic get prevPage => _prevPage ?? 0;

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
      PlanId? planId, 
      int? membershipId, 
      String? userId, 
      bool? activated, 
      int? paidPrice, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _planId = planId;
    _membershipId = membershipId;
    _userId = userId;
    _activated = activated;
    _paidPrice = paidPrice;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Records.fromJson(dynamic json) {
    _id = json['_id'];
    _planId = json['plan_id'] != null ? PlanId.fromJson(json['plan_id']) : null;
    _membershipId = json['membership_id'];
    _userId = json['user_id'];
    _activated = json['activated'];
    _paidPrice = json['paid_price'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  PlanId? _planId;
  int? _membershipId;
  String? _userId;
  bool? _activated;
  int? _paidPrice;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id ?? '';
  PlanId? get planId => _planId ?? PlanId();
  int? get membershipId => _membershipId ?? 0;
  String? get userId => _userId ?? '';
  bool? get activated => _activated ?? false;
  int? get paidPrice => _paidPrice ?? 0;
  String? get createdAt => _createdAt ?? '';
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_planId != null) {
      map['plan_id'] = _planId?.toJson();
    }
    map['membership_id'] = _membershipId;
    map['user_id'] = _userId;
    map['activated'] = _activated;
    map['paid_price'] = _paidPrice;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}

class PlanId {
  PlanId({
      String? id, 
      String? name, 
      int? frequency, 
      int? subscriberType, 
      int? opdMaxDiscount, 
      int? opdPrecentDiscount, 
      int? labMaxDiscount, 
      int? labPrecentDiscount, 
      int? pharmacyMaxDiscount, 
      int? pharmacyPrecentDiscount, 
      List<PlanBenefits>? planBenefits, 
      List<MembershipOptions>? membershipOptions, 
      List<String>? files,
      String? createdAt, 
      String? updatedAt, 
      int? v, 
      int? claimCombination, 
      dynamic combinedLabPlusTestMaxDiscount, 
      dynamic combinedLabPlusTestPercent,}){
    _id = id;
    _name = name;
    _frequency = frequency;
    _subscriberType = subscriberType;
    _opdMaxDiscount = opdMaxDiscount;
    _opdPrecentDiscount = opdPrecentDiscount;
    _labMaxDiscount = labMaxDiscount;
    _labPrecentDiscount = labPrecentDiscount;
    _pharmacyMaxDiscount = pharmacyMaxDiscount;
    _pharmacyPrecentDiscount = pharmacyPrecentDiscount;
    _planBenefits = planBenefits;
    _membershipOptions = membershipOptions;
    _files = files;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _claimCombination = claimCombination;
    _combinedLabPlusTestMaxDiscount = combinedLabPlusTestMaxDiscount;
    _combinedLabPlusTestPercent = combinedLabPlusTestPercent;
}

  PlanId.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _frequency = json['frequency'];
    _subscriberType = json['subscriber_type'];
    _opdMaxDiscount = json['opd_max_discount'];
    _opdPrecentDiscount = json['opd_precent_discount'];
    _labMaxDiscount = json['lab_max_discount'];
    _labPrecentDiscount = json['lab_precent_discount'];
    _pharmacyMaxDiscount = json['pharmacy_max_discount'];
    _pharmacyPrecentDiscount = json['pharmacy_precent_discount'];
    if (json['plan_benefits'] != null) {
      _planBenefits = [];
      json['plan_benefits'].forEach((v) {
        _planBenefits?.add(PlanBenefits.fromJson(v));
      });
    }
    if (json['membership_options'] != null) {
      _membershipOptions = [];
      json['membership_options'].forEach((v) {
        _membershipOptions?.add(MembershipOptions.fromJson(v));
      });
    }
    if (json['files'] != null) {
      _files = [];
      json['files'].forEach((v) {
        _files?.add(v);
      });
    }
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _claimCombination = json['claim_combination'];
    _combinedLabPlusTestMaxDiscount = json['combined_lab_plus_test_max_discount'];
    _combinedLabPlusTestPercent = json['combined_lab_plus_test_percent'];
  }
  String? _id;
  String? _name;
  int? _frequency;
  int? _subscriberType;
  int? _opdMaxDiscount;
  int? _opdPrecentDiscount;
  int? _labMaxDiscount;
  int? _labPrecentDiscount;
  int? _pharmacyMaxDiscount;
  int? _pharmacyPrecentDiscount;
  List<PlanBenefits>? _planBenefits;
  List<MembershipOptions>? _membershipOptions;
  List<String>? _files;
  String? _createdAt;
  String? _updatedAt;
  int? _v;
  int? _claimCombination;
  dynamic _combinedLabPlusTestMaxDiscount;
  dynamic _combinedLabPlusTestPercent;

  String? get id => _id ?? '';
  String? get name => _name ?? "";
  int? get frequency => _frequency ?? 0;
  int? get subscriberType => _subscriberType ?? 0;
  int? get opdMaxDiscount => _opdMaxDiscount ?? 0;
  int? get opdPrecentDiscount => _opdPrecentDiscount ?? 0;
  int? get labMaxDiscount => _labMaxDiscount ?? 0;
  int? get labPrecentDiscount => _labPrecentDiscount ?? 0;
  int? get pharmacyMaxDiscount => _pharmacyMaxDiscount ?? 0;
  int? get pharmacyPrecentDiscount => _pharmacyPrecentDiscount ?? 0;
  List<PlanBenefits>? get planBenefits => _planBenefits ?? [];
  List<MembershipOptions>? get membershipOptions => _membershipOptions ?? [];
  List<String>? get files => _files ?? [];
  String? get createdAt => _createdAt ?? '';
  String? get updatedAt => _updatedAt ?? '';
  int? get v => _v ?? 0;
  int? get claimCombination => _claimCombination ?? 0;
  dynamic get combinedLabPlusTestMaxDiscount => _combinedLabPlusTestMaxDiscount ?? 0;
  dynamic get combinedLabPlusTestPercent => _combinedLabPlusTestPercent ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['frequency'] = _frequency;
    map['subscriber_type'] = _subscriberType;
    map['opd_max_discount'] = _opdMaxDiscount;
    map['opd_precent_discount'] = _opdPrecentDiscount;
    map['lab_max_discount'] = _labMaxDiscount;
    map['lab_precent_discount'] = _labPrecentDiscount;
    map['pharmacy_max_discount'] = _pharmacyMaxDiscount;
    map['pharmacy_precent_discount'] = _pharmacyPrecentDiscount;
    if (_planBenefits != null) {
      map['plan_benefits'] = _planBenefits?.map((v) => v.toJson()).toList();
    }
    if (_membershipOptions != null) {
      map['membership_options'] = _membershipOptions?.map((v) => v.toJson()).toList();
    }
    if (_files != null) {
      map['files'] = _files?.map((v) => v).toList();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['claim_combination'] = _claimCombination;
    map['combined_lab_plus_test_max_discount'] = _combinedLabPlusTestMaxDiscount;
    map['combined_lab_plus_test_percent'] = _combinedLabPlusTestPercent;
    return map;
  }

}

class MembershipOptions {
  MembershipOptions({
      int? membershipId, 
      String? membershipLabel, 
      int? memberCount, 
      int? charges, 
      int? walletBalance,}){
    _membershipId = membershipId;
    _membershipLabel = membershipLabel;
    _memberCount = memberCount;
    _charges = charges;
    _walletBalance = walletBalance;
}

  MembershipOptions.fromJson(dynamic json) {
    _membershipId = json['membership_id'];
    _membershipLabel = json['membership_label'];
    _memberCount = json['member_count'];
    _charges = json['charges'];
    _walletBalance = json['wallet_balance'];
  }
  int? _membershipId;
  String? _membershipLabel;
  int? _memberCount;
  int? _charges;
  int? _walletBalance;

  int? get membershipId => _membershipId ?? 0;
  String? get membershipLabel => _membershipLabel ?? "";
  int? get memberCount => _memberCount ?? 0;
  int? get charges => _charges ?? 0;
  int? get walletBalance => _walletBalance ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['membership_id'] = _membershipId;
    map['membership_label'] = _membershipLabel;
    map['member_count'] = _memberCount;
    map['charges'] = _charges;
    map['wallet_balance'] = _walletBalance;
    return map;
  }

}

class PlanBenefits {
  PlanBenefits({
      String? planLabel, 
      String? planFeature,}){
    _planLabel = planLabel;
    _planFeature = planFeature;
}

  PlanBenefits.fromJson(dynamic json) {
    _planLabel = json['plan_label'];
    _planFeature = json['plan_feature'];
  }
  String? _planLabel;
  String? _planFeature;

  String? get planLabel => _planLabel ?? "";
  String? get planFeature => _planFeature ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['plan_label'] = _planLabel;
    map['plan_feature'] = _planFeature;
    return map;
  }

}