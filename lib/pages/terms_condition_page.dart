import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/model/terms_condition_model.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:simple_html_css/simple_html_css.dart';

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
                final TextSpan textSpan = HTML.toTextSpan(
                  context,
                  tcm.data!.condition!,
                  linksCallback: (dynamic link) {
                    debugPrint('You clicked on $link');
                  },
                  // as name suggests, optionally set the default text style
                  defaultTextStyle: TextStyle(color: Colors.grey[700]),
                  overrideStyle: <String, TextStyle>{
                    'p': const TextStyle(fontSize: 17.3),
                    'a': const TextStyle(wordSpacing: 2),
                    // specify any tag not just the supported ones,
                    // and apply TextStyles to them and/override them
                  },
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Center(
                    // child: AppTextView(text: tcm.data!.condition!,),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/app_logo.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            child: RichText(text: textSpan),
                          ),
                        ],
                      ),
                    ),
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