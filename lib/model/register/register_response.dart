class RegisterResponse {
  RegisterResponse({
      RegisterData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  RegisterResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? RegisterData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  RegisterData? _data;
  bool? _success;
  String? _message;

  RegisterData? get data => _data;
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

class RegisterData {
  RegisterData({
      String? token,
  String? userId}){
    _token = token;
    _userId = userId;
}

  RegisterData.fromJson(dynamic json) {
    _token = json['token'];
    _userId = json['user_id'];
  }
  String? _token;
  String? _userId;

  String? get token => _token;
  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['user_id'] = _userId;
    return map;
  }

}