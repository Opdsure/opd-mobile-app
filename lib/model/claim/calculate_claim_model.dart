class CalculateClaimModel {
  CalculateClaimModel({Data? data, bool? success, String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  CalculateClaimModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  Data? _data;
  bool? _success;
  String? _message;

  Data? get data => _data;
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

class Data {
  Data({
      int? finalPrice,}){
    _finalPrice = finalPrice;
}

  Data.fromJson(dynamic json) {
    _finalPrice = json['finalPrice'];
  }
  dynamic _finalPrice;

  dynamic get finalPrice => _finalPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['finalPrice'] = _finalPrice;
    return map;
  }

}