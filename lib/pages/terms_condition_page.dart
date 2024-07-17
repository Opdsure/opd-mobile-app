import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/terms_condition_model.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

class TermsConditionPage extends StatelessWidget{
  final String? termsType;
  TermsConditionPage({this.termsType});

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Terms and Conditions',),
      childContent: ListView(
        children: [
          FutureBuilder(
            future: OpdSure.of(context).client.getTermsConditions(termsType!),
            builder: (context, snapshot){
              if(snapshot.data == null){
                return SizedBox(
                  height: h,
                  child: const Center(
                    child: AppTextView(text: 'Data is loading...',),
                  ),
                );
              }
              else{
                TermsConditionModel tcm = TermsConditionModel.fromJson(jsonDecode(snapshot.data));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Center(
                    child: AppTextView(text: tcm.data!.condition!,),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

}