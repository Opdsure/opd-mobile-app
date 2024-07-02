class RegisterResponse {
  RegisterResponse({
      Data? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  RegisterResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  Data? _data;
  bool? _success;
  String? _message;

  Data? get data => _data;
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

class Data {
  Data({
      String? token,}){
    _token = token;
}

  Data.fromJson(dynamic json) {
    _token = json['token'];
  }
  String? _token;

  String? get token => _token ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    return map;
  }

}