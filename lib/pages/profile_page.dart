import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/pages/add_family_details/add_family_details.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';
import 'package:opdsure/pages/update_profile_page.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/opd_extension/int_extention.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../custom_ui/app_button.dart';
import '../custom_ui/app_round_view.dart';
import '../model/plans/plans_response.dart';
import '../model/user_profile/user_profile.dart';
import '../utils/app_colors.dart';

class ProfilePage extends StatelessWidget{
  TypeController typeController = Get.put(TypeController());
  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: AppBasePage(
        appHeader: AppHomeHeader(
          titleUi: const AppTextView(
            text: 'Profile',
            size: 22.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        childContent: Column(
          children: [
            Center(
              child: TabBar(
                unselectedLabelStyle: GoogleFonts.montserrat(
                    color: const Color(0xFF344054),
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0
                ),
                labelStyle: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0
                ),
                labelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Personal Info',
                  ),
                  Tab(
                    text: 'Family Members',
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,

              ),
            ),
            Expanded(
              child: TabBarView(
                // controller: _tabController,
                children: [
                  Obx((){
                    bool refresh = typeController.refreshProfile.value;
                    return refresh?FutureBuilder(
                      future: OpdSure.of(context).client.getProfile(),
                      builder: (context,snapshot){
                        if(snapshot.data == null){
                          return Container();
                        }
                        else{
                          UserProfile userProfile = snapshot.data!;
                          String actualDob = '';
                          if(userProfile.data!.dob!.isNotEmpty){
                            actualDob = CommonMethods.formatIsoDateString(userProfile.data!.dob!);
                          }

                          return ListView(
                            children: [
                              const SizedBox(height: 5,),
                              AppRoundView(
                                corner: 10.0,
                                color: const Color(0x1A486AB3),
                                mChild: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const AppTextView(
                                            text: 'Personal Information',
                                            size: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,),
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfilePage(userProfile)));
                                            },
                                            child: Image.asset(
                                              'assets/images/edit_pen.png',
                                              height: 20.0,
                                              width: 20.0,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10.0,),
                                      AppKeyValue(
                                        mKey: 'Name',
                                        value: userProfile.data!.name!,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      AppKeyValue(
                                        mKey: 'Age',
                                        value: actualDob.isEmpty?'':'${CommonMethods.calculateAge(DateFormat("dd/MM/yyyy").parse(actualDob))} years',
                                      ),
                                      const SizedBox(height: 5.0,),
                                      AppKeyValue(
                                        mKey: 'Gender',
                                        value: CommonMethods.getGenderByKey(userProfile.data!.gender!),
                                      ),
                                      const SizedBox(height: 5.0,),
                                      AppKeyValue(
                                        mKey: 'Date of Birth',
                                        value: actualDob,
                                        // value: userProfile.data!.dob!,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      AppKeyValue(
                                        mKey: 'Mobile Number',
                                        value: '${userProfile.data!.countryCode!} ${userProfile.data!.phone!}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0,),
                              AppRoundView(
                                corner: 10.0,
                                color: const Color(0x1A486AB3),
                                mChild: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const AppTextView(
                                            text: 'Address',
                                            size: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          Visibility(
                                            visible: false,
                                            child: Image.asset(
                                              'assets/images/edit_pen.png',
                                              height: 20.0,
                                              width: 20.0,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10.0,),
                                      AppKeyValue(
                                        mKey: 'Address',
                                        value: userProfile.data!.address!,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      AppKeyValue(
                                        mKey: 'City',
                                        value: userProfile.data!.city!,
                                      ),
                                      const SizedBox(height: 5.0,),
                                      AppKeyValue(
                                        mKey: 'Pin code',
                                        value: '${userProfile.data!.pinCode!}'=='0'?'':'${userProfile.data!.pinCode!}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0,),
                              AppRoundView(
                                corner: 10.0,
                                color: const Color(0x1A486AB3),
                                mChild: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const AppTextView(
                                            text: 'Subscribed Plan',
                                            size: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: buttonColor,
                                          ),
                                          Visibility(
                                            visible: true,
                                            child: SizedBox(
                                              height: 30,
                                                width: 100,
                                                child: AppButton(
                                                  text: 'Upgrade',
                                                  onClick: (){
                                                    // context.go('/home/view_plans?upgrade=true');
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ViewPlansPage(isUpgrade: true)));
                                                  },
                                                ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 2.0,),
                                      FutureBuilder(
                                        future: OpdSure.of(context).client.getPlanById(
                                          planId: userProfile.data!.plan!.id,
                                          memberShipId: userProfile.data!.plan!.membershipId,
                                        ),
                                        builder: (context,snapshot){
                                          if(snapshot.data == null){
                                            return Container();
                                          }
                                          else{
                                            print(snapshot.data);
                                            PlanRecords planRecord = snapshot.data!;
                                            return snapshot.data==null?const AppTextView(text: 'No plan selected'):Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AppTextView(
                                                  text: '${planRecord.name!} - ${planRecord.membershipOptions![0].membershipLabel}',
                                                  color: buttonColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                const SizedBox(height: 5,),
                                                AppTextView(
                                                  text: '${planRecord.membershipOptions![0].charges!+(planRecord.membershipOptions![0].charges!*18)/100}/Year',
                                                  color: buttonColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const SizedBox(height: 5,),
                                                SizedBox(
                                                  height:planRecord.planBenefits!.length*h*0.03,
                                                  child: ListView.builder(
                                                    itemCount: planRecord.planBenefits!.length,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, index){
                                                      return AppTextView(text: planRecord.planBenefits![index].planFeature!);
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0,),
                              AppRoundView(
                                onClick: (){
                                  showAlertDialog(
                                      context,'Are you sure want to logout','Logout','Yes','Cancel'
                                  );
                                },
                                corner: 10.0,
                                color: const Color(0x1A486AB3),
                                mChild: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppTextView(
                                        text: 'Logout',
                                        size: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Icon(
                                        Icons.logout,
                                        size: 20.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: h*0.15,)
                            ],
                          );
                        }
                      },
                    ):Container();
                  }),
                  Column(
                    children: [
                    const SizedBox(height: 5,),
                    Obx((){
                      bool refresh = typeController.refreshMemberList.value;
                      return refresh?FutureBuilder<MyMemberModel?>(
                          future: OpdSure.of(context).client.getFamilyMember(update: true),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return const Center(child: CircularProgressIndicator(),);
                            }else{
                              return SizedBox(
                                height: h*0.65,
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    await OpdSure.of(context).client.getFamilyMember(update: true);
                                  },
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder: (context, index){
                                        MemberList member = snapshot.data!.data![index];
                                        int fmAge;
                                        if(member.dob==null){
                                          fmAge = 0;
                                        }
                                        else {
                                          fmAge = CommonMethods.calculateAge(DateFormat("yyyy-MM-dd").parse(member.dob!));
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                                          child: AppRoundView(
                                            corner: 10.0,
                                            color: const Color(0x1A486AB3),
                                            mChild: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      AppTextView(
                                                        text: '${member.name!} | ${member.relation!.getRelation()}',
                                                        size: 16.0,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context)=>AddFamilyDetails(isUpdate: true,member: member,isFirstMember: false,)),
                                                          );
                                                        },
                                                        child: Image.asset(
                                                          'assets/images/edit_pen.png',
                                                          height: 20.0,
                                                          width: 20.0,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10.0,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const AppTextView(
                                                        text: 'Status',
                                                        size: 16.0,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                      Row(
                                                        children: [
                                                          member.reviewStatus == 0?const Icon(Icons.access_time_outlined,
                                                          size: 17.0,
                                                          color: Color(0xFFEF6C00),):const Icon(Icons.check_circle_outline_rounded,
                                                          size: 17.0,
                                                          color: Colors.green,),
                                                          AppTextView(
                                                            text: member.reviewStatus == 0?'Pending':'Approved',
                                                            size: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            color: member.reviewStatus == 0?const Color(0xFFEF6C00):Colors.green,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5.0,),
                                                  AppKeyValue(
                                                    mKey: 'Age',
                                                    value: '$fmAge years',
                                                  ),
                                                  const SizedBox(height: 5.0,),
                                                  AppKeyValue(
                                                    mKey: 'Date of Birth',
                                                    value: member.dob==null?'':CommonMethods.changeDateFormat(member.dob!,from: 'yyyy-MM-dd',to: 'dd/MM/yyyy'),
                                                  ),
                                                  const SizedBox(height: 5.0,),
                                                  AppKeyValue(
                                                    mKey: 'Mobile',
                                                    value: '${member.phone!}',
                                                  ),
                                                  AppKeyValue(
                                                    mKey: 'Plan',
                                                    value: (member.planStatus! == 1)?'Paid':'Unpaid',
                                                  ),
                                                  const SizedBox(height: 5.0,),
                                                  SizedBox(
                                                    width: w*0.9,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const AppTextView(
                                                          text: 'Address:',
                                                          size: 14.0,
                                                          fontWeight: FontWeight.w600,
                                                          color: Color(0xFF344054),
                                                        ),
                                                        member.address==null?Container():SizedBox(
                                                          width: w*0.55,
                                                          child: AppTextView(
                                                            text: member.address!,
                                                            size: 14.0,
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xFF344054),
                                                            mTextAlign: member.address!.length>30?TextAlign.start:TextAlign.end,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              );
                            }

                          }
                      ):Container();
                    }),
                    AppButton(
                      text: 'Add Member',
                      color: const Color(0xFFebecf1),
                      textColor: buttonColor,
                      borderColor: buttonColor,
                      onClick: (){
                        // context.push('/home/view_plans/add_members');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>AddFamilyDetails(isUpdate: false,isFirstMember: false,)),
                        );
                      },
                    )
                  ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String message, String heading,
      String buttonAcceptTitle, String buttonCancelTitle) {
    // set up the buttons
    Widget cancelButton = MaterialButton(
      child: Text(buttonCancelTitle),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
        // Navigator.pop(context);
      },
    );
    Widget continueButton = MaterialButton(
      child: Text(buttonAcceptTitle),
      onPressed: () async {
        await OpdSure.of(context).client.logout();
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}