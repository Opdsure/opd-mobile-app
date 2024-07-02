import 'dart:async';

import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/repository/network_api/opd_api.dart';
import 'package:http/http.dart' as http;
import 'package:opdsure/utils/exception/exception.dart';
import 'package:opdsure/utils/http_timeout.dart';
import 'package:opdsure/utils/logs/logs.dart';
import 'package:opdsure/utils/run_banchmark.dart';
import 'package:opdsure/utils/streams/cached_stream_controller.dart';

import '../../model/forget_password/forget_password_response.dart';
import '../../model/login/login_response.dart';
import '../../model/register/register_response.dart';
import '../database_api/database_api.dart';

enum LoginState { loggedIn, loggedOut }

class OpdClient extends OpdApi {
  final String clientName;

  String? get userID => _userID;

  String? _userID;

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

  Future<void> init({String? userId, String? accessToken}) async {
    if ((userId != null || accessToken != null) &&
        (userId == null || accessToken == null)) {
      throw OpdClientInitPreconditionError(
        'If one of [userId, accessToken] is set then all of them must be set!',
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

      final clientBox = await _database?.getClient(clientName);

      if(clientBox != null){
        baseServerUri = Uri.parse(clientBox.baseServerUrl!);
        _userID = clientBox.userId!;
        this.accessToken = clientBox.accessToken!;
      }
      if(userId != null){
        baseServerUri = Uri.https(AppConfig.defaultBaseUrl);
        _userID = userId;
        this.accessToken = accessToken;
        await _database?.insertClient(Uri.https(AppConfig.defaultBaseUrl).toString(), accessToken!, userId);
      }else{
        baseServerUri = Uri.https(AppConfig.defaultBaseUrl);
        Logs().e('User is not logged in');
      }
    } on OpdClientInitException {
      rethrow;
    } catch (e, s) {
      Logs().e('OpdClient initialization failed', e, s);
    }
  }

  Future<void> clear() async {
    accessToken = null;
    baseServerUri = null;
    _userID = null;
    _database = null;
    _initLock = false;
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
      await init(accessToken: response.data!.token!, userId: "1");
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
      await init(accessToken: response.data!.token!, userId: '1');
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
  Future<LoginResponse> logout() async {
    try {
      final response = await super.logout();
      final clientBox = await _database?.getClient(clientName);
      if (clientBox != null) {
        clientBox.userId = null;
        clientBox.accessToken = null;
        _database?.updateClient(clientBox);
      }
      onLoginStateChanged.add(LoginState.loggedOut);
      return response;
    }catch (e){
      clear();
      final clientBox = await _database?.getClient(clientName);
      if (clientBox != null) {
        clientBox.userId = null;
        clientBox.accessToken = null;
        _database?.updateClient(clientBox);
      }
      onLoginStateChanged.add(LoginState.loggedOut);
      return LoginResponse();
    }

  }
}
