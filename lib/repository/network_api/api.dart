import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:opdsure/model/claim/file_claim_response.dart';
import 'package:opdsure/model/fileUpload/file_upload_response.dart';
import 'package:opdsure/model/forget_password/forget_password_response.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/login/login_response.dart';
import 'package:opdsure/model/payment_models/create_order.dart';
import 'package:opdsure/model/register/register_response.dart';
import 'package:opdsure/model/relation/relations.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../config/app_config.dart';
import '../../model/my_member_model.dart';
import '../../model/plans/plans_response.dart';
import '../../model/subscribed_plan_model.dart';

class Api {
  Client httpClient;
  Uri? baseUri = Uri.https(AppConfig.defaultBaseUrl);
  String? bearerToken;
  bool isPlanBuy = false;

  Api({Client? httpClient, this.baseUri, this.bearerToken})
      : httpClient = httpClient ?? Client();

  Never unexpectedResponse(BaseResponse response, Uint8List body) {
    if (response.reasonPhrase == 'Conflict') {
      CommonMethods.showToast('Email or mobile already exist');
    } else if (response.reasonPhrase == 'Not Found') {
      CommonMethods.showToast('Email/Mobile or password is incorrect');
    }
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

  Future<SubscribedPlanModel> getSubscribedPlan() async {
    final requestUri = Uri(path: 'api/v1/user/get-subscribed-plan');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return SubscribedPlanModel.fromJson(json);
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

  Future<UserProfile?> updateUserProfile(
      {String? name,
      String? email,
      String? phone,
      String? dob,
      String? gender,
      String? address,
      String? city,
      String? pinCode,
      Map<String, dynamic>? plan}) async {
    final requestUri = Uri(path: 'api/v1/user/update-profile');
    final request = Request('PUT', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (name != null) 'name': name,
      if (plan != null) 'plan': plan,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (pinCode != null) 'pin_code': pinCode,
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return UserProfile.fromJson(json);
  }

  Future addFamilyMember({
    String? name,
    int? relation,
    String? dob,
    String? gender,
    String? phone,
    String? countryCode,
    String? address,
  }) async {
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
      "address": address
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future updateFamilyMember({
    String? name,
    int? relation,
    String? dob,
    String? gender,
    String? phone,
    String? countryCode,
    String? address,
    String? memberId,
    String? file,
  }) async {
    final requestUri = Uri(path: 'api/v1/user/request-update-member');
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
      "address": address,
      "member_id": memberId,
      "file": file,
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future<MyMemberModel?> getFamilyMember() async {
    final requestUri = Uri(path: 'api/v1/user/get-members');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return MyMemberModel.fromJson(json);
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
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future getHealthTest() async {
    final requestUri = Uri(path: 'api/v1/public/get-health-tests');
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
    // final json = jsonDecode(responseString);
    return responseString;
  }

  Future updateAClaim(String claimId, String jsonData) async {
    final requestUri = Uri(path: 'api/v1/user/edit-claim/$claimId');
    final request = Request('PATCH', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonData);
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200){
      // unexpectedResponse(response, responseBody);
      return utf8.decode(responseBody);
    }
    else{
      final responseString = utf8.decode(responseBody);
      final json = jsonDecode(responseString);
      return responseString;
    }

  }

  Future<FileUploadResponse?> uploadFile({required List<http.MultipartFile> results}) async {
    final requestUri = Uri(path: 'api/v1/user/upload-file');
    final request = http.MultipartRequest('POST', baseUri!.resolveUri(requestUri));
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

  Future getSingleClaims(String id) async {
    final requestUri = Uri.parse('api/v1/user/get-claim-details?id=$id');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future calculateClaimPrice(String type, double amount) async {
    final requestUri = Uri.parse(
        'api/v1/user/get-claimable-amount?parameter=$type&amount=$amount');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future<CreateOrder?> createOrder(
      {String? planId,
      int? membershipId,
      String? healthId,
      required int type}) async {
    final requestUri = Uri(path: 'api/v1/user/create-orders');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8
        .encode(jsonEncode({
      "order_for" : type,
      if(planId != null) "plan_id": planId,
      if(planId != null) "membership_id": membershipId,
      if(healthId != null) "health_id" : healthId
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return CreateOrder.fromJson(json);
  }

  Future<CreateOrder?> verifyOrder(
      String? orderId, String? paymentId, String? signature) async {
    final requestUri = Uri(path: 'api/v1/user/verify-payment');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": signature
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return CreateOrder.fromJson(json);
  }

  Future<HealthCheckupResponse?> getHealthCheckupPlan() async {
    final requestUri = Uri(path: 'api/v1/public/get-health-checkup-plans');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return HealthCheckupResponse.fromJson(json);
  }

  Future getTermsConditions(String type) async {
    final requestUri = Uri.parse('api/v1/public/get-terms-and-condition?TC_TYPE_ENUM=$type');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    // final json = jsonDecode(responseString);
    return responseString;
  }

  Future getAllCheckup() async {
    final requestUri = Uri.parse('api/v1/user/get-health-checkups');
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

  Future addHealthCheckup({
    String? memberId,
    List<int>? checkupFor,
    String? message,
  }) async {
    final requestUri = Uri(path: 'api/v1/user/add-health-checkup');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      "member_id": memberId,
      "checkup_for": checkupFor,
      "message": message
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

}
