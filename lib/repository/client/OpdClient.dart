import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mime/mime.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/model/fileUpload/file_upload_response.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/relation/relations.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/repository/network_api/opd_api.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

typedef PhoneVerificationCompleted = void Function(
  PhoneAuthCredential phoneAuthCredential,
);

typedef PhoneVerificationFailed = void Function(FirebaseAuthException error);

typedef PhoneCodeSent = void Function(
  String verificationId,
  int? forceResendingToken,
);

typedef PhoneCodeAutoRetrievalTimeout = void Function(String verificationId);

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

  ProfileData? profileData;

  UserCredential? firebaseUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  int? _resendToken;

  final CachedStreamController<LoginState> onLoginStateChanged =
  CachedStreamController();

  OpdClient(this.clientName, {
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

  Future<void> init({String? newUserId,
    String? newAccessToken}) async {
    if ((newUserId != null ||
        newAccessToken != null) &&
        (newUserId == null ||
            newAccessToken == null)) {
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

      if (clientBox != null) {
        userId = clientBox.userId;
        accessToken = clientBox.accessToken;
        isPlanPurchased = clientBox.isPlanPurchased;
      }
      if (newUserId != null) {
        userId = _userId = newUserId;
        accessToken = this.accessToken = newAccessToken;
      } else {
        accessToken = this.accessToken = newAccessToken ?? accessToken;
        userId = _userId = newUserId ?? userId;
      }

      if (this.accessToken == null || this.userId == null) {
        onLoginStateChanged.add(LoginState.loggedOut);
        Logs().e('User is not logged in.');
        _initLock = false;
        return;
      }
      await getProfile(update: true);
      await getAllPlans(update: true);
     isPlanPurchased = isPlanBuy = profileData!.plan!.purchased!;


      final database = this.database;
      if (database != null) {
        if (id != null) {
          await database.updateClient(
              userId: userId,
              accessToken: accessToken,
              baseUri: baseServerUri.toString(),
              isPlanPurchased: isPlanPurchased);
        } else {
          _id = await database.insertClient(
              baseUri: baseServerUri.toString(),
              accessToken: accessToken,
              userId: userId,
              isPlanPurchased: isPlanPurchased);
        }
      }

      _initLock = false;

      onLoginStateChanged.add(LoginState.loggedIn);
      Logs().i(
        'Successfully connected as $userId with ${baseServerUri.toString()}',
      );
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
  Future<RegisterResponse> register({
    String? emailAddress,
    required String? password,
    required String? confirmPassword,
    String? countryCode,
    String? phone,
    required int? loginType,
    required bool? termAndCondition,
  }) async {
    if (baseServerUri == null) {
      throw Exception("No baseServerUri set");
    }
    final response = await super.register(
        emailAddress: emailAddress,
        password: password,
        confirmPassword: confirmPassword,
        countryCode: countryCode,
        phone: phone,
        loginType: loginType,
        termAndCondition: termAndCondition);

    if (response.data == null) {
      throw Exception(response.toString());
    }

    return response;
  }

  @override
  Future<LoginResponse> login({String? emailAddress,
    String? password,
    String? phone,
    String? countryCode,
    int? loginType}) async {
    if (baseServerUri == null) {
      throw Exception("No baseServerUri set");
    }
    final response = await super.login(
        emailAddress: emailAddress,
        password: password,
        phone: phone,
        countryCode: countryCode,
        loginType: loginType);

    if (response.success!) {
      await init(
          newAccessToken: response.data!.token!,
          newUserId: response.data!.userId!);
    }

    if (response.data == null) {
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
    try {
      final response = await super.logout();
      if (response.success!) {
        await clear();
      } else {
        await clear();
      }
    } catch (e) {
      await clear();
    }
    final database = this.database;
    if (database != null) {
      database.deleteClient();
      database.deleteUserProfile();
      database.deleteFamilyMembers();
      database.deletePlans();
      database.deleteRelations();
    }
    onLoginStateChanged.add(LoginState.loggedOut);
  }

  @override
  Future<PlansResponse?> getAllPlans({bool update = false}) async {
    PlansResponse? plansResponse;
    final database = this.database;
    if (database != null && !update) {
      plansResponse = await database.getPlans();
      plansResponse ??= await super.getAllPlans();
      await database.updatePlans(plans: plansResponse);
    } else {
      plansResponse = await super.getAllPlans();
      final database = this.database;
      if (database != null) {
        await database.insertPlans(plans: plansResponse);
      }
    }
    return plansResponse;
  }

  @override
  Future<UserProfile> getProfile({bool update = true}) async {
    UserProfile? userProfile;
    final database = this.database;
    if (database != null) {
      if(update){
        userProfile = await super.getProfile();
        await database.updateUserProfile(userProfile: userProfile);
        profileData = userProfile.data!;
        return userProfile;
      }
      userProfile = await database.getUserProfile();
      userProfile ??= await super.getProfile();
      await database.updateUserProfile(userProfile: userProfile);
    } else {
      userProfile = await super.getProfile();

      final databaseBuilder = this.databaseBuilder;
      if (databaseBuilder != null) {
        _database ??= await runBenchmarked(
          'Build database',
              () async => databaseBuilder(this),
        );
      }

      final database = this.database;
      if (database != null) {
        await database.insertUserProfile(userProfile: userProfile);
      }
    }
    profileData = userProfile.data!;
    return userProfile;
  }

  Future getFirebaseOTP(String mobile, {
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      forceResendingToken: _resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        firebaseUser = await _auth.signInWithCredential(credential);
        _resendToken = null;
        verificationCompleted.call(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationFailed.call(e);
      },
      codeSent: (String verId, int? resendToken) {
        _verificationId = verId;
        _resendToken = resendToken;
        codeSent.call(verId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verId) {
        _verificationId = verId;
        codeAutoRetrievalTimeout.call(verId);
      },
    );
  }

  Future<UserCredential?> signInWithOTP(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    try {
      firebaseUser = await _auth.signInWithCredential(credential);
      _resendToken = null;
      return firebaseUser;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      firebaseUser = userCredential;
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future updatePlanPurchasedStatus(bool value) async {
    final database = this.database;
    if (database != null) {
      isPlanPurchased = value;
      database.updatePlanPurchasedStatus(value);
    }
  }

  // @override
  // Future<UserProfile?> updateUserProfile(
  //     {String? name, String? email, String? phone, Map<String, dynamic>? plan}) async {
  //   final response = await super.updateUserProfile(
  //       name: name, email: email, phone: phone, plan: plan);
  //   if (response != null) {
  //     final database = this.database;
  //     if (database != null) {
  //       final userProfile = await database.getUserProfile();
  //       if (name != null) {
  //         userProfile!.data!.name = name;
  //       }
  //       if (email != null) {
  //         userProfile!.data!.email = email;
  //       }
  //       if (phone != null) {
  //         userProfile!.data!.phone = phone;
  //       }
  //       await database.updateUserProfile(userProfile: userProfile);
  //     }
  //   }else{
  //     return null;
  //   }
  //   return response;
  // }


  @override
  Future<MyMemberModel?> getFamilyMember({bool update = false}) async  {
    MyMemberModel? myMembers;
      final database = this.database;

      if(database != null){
        if(update){
          myMembers ??= await super.getFamilyMember();
          await database.updateFamilyMembers(myMember: myMembers);
          return myMembers;
        }
        myMembers = await database.getFamilyMembers();
        myMembers ??= await super.getFamilyMember();
        await database.updateFamilyMembers(myMember: myMembers);
      }else{
        return null;
      }
    return myMembers;
  }


  @override
  Future<Relations?> getRelations() async {
    Relations? relations;
    final database = this.database;
    if(database!= null){
      relations = await database.getRelations();
      relations ?? await super.getRelation();
      await database.updateRelations(relations: relations);
    }else{
      return null;
    }
    return relations;
  }

  Future<FileUploadResponse?> uploadFiles({required FilePickerResult results}) async {
    var files =  results.files.map((file) async  {
      final mimeTypeData = lookupMimeType(file.path!, headerBytes: [0xFF, 0xD8])?.split('/');
      return  await http.MultipartFile.fromPath(
        'files',
        file.path!,
        filename: file.name,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
    });
    List<http.MultipartFile> newFile = [];
    for(var file in files.toList()) {
      newFile.add(await file);
    }
    return super.uploadFile(results: newFile);
  }

  Future<PlanRecords?> getPlanById({required String? planId, int? memberShipId})async {
    PlanRecords? records;
    final database = this.database;
    if(database != null){
      records = await database.getPlanById(planId: planId, memberShipId: memberShipId);
    }
    return records;
  }

}
