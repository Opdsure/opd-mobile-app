import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_round_view.dart';
import 'app_text_view.dart';

class SelectPlan extends StatelessWidget{
  final String imgUri;
  final String planName;
  final bool isPopular;
  final String forWhat;
  final String memberCount;
  final VoidCallback? onClick;
  final bool isSelected;

  SelectPlan({
    this.imgUri = 'family_icon',
    this.planName = 'Health Plan',
    this.isPopular = true,
    this.forWhat = 'For Family',
    this.memberCount = 'Add upto 10 members from family.',
    this.onClick,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: onClick,
      child: AppRoundView(
        mChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/$imgUri.png',
                        height: 40.0,
                        width: 40.0,
                      ),
                      const SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppTextView(
                                text: planName,
                                size: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF039855),
                              ),
                              const SizedBox(width: 10.0,),
                              isPopular?const AppRoundView(
                                mChild: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                                  child: AppTextView(
                                    text: 'Most Popular',
                                    size: 10.0,
                                    color: Colors.white,
                                  ),
                                ),
                                color: Color(0xFF8A48B3),
                              ):Container()
                            ],
                          ),
                          const SizedBox(height: 5,),
                          AppTextView(
                            text: forWhat,
                            size: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 2,),
                          AppTextView(
                            text: memberCount,
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    isSelected?Icons.radio_button_checked:Icons.radio_button_off,
                    color: isSelected?const Color(0xFF486AB3):const Color(0xFFB6C2E2),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}