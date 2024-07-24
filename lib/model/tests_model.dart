class TestsModel {
  TestsModel({
      TestsData? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  TestsModel.fromJson(dynamic json) {
    _data = json['data'] != null ? TestsData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  TestsData? _data;
  bool? _success;
  String? _message;

  TestsData? get data => _data;
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

class TestsData {
  TestsData({
      int? bloodsugar, 
      int? lipid, 
      int? fullbody,}){
    _bloodsugar = bloodsugar;
    _lipid = lipid;
    _fullbody = fullbody;
}

  TestsData.fromJson(dynamic json) {
    _bloodsugar = json['BLOOD_SUGAR'];
    _lipid = json['LIPID'];
    _fullbody = json['FULL_BODY'];
  }
  int? _bloodsugar;
  int? _lipid;
  int? _fullbody;

  int? get bloodsugar => _bloodsugar;
  int? get lipid => _lipid;
  int? get fullbody => _fullbody;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BLOOD_SUGAR'] = _bloodsugar;
    map['LIPID'] = _lipid;
    map['FULL_BODY'] = _fullbody;
    return map;
  }

}