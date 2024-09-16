import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:simple_html_css/simple_html_css.dart';

import '../../../config/app_config.dart';
import '../../../custom_ui/app_header.dart';
import '../../../custom_ui/app_text_view.dart';
import 'health_checkup_details_controller.dart';

class HealthCheckupDetailsView extends StatelessWidget {
  final HealthCheckupDetailsController controller;
  final Color textColor = AppConfig.primaryColor;

  const HealthCheckupDetailsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(
        headerName: 'Health CheckUp',
      ),
      childContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Container(
                width: CommonMethods.deviceWidth(context) * 0.65,
                child: AppTextView(
                  text: controller.records!.name!,
                  color: textColor,
                  size: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppConfig.primaryColor.withOpacity(0.25),
                          Colors.white.withOpacity(0.25)
                        ])),
                child: AppTextView(
                  text: "${controller.records!.parameters!.toString()}\nTests",
                  size: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.primaryColor,
                  mTextAlign: TextAlign.center,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          const AppTextView(
            text: 'Test Included',
            size: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: controller.records!.testDetails!.length,
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                itemBuilder: (context, index) {
                  final TextSpan textSpan = HTML.toTextSpan(
                    context,
                    controller.records!.testDetails![index].subParameter!,
                    linksCallback: (dynamic link) {
                      debugPrint('You clicked on $link');
                    },
                    // as name suggests, optionally set the default text style
                    defaultTextStyle: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w700),
                    overrideStyle: <String, TextStyle>{
                      'p': GoogleFonts.montserrat(fontSize: 17.3, fontWeight: FontWeight.w800),
                      'a': GoogleFonts.montserrat(wordSpacing: 2, fontWeight: FontWeight.w800),
                    },
                  );
                  final TextSpan textSpan2 = HTML.toTextSpan(
                    context,
                    controller.records!.testDetails![index].testsName!.replaceAll('&nbsp;', ''),
                    linksCallback: (dynamic link) {
                      debugPrint('You clicked on $link');
                    },
                    defaultTextStyle: GoogleFonts.montserrat(color: Colors.grey[700]),
                    overrideStyle: <String, TextStyle>{
                      'p': GoogleFonts.montserrat(fontSize: 17.3),
                      'a': GoogleFonts.montserrat(wordSpacing: 2),
                    },
                  );
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.verified,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 8,),
                            SizedBox(
                              width: CommonMethods.deviceWidth(context) * 0.8,
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: RichText(text: textSpan),
                              ),
                            ),
                          ],
                        ),
                        if (textSpan2.children != null && textSpan2.children!.isNotEmpty) ...[
                          Row(
                            children: [
                              const SizedBox(
                                width: 30,
                              ),
                              const SizedBox(width: 8,),
                              SizedBox(
                                width: CommonMethods.deviceWidth(context) * 0.8,
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: RichText(text: textSpan2),
                                ),
                              ),
                            ],
                          )
                        ],
                      ],
                    ),
                  );
                }),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      isBottomContent: !controller.widget.isView,
      bottomContent: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
        width: CommonMethods.deviceWidth(context),
        height: AppBar().preferredSize.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextView(
                  text:
                      "$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, controller.getDiscountPrice())}",
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  width: 5,
                ),
                AppTextView(
                  text:
                      "$rupeeSymbol ${CommonMethods.amountFormater(isDouble: true, controller.getBasePrice())}",
                  fontStyle: FontStyle.italic,
                  isLineThrough: true,
                ),
              ],
            ),
            AppButton(
              text: 'Buy Now',
              width: 120,
              height: 60,
              onClick: (){
                context.push('/home/health_checkup_checkout', extra: controller.records!);
              },
            )
          ],
        ),
      ),
    );
  }
}
