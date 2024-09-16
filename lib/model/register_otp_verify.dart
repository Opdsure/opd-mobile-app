class RegisterOtpVerify {
  RegisterOtpVerify({
      RegisterOtpData? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  RegisterOtpVerify.fromJson(dynamic json) {
    _data = json['data'] != null ? RegisterOtpData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  RegisterOtpData? _data;
  bool? _success;
  String? _message;

  RegisterOtpData? get data => _data ?? RegisterOtpData();
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

class RegisterOtpData {
  RegisterOtpData({
      bool? verified,}){
    _verified = verified;
}

  RegisterOtpData.fromJson(dynamic json) {
    _verified = json['verified'];
  }
  bool? _verified;

  bool? get verified => _verified ?? false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['verified'] = _verified;
    return map;
  }

}