class NotificationModel {
  NotificationModel({
      NotificationsData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  NotificationModel.fromJson(dynamic json) {
    _data = json['data'] != null ? NotificationsData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  NotificationsData? _data;
  bool? _success;
  String? _message;

  NotificationsData? get data => _data;
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

class NotificationsData {
  NotificationsData({
      List<NotificationRecords>? records,}){
    _records = records;
}

  NotificationsData.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(NotificationRecords.fromJson(v));
      });
    }
  }
  List<NotificationRecords>? _records;

  List<NotificationRecords>? get records => _records;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_records != null) {
      map['records'] = _records?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class NotificationRecords {
  NotificationRecords({
      String? id, 
      String? message, 
      String? createdAt,}){
    _id = id;
    _message = message;
    _createdAt = createdAt;
}

  NotificationRecords.fromJson(dynamic json) {
    _id = json['_id'];
    _message = json['message'];
    _createdAt = json['createdAt'];
  }
  String? _id;
  String? _message;
  String? _createdAt;

  String? get id => _id;
  String? get message => _message;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['message'] = _message;
    map['createdAt'] = _createdAt;
    return map;
  }

}