import 'package:hive/hive.dart';
import 'package:opdsure/model/database_type_key.dart';

part 'plans_response.g.dart';

enum PlanType { individual, family, both }

@HiveType(typeId: DatabaseTypeKey.planBox)
class PlansResponse {
  PlansResponse({
    PlansData? data,
    bool? success,
    String? message,
  }) {
    _data = data;
    _success = success;
    _message = message;
  }

  PlansResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? PlansData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }

  @HiveField(0)
  PlansData? _data;
  @HiveField(1)
  bool? _success;
  @HiveField(2)
  String? _message;
  @HiveField(3)
  String? _error;

  PlansData? get data => _data ?? PlansData();

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

@HiveType(typeId: DatabaseTypeKey.planData)
class PlansData {
  PlansData({
    List<PlanRecords>? records,
    Pagination? pagination,
  }) {
    _records = records;
    _pagination = pagination;
  }

  PlansData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(PlanRecords.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  @HiveField(0)
  List<PlanRecords>? _records;
  @HiveField(1)
  Pagination? _pagination;

  List<PlanRecords>? get records {
    List<PlanRecords>? newRecords = _records ?? [];
    newRecords.sort((a, b) => a.membershipOptions![0].charges!.compareTo(b.membershipOptions![0].charges!));
    return newRecords;
  }

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

@HiveType(typeId: DatabaseTypeKey.planPagination)
class Pagination {
  Pagination({
    int? totalRecords,
    int? pageSize,
    int? totalPages,
    int? currentPage,
    int? nextPage,
    int? prevPage,
  }) {
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

  @HiveField(0)
  int? _totalRecords;
  @HiveField(1)
  int? _pageSize;
  @HiveField(2)
  int? _totalPages;
  @HiveField(3)
  int? _currentPage;
  @HiveField(4)
  int? _nextPage;
  @HiveField(5)
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

@HiveType(typeId: DatabaseTypeKey.planRecords)
class PlanRecords {
  PlanRecords({
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
  }) {
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
  }

  PlanRecords.fromJson(dynamic json) {
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
    _files = json['files'] != null ? json['files'].cast<String>() : [];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }

  @HiveField(0)
  String? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  int? _frequency;
  @HiveField(3)
  int? _subscriberType;
  @HiveField(4)
  int? _opdMaxDiscount;
  @HiveField(5)
  int? _opdPrecentDiscount;
  @HiveField(6)
  int? _labMaxDiscount;
  @HiveField(7)
  int? _labPrecentDiscount;
  @HiveField(8)
  int? _pharmacyMaxDiscount;
  @HiveField(9)
  int? _pharmacyPrecentDiscount;
  @HiveField(10)
  List<PlanBenefits>? _planBenefits;
  @HiveField(11)
  List<MembershipOptions>? _membershipOptions;
  @HiveField(12)
  List<String>? _files;
  @HiveField(13)
  String? _createdAt;
  @HiveField(14)
  String? _updatedAt;
  @HiveField(15)
  int? _v;

  String? get id => _id ?? "";

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

  List<MembershipOptions>? get membershipOptions {
    List<MembershipOptions>? membersOptions = _membershipOptions ?? [];
    membersOptions.removeWhere((v) => v.charges == 0 || v.walletBalance == 0);
    return membersOptions;
  }

  List<String>? get files => _files ?? [];

  String? get createdAt => _createdAt ?? "";

  String? get updatedAt => _updatedAt ?? "";

  int? get v => _v ?? 0;

  PlanType? get planType {
    if (_membershipOptions != null) {
      final firstOption = _membershipOptions![0];
      final isIndividual = (firstOption.charges != 0 || firstOption.walletBalance != 0) && firstOption._membershipLabel == 'Individual';
      final isFamilyList = _membershipOptions!.skip(1).toList();
      final isFamily = _isFamily(isFamilyList);
      if (isIndividual && !isFamily) {
        return PlanType.individual;
      }
      if (!isIndividual && isFamily) {
        return PlanType.family;
      }

      if (isIndividual && isFamily) {
        return PlanType.both;
      }
    }
    return PlanType.both;
  }

  //
  // set membershipOptions(List<MembershipOptions>? value) {
  //   _membershipOptions = value;
  // }

  bool _isFamily(List<MembershipOptions> options) {
    for (var option in options) {
      if (option.charges! == 0 || option.walletBalance! == 0) {
        continue;
      } else {
        return true;
      }
    }
    return false;
  }

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
      map['membership_options'] =
          _membershipOptions?.map((v) => v.toJson()).toList();
    }
    map['files'] = _files;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }
}

@HiveType(typeId: DatabaseTypeKey.membershipOptions)
class MembershipOptions {
  MembershipOptions({
    int? membershipId,
    String? membershipLabel,
    int? memberCount,
    int? charges,
    int? walletBalance,
  }) {
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

  @HiveField(0)
  int? _membershipId;
  @HiveField(1)
  String? _membershipLabel;
  @HiveField(2)
  int? _memberCount;
  @HiveField(3)
  int? _charges;
  @HiveField(4)
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

@HiveType(typeId: DatabaseTypeKey.plansBenefits)
class PlanBenefits {
  PlanBenefits({
    String? planLabel,
    String? planFeature,
  }) {
    _planLabel = planLabel;
    _planFeature = planFeature;
  }

  PlanBenefits.fromJson(dynamic json) {
    _planLabel = json['plan_label'];
    _planFeature = json['plan_feature'];
  }

  @HiveField(0)
  String? _planLabel;
  @HiveField(1)
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
