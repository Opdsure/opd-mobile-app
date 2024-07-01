import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:opdsure/model/register/RegisterResponse.dart';

class Api {
  Client httpClient;
  Uri? baseUri;
  String? bearerToken;

  Api({Client? httpClient, this.baseUri, this.bearerToken})
      : httpClient = httpClient ?? Client();

  Never unexpectedResponse(BaseResponse response, Uint8List body) {
    throw Exception('http error response');
  }

  Never bodySizeExceeded(int expected, int actual) {
    throw Exception('body size $actual exceeded $expected');
  }

  Future<RegisterResponse> register({
    String? emailAddress,
    String? password,
    String? confirmPassword,
    String? countryCode,
    String? phone,
    String? name,
    bool? termAndCondition,
  }) async {
    final requestUri = Uri(path: 'api/v1/user/register');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if(emailAddress != null) 'email' : emailAddress,
      if(password != null) 'password' : password,
      if(confirmPassword != null) 'confirm_password' : confirmPassword,
      if(countryCode != null) 'country_code' : countryCode,
      if(phone != null) 'phone' : phone,
      if(name != null) 'name' : name,
      if(termAndCondition != null) 'terms_and_condition' : termAndCondition
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if(response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return RegisterResponse.fromJson(json);
  }
}
