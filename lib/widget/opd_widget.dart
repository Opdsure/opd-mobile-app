import 'package:flutter/material.dart';
import 'package:opdsure/repository/client/OpdClient.dart';
import 'package:opdsure/utils/app_keys/app_key.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpdSure extends StatefulWidget {
  final Widget? child;
  final SharedPreferences store;
  const OpdSure({required this.store, this.child, super.key});

  @override
  State<OpdSure> createState() => OpdSureState();

  static OpdSureState of(BuildContext context) =>
      Provider.of<OpdSureState>(context, listen: false);
}

class OpdSureState extends State<OpdSure> with WidgetsBindingObserver {

  SharedPreferences get store => widget.store;

  OpdClient get client{
    return OpdClient("");
  }

  bool get isOnboardScreenActive {
    return widget.store.getBool(AppKey.onBoardScreen) ?? false;
  }

  set isOnboardScreenActive(bool value) {
    store.setBool(AppKey.onBoardScreen, value);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(create: (_) => this, child: widget.child, );
  }
}
