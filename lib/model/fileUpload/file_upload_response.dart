class FileUploadResponse {
  FileUploadResponse({
      List<String>? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  FileUploadResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? json['data'].cast<String>() : [];
    _success = json['success'];
    _message = json['message'];
  }
  List<String>? _data;
  bool? _success;
  String? _message;

  List<String>? get data => _data;
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