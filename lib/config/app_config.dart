import 'dart:ui';

abstract class AppConfig {
  static String _applicationName = 'OPD Sure';
  static String get applicationName => _applicationName;
  // static String _defaultBaseUrl = 'stage.opdsure.net';
  static String _defaultBaseUrl = 'opdsure-backend.onrender.com';
  static String get defaultBaseUrl => _defaultBaseUrl;
  static double fontSizeFactor = 01;
  static Color? colorSchemeSeed = primaryColor;
  static const Color primaryColor = Color(0xff233672);
  static const Color primaryColorLight = Color(0xFFebf3ff);
  static const Color secondaryColor = Color(0xFF41a2bc);
  static const Color roundedViewColor = Color(0xffffffff);
  static const double borderRadius = 18.0;
  static const String pharmaEasyUrl =
      "https://pharmeasy.in/online-medicine-order?utm_source=alz-finlyt&utm_medium=alliance&utm_campaign=finlyt-20april2022";
  static const String apolloPharmaUrl =
      "https://www.apollo247.com/lab-tests?lat=28.46527157578308&long=77.07399318571626";
  static const String apolloPharmaUrll =
      "https://www.apollopharmacy.in/?utm_source=HANA_Brand&utm_medium=Brand&utm_campaign=OPDSure_Pharma";
  static const String simplyfiyInsurenceUrl = "https://www.smcinsurance.com";

  void loadFromJson(Map<String, dynamic> json) {
    if (json['application_name'] is String) {
      _applicationName = json['application_name'];
    }
    if (json['default_baseurl'] is String) {
      _defaultBaseUrl = json['default_baseurl'];
    }
  }
}
