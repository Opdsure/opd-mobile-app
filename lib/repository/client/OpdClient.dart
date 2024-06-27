import 'package:hive/hive.dart';
import 'package:opdsure/repository/network_api/opd_api.dart';
import 'package:http/http.dart' as http;
import 'package:opdsure/utils/http_timeout.dart';

import '../../model/register/RegisterResponse.dart';

enum LoginState {loggedIn, loggedOut}


class OpdClient extends OpdApi {
  final String clientName;

  String? get userID => _userID;

  String? _userID;



  OpdClient(
    this.clientName, {
    http.Client? httpClient,
    Duration defaultNetworkRequestTimeout = const Duration(seconds: 35),
  }) : super(
            httpClient: FixedTimeoutHttpClient(
                httpClient ?? http.Client(), defaultNetworkRequestTimeout));

  bool get isLogged => accessToken != null;

@override
  Future<RegisterResponse> register({
  String? emailAddress,
  String? password,
  String? confirmPassword,
  String? countryCode,
  String? phone,
  String? name,
  bool? termAndCondition}) {
    if(baseServerUri == null){
      throw Exception("No baseServerUri set");
    }
    return super.register(
        emailAddress : emailAddress,
        password : password,
        confirmPassword : confirmPassword,
        countryCode : countryCode,
        phone : phone,
        name : name,
        termAndCondition : termAndCondition
    );
  }
}
