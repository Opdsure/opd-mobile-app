import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 6)
class UserProfile {
  UserProfile({
      ProfileData? data,
      bool? success, 
      String? message,}){
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

  ProfileData? get data => _data;
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

@HiveType(typeId: 7)
class ProfileData {
  ProfileData({
      String? id, 
      String? name, 
      String? email, 
      int? phone, 
      String? countryCode,}){
    _id = id;
    _name = name;
    _email = email;
    _phone = phone;
    _countryCode = countryCode;
}

  ProfileData.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _countryCode = json['country_code'];
  }
  @HiveField(0)
  String? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  String? _email;
  @HiveField(3)
  int? _phone;
  @HiveField(4)
  String? _countryCode;

  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  int? get phone => _phone;
  String? get countryCode => _countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone'] = _phone;
    map['country_code'] = _countryCode;
    return map;
  }

}