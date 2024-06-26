import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TypeController extends GetxController{
  RxString countryFlag = ''.obs;
  void countryFlagChange(String type){
    countryFlag.value = type;
  }

  RxString signUpBy = 'email'.obs;
  void signUpByChange(String type){
    signUpBy.value = type;
  }

  RxString loginBy = 'email'.obs;
  void loginByChange(String type){
    loginBy.value = type;
  }

  RxBool signPass = false.obs;
  void signPassChange(bool type){
    signPass.value = type;
  }

  RxBool signRePass = false.obs;
  void signRePassChange(bool type){
    signRePass.value = type;
  }

}