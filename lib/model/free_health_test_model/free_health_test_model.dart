/// data : {"records":[{"_id":"668d0a6285008b0162954189","name":"TSH","plan":"668d026685008b0162953fcf","details":"Thyriod test","createdAt":"2024-07-09T10:01:06.575Z","updatedAt":"2024-07-09T10:01:06.575Z","__v":0},{"_id":"668d0c1985008b016295421e","name":"Intech","plan":"668d026685008b0162953fcf","details":"Thyriod testing ","createdAt":"2024-07-09T10:08:25.037Z","updatedAt":"2024-07-09T10:08:25.037Z","__v":0}]}
/// success : true
/// message : "API executed successfully"

class FreeHealthTestModel {
  FreeHealthTestModel({
    FreeHealthTestData? data,
    bool? success,
    String? message,}){
    _data = data;
    _success = success;
    _message = message;
  }

  FreeHealthTestModel.fromJson(dynamic json) {
    _data = json['data'] != null ? FreeHealthTestData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  FreeHealthTestData? _data;
  bool? _success;
  String? _message;

  FreeHealthTestData? get data => _data ?? FreeHealthTestData();
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

/// records : [{"_id":"668d0a6285008b0162954189","name":"TSH","plan":"668d026685008b0162953fcf","details":"Thyriod test","createdAt":"2024-07-09T10:01:06.575Z","updatedAt":"2024-07-09T10:01:06.575Z","__v":0},{"_id":"668d0c1985008b016295421e","name":"Intech","plan":"668d026685008b0162953fcf","details":"Thyriod testing ","createdAt":"2024-07-09T10:08:25.037Z","updatedAt":"2024-07-09T10:08:25.037Z","__v":0}]

class FreeHealthTestData {
  FreeHealthTestData({
    List<FreeHealthTestRecords>? records,}){
    _records = records;
  }

  FreeHealthTestData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(FreeHealthTestRecords.fromJson(v));
      });
    }
  }
  List<FreeHealthTestRecords>? _records;

  List<FreeHealthTestRecords>? get records => _records ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_records != null) {
      map['records'] = _records?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "668d0a6285008b0162954189"
/// name : "TSH"
/// plan : "668d026685008b0162953fcf"
/// details : "Thyriod test"
/// createdAt : "2024-07-09T10:01:06.575Z"
/// updatedAt : "2024-07-09T10:01:06.575Z"
/// __v : 0

class FreeHealthTestRecords {
  FreeHealthTestRecords({
    String? id,
    String? name,
    String? plan,
    String? details,
    String? createdAt,
    String? updatedAt,
    int? v,}){
    _id = id;
    _name = name;
    _plan = plan;
    _details = details;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  FreeHealthTestRecords.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _plan = json['plan'];
    _details = json['details'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  String? _plan;
  String? _details;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id ?? '';
  String? get name => _name ?? "";
  String? get plan => _plan ?? '';
  String? get details => _details ?? "";
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['plan'] = _plan;
    map['details'] = _details;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}