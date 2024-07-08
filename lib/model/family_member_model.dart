// To parse this JSON data, do
//
//     final familyMemberModel = familyMemberModelFromJson(jsonString);

import 'dart:convert';

FamilyMemberModel familyMemberModelFromJson(String str) => FamilyMemberModel.fromJson(json.decode(str));

String familyMemberModelToJson(FamilyMemberModel data) => json.encode(data.toJson());

class FamilyMemberModel {
  List<FamilyMemberListData> data;
  bool success;
  String message;

  FamilyMemberModel({
    required this.data,
    required this.success,
    required this.message,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) => FamilyMemberModel(
    data: List<FamilyMemberListData>.from(json["data"].map((x) => FamilyMemberListData.fromJson(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "message": message,
  };
}

class FamilyMemberListData {
  String id;
  String name;
  int phone;
  String countryCode;
  int gender;
  String dob;
  String userId;
  String address;
  int relation;
  int planStatus;
  int reviewStatus;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  FamilyMemberListData({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryCode,
    required this.gender,
    required this.dob,
    required this.userId,
    required this.address,
    required this.relation,
    required this.planStatus,
    required this.reviewStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory FamilyMemberListData.fromJson(Map<String, dynamic> json) => FamilyMemberListData(
    id: json["_id"],
    name: json["name"],
    phone: json["phone"],
    countryCode: json["country_code"],
    gender: json["gender"],
    dob: json["dob"],
    userId: json["user_id"],
    address: json["address"],
    relation: json["relation"],
    planStatus: json["plan_status"],
    reviewStatus: json["review_status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "phone": phone,
    "country_code": countryCode,
    "gender": gender,
    "dob": dob,
    "user_id": userId,
    "address": address,
    "relation": relation,
    "plan_status": planStatus,
    "review_status": reviewStatus,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
