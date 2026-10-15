import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/model/hospital/hospital_model.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/update_member/update_member.dart';
import 'package:opdsure/model/user_profile/user_profile.dart';
import 'package:opdsure/pages/profile_page/profile_page_view.dart';
import 'package:opdsure/utils/logs/logs.dart';

import '../../widget/opd_widget.dart';
import '../update_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageController();
}

class ProfilePageController extends State<ProfilePage> {
  UserProfile? userProfile;
  MyMemberModel? memberModel;
  UpdateMember? updateMember;

  // Hospitals tab state. `null` while loading; a list (possibly empty) once the
  // fetch completes or fails, so the tab can distinguish "loading" from "none".
  List<HospitalRecord>? hospitals;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  getProfileData() async {
    await OpdSure.of(context).client.getNotifications();
    userProfile = await OpdSure.of(context).client.getProfile(update: true);
    memberModel =
        await OpdSure.of(context).client.getFamilyMember(update: true);
    updateMember = await OpdSure.of(context).client.getRequestedMembers();
    if (mounted) {
      setState(() {});
    }
    getHospitals();
  }

  Future<void> getHospitals() async {
    try {
      final response = await OpdSure.of(context).client.getHospitals();
      hospitals = response.data?.records ?? [];
    } catch (e) {
      Logs().w('ProfilePage: Failed to fetch hospitals: $e');
      hospitals = [];
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => ProfilePageView(this);

  void updateProfile() async {
    await context.push('/home/update-profile', extra: {"profile": userProfile});
    getProfileData();
  }

  void updateFamilyMember(MemberList member) async {
    await context.push('/home/add-members', extra: {
      "isUpdate": true,
      "member": member,
      "isAddingFirstMember": false
    });
    getProfileData();
  }

  void addFamilyMember() async {
    final result = await context.push('/home/add-members',
        extra: {"isUpdate": false, "isAddingFirstMember": false});
    print(result);
    getProfileData();
  }
}
