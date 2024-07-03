

import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/utils/opd_extension/try_get_map_extention.dart';

class AccountBundles {
  String? prefix;
  List<AccountBundle>? bundles;

  AccountBundles({this.prefix, this.bundles});

  AccountBundles.fromJson(Map<String, dynamic> json)
      : prefix = json.tryGet<String>('prefix'),
        bundles = json['bundles'] is List
            ? json['bundles']
                .map((b) {
                  try {
                    return AccountBundle.fromJson(b);
                  } catch (_) {
                    return null;
                  }
                })
                .whereType<AccountBundle>()
                .toList()
            : null;

  Map<String, dynamic> toJson() => {
        if (prefix != null) 'prefix': prefix,
        if (bundles != null)
          'bundles': bundles!.map((v) => v.toJson()).toList(),
      };
}

class AccountBundle {
  String? name;
  int? priority;

  AccountBundle({this.name, this.priority});

  AccountBundle.fromJson(Map<String, dynamic> json)
      : name = json.tryGet<String>('name'),
        priority = json.tryGet<int>('priority');

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (name != null) 'name': name,
        if (priority != null) 'priority': priority,
      };
}

const accountBundlesType = 'io.app.opd.account_bundles';

extension AccountBundlesExtension on OpdClient {
  List<AccountBundle> get accountBundles {
    List<AccountBundle>? ret;
    if (accountData.containsKey(accountBundlesType)) {
      ret = AccountBundles.fromJson(accountData[accountBundlesType] ?? {})
          .bundles;
    }
    ret ??= [];
    if (ret.isEmpty) {
      ret.add(
        AccountBundle(
          name: userId,
          priority: 0,
        ),
      );
    }
    return ret;
  }

  Future<void> setAccountBundle(String name, [int? priority]) async {
    final data =
        AccountBundles.fromJson(accountData[accountBundlesType] ?? {});
    var foundBundle = false;
    final bundles = data.bundles ??= [];
    for (final bundle in bundles) {
      if (bundle.name == name) {
        bundle.priority = priority;
        foundBundle = true;
        break;
      }
    }
    if (!foundBundle) {
      bundles.add(AccountBundle(name: name, priority: priority));
    }
   // await setAccountData(userId!, accountBundlesType, data.toJson());
  }

  Future<void> removeFromAccountBundle(String name) async {
    if (!accountData.containsKey(accountBundlesType)) {
      return; // nothing to do
    }
    final data =
        AccountBundles.fromJson(accountData[accountBundlesType] ?? {});
    if (data.bundles == null) return;
    data.bundles!.removeWhere((b) => b.name == name);
   // await setAccountData(userId!, accountBundlesType, data.toJson());
  }

  String get sendPrefix {
    final data =
        AccountBundles.fromJson(accountData[accountBundlesType] ?? {});
    return data.prefix!;
  }
}
