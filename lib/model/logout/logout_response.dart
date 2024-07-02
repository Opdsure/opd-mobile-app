class LogoutResponse {
  LogoutResponse({
      dynamic data, 
      bool? success, 
      String? message, 
      String? error,}){
    _data = data;
    _success = success;
    _message = message;
    _error = error;
}

  LogoutResponse.fromJson(dynamic json) {
    _data = json['data'];
    _success = json['success'];
    _message = json['message'];
    _error = json['error'];
  }
  dynamic _data;
  bool? _success;
  String? _message;
  String? _error;

  dynamic get data => _data;
  bool? get success => _success;
  String? get message => _message;
  String? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = _data;
    map['success'] = _success;
    map['message'] = _message;
    map['error'] = _error;
    return map;
  }

}