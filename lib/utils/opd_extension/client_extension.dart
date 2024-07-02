import 'package:opdsure/repository/client/OpdClient.dart';

extension InitWithRestoreExtension on OpdClient{

  Future<void> initWithRestore() async {
   await init();
  }

}