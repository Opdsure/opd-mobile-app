// To parse this JSON data, do
//
//     final relationModel = relationModelFromJson(jsonString);

import 'dart:convert';

RelationModel relationModelFromJson(String str) => RelationModel.fromJson(json.decode(str));

String relationModelToJson(RelationModel data) => json.encode(data.toJson());

class RelationModel {
  Data data;
  bool success;
  String message;

  RelationModel({
    required this.data,
    required this.success,
    required this.message,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) => RelationModel(
    data: Data.fromJson(json["data"]),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "success": success,
    "message": message,
  };
}

class Data {
  int self;
  int father;
  int mother;
  int sister;
  int brother;
  int son;
  int daughter;
  int wife;
  int husband;
  int fatherInLaw;
  int motherInLaw;

  Data({
    required this.self,
    required this.father,
    required this.mother,
    required this.sister,
    required this.brother,
    required this.son,
    required this.daughter,
    required this.wife,
    required this.husband,
    required this.fatherInLaw,
    required this.motherInLaw,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    self: json["SELF"],
    father: json["FATHER"],
    mother: json["MOTHER"],
    sister: json["SISTER"],
    brother: json["BROTHER"],
    son: json["SON"],
    daughter: json["DAUGHTER"],
    wife: json["WIFE"],
    husband: json["HUSBAND"],
    fatherInLaw: json["FATHER_IN_LAW"],
    motherInLaw: json["MOTHER_IN_LAW"],
  );

  Map<String, dynamic> toJson() => {
    "SELF": self,
    "FATHER": father,
    "MOTHER": mother,
    "SISTER": sister,
    "BROTHER": brother,
    "SON": son,
    "DAUGHTER": daughter,
    "WIFE": wife,
    "HUSBAND": husband,
    "FATHER_IN_LAW": fatherInLaw,
    "MOTHER_IN_LAW": motherInLaw,
  };
}
