import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:opdsure/model/forget_password/forget_password_response.dart';
import 'package:opdsure/model/login/login_response.dart';
import 'package:opdsure/model/register/register_response.dart';

import '../../config/app_config.dart';
import '../../model/plans/plans_response.dart';

class Api {
  Client httpClient;
  Uri? baseUri = Uri.https(AppConfig.defaultBaseUrl);
  String? bearerToken;
  bool isPlanBuy = false;

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
    final requestUri = Uri(path: 'api/v1/user/signup');
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

  Future<LoginResponse> login({String? emailAddress, String? password, String? phone}) async {
    final requestUri = Uri(path: 'api/v1/user/login');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if(emailAddress != null) 'email' : emailAddress,
      if(password != null) 'password' : password,
   //   if(phone != null) 'phone' : phone
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if(response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return LoginResponse.fromJson(json);
  }

  Future<ForgetPasswordResponse> forgetPassword({String? email}) async {
    final requestUri = Uri(path: 'api/v1/user/forgotpassword');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if(email != null) 'email' : email,
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if(response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return ForgetPasswordResponse.fromJson(json);
  }

  Future logout() async {
    final requestUri = Uri(path: 'api/v1/user/logout');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if(response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return LoginResponse.fromJson(json);
  }

  Future<PlansResponse?> getAllPlans() async {
    final requestUri = Uri(path: 'api/v1/public/plan');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if(response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return PlansResponse.fromJson(json);
  }
}
