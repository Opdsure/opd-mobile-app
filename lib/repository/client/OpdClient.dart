import 'dart:async';

import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/repository/network_api/opd_api.dart';
import 'package:http/http.dart' as http;
import 'package:opdsure/utils/exception/exception.dart';
import 'package:opdsure/utils/http_timeout.dart';
import 'package:opdsure/utils/logs/logs.dart';
import 'package:opdsure/utils/run_banchmark.dart';
import 'package:opdsure/utils/streams/cached_stream_controller.dart';

import '../../model/forget_password/forget_password_response.dart';
import '../../model/login/login_response.dart';
import '../../model/plans/plans_response.dart';
import '../../model/register/register_response.dart';
import '../database_api/database_api.dart';

enum LoginState { loggedIn, loggedOut }

class OpdClient extends OpdApi {
  int? _id;

  int? get id => _id;

  final String clientName;

  String? get userId => _userId;

  String? _userId;

  bool _initLock = false;

  final FutureOr<DatabaseApi> Function(OpdClient)? databaseBuilder;

  DatabaseApi? _database;

  DatabaseApi? get database => _database;

  final CachedStreamController<LoginState> onLoginStateChanged =
      CachedStreamController();

  OpdClient(
    this.clientName, {
    this.databaseBuilder,
    http.Client? httpClient,
    Duration defaultNetworkRequestTimeout = const Duration(seconds: 35),
  }) : super(
    baseServerUri: Uri.https(AppConfig.defaultBaseUrl),
          httpClient: FixedTimeoutHttpClient(
              httpClient ?? http.Client(), defaultNetworkRequestTimeout),
        );

  bool get isLogged => accessToken != null;


  Map<String, Map<String, String>> _accountData = {};

  Map<String, Map<String, String>> get accountData => _accountData;

  Future<void> init({String? newUserId, String? newAccessToken, bool? newIsPlanPurchased}) async {
    if ((newUserId != null || newAccessToken != null || newIsPlanPurchased != null) &&
        (newUserId == null || newAccessToken == null || newIsPlanPurchased == null)) {
      throw OpdClientInitPreconditionError(
        'If one of [userId, accessToken, isPlanPurchased] is set then all of them must be set!',
      );
    }

    if (_initLock) {
      throw OpdClientInitPreconditionError(
        '[init()] is call multiple times!',
      );
    }

    try {
      if (onLoginStateChanged.value == LoginState.loggedIn) {
        throw OpdClientInitPreconditionError(
          'User is already logged in! Call [logout()] first!',
        );
      }

      final databaseBuilder = this.databaseBuilder;
      if (databaseBuilder != null) {
        _database ??= await runBenchmarked(
          'Build database',
          () async => databaseBuilder(this),
        );
      }

      String? accessToken;
      String? userId;
      bool? isPlanPurchased;

      final clientBox = await this.database?.getClient(clientName);

      if(clientBox != null){
        userId = clientBox.userId;
        accessToken = clientBox.accessToken;
        isPlanPurchased = clientBox.isPlanPurchased;
      }
      if(newUserId != null){
        userId = _userId = newUserId;
        accessToken = this.accessToken = newAccessToken;
        isPlanPurchased = isPlanBuy = newIsPlanPurchased ?? false;
      }else{
        accessToken = this.accessToken = newAccessToken ?? accessToken;
        userId = _userId = newUserId ?? userId;
        isPlanPurchased = this.isPlanPurchased = newIsPlanPurchased ?? isPlanPurchased ?? false;
      }

      if(this.accessToken == null || this.userId == null){
        onLoginStateChanged.add(LoginState.loggedOut);
        Logs().e('User is not logged in.');
        _initLock = false;
        return;
      }

      final database = this.database;
      if(database != null){
        if(id != null){
          await database.updateClient(
            userId: userId,
            accessToken: accessToken,
            baseUri: baseServerUri.toString(),
            isPlanPurchased: isPlanPurchased
          );
        }else{
          _id = await database.insertClient(
              baseUri: baseServerUri.toString(),
              accessToken: accessToken,
              userId: userId,
            isPlanPurchased: isPlanPurchased
          );
        }
      }

      _initLock = false;
      onLoginStateChanged.add(LoginState.loggedIn);
      Logs().i('Successfully connected as $userId with ${baseServerUri.toString()}',);
    } on OpdClientInitException {
      rethrow;
    } catch (e, s) {
      await clear();
      _initLock = false;
      Logs().e('OpdClient initialization failed', e, s);
    }
  }

  Future<void> clear() async {
    accessToken = null;
    _userId = null;
    _initLock = false;
    _id = null;
  }

  @override
  Future<RegisterResponse> register(
      {String? emailAddress,
      String? password,
      String? confirmPassword,
      String? countryCode,
      String? phone,
      String? name,
      bool? termAndCondition}) async {
    if (baseServerUri == null) {
      throw Exception("No baseServerUri set");
    }
    final response = await  super.register(
        emailAddress: emailAddress,
        password: password,
        confirmPassword: confirmPassword,
        countryCode: countryCode,
        phone: phone,
        name: name,
        termAndCondition: termAndCondition);
    if(response.success!){
      await init(newAccessToken: response.data!.token!, newUserId: "1", newIsPlanPurchased: false);
    }

    if(response.data == null){
      throw Exception(response.toString());
    }

    return response;
  }


  @override
  Future<LoginResponse> login({String? emailAddress, String? password, String? phone}) async {
    if (baseServerUri == null) {
      throw Exception("No baseServerUri set");
    }
    final response = await super.login(emailAddress:emailAddress, password: password, phone: phone);

    if(response.success!){
      await init(newAccessToken: response.data!.token!, newUserId: '1', newIsPlanPurchased: false);
    }

    if(response.data == null){
      throw Exception(response.toJson());
    }

    return response;
  }

  @override
  Future<ForgetPasswordResponse> forgetPassword({String? email}) {
    return super.forgetPassword(email: email);
  }

  @override
  Future logout() async {
    if (baseServerUri == null) {
      throw Exception("No baseServerUri set");
    }
    try{
    final response = await super.logout();
    if(response.success!){
      await clear();
    }else{
      await clear();
    }
    }catch(e){
      await clear();
    }
   final database = this.database;
    if(database != null){
      database.deleteClient();
    }
    onLoginStateChanged.add(LoginState.loggedOut);
  }

  @override
  Future<PlansResponse?> getAllPlans() async {
    PlansResponse? plansResponse;
    final database = this.database;
    if(database != null){
      plansResponse = await database.getPlans();
      plansResponse ??= await super.getAllPlans();
      await database.updatePlans(plans: plansResponse);
    }else{
      plansResponse = await super.getAllPlans();

      final databaseBuilder = this.databaseBuilder;
      if (databaseBuilder != null) {
        _database ??= await runBenchmarked(
          'Build database',
              () async => databaseBuilder(this),
        );
      }
      final database = this.database;
      if(database != null) {
        await database.insertPlans(plans: plansResponse);
      }
    }
    return plansResponse;
  }

  @override
  Future<UserProfile> getProfile() async {
    UserProfile? userProfile;
    final database = this.database;
    if(database != null){
      userProfile = await database.getUserProfile();
      userProfile ??= await super.getProfile();
      await database.updateUserProfile(userProfile: userProfile);
    }else{
      userProfile = await super.getProfile();

      final databaseBuilder = this.databaseBuilder;
      if (databaseBuilder != null) {
        _database ??= await runBenchmarked(
          'Build database',
              () async => databaseBuilder(this),
        );
      }

      final database = this.database;
      if(database != null) {
        await database.insertUserProfile(userProfile: userProfile);
      }
    }
    return userProfile;
  }


  Future updatePlanPurchasedStatus(bool value) async {
    final database = this.database;
    if(database != null){
      isPlanPurchased = value;
      database.updatePlanPurchasedStatus(value);
    }
  }

}
