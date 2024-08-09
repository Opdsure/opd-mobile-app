import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_gradient.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/health_check_up_page.dart';
import 'package:opdsure/utils/app_colors.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_ui/app_button.dart';
import '../../custom_ui/app_card_view.dart';
import '../../model/claim_status_model.dart';
import '../../model/my_claim/my_claims_model.dart';
import '../../utils/app_var.dart';
import '../all_checkup_page.dart';
import '../claims_details_page.dart';
import '../file_claim_page.dart';

typedef ValueCallback = void Function(int value);

class HomePage extends StatefulWidget {
  final ValueCallback callback;

  HomePage({required this.callback, super.key});

  static const List<IconData> icons = [
    Icons.chat,
    Icons.phone,
    Icons.group_add
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> joinWhatsAppGroup() async {
    const String groupLink =
        'https://chat.whatsapp.com/your-group-invite-link'; // Replace with your group invite link

    if (await canLaunch(groupLink)) {
      await launch(groupLink);
    } else {
      throw 'Could not launch $groupLink';
    }
  }

  openWhatsapp() async {
    var contact = "+919868645544";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      CommonMethods.showToast('WhatsApp is not installed.');
    }
  }

  openDialerPad() async {
    const url = "tel:+91 9868645544";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = CommonMethods.deviceHeight(context);
    double w = CommonMethods.deviceWidth(context);
    TypeController typeController = Get.put(TypeController());
    return AppBasePage(
      appHeader: AppHomeHeader(
        titleUi: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: 'Welcome, ',
                  style: GoogleFonts.montserrat(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              TextSpan(
                  text: OpdSure.of(context).profileData!.name!,
                  style: GoogleFonts.montserrat(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: buttonColor)),
            ],
          ),
        ),
      ),
      childContent: ListView(
        children: [
          const AppTextView(
            text: 'Have a great day',
            color: Color(0xFF667085),
          ),
          SizedBox(
            height: h * 0.03,
          ),
          AppGradient(
            mChild: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/claim.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: w * 0.75,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTextView(
                                      text: '100 + Claims Filed',
                                      size: 13.0,
                                      color: Color(0xFF667085),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    AppTextView(
                                      text: 'File an OPD Claim',
                                      size: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Icon(Icons.keyboard_arrow_right_sharp)
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            width: w * 0.7,
                            child: const AppTextView(
                              text:
                                  'File your OPD Claim quickly and effortlessly, and let us take care of the rest',
                              size: 14.0,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            mCallback: () {
              widget.callback.call(1);
            },
            colorList: const [
              Color(0xFFfcf2f9),
              Color(0xFFede0f2),
              Color(0xFFe0dff5),
              Color(0xFFd3dff7),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          AppGradient(
            mChild: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppRoundView(
                        corner: 7.0,
                        color: Color(0xFF79ceff),
                        mChild: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.add_box,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: w * 0.75,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextView(
                                  text: 'Book Free Health Check-up',
                                  size: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(Icons.keyboard_arrow_right_sharp)
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            width: w * 0.7,
                            child: const AppTextView(
                              text:
                                  'Book your free health check -up today and prioritize your well-being with confidence.',
                              size: 14.0,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            mCallback: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCheckupPage()),
              );
            },
            colorList: const [
              Color(0xFFeff9ff),
              Color(0xFFd8f1ff),
              Color(0xFFc0e7ff),
              Color(0xFFcaebff),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppTextView(
                text: 'My Claims',
                color: Colors.black,
                size: 18.0,
                fontWeight: FontWeight.w500,
              ),
              InkWell(
                onTap: () {
                  widget.callback.call(1);
                },
                child: const Row(
                  children: [
                    AppTextView(
                      text: 'View all',
                      color: Color(0xFF98A2B3),
                      size: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: Color(0xFF98A2B3),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Obx(() {
            bool refresh = typeController.refreshClaimList.value;
            return SizedBox(
              height: h * 0.37,
              child: refresh
                  ? FutureBuilder<MyClaimsModel?>(
                      future: OpdSure.of(context).client.getAllClaims(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                            child: AppTextView(
                              text: 'Claims are loading...',
                            ),
                          );
                        } else {
                          MyClaimsModel? myClaimsModel = snapshot.data;
                          List<ClaimRecords> listData = myClaimsModel!.data!.records!;
                          return listData.isEmpty
                              ? const Center(
                                  child: AppTextView(
                                    text: 'No Claim Found',
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      listData.length > 3 ? 3 : listData.length,
                                  itemBuilder: (context, index) {
                                    ClaimRecords records = listData[index];
                                    ClaimStatusModel claimStatusModel =
                                        ClaimStatusModel().getClaimBuStatus(
                                            records.status!,
                                            reSubmit: records.resubmission!);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClaimsDetailsPage(
                                                      oneClaim: records,
                                                      isDispute: false,
                                                    )),
                                          );
                                        },
                                        child: AppCardView(
                                          mChaild: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppTextView(
                                                    text:
                                                        'Hospital | ${records.hospital} ',
                                                    size: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .keyboard_arrow_right_sharp,
                                                    color: Colors.black,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 2.0,
                                              ),
                                              AppTextView(
                                                text:
                                                    'Applicant name : ${records.memberId!.name}',
                                                size: 12.0,
                                                color: const Color(0xFF667085),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              AppTextView(
                                                text:
                                                    'Hospital : ${records.hospital!}',
                                                size: 12.0,
                                                color: const Color(0xFF667085),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              AppTextView(
                                                text:
                                                    'Claim ID : ${records.claimId}',
                                                size: 12.0,
                                                color: const Color(0xFF667085),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            'Claimable Amount: ',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                              0xFF667085),
                                                        )),
                                                    TextSpan(
                                                      text:
                                                          '$rupeeSymbol ${records.claimableAmount!.toDouble()}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color(
                                                                  0xFF027A48)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              AppTextView(
                                                text:
                                                'Claim Date: ${CommonMethods.formatIsoDateString(records.createdAt!)}',
                                                size: 12.0,
                                                color:
                                                const Color(0xFF667085),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              (records.status == 6 &&
                                                      !(records
                                                          .subscriberReaction!))
                                                  ? AppButton(
                                                      text:
                                                          'Clarification Required',
                                                height: 40.0,
                                                width: CommonMethods
                                                    .deviceWidth(
                                                    context),
                                                      textSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      onClick: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    FileClaimPage(
                                                              isUpdate:
                                                                  true,
                                                              records:
                                                                  records,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Row(
                                                      children: [
                                                        const AppTextView(
                                                          text: 'Status: ',
                                                          size: 12.0,
                                                          color: Color(
                                                              0xFF667085),
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                        ),
                                                        Icon(
                                                          claimStatusModel
                                                              .iconData,
                                                          color: claimStatusModel
                                                              .statusColor,
                                                          size: 15.0,
                                                        ),
                                                        AppTextView(
                                                          text:
                                                              ' ${claimStatusModel.statusName}',
                                                          size: 1.0,
                                                          color: claimStatusModel
                                                              .statusColor!,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                        ),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              if((records.status! == 2 || records.status! == 7 || records.status! == 12))...[
                                                !records.dispute!
                                                    ? AppButton(
                                                  text: 'Raise Dispute',
                                                  height: 40.0,
                                                  width: CommonMethods.deviceWidth(context),
                                                  textSize: 14.0,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  onClick: () {
                                                    Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ClaimsDetailsPage(oneClaim: records, isDispute: true,)),
                                                    );
                                                  },
                                                )
                                                    : const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.sync_sharp,
                                                      color: Colors.red,
                                                      size: 15.0,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    AppTextView(
                                                      text:
                                                      'Dispute Raised',
                                                      size: 12.0,
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                )
                                              ]
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        }
                      },
                    )
                  : Container(),
            );
          }),
        ],
      ),
      isFloatingButton: false,
      floatingView: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(HomePage.icons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller!,
                curve: Interval(0.0, 1.0 - index / HomePage.icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: buttonColor,
                mini: true,
                child: Icon(HomePage.icons[index], color: Colors.white),
                onPressed: () {
                  switch (index) {
                    case 0:
                      openWhatsapp();
                      break;
                    case 1:
                      openDialerPad();
                      break;
                    case 2:
                      joinWhatsAppGroup();
                      break;
                  }
                },
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
              heroTag: null,
              child: AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) {
                  return Transform(
                    transform:
                        Matrix4.rotationZ(_controller!.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(_controller!.isDismissed
                        ? Icons.support_agent_outlined
                        : Icons.close),
                  );
                },
              ),
              onPressed: () {
                if (_controller!.isDismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
            ),
          ),
      ),
    );
  }
}
