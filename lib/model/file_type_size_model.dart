// To parse this JSON data, do
//
//     final fileTypeSizeModel = fileTypeSizeModelFromJson(jsonString);

import 'dart:convert';

FileTypeSizeModel fileTypeSizeModelFromJson(String str) => FileTypeSizeModel.fromJson(json.decode(str));

String fileTypeSizeModelToJson(FileTypeSizeModel data) => json.encode(data.toJson());

class FileTypeSizeModel {
  List<TypeSizeList> data;
  bool success;
  String message;

  FileTypeSizeModel({
    required this.data,
    required this.success,
    required this.message,
  });

  factory FileTypeSizeModel.fromJson(Map<String, dynamic> json) => FileTypeSizeModel(
    data: List<TypeSizeList>.from(json["data"].map((x) => TypeSizeList.fromJson(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "message": message,
  };
}

class TypeSizeList {
  String id;
  int docSize;
  String fileType;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  TypeSizeList({
    required this.id,
    required this.docSize,
    required this.fileType,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TypeSizeList.fromJson(Map<String, dynamic> json) => TypeSizeList(
    id: json["_id"],
    docSize: json["docSize"],
    fileType: json["file_type"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "docSize": docSize,
    "file_type": fileType,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
