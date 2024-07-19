import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../model/my_member_model.dart';
import '../model/state_model.dart';

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

  RxString myDOB = ''.obs;
  void myDOBChange(String type){
    myDOB.value = type;
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

  RxString selectRelation = ''.obs;
  void selectRelationChange(String type){
    selectRelation.value = type;
  }

  RxInt selectRelationKey = 100.obs;
  void selectRelationKeyChange(int type){
    selectRelationKey.value = type;
  }

  RxString selectClaim = ''.obs;
  void selectClaimChange(String type){
    selectClaim.value = type;
  }

  RxList prescriptionList = <File>[].obs;
  void prescriptionListChange(File type){
    prescriptionList.add(type);
  }
  void removePrescription(File prescription) {
    prescriptionList.remove(prescription);
  }

  RxList docFeeRcpt = <File>[].obs;
  void docFeeRcptChange(File type){
    docFeeRcpt.add(type);
  }
  void removeDocFeeRcpt(File file) {
    docFeeRcpt.remove(file);
  }

  RxList pharmacyRcpt = <File>[].obs;
  void pharmacyRcptChange(File type){
    pharmacyRcpt.add(type);
  }
  void removePharmacyRcpt(File file) {
    pharmacyRcpt.remove(file);
  }

  RxList labTestRcpt = <File>[].obs;
  void labTestRcptChange(File type){
    labTestRcpt.add(type);
  }
  void removeLabTestRcpt(File file) {
    labTestRcpt.remove(file);
  }

  RxString countryCode = '+91'.obs;
  void countryCodeChange(String type){
    countryCode.value = type;
  }

  RxString flagCode = ''.obs;
  void flagCodeChange(String type){
    flagCode.value = type;
  }

  RxString planName = 'Care'.obs;
  void planNameChange(String type){
    planName.value = type;
  }

  RxInt planIndex = 0.obs;
  void planIndexChange(int type){
    planIndex.value = type;
  }

  var memberList = <MemberList>[].obs;
  void memberListChange(MemberList claim) {
    memberList.add(claim);
  }

  var stateList = <StateListData>[].obs;
  void stateListChange(StateListData state) {
    stateList.add(state);
  }

  RxDouble totalBill = 0.0.obs;
  void totalBillChange(double type){
    totalBill.value = type;
  }

  RxBool refreshClaimList = true.obs;
  void refreshClaimListChange(bool type){
    refreshClaimList.value = type;
  }

  RxBool refreshProfile = true.obs;
  void refreshProfileChange(bool type){
    refreshProfile.value = type;
  }

  RxBool refreshMemberList = true.obs;
  void refreshMemberListChange(bool type){
    refreshMemberList.value = type;
  }

  RxInt pageIndex = 0.obs;
  void pageIndexChange(int type){
    pageIndex.value = type;
  }

}