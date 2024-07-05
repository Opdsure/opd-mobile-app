import 'package:opdsure/model/client/client_box.dart';

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

Future<UserProfile?> getUserProfile();
Future updateUserProfile({UserProfile? userProfile});
Future insertUserProfile({UserProfile? userProfile});
Future deleteUserProfile();
}