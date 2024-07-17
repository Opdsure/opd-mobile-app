import 'dart:ui';

abstract class AppConfig{
  static String _applicationName = 'OPD Sure';
  static String get applicationName => _applicationName;
  static String _defaultBaseUrl = 'stage.opdsure.net';
  static String get defaultBaseUrl => _defaultBaseUrl;
  static double fontSizeFactor = 1;
  static Color? colorSchemeSeed = primaryColor;
  static const Color primaryColor = Color(0xFF5625BA);
  static const Color primaryColorLight = Color(0xFFCCBDEA);
  static const Color secondaryColor = Color(0xFF41a2bc);
  static const double borderRadius = 18.0;


  void loadFromJson(Map<String, dynamic> json){
    if (json['application_name'] is String) {
      _applicationName = json['application_name'];
    }
    if (json['default_baseurl'] is String) {
      _defaultBaseUrl = json['default_baseurl'];
    }
  }
}