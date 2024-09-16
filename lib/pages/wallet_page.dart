import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_card_view.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';

import '../config/app_config.dart';
import '../custom_ui/app_header.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Wallet',
      ),
      childContent: FutureBuilder(
          future: OpdSure.of(context).client.getProfile(update: true),
          builder: (context, profile) {
            return FutureBuilder(
                future: OpdSure.of(context).client.getTransactions(),
                builder: (context, transaction) {
                  if (transaction.data == null) {
                    return const Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: CommonMethods.deviceWidth(context) - 30,
                          child: AppCardView(
                            mChaild: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const AppTextView(
                                  text: 'Available Balance',
                                  size: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                profile.data == null
                                    ? const CircularProgressIndicator()
                                    : AppTextView(
                                        text:
                                            '$rupeeSymbol ${CommonMethods.amountFormater(profile.data!.data!.walletBalance.toString(), isDouble: true)}',
                                        size: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF027A48),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const AppTextView(
                          text: 'Transaction history',
                          size: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: transaction.data!.data!.length,
                              itemBuilder: (context, index) {
                                return AppRoundView(
                                    isMargin: true,
                                    corner: 10.0,
                                    color: AppConfig.roundedViewColor,
                                    mChild: ListTile(
                                      title: AppTextView(
                                        text: transaction
                                                    .data!.data![index].type! ==
                                                1
                                            ? 'Reward amount'
                                            : 'Claim settled',
                                        size: 14,
                                      ),
                                      subtitle: AppTextView(
                                        text: CommonMethods.formatIsoDateString(
                                            transaction
                                                .data!.data![index].createdAt!,
                                            isTime: true),
                                        size: 12,
                                      ),
                                      trailing: AppTextView(
                                        text:
                                            '${transaction.data!.data![index].type! == 1 ? '+' : '-'} $rupeeSymbol ${CommonMethods.amountFormater(transaction.data!.data![index].amount!.toStringAsFixed(2), isDouble: true)}',
                                        color: transaction
                                                    .data!.data![index].type! ==
                                                1
                                            ? Colors.green
                                            : Colors.red,
                                        size: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ));
                              }),
                        )
                      ],
                    );
                  }
                });
          }),
    );
  }
}
