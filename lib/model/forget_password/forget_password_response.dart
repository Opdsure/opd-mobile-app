class ForgetPasswordResponse {
  ForgetPasswordResponse({
      dynamic data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  ForgetPasswordResponse.fromJson(dynamic json) {
    _data = json['data'];
    _success = json['success'];
    _message = json['message'];
  }
  dynamic _data;
  bool? _success;
  String? _message;

  dynamic get data => _data;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = _data;
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}