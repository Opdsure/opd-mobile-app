import 'package:hive/hive.dart';
import 'package:opdsure/model/database_type_key.dart';

part 'my_member_model.g.dart';


@HiveType(typeId: DatabaseTypeKey.familyMember)
class MyMemberModel {
  MyMemberModel({
      List<MemberList>? data,
      bool? success,
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  MyMemberModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MemberList.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
  }

  @HiveField(0)
  List<MemberList>? _data;
  @HiveField(1)
  bool? _success;
  @HiveField(2)
  String? _message;

  List<MemberList>? get data => _data ?? [];
  bool? get success => _success ?? false;
  String? get message => _message ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

@HiveType(typeId: DatabaseTypeKey.familyMemberData)
class MemberList {
  MemberList({
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

  MemberList.fromJson(dynamic json) {
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

  @HiveField(0)
  String? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  int? _phone;
  @HiveField(3)
  String? _countryCode;
  @HiveField(4)
  int? _gender;
  @HiveField(5)
  String? _dob;
  @HiveField(6)
  String? _userId;
  @HiveField(7)
  String? _address;
  @HiveField(8)
  int? _relation;
  @HiveField(9)
  int? _planStatus;
  @HiveField(10)
  int? _reviewStatus;
  @HiveField(11)
  String? _createdAt;
  @HiveField(12)
  String? _updatedAt;
  @HiveField(13)
  int? _v;

  String? get id => _id ?? '';
  String? get name => _name ?? '';
  int? get phone => _phone ?? 0;
  String? get countryCode => _countryCode ?? '';
  int? get gender => _gender;
  String? get dob => _dob ?? '';
  String? get userId => _userId ?? '';
  String? get address => _address ?? '';
  int? get relation => _relation ?? -1;
  int? get planStatus => _planStatus ?? -1;
  int? get reviewStatus => _reviewStatus ?? -1;
  String? get createdAt => _createdAt ?? '';
  String? get updatedAt => _updatedAt ?? '';
  int? get v => _v ?? 0;

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