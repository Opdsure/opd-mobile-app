import 'package:hive/hive.dart';
import 'package:opdsure/model/client/client_box.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/database_api/database_api.dart';
import 'package:opdsure/utils/app_keys/database_box_key.dart';

class OpdDatabaseApi extends DatabaseApi {
  static const int version = 1;
  final String name;
  late Box<ClientBox> _clientBox;
  late Box<PlansResponse> _planBox;
  late Box<UserProfile> _userProfileBox;

  OpdDatabaseApi(this.name);


  @override
  Future<ClientBox?> getClient(String name) async {
    return _clientBox.get(name, defaultValue: null);
  }

  @override
  Future<int?> insertClient(
      {String? baseUri,
      String? accessToken,
      String? userId,
      bool? isPlanPurchased}) async {
    try {
      await _clientBox.put(
        name,
        ClientBox(
            userId: userId,
            accessToken: accessToken,
            baseServerUrl: baseUri,
            id: 0),
      );
      return 0;
    } catch (e) {
      return null;
    }
  }

  @override
  Future updateClient(
      {String? baseUri,
      String? accessToken,
      String? userId,
      bool? isPlanPurchased}) async {
    final clientBox = _clientBox.get(name);
    if (clientBox != null) {
      if (userId != null) {
        clientBox.userId = userId;
      } else {
        clientBox.userId = null;
      }
      if (accessToken != null) {
        clientBox.accessToken = userId;
      } else {
        clientBox.accessToken = null;
      }
      if (baseUri != null) {
        clientBox.baseServerUrl = userId;
      } else {
        clientBox.baseServerUrl = null;
      }
      await _clientBox.put(name, clientBox);
    } else {
      await _clientBox.put(
          name,
          ClientBox(
              userId: userId,
              accessToken: accessToken,
              baseServerUrl: baseUri,
              id: 0));
    }
  }

  Future<void> open() async {
    Hive.registerAdapter(ClientBoxAdapter());
    Hive.registerAdapter(PlansResponseAdapter());
    Hive.registerAdapter(PlansDataAdapter());
    Hive.registerAdapter(RecordsAdapter());
    Hive.registerAdapter(PaginationAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(ProfileDataAdapter());
    _clientBox = await Hive.openBox(name);
    _planBox = await Hive.openBox(DatabaseBoxKey.planBoxName);
    _userProfileBox = await Hive.openBox(DatabaseBoxKey.userProfileBoxName);
  }

  @override
  Future<PlansResponse?> getPlans() async {
    return _planBox.get(DatabaseBoxKey.planBoxName, defaultValue: null);
  }

  @override
  Future<int?> insertPlans({PlansResponse? plans}) async {
    if (plans != null) {
      await _planBox.put(DatabaseBoxKey.planBoxName, plans);
      return 0;
    }
    return 1;
  }

  @override
  Future updatePlans({PlansResponse? plans}) async {
    if (plans != null) {
      await _planBox.put(DatabaseBoxKey.planBoxName, plans);
    }
  }

  @override
  Future updatePlanPurchasedStatus(bool value) async {
    ClientBox? clientBox = await getClient(name);
    if(clientBox != null){
      clientBox.isPlanPurchased = value;
      await _clientBox.put(name, clientBox);
    }
  }

  @override
  Future deleteClient() async {
    await _clientBox.delete(name);
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    return _userProfileBox.get(DatabaseBoxKey.userProfileBoxName, defaultValue: null);
  }

  @override
  Future deletePlans({PlansResponse? plans}) async{
    await _planBox.delete(DatabaseBoxKey.planBoxName);
  }

  @override
  Future deleteUserProfile() async {
    await _userProfileBox.delete(DatabaseBoxKey.userProfileBoxName);
  }

  @override
  Future insertUserProfile({UserProfile? userProfile}) async {
    if(userProfile != null) {
      await _userProfileBox.put(DatabaseBoxKey.userProfileBoxName, userProfile);
    }
  }

  @override
  Future updateUserProfile({UserProfile? userProfile}) async {
    if(userProfile != null) {
      await _userProfileBox.put(DatabaseBoxKey.userProfileBoxName, userProfile);
    }
  }
}
