import 'package:opdsure/model/client/client_box.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/relation/relations.dart';

import '../../model/plans/plans_response.dart';
import '../../model/user_profile/user_profile.dart';

abstract class DatabaseApi{

Future<ClientBox?> getClient(String name);

Future updateClient({String? baseUri,
  String? accessToken,
  String? userId,
bool? isPlanPurchased});

Future insertClient({String? baseUri,
  String? accessToken,
  String? userId,
bool? isPlanPurchased});

Future deleteClient();

Future<PlansResponse?> getPlans();


Future updatePlans({PlansResponse? plans});
Future insertPlans({PlansResponse? plans});
Future deletePlans({PlansResponse? plans});
Future updatePlanPurchasedStatus(bool value);
Future getPlanById({required String? planId, int? memberShipId});
Future getPlansForUpgrade({required int? planPrice});

Future<UserProfile?> getUserProfile();
Future updateUserProfile({UserProfile? userProfile});
Future insertUserProfile({UserProfile? userProfile});
Future deleteUserProfile();


Future<MyMemberModel?> getFamilyMembers();
Future updateFamilyMembers({MyMemberModel? myMember});
Future insertFamilyMembers({MyMemberModel? myMember});
Future deleteFamilyMembers();

Future<Relations?> getRelations();
Future updateRelations({Relations? relations});
Future insertRelations({Relations? relations});
Future deleteRelations();
}