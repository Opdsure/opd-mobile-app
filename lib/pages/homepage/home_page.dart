import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_home_header.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/custom_ui/claim_count_tile.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/pages/claim_pages/claim_tile.dart';
import 'package:opdsure/pages/homepage/home_service_tile.dart';
import 'package:opdsure/utils/common_methods.dart';
import 'package:opdsure/widget/opd_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_config.dart';
import '../../custom_ui/app_rich_text.dart';
import '../../model/claim_status_model.dart';
import '../../model/my_claim/my_claims_model.dart';

typedef ValueCallback = void Function(int value);

class OpdService {
  String image;
  String title;
  VoidCallback onTap;

  OpdService({required this.title, required this.onTap, required this.image});
}

class HomePage extends StatefulWidget {
  final ValueCallback callback;

  const HomePage({required this.callback, super.key});

  static const List<IconData> icons = [
    Icons.chat,
    Icons.phone,
    Icons.group_add
  ];

  static List<OpdService> serviceTittle(BuildContext context, {ValueCallback? callBack}) => [
    OpdService(
      title: 'In-Clinic Doctor',
        image: 'assets/images/offline_doc.png',
      onTap: (){
          CommonMethods.customAlertBox(context,
            title: 'In-Clinic Consultation',
            message: 'Visit any clinic in India.',
          );
      }
    ),
    OpdService(
        title: 'Online Doctor',
        image: 'assets/images/online_doc.png',
        onTap: () async {
          CommonMethods.showAlertDialog(context);
          final opd = OpdSure.of(context);
          if(opd.profileData!.plan!.purchased!){
            try {
              final mfine = await opd.client.mFine();
              Navigator.of(context).pop();
              context.push('/home/web_view', extra: mfine.data!.redirectUrl!);
            }catch(e){
              Navigator.of(context).pop();
              CommonMethods.customAlertBox(context,
                title: 'Alert',
                message: "Service coming soon",
              );
            }
          }else{
            Navigator.of(context).pop();
            CommonMethods.customAlertBox(context,
              title: 'Alert',
              message: "You don't have a valid plan to consult a doctor. Please purchase a plan first.",
            );
          }
        }),
    OpdService(
        title: 'Pharmacy',
        image: 'assets/images/pharma.png',
        onTap: () async {
      CommonMethods.customAlertBox(context,
        negativeButton: 'PharmEasy',
        positiveButton: 'Apollo 24/7',
        okCallBack: (context1){
        Navigator.of(context1, rootNavigator: true).pop();
        context.push('/home/web_view', extra: AppConfig.apolloPharmaUrll);
        },
        cancelCallBack: (context1){
          Navigator.of(context1, rootNavigator: true).pop();
          context.push('/home/web_view', extra: AppConfig.pharmaEasyUrl);
        },
        isCancelButton: true,
        message: "Please select one",
        title: "Pharmacy",
        shouldDismiss: true,
      );
        }),
    OpdService(
        title: 'Diagnostic',
        image: 'assets/images/diag.png',
        onTap: (){
          context.push('/home/web_view', extra: AppConfig.apolloPharmaUrl);
        }),
    OpdService(
        title: 'Free Health Checkups',
        image: 'assets/images/health.png',
        onTap: (){
          final opd = OpdSure.of(context);
          if(opd.profileData!.plan!.purchased!){
            context.push('/home/book_checkup/add_health_checkup');
          }else{
            Navigator.of(context).pop();
            CommonMethods.customAlertBox(context,
              title: 'Alert',
              message: "You don't have a valid plan to book . Please purchase a plan first.",
            );
          }
        }),
    OpdService(
        title: 'Ambulance',
  image: 'assets/images/ambu.png',
        onTap: (){
          launchUrl(Uri(
            scheme: 'tel',
            path: '102',
          ));
        }),


    OpdService(
        title: 'Simplify Insurance',
        image: 'assets/images/insurance.png',
        onTap: (){
          context.push('/home/web_view', extra: 'https://www.smcinsurance.com/?user=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiT1BEIFN1cmUiLCJ1bmlxdWVfbmFtZSI6Ik9QRCBTdXJlIiwicm9sZSI6IjI5IiwiZW1haWwiOiJ1bWVzaC5nQG9wZHN1cmUuY29tIiwibmFtZWlkIjoiNTIiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiMTkwNDI1IiwiUm9sZU5hbWUiOiJBZmZpbGlhdGUiLCJNb2JpbGVObyI6Ijg4MDA2MTQ1ODgiLCJQb3NDb2RlIjoiMCIsImJscGF5bG9hZCI6IiIsImNscGF5bG9hZCI6IiIsInVzZXJ0b2tlbiI6ImVmYTBhZDM0ZGY4NDQ3ZmQ4ZWI5YjUyZjJjYWRiOGFhIiwibmJmIjoxNzI1OTYxMjk2LCJleHAiOjE3MjYwNDc2OTYsImlhdCI6MTcyNTk2MTI5NiwiaXNzIjoiaHR0cHM6Ly93d3cuc21jaW5zdXJhbmNlLmNvbSIsImF1ZCI6Imh0dHBzOi8vd3d3LnNtY2luc3VyYW5jZS5jb20ifQ.V4WobGKx6g6eJ72aNjVM5n1AjLGb4Rn7gAlXMxG4RY4&BusinessID=');
        }),
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
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
        title: AppRichText(
          textSpan: TextSpan(
            children: [
              TextSpan(
                  text: 'Welcome, ',
                  style: GoogleFonts.montserrat(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              TextSpan(
                  text: OpdSure.of(context).profileData!.name!,
                  style: GoogleFonts.montserrat(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppConfig.primaryColor)),
            ],
          ),
        ),
      ),
      childContent: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTextView(
              text: 'Services',
              color: Colors.black,
              size: 18.0,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: [
                GridView.builder(
                  itemCount: HomePage.serviceTittle(context).length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return HomeServiceTile(
                        width: 100,
                        height: 100,
                        index : index,
                        title: HomePage.serviceTittle(context)[index],
                        onTap: HomePage.serviceTittle(context, callBack: (value){
                          widget.callback(value);
                        })[index].onTap
                    );
                  }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0, // Optional: Adjust height-to-width ratio
                ),
                ),
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
                  fontWeight: FontWeight.w700,
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
              return refresh
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
                          List<ClaimRecords> listData =
                              myClaimsModel!.data!.records!;
                          return listData.isEmpty
                              ? const Center(
                                  child: AppTextView(
                                    text: 'No Claim Found',
                                  ),
                                )
                              : Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: ClaimCountTile(count: myClaimsModel.data!.getTotalClaim, title: 'Total Claims')),
                                            Expanded(child: ClaimCountTile(count: myClaimsModel.data!.getPendingClaim, title: 'Pending Claims')),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: ClaimCountTile(count: myClaimsModel.data!.getRejectedClaim, title: 'Rejected Claims')),
                                            Expanded(child: ClaimCountTile(count: myClaimsModel.data!.getSettledClaim, title: 'Settled Claims')),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      itemCount: listData.length > 3 ? 3 : listData.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {

                                        ClaimRecords records = listData[index];
                                        ClaimStatusModel claimStatusModel =
                                            ClaimStatusModel().getClaimBuStatus(
                                                records.status!!,
                                                reSubmit: records.resubmission!);
                                        ClaimStatusModel disputeClaimStatus =
                                            ClaimStatusModel().getDisputeClaimBuStatus(records.disputeDetails!);
                                        return ClaimTile(
                                            records: records,
                                            claimStatus: claimStatusModel,
                                            disputeClaimStatus: disputeClaimStatus);



                                      },
                                    ),
                                ],
                              );
                        }
                      },
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }
}
