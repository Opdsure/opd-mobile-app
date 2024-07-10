import 'package:hive/hive.dart';
import 'package:opdsure/model/client/client_box.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/plans/plans_response.dart';
import 'package:opdsure/model/relation/relations.dart';
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
  late Box<Relations> _relationsBox;
  late Box<MyMemberModel> _familyMemberBox;

  OpdDatabaseApi(this.name);

  Future<void> open() async {
    Hive.registerAdapter(ClientBoxAdapter());
    Hive.registerAdapter(PlansResponseAdapter());
    Hive.registerAdapter(PlansDataAdapter());
    Hive.registerAdapter(RecordsAdapter());
    Hive.registerAdapter(PaginationAdapter());
    Hive.registerAdapter(MembershipOptionsAdapter());
    Hive.registerAdapter(PlanBenefitsAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(ProfileDataAdapter());
    Hive.registerAdapter(RelationsAdapter());
    Hive.registerAdapter(RelationsDataAdapter());
    Hive.registerAdapter(MyMemberModelAdapter());
    Hive.registerAdapter(MemberListAdapter());
    Hive.registerAdapter(PlanAdapter());
    Hive.registerAdapter(VerifiedAdapter());
    _clientBox = await Hive.openBox(name);
    _planBox = await Hive.openBox(DatabaseBoxKey.planBoxName);
    _userProfileBox = await Hive.openBox(DatabaseBoxKey.userProfileBoxName);
    _relationsBox = await Hive.openBox(DatabaseBoxKey.relationsBox);
    _familyMemberBox = await Hive.openBox(DatabaseBoxKey.familyMembersBox);
  }

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
            isPlanPurchased: isPlanPurchased,
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
      }
      if (accessToken != null) {
        clientBox.accessToken = userId;
      }
      if (baseUri != null) {
        clientBox.baseServerUrl = userId;
      }
      if (isPlanPurchased != null) {
        clientBox.isPlanPurchased = isPlanPurchased;
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
    if (clientBox != null) {
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
    return _userProfileBox.get(DatabaseBoxKey.userProfileBoxName,
        defaultValue: null);
  }

  @override
  Future deletePlans({PlansResponse? plans}) async {
    await _planBox.delete(DatabaseBoxKey.planBoxName);
  }

  @override
  Future deleteUserProfile() async {
    await _userProfileBox.delete(DatabaseBoxKey.userProfileBoxName);
  }

  @override
  Future insertUserProfile({UserProfile? userProfile}) async {
    if (userProfile != null) {
      await _userProfileBox.put(DatabaseBoxKey.userProfileBoxName, userProfile);
    }
  }

  @override
  Future updateUserProfile({UserProfile? userProfile}) async {
    if (userProfile != null) {
      await _userProfileBox.put(DatabaseBoxKey.userProfileBoxName, userProfile);
    }
  }

  @override
  Future deleteFamilyMembers() async {
    await _familyMemberBox.delete(DatabaseBoxKey.familyMembersBox);
  }

  @override
  Future deleteRelations() async {
    await _relationsBox.delete(DatabaseBoxKey.relationsBox);
  }

  @override
  Future<MyMemberModel?> getFamilyMembers() async {
    return _familyMemberBox.get(DatabaseBoxKey.familyMembersBox,
        defaultValue: null);
  }

  @override
  Future<Relations?> getRelations() async {
    return _relationsBox.get(DatabaseBoxKey.relationsBox, defaultValue: null);
  }

  @override
  Future insertFamilyMembers({MyMemberModel? myMember}) async {
    if (myMember != null) {
      await _familyMemberBox.put(DatabaseBoxKey.familyMembersBox, myMember);
    }
  }

  @override
  Future insertRelations({Relations? relations}) async {
    if (relations != null) {
      _relationsBox.put(DatabaseBoxKey.relationsBox, relations);
    }
  }

  @override
  Future updateFamilyMembers({MyMemberModel? myMember}) async {
    if (myMember != null) {
      await _familyMemberBox.put(DatabaseBoxKey.familyMembersBox, myMember);
    }
  }

  @override
  Future updateRelations({Relations? relations}) async {
    if (relations != null) {
      _relationsBox.put(DatabaseBoxKey.relationsBox, relations);
    }
  }

  @override
  Future getPlanById({required String? planId, int? memberShipId}) async {
    final plans = await getPlans();

    if (plans != null) {
      final records = plans.data!.records!
          .where((records) => records.id == planId!)
          .toList();
      final memberShipOption = records[0]
          .membershipOptions!
          .where((options) => options.membershipId == memberShipId)
          .toList();
      records[0].membershipOptions = memberShipOption;
      return records[0];
    } else {
      return null;
    }
  }
}
