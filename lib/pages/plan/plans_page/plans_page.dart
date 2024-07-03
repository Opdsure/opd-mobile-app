import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/select_plan.dart';
import 'package:opdsure/pages/plan/plans_page/plans_page_controller.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../../../repository/client/client_manager.dart';
import '../../../utils/app_colors.dart';

class PlansPageView extends StatelessWidget{
  final PlansPageController controller;
  const PlansPageView(this.controller, {super.key});

  Widget commonRow(BuildContext context,  String imgUri, String desc){
    double w = CommonMethods.deviceWidth(context);
    return Row(
      children: [
        Image.asset('assets/images/$imgUri.png'),
        const SizedBox(width: 10.0,),
        SizedBox(
          width: w*0.8,
          child: AppTextView(text: desc),
        )
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: controller.plansLength!,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              const SizedBox(height: 16.0,),
              AppHeader(headerName: 'Plans & Pricing',),
              const SizedBox(height: 30.0,),
              const AppTextView(
                text: 'Select Plan',
                size: 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              const SizedBox(height: 15.0,),
              ButtonsTabBar(
                backgroundColor: Colors.transparent,
                unselectedBackgroundColor: Colors.white,
                labelStyle: GoogleFonts.montserrat(
                  color: buttonColor,
                ),
                borderColor: buttonColor,
                height: 40.0,
                width: 100.0,
                contentCenter: true,
                unselectedLabelStyle: GoogleFonts.montserrat(
                  color: Colors.black,
                ),
                borderWidth: 1,
                unselectedBorderColor: const Color(0xFFEAECF0),
                radius: 15,
                tabs: controller.plansTab,
                onTap: (index){
                  controller.getIndexedRecords(index: index);
                },
              ),
              const SizedBox(height: 15.0,),
              AppTextView(
                text: '₹ ${controller.record.charges!}/mo',
                color: Color(0xFF8A48B3),
                size: 40.0,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 15.0,),
              const AppTextView(
                text: 'Billed annually',
                size: 16.0,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 15.0,),
              const AppTextView(
                text: 'Benefits',
                size: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10.0,),
               commonRow(context,'unlimited_doctor', controller.record.features!),
              // const SizedBox(height: 10.0,),
              // commonRow(context,'max_limit','Maximum limit of INR 500/- per Doctor Consultation.'),
              // const SizedBox(height: 10.0,),
              // commonRow(context,'pharmacy_labs','Prescribed pharmacy & lab test - 50% reimbursement or INR 500/- (whichever lower).'),
              // const SizedBox(height: 10.0,),
              // commonRow(context,'free_annual','Free Preventive Annual Health Check-up - 87 parameters.'),
              // const SizedBox(height: 10.0,),
              // commonRow(context,'easy_claim','Easy claim Processing and cashless OPD with network doctors.'),
              // const SizedBox(height: 10.0,),
              // commonRow(context,'add_family','Add family members at 50% discount.'),
              // const SizedBox(height: 20.0,),
              AppButton(
                text: 'Select',
                onClick: (){
                  modalBottomSheetMenu(context);
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            ClientManager.removeClientNameFromStore(OpdSure.of(context).client.clientName, OpdSure.of(context).store);
            OpdSure.of(context).client.logout();
          },
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          selectedIndex: 1,
          destinations: <Widget>[
            NavigationDestination(
              // selectedIcon: Image.asset('assets/images/bottom_home.png'),
              icon: Image.asset(
                'assets/images/bottom_home.png',
                height: 30.0,
                width: 30.0,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Image.asset(
                'assets/images/bottom_claim.png',
                height: 30.0,
                width: 30.0,
              ),
              label: 'Claims',
            ),
            NavigationDestination(
              icon: Image.asset(
                'assets/images/bottom_appointment.png',
                height: 30.0,
                width: 30.0,
              ),
              label: 'Appointment',
            ),
            NavigationDestination(
              icon: Image.asset(
                'assets/images/bottom_profile.png',
                height: 30.0,
                width: 30.0,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 20, // here increase or decrease in width
        ),
        builder: (builder){
          return Container(
            height: 450.0,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F7),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppTextView(
                        text: 'Select One',
                        size: 22.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      Image.asset(
                        'assets/images/cancel_icon.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  SelectPlan(),
                  const SizedBox(height: 15.0,),
                  SelectPlan(
                    imgUri: 'indivisual_icon',
                    isPopular: false,
                    forWhat: 'For Individual',
                    memberCount: 'Enjoy all the services yourself.',
                    isSelected: true,
                  ),
                  const SizedBox(height: 15.0,),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'You can cancel whenever you want. By confirming, you agree to the ',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF667085)
                              )
                          ),
                          TextSpan(
                            text: 'Terms & Conditions.',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475467)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  const AppButton(text: 'Continue')
                ],
              ),
            ),
          );
        }
    );

  }

}