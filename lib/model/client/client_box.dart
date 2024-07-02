import 'package:hive/hive.dart';
part 'client_box.g.dart';

@HiveType(typeId: 1)
class ClientBox {
  ClientBox({
      String? baseServerUrl, 
      String? accessToken, 
      String? userId,}){
    _baseServerUrl = baseServerUrl;
    _accessToken = accessToken;
    _userId = userId;
}

  ClientBox.fromJson(dynamic json) {
    _baseServerUrl = json['base_server_url'];
    _accessToken = json['access_token'];
    _userId = json['user_id'];
  }
  @HiveField(0)
  String? _baseServerUrl;
  @HiveField(1)
  String? _accessToken;
  @HiveField(2)
  String? _userId;

  String? get baseServerUrl => _baseServerUrl ?? "";
  String? get accessToken => _accessToken ?? "";
  String? get userId => _userId ?? "";


  set baseServerUrl(String? value) {
    _baseServerUrl = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['base_server_url'] = _baseServerUrl;
    map['access_token'] = _accessToken;
    map['user_id'] = _userId;
    return map;
  }

  set accessToken(String? value) {
    _accessToken = value;
  }

  set userId(String? value) {
    _userId = value;
  }
}