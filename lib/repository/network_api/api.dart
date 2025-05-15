import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:opdsure/model/QueuedPlans/quequed_plans.dart';
import 'package:opdsure/model/buy_health_plan/buy_health_plan.dart';
import 'package:opdsure/model/fileUpload/file_upload_response.dart';
import 'package:opdsure/model/forget_password/forget_password_response.dart';
import 'package:opdsure/model/free_health_test_model/free_health_test_model.dart';
import 'package:opdsure/model/health_checkup/health_checkup.dart';
import 'package:opdsure/model/login/login_response.dart';
import 'package:opdsure/model/mFine/m_fine.dart';
import 'package:opdsure/model/notifications/notification_model.dart';
import 'package:opdsure/model/payment_models/create_order.dart';
import 'package:opdsure/model/referral_member/referral_member.dart';
import 'package:opdsure/model/register/register_response.dart';
import 'package:opdsure/model/relation/relations.dart';
import 'package:opdsure/model/specialization_model.dart';
import 'package:opdsure/model/transaction/transaction.dart';
import 'package:opdsure/model/update_member/update_member.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/checkout/checkout_controller.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../../config/app_config.dart';
import '../../model/free_health_checkups/free_health_checkups_model.dart';
import '../../model/my_claim/my_claims_model.dart';
import '../../model/my_member_model.dart';
import '../../model/plans/plans_response.dart';
import '../../model/register_otp_verify.dart';
import '../../model/subscribed_plan_model.dart';

class Api {
  Client httpClient;
  Uri? baseUri = Uri.https(AppConfig.defaultBaseUrl);
  String? bearerToken;
  bool isPlanBuy = false;

  Api({Client? httpClient, this.baseUri, this.bearerToken})
      : httpClient = httpClient ?? Client();

  Never unexpectedResponse(BaseResponse response, Uint8List body) {
    try {
      Map<String, dynamic> resMap = jsonDecode(utf8.decode(body));
      CommonMethods.showToast(resMap['message']);
    } catch (e) {
      throw Exception('http error response');
    }
    throw Exception('http error response');
  }

  Never bodySizeExceeded(int expected, int actual) {
    throw Exception('body size $actual exceeded $expected');
  }

  Uri _getCouponUri(PaymentType type, {String? planId, String? memberId, String? couponCode}) {
    switch (type) {
      case PaymentType.buyPlan:
        return Uri.parse(
            'api/v1/user/get-plan-price-details?order_for=${type.index}&coupon_code=$couponCode&plan_id=$planId&membership_id=$memberId');
      case PaymentType.buyHealthCheckup:
        return Uri.parse(
            'api/v1/user/get-plan-price-details?order_for=${type.index}&coupon_code=$couponCode&health_plan_id=$planId');
      case PaymentType.planUpgrade:
        return Uri.parse(
            'api/v1/user/get-upgrade-plan-price-details?order_for=${type.index}&coupon_code=$couponCode&plan_id=$planId&membership_id=$memberId');
      case PaymentType.planRenew:
        return Uri.parse(
            'api/v1/user/get-renew-plan-price-details?order_for=${type.index}&coupon_code=$couponCode&plan_id=$planId&membership_id=$memberId');
    }
  }

  Uri _getCreateOrderUri(PaymentType type) {
    switch (type) {
      case PaymentType.buyPlan:
        return Uri(path: 'api/v1/user/create-orders');
      case PaymentType.buyHealthCheckup:
        return Uri(path: 'api/v1/user/create-orders');
      case PaymentType.planUpgrade:
        return Uri(path: 'api/v1/user/create-plan-upgrade-orders');
      case PaymentType.planRenew:
        return Uri(path: 'api/v1/user/create-plan-renew-orders');
    }
  }

  Uri _getCollectionApi({String? healthPlanId}){
    if(healthPlanId != null){
      return Uri(path: 'api/v1/user/collection-details/$healthPlanId');
    }else{
      return Uri(path: 'api/v1/user/collection-details');
    }
  }

  Uri _getVerifyPaymentUri(PaymentType type) {
    switch (type) {
      case PaymentType.buyPlan:
        return Uri(path: 'api/v1/user/verify-payment');
      case PaymentType.buyHealthCheckup:
        return Uri(path: 'api/v1/user/verify-payment');
      case PaymentType.planUpgrade:
        return Uri(path: 'api/v1/user/verify-plan-upgrade-payment');
      case PaymentType.planRenew:
        return Uri(path: 'api/v1/user/verify-plan-renew-payment');
    }
  }

  Future<RegisterResponse> register({
    required String? countryCode,
    required String? phone,
    required int? loginType,
    required bool? termAndCondition,
  }) async {
    final requestUri = Uri(path: 'api/v1/user/signup');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      'key_type': loginType,
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

  Future<LoginResponse> login({int? otp,
      String? phone,
      String? countryCode,
      int loginType = 1}) async {
    final requestUri = Uri(path: 'api/v1/user/login');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (phone != null) 'phone': phone,
      'key_type': loginType,
      if (countryCode != null) 'country_code': countryCode,
      if (otp != null) 'otp': otp
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return LoginResponse.fromJson(json);
  }

  Future<LoginResponse> registerOtp(
      {String? phone, String? countryCode}) async {
    final requestUri = Uri(path: 'api/v1/user/signup-otp');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (phone != null) 'phone': phone,
      if (countryCode != null) 'country_code': countryCode
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return LoginResponse.fromJson(json);
  }

  Future<RegisterOtpVerify?> registerVerifyOtp(
      {String? phone,
      String? countryCode,
      int? otp}) async {
    final requestUri = Uri(path: 'api/v1/user/verify-signup-otp');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (phone != null) 'phone': phone,
      if (otp != null) 'otp': otp,
      if (countryCode != null) 'country_code': countryCode
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return RegisterOtpVerify.fromJson(json);
  }

  Future<LoginResponse> loginOtp(
      {String? phone,
      String? countryCode}) async {
    final requestUri = Uri(path: 'api/v1/user/login-otp');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode({
      if (phone != null) 'phone': phone,
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
    print("token $bearerToken");
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

  Future<PlansResponse?> getAllPlans({bool isUpgrade = false}) async {
    final Uri requestUri;
    if (isUpgrade) {
      requestUri = Uri(path: 'api/v1/user/upgrade-plan');
    } else {
      requestUri = Uri(path: 'api/v1/public/plan');
    }
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
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
      String? countryCode,
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
      if (countryCode != null) 'country_code': countryCode,
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

  Future<SpecializationModel?> getSpecialization() async {
    final requestUri = Uri(path: 'api/v1/public/specialization');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return SpecializationModel.fromJson(json);
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

  Future<FreeHealthTestModel?> getHealthTest() async {
    final requestUri = Uri(path: 'api/v1/user/get-free-health-tests');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.headers['content-type'] = 'application/json';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return FreeHealthTestModel.fromJson(json);
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
    if (response.statusCode != 200) {
      // unexpectedResponse(response, responseBody);
      return utf8.decode(responseBody);
    } else {
      final responseString = utf8.decode(responseBody);
      final json = jsonDecode(responseString);
      return responseString;
    }
  }

  Future<FileUploadResponse?> uploadFile(
      {required List<http.MultipartFile> results}) async {
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

  Future<MyClaimsModel?> getAllClaims() async {
    final requestUri = Uri(path: 'api/v1/user/get-claims');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return MyClaimsModel.fromJson(json);
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

  Future applyCoupon(String couponCode, String planId, String memberId,
      PaymentType type) async {
    Uri requestUri = _getCouponUri(type,
        couponCode: couponCode, planId: planId, memberId: memberId);
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
      String? healthPlanId,
      String? couponCode,
      required PaymentType type}) async {
    final requestUri = _getCreateOrderUri(type);
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      "order_for": type.index,
      if (planId != null) "plan_id": planId,
      if (planId != null) "membership_id": membershipId,
      if (healthPlanId != null) "health_plan_id": healthPlanId,
      if (couponCode != null) "coupon_code": couponCode
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return CreateOrder.fromJson(json);
  }

  Future<CreateOrder?> verifyOrder(PaymentType type, String? orderId,
      String? paymentId, String? signature) async {
    final requestUri = _getVerifyPaymentUri(type);
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
    final requestUri =
        Uri.parse('api/v1/public/get-terms-and-condition?TC_TYPE_ENUM=$type');
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
    List<String>? checkupFor,
    String? message,
    required String? appointmentDataTime,
  }) async {
    final requestUri = Uri(path: 'api/v1/user/add-health-checkup');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      "member_id": memberId,
      "checkup_for": checkupFor,
      "message": message,
      "appointment" : appointmentDataTime
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future addDispute(String? id,
      {String? userRemark, List<String>? allDocs}) async {
    final requestUri = Uri(path: 'api/v1/user/claim-dispute/$id');
    final request = Request('PATCH', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes =
        utf8.encode(jsonEncode({"user_remark": userRemark, "files": allDocs}));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future sendReferral({String? name, String? mobile, String? email}) async {
    final requestUri = Uri(path: 'api/v1/user/refer');
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode(
        {"refer_name": name, "refer_phone": mobile, "refer_email": email}));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    return responseString;
  }

  Future<QueuedPlans?> collectSampleCollectionData({required String patientName, required int age, required int gender, required String address, required int pinCode, required String appointment, String? healthPlanId}) async {
    final requestUri = _getCollectionApi(healthPlanId: healthPlanId);
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.bodyBytes = utf8.encode(jsonEncode({
      "patient_name" : patientName,
      "age" : age,
      "gender" : gender,
      "address" : address,
      "pincode" : pinCode,
      "appointment" : pinCode
    }));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return QueuedPlans.fromJson(json);
  }

  Future<QueuedPlans> getQueuedPlans() async {
    final requestUri = Uri(path: 'api/v1/user/get-queued-plans');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return QueuedPlans.fromJson(json);
  }

  Future<Transaction> getTransactions() async {
    final requestUri = Uri(path: 'api/v1/user/get-transactions');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return Transaction.fromJson(json);
  }

  Future<ReferralMember> getReferredUsers() async {
    final requestUri = Uri(path: 'api/v1/user/get-refered-users');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return ReferralMember.fromJson(json);
  }

  Future<BuyHealthPlan> getPurchasedHealtchekupPlans() async {
    final requestUri = Uri(path: 'api/v1/user/get-purchased-healtchekup-plans');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return BuyHealthPlan.fromJson(json);
  }

  Future<FreeHealthCheckupsModel?> getFreeHealthCheckup() async {
    final requestUri = Uri(path: 'api/v1/user/get-health-checkups');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return FreeHealthCheckupsModel.fromJson(json);
  }

  Future<UpdateMember> getRequestedMembers() async {
    final requestUri = Uri(path: 'api/v1/user/get-requested-members');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return UpdateMember.fromJson(json);
  }

  Future<NotificationModel> getNotifications() async {
    final requestUri = Uri(path: 'api/v1/user/notifications');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return NotificationModel.fromJson(json);
  }

  Future<NotificationModel> deleteNotifications(String notificationId) async {
    final requestUri = Uri(path: 'api/v1/user/notification/$notificationId');
    final request = Request('DELETE', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return NotificationModel.fromJson(json);
  }

  Future<MFine> mFine() async {
    final requestUri = Uri(path: 'api/v1/user/mfine');
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $bearerToken';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode != 200) unexpectedResponse(response, responseBody);
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return MFine.fromJson(json);
  }
}
