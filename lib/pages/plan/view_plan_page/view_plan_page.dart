import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/login_scafold.dart';
import 'package:opdsure/pages/plan/view_plan_page/view_plans_controller.dart';

import '../../../custom_ui/app_button.dart';
import '../../../custom_ui/app_text_view.dart';
import '../../../widget/opd_widget.dart';

class ViewPlanPageView extends StatelessWidget{

  final ViewPlansPageController controller;

  const ViewPlanPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LoginScaffold(
      enforceMobileMode: !OpdSure.of(context).client.isLogged,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 16.0,),
          Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              height: 100.0,
              width: 100.0,
            ),
          ),
          const SizedBox(height: 30.0,),
          Image.asset('assets/images/view_plans.png'),
          const SizedBox(height: 20.0,),
          const Center(
            child: AppTextView(
              text: 'Access Exclusive Features by\nSelecting a Plan',
              size: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              mTextAlign: TextAlign.center,
            ),
          ),
          const Center(
            child: AppTextView(
              text: 'Unlock all our premium features by\nselecting the plan that fits you best.',
              size: 16.0,
              color: Colors.black,
              mTextAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: AppButton(
              text: 'View Plans',
              onClick: (){
                controller.selectPlans(context);
              },
            ),
          ),
          // const SizedBox(height: 12.0,),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15.0),
          //   child: AppBorderBox(
          //     myChild: Center(
          //       child: AppTextView(
          //         text: 'Cancel',
          //         size: 16.0,
          //         fontWeight: FontWeight.w600,
          //         color: Color(0xFF344054),
          //       ),
          //     ),
          //     borderColor: Color(0xFFD0D5DD),
          //     boxColor: Color(0x1A101828),
          //   ),
          // ),
        ],
      ),
    );
  }

}