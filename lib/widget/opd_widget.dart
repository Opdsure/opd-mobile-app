import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/client/client_manager.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/utils/platform_infos.dart';
import 'package:opdsure/widget/opd_sure_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../utils/logs/logs.dart';
import '../utils/opd_extension/account_bundles.dart';

class OpdSure extends StatefulWidget {
  final Widget? child;
  final SharedPreferences store;
  final List<OpdClient> clients;

  const OpdSure(
      {required this.clients, required this.store, this.child, super.key});

  @override
  State<OpdSure> createState() => OpdSureState();

  static OpdSureState of(BuildContext context) =>
      Provider.of<OpdSureState>(context, listen: false);
}

class OpdSureState extends State<OpdSure> with WidgetsBindingObserver {
  int _activeClient = -1;
  String? activeBundle;

  List<OpdClient?>? get currentBundle {
    if (!hasComplexBundles) {
      return List.from(widget.clients);
    }
    final bundles = accountBundles;
    if (bundles.containsKey(activeBundle)) {
      return bundles[activeBundle];
    }
    return bundles.values.first;
  }



  Map<String?, List<OpdClient?>> get accountBundles {
    final resBundles = <String?, List<_AccountBundleWithClient>>{};
    for (var i = 0; i < widget.clients.length; i++) {
      final bundles = widget.clients[i].accountBundles;
      for (final bundle in bundles) {
        if (bundle.name == null) {
          continue;
        }
        resBundles[bundle.name] ??= [];
        resBundles[bundle.name]!.add(
          _AccountBundleWithClient(
            client: widget.clients[i],
            bundle: bundle,
          ),
        );
      }
    }
    for (final b in resBundles.values) {
      b.sort(
            (a, b) => a.bundle!.priority == null
            ? 1
            : b.bundle!.priority == null
            ? -1
            : a.bundle!.priority!.compareTo(b.bundle!.priority!),
      );
    }
    return resBundles
        .map((k, v) => MapEntry(k, v.map((vv) => vv.client).toList()));
  }

  bool get hasComplexBundles => accountBundles.values.any((v) => v.length > 1);
  SharedPreferences get store => widget.store;

  bool isSelectPlans = false;

  OpdClient get client {
    if (widget.clients.isEmpty) {
      widget.clients.add(getLoginClient());
    }
    if (_activeClient < 0 || _activeClient >= widget.clients.length) {
      return currentBundle!.first!;
    }
    return widget.clients[_activeClient];
  }

  bool get isOnboardScreenActive {
    return widget.store.getBool(AppKey.onBoardScreen) ?? false;
  }

  set isOnboardScreenActive(bool value) {
    store.setBool(AppKey.onBoardScreen, value);
  }

  OpdClient? _loginClientCandidate;

  void setActiveClient(OpdClient? cl) {
    final i = widget.clients.indexWhere((c) => c == cl);
    if (i != -1) {
      _activeClient = i;
    } else {
      Logs().w('Tried to set an unknown client ${cl!.userId} as active');
    }
  }

  OpdClient getLoginClient() {
    if (widget.clients.isNotEmpty && !client.isLogged) {
      _registerSub(client.clientName);
      return client;
    }
    final candidate = _loginClientCandidate ??= ClientManager.createClient(
      '${AppConfig.applicationName}-${DateTime.now().millisecondsSinceEpoch}',
    )..onLoginStateChanged
          .stream
          .where((l) => l == LoginState.loggedIn)
          .first
          .then((_) {
        if (!widget.clients.contains(_loginClientCandidate)) {
          widget.clients.add(_loginClientCandidate!);
        }
        ClientManager.addClientNameToStore(
          _loginClientCandidate!.clientName,
          store,
        );
        _registerSub(_loginClientCandidate!.clientName);
        _loginClientCandidate = null;
        OpdSureApp.router.go('/home');
      });
    return candidate;
  }

  void initOpd() {
    for (final c in widget.clients) {
      _registerSub(c.clientName);
    }
  }

  OpdClient? getClientByName(String name) =>
      widget.clients.firstWhereOrNull((c) => c.clientName == name);

  final onLoginStateChanged = <String, StreamSubscription<LoginState>>{};

  void _registerSub(String name) {
    final c = getClientByName(name);
    if (c != null) {
      onLoginStateChanged[name] ??=
          c.onLoginStateChanged.stream.listen((state) {
        final loggedInWithMultipleClients = widget.clients.length > 1;
        if (state == LoginState.loggedOut) {
          _clearSub(name);
          isSelectPlans = false;
        }
        if (loggedInWithMultipleClients && state != LoginState.loggedIn) {
          _clearSub(c.clientName);
          widget.clients.remove(c);
          ClientManager.removeClientNameFromStore(c.clientName, store);
        } else {
          OpdSureApp.router.go(state == LoginState.loggedIn ? "/home" : '/signup/login');
        }
      });
    }
  }

  void _clearSub(String name) {
    onLoginStateChanged[name]?.cancel();
    onLoginStateChanged.remove(name);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initOpd();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => this,
      child: widget.child,
    );
  }
}


class _AccountBundleWithClient {
  final OpdClient? client;
  final AccountBundle? bundle;

  _AccountBundleWithClient({this.client, this.bundle});
}