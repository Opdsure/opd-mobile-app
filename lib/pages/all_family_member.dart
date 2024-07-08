import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_colors.dart';

import '../repository/network_api/api.dart';

class AllFamilyMember extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'My Family Member'),
      childContent: FutureBuilder(
        future: Api().getFamilyMember(),
        builder: (context,snapshot){
          if(snapshot.data==null){
            return Container();
          }
          else{
            print(snapshot.data);
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AppCardView(
                    mChaild: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AppTextView(
                              text: 'Amit Kumar',
                              size: 16.0,
                              fontWeight: FontWeight.w600,
                              color: buttonColor,
                            ),
                            InkWell(
                              onTap: (){

                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

}