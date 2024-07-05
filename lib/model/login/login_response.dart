class LoginResponse {
  LoginResponse({
      LoginData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  LoginResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  LoginData? _data;
  bool? _success;
  String? _message;

  LoginData? get data => _data;
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

class LoginData {
  LoginData({
      String? token,}){
    _token = token;
}

  LoginData.fromJson(dynamic json) {
    _token = json['token'];
  }
  String? _token;

  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    return map;
  }

}