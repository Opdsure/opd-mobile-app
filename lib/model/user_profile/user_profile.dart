import 'package:hive/hive.dart';

import '../database_type_key.dart';

part 'user_profile.g.dart';

@HiveType(typeId: DatabaseTypeKey.userBox)
class UserProfile {
  UserProfile({
    ProfileData? data,
    bool? success,
    String? message,
  }) {
    _data = data;
    _success = success;
    _message = message;
  }

  UserProfile.fromJson(dynamic json) {
    _data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }

  @HiveField(0)
  ProfileData? _data;
  @HiveField(1)
  bool? _success;
  @HiveField(2)
  String? _message;

  ProfileData? get data => _data ?? ProfileData();
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

@HiveType(typeId: DatabaseTypeKey.userData)
class ProfileData {
  ProfileData(
      {Verified? verified,
      Plan? plan,
      String? id,
      String? phone,
      String? email,
      dynamic state,
      String? city,
      dynamic pinCode,
      String? address,
      String? countryCode,
      dynamic gender,
      String? dob,
      String? organizationId,
      String? profileImage,
      String? name,
      dynamic walletBalance,
      dynamic firstPlanPurchase}) {
    _verified = verified;
    _plan = plan;
    _id = id;
    _phone = phone;
    _email = email;
    _state = state;
    _city = city;
    _pinCode = pinCode;
    _address = address;
    _countryCode = countryCode;
    _gender = gender;
    _dob = dob;
    _organizationId = organizationId;
    _profileImage = profileImage;
    _name = name;
    _walletBalance = walletBalance;
    _firstPlanPurchase = firstPlanPurchase;
  }

  ProfileData.fromJson(dynamic json) {
    _verified =
        json['verified'] != null ? Verified.fromJson(json['verified']) : null;
    _plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    _id = json['_id'];
    if (json['phone'] != null) {
      if (json['phone'].runtimeType is String) {
        _phone = json['phone'];
      } else {
        _phone = json['phone'].toString();
      }
    } else {
      _phone = json['phone'];
    }

    _email = json['email'];
    _state = json['state'];
    _city = json['city'];
    _pinCode = json['pin_code'];
    _address = json['address'];
    _countryCode = json['country_code'];
    _gender = json['gender'];
    _dob = json['dob'];
    _organizationId = json['organization_id'];
    _profileImage = json['profile_image'];
    _name = json['name'];
    _walletBalance = json['wallet_balance'];
    _firstPlanPurchase = json['first_plan_purchase'];
  }

  @HiveField(0)
  Verified? _verified;
  @HiveField(1)
  Plan? _plan;
  @HiveField(2)
  String? _id;
  @HiveField(3)
  String? _phone;
  @HiveField(4)
  String? _email;
  @HiveField(5)
  dynamic _state;
  @HiveField(6)
  String? _city;
  @HiveField(7)
  dynamic _pinCode;
  @HiveField(8)
  String? _address;
  @HiveField(9)
  String? _countryCode;
  @HiveField(10)
  dynamic _gender;
  @HiveField(11)
  String? _dob;
  @HiveField(12)
  String? _organizationId;
  @HiveField(13)
  String? _profileImage;
  @HiveField(14)
  String? _name;
  @HiveField(15)
  dynamic _walletBalance;
  @HiveField(16)
  dynamic _firstPlanPurchase;

  Verified? get verified => _verified ?? Verified();
  Plan? get plan => _plan ?? Plan();
  String? get id => _id ?? "";
  String? get phone => _phone ?? "";
  String? get email => _email ?? "";
  dynamic get state => _state ?? 0;
  String? get city => _city ?? "";
  dynamic get pinCode => _pinCode ?? 0;
  String? get address => _address ?? "";
  String? get countryCode => _countryCode ?? "";
  dynamic get gender => _gender ?? 0;
  String? get dob => _dob ?? "";
  String? get organizationId => _organizationId ?? "";
  String? get profileImage => _profileImage ?? "";
  String? get name => _name ?? "";
  dynamic get walletBalance => _walletBalance ?? 0;
  dynamic get firstPlanPurchase => _firstPlanPurchase ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_verified != null) {
      map['verified'] = _verified?.toJson();
    }
    if (_plan != null) {
      map['plan'] = _plan?.toJson();
    }
    map['_id'] = _id;
    map['phone'] = _phone;
    map['email'] = _email;
    map['state'] = _state;
    map['city'] = _city;
    map['pin_code'] = _pinCode;
    map['address'] = _address;
    map['country_code'] = _countryCode;
    map['gender'] = _gender;
    map['dob'] = _dob;
    map['organization_id'] = _organizationId;
    map['profile_image'] = _profileImage;
    map['name'] = _name;
    map['wallet_balance'] = _walletBalance;
    map['first_plan_purchase'] = _walletBalance;
    return map;
  }

  set verified(Verified? value) {
    _verified = value;
  }

  set plan(Plan? value) {
    _plan = value;
  }

  set id(String? value) {
    _id = value;
  }

  set phone(String? value) {
    _phone = value;
  }

  set email(String? value) {
    _email = value;
  }

  set state(dynamic value) {
    _state = value;
  }

  set city(String? value) {
    _city = value;
  }

  set pinCode(dynamic value) {
    _pinCode = value;
  }

  set address(String? value) {
    _address = value;
  }

  set countryCode(String? value) {
    _countryCode = value;
  }

  set gender(dynamic value) {
    _gender = value;
  }

  set dob(String? value) {
    _dob = value;
  }

  set organizationId(String? value) {
    _organizationId = value;
  }

  set profileImage(String? value) {
    _profileImage = value;
  }

  set name(String? value) {
    _name = value;
  }

  set walletBalance(dynamic value) {
    _walletBalance = value;
  }
}

@HiveType(typeId: DatabaseTypeKey.userPlan)
class Plan {
  Plan(
      {bool? purchased,
      String? id,
      dynamic membershipId,
      String? startDate,
      String? endDate,
      dynamic pricePaid}) {
    _purchased = purchased;
    _id = id;
    _membershipId = membershipId;
    _pricePaid = pricePaid;
    _startDate = startDate;
    _endDate = endDate;
  }

  Plan.fromJson(dynamic json) {
    _purchased = json['purchased'];
    // Backend may return 'id' as a populated object (Map) or a plain string ID
    if (json['id'] is Map<String, dynamic>) {
      _id = json['id']['_id']?.toString();
    } else {
      _id = json['id']?.toString();
    }
    _membershipId = json['membership_id'];
    _endDate = json['end_date']?.toString();
    _startDate = json['start_date']?.toString();
    _pricePaid = json['paid_price'];
  }
  @HiveField(0)
  bool? _purchased;
  @HiveField(1)
  String? _id;
  @HiveField(2)
  dynamic _membershipId;
  @HiveField(3)
  String? _startDate;
  @HiveField(4)
  String? _endDate;
  @HiveField(5)
  dynamic _pricePaid;

  bool? get purchased => _purchased ?? false;
  String? get id => _id ?? "";
  dynamic get membershipId => _membershipId ?? 0;
  dynamic get pricePaid => _pricePaid ?? 0;
  String? get startDate => _startDate ?? '';
  String? get endDate => _endDate ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['purchased'] = _purchased;
    map['id'] = _id;
    map['membership_id'] = _membershipId;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['paid_price'] = _pricePaid;
    return map;
  }
}

@HiveType(typeId: DatabaseTypeKey.userVerified)
class Verified {
  Verified({
    bool? email,
    bool? phone,
  }) {
    _email = email;
    _phone = phone;
  }

  Verified.fromJson(dynamic json) {
    _email = json['email'];
    _phone = json['phone'];
  }
  @HiveField(0)
  bool? _email;
  @HiveField(1)
  bool? _phone;

  bool? get email => _email ?? false;
  bool? get phone => _phone ?? false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['phone'] = _phone;
    return map;
  }
}
