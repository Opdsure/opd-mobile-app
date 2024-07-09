import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:opdsure/model/fileUpload/file_upload_response.dart';
import 'package:opdsure/model/forget_password/forget_password_response.dart';
import 'package:opdsure/model/login/login_response.dart';
import 'package:opdsure/model/register/register_response.dart';
import 'package:opdsure/model/relation/relations.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';

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
    required String? password,
    required String? confirmPassword,
    String? countryCode,
    String? phone,
    required int? loginType,
    required bool? termAndCondition,
  }) async {
    final requestUri = Uri(path: 'api/v1/user/signup');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (loginType != null) 'key_type': loginType,
      if (emailAddress != null) 'email': emailAddress,
      if (password != null) 'password': password,
      if (confirmPassword != null) 'confirm_password': confirmPassword,
      if (countryCode != null) 'country_code': countryCode,
      if (phone != null) 'phone': phone,
      if (termAndCondition != null) 'terms_and_condition': termAndCondition
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return RegisterResponse.fromJson(json);
  }

  Future<LoginResponse> login(
      {String? emailAddress,
      String? password,
      String? phone,
      String? countryCode,
      int? loginType}) async {
    final requestUri = Uri(path: 'api/v1/user/login');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (emailAddress != null) 'email': emailAddress,
      if (password != null) 'password': password,
      if (phone != null) 'phone': phone,
      if (loginType != null) 'key_type': loginType,
      if (countryCode != null) 'country_code': countryCode
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return LoginResponse.fromJson(json);
  }

  Future<ForgetPasswordResponse> forgetPassword({String? email}) async {
    final requestUri = Uri(path: 'api/v1/user/forgotpassword');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (email != null) 'email': email,
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
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
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return LoginResponse.fromJson(json);
  }

  Future<UserProfile> getProfile() async {
    final requestUri = Uri(path: 'api/v1/user/get-profile');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return UserProfile.fromJson(json);
  }

  Future<PlansResponse?> getAllPlans() async {
    final requestUri = Uri(path: 'api/v1/public/plan');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return PlansResponse.fromJson(json);
  }

  Future getAllState() async {
    final requestUri = Uri(path: 'api/v1/public/get-states');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    // final json = jsonDecode(responseString);
    return responseString;
  }

  Future<UserProfile?> updateUserProfile({String? name, String? email, String? phone,}) async {
    final requestUri = Uri(path: 'api/v1/user/update-profile');
    final request = Request('PUT', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (name != null) 'name': name
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return UserProfile.fromJson(json);
  }

  Future addFamilyMember({String? name,
    String? relation,String? dob,String? gender, String? phone,String? countryCode,String? address,}) async {
    final requestUri = Uri(path: 'api/v1/user/add-member');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      "name": name,
      "relation": relation,
      "dob": dob,
      "gender": gender,
      "phone": phone,
      "country_code": countryCode,
      "address" : address
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future getFamilyMember() async {
    final requestUri = Uri(path: 'api/v1/user/get-members');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    // final json = jsonDecode(responseString);
    return responseString;
  }

  Future<Relations?> getRelation() async {
    final requestUri = Uri(path: 'api/v1/public/get-relations');
    baseUri ??= Uri.parse('https://dev.opdsure.net');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return Relations.fromJson(json);
  }

  Future getFileTypeAndSize() async {
    final requestUri = Uri(path: 'api/v1/public/get-file-size');
    baseUri ??= Uri.parse('https://dev.opdsure.net');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future fileAClaim(String jsonData) async {
    final requestUri = Uri(path: 'api/v1/user/add-claim');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonData);
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future<FileUploadResponse?> uploadFile({required List<http.MultipartFile> results}) async {
    final requestUri = Uri(path: 'api/v1/user/upload-file');
    final request =  http.MultipartRequest('POST', baseUri!.resolveUri(requestUri));
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.files.addAll(results);
    final response = await request.send();
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return FileUploadResponse.fromJson(json);
  }

  Future getAllClaims() async {
    final requestUri = Uri(path: 'api/v1/user/get-claims');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

}
