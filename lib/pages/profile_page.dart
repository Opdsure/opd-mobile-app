import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_key_value.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/common_methods.dart';

import '../custom_ui/app_round_view.dart';
import '../utils/app_colors.dart';

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double w = CommonMethods.deviceWidth(context);
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: AppBasePage(
        appHeader: AppHeader(
          headerName: 'Profile',
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
            const SizedBox(height: 10,),
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
                      value: 'Dipti Sharma',
                    ),
                    const SizedBox(height: 5.0,),
                    AppKeyValue(
                      mKey: 'Age',
                      value: '25 Years',
                    ),
                    const SizedBox(height: 5.0,),
                    AppKeyValue(
                      mKey: 'Gender',
                      value: 'Female',
                    ),
                    const SizedBox(height: 5.0,),
                    AppKeyValue(
                      mKey: 'Date of Birth',
                      value: '10/2/1998',
                    ),
                    const SizedBox(height: 5.0,),
                    AppKeyValue(
                      mKey: 'Mobile Number',
                      value: '+91 8623794732',
                    ),
                  ],
                ),
              ),
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
          ],
        ),
      ),
    );
  }

}