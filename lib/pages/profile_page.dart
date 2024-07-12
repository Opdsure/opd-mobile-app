import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/pages/add_family_details/add_family_details.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/utils/opd_extension/int_extention.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../custom_ui/app_button.dart';
import '../custom_ui/app_round_view.dart';
import '../model/user_profile/user_profile.dart';
import '../utils/app_colors.dart';

class ProfilePage extends StatelessWidget{
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
        childContent: ListView(
          children: [
            const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/140x100')
            ),
            const SizedBox(height: 15.0,),
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

            SizedBox(
              height: 600,
              child: TabBarView(children: [
                Column(children: [
                  const SizedBox(height: 10,),
                  FutureBuilder(
                    future: OpdSure.of(context).client.getProfile(),
                    builder: (context,snapshot){
                      if(snapshot.data == null){
                        return Container();
                      }
                      else{
                        UserProfile userProfile = snapshot.data!;
                        return AppRoundView(
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
                                    Image.asset(
                                      'assets/images/edit_pen.png',
                                      height: 20.0,
                                      width: 20.0,
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
                                  value: '25 Years',
                                ),
                                const SizedBox(height: 5.0,),
                                AppKeyValue(
                                  mKey: 'Gender',
                                  value: CommonMethods.getGenderByKey(userProfile.data!.gender!),
                                ),
                                const SizedBox(height: 5.0,),
                                AppKeyValue(
                                  mKey: 'Date of Birth',
                                  value: userProfile.data!.dob!,
                                ),
                                const SizedBox(height: 5.0,),
                                AppKeyValue(
                                  mKey: 'Mobile Number',
                                  value: '${userProfile.data!.countryCode!} ${userProfile.data!.phone!}',
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20.0,),
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
                              Image.asset(
                                'assets/images/edit_pen.png',
                                height: 20.0,
                                width: 20.0,
                              )
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          AppKeyValue(
                            mKey: 'House No.',
                            value: 'D-56',
                          ),
                          const SizedBox(height: 5.0,),
                          AppKeyValue(
                            mKey: 'Street',
                            value: 'Sector 27',
                          ),
                          const SizedBox(height: 5.0,),
                          AppKeyValue(
                            mKey: 'City',
                            value: 'Gurgaon',
                          ),
                          const SizedBox(height: 5.0,),
                          AppKeyValue(
                            mKey: 'State',
                            value: 'Haryana',
                          ),
                          const SizedBox(height: 5.0,),
                          AppKeyValue(
                            mKey: 'Pin code',
                            value: '201102',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
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
                 ],
                ),
                Column(children: [
                  const SizedBox(height: 5,),
                  FutureBuilder<MyMemberModel?>(
                      future: OpdSure.of(context).client.getFamilyMember(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){
                          return const Center(child: CircularProgressIndicator(),);
                        }else{
                          return SizedBox(
                            height: h*0.55,
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await OpdSure.of(context).client.getFamilyMember(update: true);
                              },
                              child: ListView.builder(
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index){
                                    MemberList member = snapshot.data!.data![index];
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
                                                    text: member.relation!.getRelation(),
                                                    size: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                  Image.asset(
                                                    'assets/images/edit_pen.png',
                                                    height: 20.0,
                                                    width: 20.0,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10.0,),
                                              AppKeyValue(
                                                  mKey: 'Name',
                                                  value: member.name!
                                              ),
                                              const SizedBox(height: 5.0,),
                                              AppKeyValue(
                                                mKey: 'Age',
                                                value: '34',
                                              ),
                                              const SizedBox(height: 5.0,),
                                              AppKeyValue(
                                                mKey: 'Date of Birth',
                                                value: member.dob!,
                                              ),
                                              const SizedBox(height: 5.0,),
                                              AppKeyValue(
                                                mKey: 'Mobile',
                                                value: '${member.phone!}',
                                              ),
                                              const SizedBox(height: 5.0,),
                                              AppKeyValue(
                                                mKey: 'Address',
                                                value: member.address!,
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
                  ),
                  AppButton(
                    text: 'Add Another Member',
                    color: const Color(0xFFebecf1),
                    textColor: buttonColor,
                    borderColor: buttonColor,
                    onClick: (){
                      // context.push('/home/view_plans/add_members');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>AddFamilyDetails()),
                      );
                    },
                  )
                ],)

              ]),
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