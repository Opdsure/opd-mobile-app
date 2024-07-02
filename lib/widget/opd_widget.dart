import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/repository/client/client_manager.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:opdsure/widget/opd_sure_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

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
  SharedPreferences get store => widget.store;

  OpdClient get client {
    if (widget.clients.isEmpty) {
      widget.clients.add(getLoginClient());
    } else {
      return widget.clients[0];
    }
    return widget.clients[0];
  }

  bool get isOnboardScreenActive {
    return widget.store.getBool(AppKey.onBoardScreen) ?? false;
  }

  set isOnboardScreenActive(bool value) {
    store.setBool(AppKey.onBoardScreen, value);
  }

  OpdClient? _loginClientCandidate;

  OpdClient getLoginClient() {
    if (widget.clients.isNotEmpty && !client.isLogged) {
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

  void initOpd(){
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
          OpdSureApp.navigatorKey.currentContext!.go('/signup');
        }
        if (loggedInWithMultipleClients && state != LoginState.loggedIn) {
          _clearSub(c.clientName);
          widget.clients.remove(c);
          ClientManager.removeClientNameFromStore(c.clientName, store);
        } else {
          OpdSureApp.router
              .go(state == LoginState.loggedIn ? "/home" : '/login');
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
