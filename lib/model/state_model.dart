// To parse this JSON data, do
//
//     final statemodel = statemodelFromJson(jsonString);

import 'dart:convert';

StateModel statemodelFromJson(String str) => StateModel.fromJson(json.decode(str));

String statemodelToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
  List<StateListData> data;
  bool success;
  String message;

  StateModel({
    required this.data,
    required this.success,
    required this.message,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    data: List<StateListData>.from(json["data"].map((x) => StateListData.fromJson(x))),
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "message": message,
  };
}

class StateListData {
  int id;
  String abb;
  String name;
  String state;

  StateListData({
    required this.id,
    required this.abb,
    required this.name,
    required this.state,
  });

  factory StateListData.fromJson(Map<String, dynamic> json) => StateListData(
    id: json["id"],
    abb: json["abb"],
    name: json["name"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "abb": abb,
    "name": name,
    "state": state,
  };
}
