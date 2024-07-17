class SubscribedPlanModel {
  SubscribedPlanModel({
      Data? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  SubscribedPlanModel.fromJson(dynamic json) {
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
      MembershipOptions? membershipOptions, 
      List<dynamic>? files, 
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
    _claimCombination = claimCombination;
    _combinedLabPlusTestMaxDiscount = combinedLabPlusTestMaxDiscount;
    _combinedLabPlusTestPercent = combinedLabPlusTestPercent;
}

  Data.fromJson(dynamic json) {
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
    _membershipOptions = json['membership_options'] != null ? MembershipOptions.fromJson(json['membership_options']) : null;
    if (json['files'] != null) {
      _files = [];
      // json['files'].forEach((v) {
      //   _files?.add(Dynamic.fromJson(v));
      // });
    }
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
  MembershipOptions? _membershipOptions;
  List<dynamic>? _files;
  int? _claimCombination;
  dynamic _combinedLabPlusTestMaxDiscount;
  dynamic _combinedLabPlusTestPercent;

  String? get id => _id;
  String? get name => _name;
  int? get frequency => _frequency;
  int? get subscriberType => _subscriberType;
  int? get opdMaxDiscount => _opdMaxDiscount;
  int? get opdPrecentDiscount => _opdPrecentDiscount;
  int? get labMaxDiscount => _labMaxDiscount;
  int? get labPrecentDiscount => _labPrecentDiscount;
  int? get pharmacyMaxDiscount => _pharmacyMaxDiscount;
  int? get pharmacyPrecentDiscount => _pharmacyPrecentDiscount;
  List<PlanBenefits>? get planBenefits => _planBenefits;
  MembershipOptions? get membershipOptions => _membershipOptions;
  List<dynamic>? get files => _files;
  int? get claimCombination => _claimCombination;
  dynamic get combinedLabPlusTestMaxDiscount => _combinedLabPlusTestMaxDiscount;
  dynamic get combinedLabPlusTestPercent => _combinedLabPlusTestPercent;

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
      map['membership_options'] = _membershipOptions?.toJson();
    }
    if (_files != null) {
      map['files'] = _files?.map((v) => v.toJson()).toList();
    }
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

  int? get membershipId => _membershipId;
  String? get membershipLabel => _membershipLabel;
  int? get memberCount => _memberCount;
  int? get charges => _charges;
  int? get walletBalance => _walletBalance;

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

  String? get planLabel => _planLabel;
  String? get planFeature => _planFeature;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['plan_label'] = _planLabel;
    map['plan_feature'] = _planFeature;
    return map;
  }
}