import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_var.dart';

import '../custom_ui/app_header.dart';

class WalletPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Wallet',
      ),
      childContent: ListView(
        children: [
          AppCardView(
            mChaild: Column(
              children: [
                Row(
                  children: [
                    AppRoundView(
                      color: const Color(0x1A486AB3),
                      mChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/wallet_icon.png',
                          height: 20.0,
                          width: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0,),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextView(
                          text: 'Total Wallet Balance',
                          size: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        AppTextView(
                          text: '$rupeeSymbol 2,000',
                          size: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF027A48),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}