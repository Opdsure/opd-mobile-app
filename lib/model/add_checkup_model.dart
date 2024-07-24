class AddCheckupModel {
  AddCheckupModel({
      CheckUpData? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  AddCheckupModel.fromJson(dynamic json) {
    _data = json['data'] != null ? CheckUpData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  CheckUpData? _data;
  bool? _success;
  String? _message;

  CheckUpData? get data => _data;
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

class CheckUpData {
  CheckUpData({
      String? healthCheckupId, 
      String? message, 
      List<int>? checkupFor, 
      String? userId, 
      String? memberId, 
      int? status, 
      String? id, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _healthCheckupId = healthCheckupId;
    _message = message;
    _checkupFor = checkupFor;
    _userId = userId;
    _memberId = memberId;
    _status = status;
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  CheckUpData.fromJson(dynamic json) {
    _healthCheckupId = json['health_checkup_id'];
    _message = json['message'];
    _checkupFor = json['checkup_for'] != null ? json['checkup_for'].cast<int>() : [];
    _userId = json['user_id'];
    _memberId = json['member_id'];
    _status = json['status'];
    _id = json['_id'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _healthCheckupId;
  String? _message;
  List<int>? _checkupFor;
  String? _userId;
  String? _memberId;
  int? _status;
  String? _id;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get healthCheckupId => _healthCheckupId;
  String? get message => _message;
  List<int>? get checkupFor => _checkupFor;
  String? get userId => _userId;
  String? get memberId => _memberId;
  int? get status => _status;
  String? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['health_checkup_id'] = _healthCheckupId;
    map['message'] = _message;
    map['checkup_for'] = _checkupFor;
    map['user_id'] = _userId;
    map['member_id'] = _memberId;
    map['status'] = _status;
    map['_id'] = _id;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}