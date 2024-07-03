import 'package:hive/hive.dart';
import 'package:opdsure/config/app_config.dart';

part 'client_box.g.dart';

@HiveType(typeId: 1)
class ClientBox {
  ClientBox(
      {String? baseServerUrl,
      String? accessToken,
      String? userId,
      int? id,
      bool? isPlanPurchased}) {
    _baseServerUrl = baseServerUrl;
    _accessToken = accessToken;
    _userId = userId;
    _id = id;
    _isPlanPurchased = isPlanPurchased;
  }

  ClientBox.fromJson(dynamic json) {
    _baseServerUrl = json['base_server_url'];
    _accessToken = json['access_token'];
    _userId = json['user_id'];
    _id = json['id'];
    _isPlanPurchased = json['isPlanPurchased'];
  }

  @HiveField(0)
  String? _baseServerUrl;
  @HiveField(1)
  String? _accessToken;
  @HiveField(2)
  String? _userId;
  @HiveField(3)
  int? _id;
  @HiveField(4)
  bool? _isPlanPurchased;

  String? get baseServerUrl => _baseServerUrl ?? AppConfig.defaultBaseUrl;

  String? get accessToken => _accessToken;

  String? get userId => _userId;

  int? get id => _id;

  bool? get isPlanPurchased => _isPlanPurchased ?? false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['base_server_url'] = _baseServerUrl;
    map['access_token'] = _accessToken;
    map['user_id'] = _userId;
    map['id'] = _id;
    map['isPlanPurchased'] = _isPlanPurchased;
    return map;
  }

  set baseServerUrl(String? value) {
    _baseServerUrl = value;
  }

  set accessToken(String? value) {
    _accessToken = value;
  }

  set userId(String? value) {
    _userId = value;
  }

  set id(int? value) {
    _id = value;
  }

  set isPlanPurchased(bool? value) {
    _isPlanPurchased = value ?? false;
  }
}
