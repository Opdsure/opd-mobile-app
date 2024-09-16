class MFine {
  MFine({
      MFineData? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  MFine.fromJson(dynamic json) {
    _data = json['data'] != null ? MFineData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  MFineData? _data;
  bool? _success;
  String? _message;

  MFineData? get data => _data ?? MFineData();
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

class MFineData {
  MFineData({
      String? redirectUrl, 
      String? userId,}){
    _redirectUrl = redirectUrl;
    _userId = userId;
}

  MFineData.fromJson(dynamic json) {
    _redirectUrl = json['redirect_url'];
    _userId = json['user_id'];
  }
  String? _redirectUrl;
  String? _userId;

  String? get redirectUrl => _redirectUrl ?? "";
  String? get userId => _userId ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['redirect_url'] = _redirectUrl;
    map['user_id'] = _userId;
    return map;
  }

}