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

  RxInt previewCount = 0.obs;
  void previewCountChange(int type){
    previewCount.value = type;
  }

  RxString familyMemDOB = ''.obs;
  void familyMemDOBChange(String type){
    familyMemDOB.value = type;
  }

  RxString opdVisitDate = ''.obs;
  void opdVisitDateChange(String type){
    opdVisitDate.value = type;
  }

  RxString selectState = ''.obs;
  void selectStateChange(String type){
    selectState.value = type;
  }

  RxString selectGender = ''.obs;
  void selectGenderChange(String type){
    selectGender.value = type;
  }

  RxString selectClaim = ''.obs;
  void selectClaimChange(String type){
    selectClaim.value = type;
  }

  RxList prescriptionList = [].obs;
  void prescriptionListChange(List type){
    prescriptionList.value = type;
  }

  RxString countryCode = ''.obs;
  void countryCodeChange(String type){
    countryCode.value = type;
  }

  RxString flagCode = ''.obs;
  void flagCodeChange(String type){
    flagCode.value = type;
  }

}