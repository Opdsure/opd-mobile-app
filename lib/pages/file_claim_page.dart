import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';
import 'package:opdsure/custom_ui/app_button.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/get_controllers/type_controller.dart';
import 'package:opdsure/model/claim/calculate_claim_model.dart';
import 'package:opdsure/model/claim_json_model.dart';
import 'package:opdsure/model/common_map/claim_type_model.dart';
import 'package:opdsure/model/my_member_model.dart';
import 'package:opdsure/model/single_claim_model.dart';
import 'package:opdsure/model/subscribed_plan_model.dart';
import 'package:opdsure/pages/add_family_details/add_family_details.dart';
import 'package:opdsure/pages/upload_file_claim_doc.dart';
import 'package:opdsure/utils/app_var.dart';
import 'package:opdsure/widget/opd_widget.dart';
import '../custom_ui/app_bottom_sheet.dart';
import '../custom_ui/app_edit_text.dart';
import '../custom_ui/app_mobile_field.dart';
import '../custom_ui/app_text_view.dart';
import '../model/my_claims_model.dart';
import '../model/plans/plans_response.dart';
import '../model/state_model.dart';
import '../repository/network_api/api.dart';
import '../utils/app_colors.dart';
import '../utils/common_methods.dart';
import  'package:fl_country_code_picker/fl_country_code_picker.dart' as flc;

class FileClaimPage extends StatefulWidget{
  final ClaimRecords? records;
  final bool? isUpdate;
  FileClaimPage({this.records, this.isUpdate});
  @override
  State<FileClaimPage> createState() => _FileClaimPageState();
}

class _FileClaimPageState extends State<FileClaimPage> {
  TextEditingController phoneCtrl = TextEditingController();

  TextEditingController docNameCtrl = TextEditingController();

  TextEditingController regNumCtrl = TextEditingController();

  TextEditingController specialCtrl = TextEditingController();

  TextEditingController hsptlNameCtrl = TextEditingController();

  TextEditingController cityCtrl = TextEditingController();

  TextEditingController emailCtrl = TextEditingController();

  TextEditingController diagnosisCtrl = TextEditingController();

  TextEditingController remarkCtrl = TextEditingController();

  TextEditingController docFeeCtrl = TextEditingController();

  TextEditingController docFeeClCtrl = TextEditingController();

  TextEditingController billAmntPhrCtrl = TextEditingController();

  TextEditingController billAmntPhrClCtrl = TextEditingController();

  TextEditingController billAmntDiaCtrl = TextEditingController();

  TextEditingController billAmntDiaClCtrl = TextEditingController();


  double _value1 = 0.0;
  double _value2 = 0.0;
  double _value3 = 0.0;
  double _value11 = 0.0;
  double _value12 = 0.0;
  double _value13 = 0.0;
  double totalBillAmnt = 0.0;
  double totalClaimableAmnt = 0.0;
  String claimId = '';
  String claimCombination = '';

  PlanRecords? records;
  ClaimRecords? cRecords;
  SingleClaimModel? singleClaimModel;

  void _calculateSum() {
    setState(() {
        totalClaimableAmnt = _value11 + _value12 + _value13;
        totalBillAmnt = _value1 + _value2 + _value3;
    });
  }

  void docFee({String? value = '0'}) async {
    var data = await OpdSure.of(context).client.calculateClaimPrice('0', double.parse(value!));
    CalculateClaimModel calculateClaimModel = CalculateClaimModel.fromJson(jsonDecode(data));
    setState(() {
        _value11 = double.parse('${calculateClaimModel.data!.finalPrice??'0.0'}');
        _value1 = double.tryParse(value.toString()) ??0.0;
        docFeeClCtrl.text = _value11.toStringAsFixed(0);
      _calculateSum();
    });
  }

  void pharmaBill({String? value = '0'}) async {
    String calculator = claimCombination=='1'?'1':'3';
    var data = await OpdSure.of(context).client.calculateClaimPrice(calculator, double.parse(value!));
    CalculateClaimModel calculateClaimModel = CalculateClaimModel.fromJson(jsonDecode(data));
    setState(() {
      _value12 = double.parse('${calculateClaimModel.data!.finalPrice??'0.0'}');
      _value2 = double.tryParse(value.toString()) ??0.0;
      billAmntPhrClCtrl.text = _value12.toStringAsFixed(0);
      _calculateSum();
    });
  }

  void labBill({String? value = '0'}) async {
    var data = await OpdSure.of(context).client.calculateClaimPrice('2', double.parse(value!));
    CalculateClaimModel calculateClaimModel = CalculateClaimModel.fromJson(jsonDecode(data));
    setState(() {
      _value13 = double.parse('${calculateClaimModel.data!.finalPrice??'0.0'}');
      _value3 = double.tryParse(value.toString()) ?? 0.0;
      billAmntDiaClCtrl.text = _value13.toStringAsFixed(0);
      _calculateSum();
    });
  }

  @override
  void initState() {
    super.initState();
    TypeController typeController = Get.put(TypeController());
    typeController.opdVisitDateChange('');
    typeController.selectClaimChange('');
    typeController.memberList.clear();
    typeController.stateList.clear();
    _getInitState();
    if(widget.isUpdate!){
      cRecords = widget.records!;
      claimId = cRecords!.id!;
      typeController.selectClaimChange('${cRecords!.claimType!}');
      OpdSure.of(context).client.getAllState().then((value){
        StateModel stateModel = statemodelFromJson(value);
        List<StateListData> stateListData = stateModel.data;
        if(typeController.stateList.value.isNotEmpty){
          typeController.stateList.value.clear();
        }
        typeController.stateListChange(stateListData[cRecords!.state!]);
      });
      MemberList memberList = MemberList(id: cRecords!.memberId!.id,name: cRecords!.memberId!.name,relation: cRecords!.memberId!.relation);
      typeController.memberListChange(memberList);
      typeController.opdVisitDateChange(cRecords!.opdDate!);
      phoneCtrl.text = '${cRecords!.docPhone!}';
      docNameCtrl.text = cRecords!.docName!;
      regNumCtrl.text = cRecords!.docRegistration!;
      specialCtrl.text = cRecords!.specialization??'';
      hsptlNameCtrl.text = cRecords!.hospital!;
      cityCtrl.text = cRecords!.city!;
      // emailCtrl.text = cRecords!.email!;
      diagnosisCtrl.text = cRecords!.diagonosisDetail!;
      // remarkCtrl.text = cRecords!.remark!
      docFeeCtrl.text = '${cRecords!.doctorFee!}';
      docFeeClCtrl.text = '${cRecords!.claimableDoctorFee!}';


      OpdSure.of(context).client.getSingleClaims(cRecords!.id!).then((value){
        singleClaimModel = SingleClaimModel.fromJson(jsonDecode(value));
      });
    }
    OpdSure.of(context).client.getSubscribedPlan().then((value){
      SubscribedPlanModel subscribedPlanModel = value;
      setState(() {
        claimCombination = '${subscribedPlanModel.data!.claimCombination}';
        if(widget.isUpdate!){
          if(claimCombination == '2'){
            totalBillAmnt = cRecords!.doctorFee!.toDouble()+(cRecords!.combinedPharmacyTestFees??0.0).toDouble();
            totalClaimableAmnt = cRecords!.claimableDoctorFee!.toDouble()+(cRecords!.claimableCombinedPharmacyTestFees??0.0).toDouble();
            billAmntPhrCtrl.text = '${cRecords!.combinedPharmacyTestFees}';
            billAmntPhrClCtrl.text = '${cRecords!.claimableCombinedPharmacyTestFees}';
          }
          else{
            billAmntPhrCtrl.text = cRecords!.pharmacyFee==null?'':'${cRecords!.pharmacyFee!}';
            billAmntPhrClCtrl.text = cRecords!.claimablePharmacyFee==null?'':'${cRecords!.claimablePharmacyFee!}';
            billAmntDiaCtrl.text = cRecords!.labTestFee==null?'':'${cRecords!.labTestFee!}';
            billAmntDiaClCtrl.text = cRecords!.claimableLabTestFee==null?'':'${cRecords!.claimableLabTestFee!}';
            totalBillAmnt = cRecords!.doctorFee!.toDouble()+(cRecords!.pharmacyFee??0.0).toDouble()+(cRecords!.labTestFee??0.0).toDouble();
            totalClaimableAmnt = cRecords!.claimableDoctorFee!.toDouble()+(cRecords!.claimablePharmacyFee??0.0).toDouble()+(cRecords!.claimableLabTestFee??0.0).toDouble();
          }
        }
      });
    });
  }

  _getInitState() async {
    final opd = OpdSure.of(context);
    final profile = await opd.client.getProfile();
    records = await opd.client.getPlanById(planId: profile.data!.plan!.id!, memberShipId: profile.data!.plan!.membershipId!);
  }

  final countryPicker = const FlCountryCodePicker();
  List<File> files = [];
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context,TypeController typeController) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().add(const Duration(days: -6)),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      typeController.opdVisitDateChange(formattedDate);
    }
  }
  List<Claim> claimList = [Claim(id: '0', value: 'OPD'),Claim(id: '1', value: 'PHARMACY'),Claim(id: '2', value: 'LAB TEST')];
  String getClaimName(String id){
    switch(id){
      case '0':
        return 'OPD';
      case '1':
        return 'PHARMACY';
      case '2':
        return 'LAB TEST';
      default:
        return 'OPD';
    }
  }

  Widget compulsoryField(String text){
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: text,
              style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D2939)
              )),
          TextSpan(
              text: ' *',
              style: GoogleFonts.montserrat(
                   color: Colors.red),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TypeController typeController = Get.put(TypeController());
    double w = CommonMethods.deviceWidth(context);
    double h = CommonMethods.deviceHeight(context);
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: 'File a Claim',),
      childContent: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ListView(
          children: [
            compulsoryField('Claim Type'),
            InkWell(
              onTap: ()async{
                AppBottomSheet(
                    height: h*0.3,
                    mChild: ListView.builder(
                      itemCount: claimList.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            typeController.selectClaimChange(claimList[index].id);
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: AppTextView(
                                  text: claimList[index].value,
                                ),
                              ),
                              const Divider(height: 1,),
                            ],
                          ),
                        );
                      },
                    )
                ).modalBottomSheetMenu(context);
              },
              child: AppBorderBox(
                myChild: Obx((){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: typeController.selectClaim.value==''?'Select Claim':CommonMethods.getClaimNameById(typeController.selectClaim.value),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Color(0xff667085),
                        size: 24.0,
                      )
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 15.0),
            compulsoryField('User'),
            Obx((){
              bool refresh = typeController.refreshMemberList.value;
              return refresh?FutureBuilder(
                future: OpdSure.of(context).client.getFamilyMember(update: true),
                builder: (context,snapshot){
                  if(snapshot.data == null){
                    return const AppEditText(
                      hint: 'getting users...',
                      disableText: true,
                      viewSuffix: true,
                      suffixWidget: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Color(0xff667085),
                        size: 24.0,
                      ),
                    );
                  }
                  else{
                    return InkWell(
                      onTap: (){
                        MyMemberModel myMemberModel = snapshot.data!;
                        List<MemberList>? memberList = myMemberModel.data;
                        AppBottomSheet(
                            height: 600,
                            mChild: memberList!.isEmpty?InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFamilyDetails(isUpdate: false,isFirstMember: false,)));
                              },
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppTextView(
                                      text: 'No Family member added',
                                      color: buttonColor,
                                      size: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: 10.0,),
                                    Icon(
                                      Icons.add_circle,
                                      color: buttonColor,
                                    ),
                                    AppTextView(
                                      text: 'Add Member',
                                      color: buttonColor,
                                      size: 12.0,
                                    )
                                  ],
                                ),
                              ),
                            ):ListView.builder(
                              itemCount: memberList.length,
                              itemBuilder: (context, index){
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      if(typeController.memberList.value.isNotEmpty){
                                        typeController.memberList.value.clear();
                                      }
                                      typeController.memberListChange(memberList[index]);
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AppTextView(
                                                text: memberList[index].name!,
                                                size: 16.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              AppTextView(
                                                text: '${memberList[index].phone!}',
                                                size: 14.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1,color: Color(0x1A101828),),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                        ).modalBottomSheetMenu(context);
                      },
                      child: AppBorderBox(
                        myChild: Obx((){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextView(
                                text: typeController.memberList.value.isEmpty?'Select User':typeController.memberList.first.name!,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Color(0xff667085),
                                size: 24.0,
                              )
                            ],
                          );
                        }),
                      ),
                    );
                  }
                },
              ):Container();
            }),
            const SizedBox(height: 15.0,),
            compulsoryField('OPD Visit Date'),
            Obx((){
              String date = typeController.opdVisitDate.value;
              String showDate = '';
              if(date!=''){
                showDate = CommonMethods.changeDateFormat(date,from: 'yyyy-MM-dd',to: 'dd/MM/yyyy');
              }
              return Stack(
                children: [
                  AppEditText(
                    hint: date.isEmpty?'Enter OPD Visit Date':showDate,
                    disableText: true,
                    viewSuffix: true,
                    suffixWidget: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xff667085),
                      size: 24.0,
                    ),
                    eyeCallback: (){
                      _selectDate(context, typeController);
                    },
                  ),
                  InkWell(
                    onTap: (){
                      _selectDate(context, typeController);
                    },
                    child: SizedBox(
                      height: 40,
                      width: w*0.8,
                    ),
                  )
                ],
              );
            }),
            const SizedBox(height: 15.0),
            compulsoryField('Doctor Name'),
            AppEditText(
              hint: 'Enter the name',
              textEditingController: docNameCtrl,
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: 15.0),
            compulsoryField('Doc Reg. Number'),
            AppEditText(
              hint: 'Enter doc Reg. Number',
              textEditingController: regNumCtrl,
              textInputType: TextInputType.name,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
              ],
            ),
            const SizedBox(height: 15.0),
            const AppTextView(
              text: 'Specialization',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            AppEditText(
              hint: 'Enter Specialization',
              textEditingController: specialCtrl,
              textInputType: TextInputType.name,),
            const SizedBox(height: 15.0),
            compulsoryField('Hospital Name'),
            AppEditText(
              hint: 'Enter hospital Name',
              textEditingController: hsptlNameCtrl,
              textInputType: TextInputType.name,),
            const SizedBox(height: 15.0,),
            compulsoryField('State'),
            InkWell(
              onTap: ()async{
                var data = await OpdSure.of(context).client.getAllState();
                StateModel stateModel = statemodelFromJson(data);
                List<StateListData> stateListData = stateModel.data;
                AppBottomSheet(
                    height: 600,
                    mChild: ListView.builder(
                      itemCount: stateListData.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            if(typeController.stateList.value.isNotEmpty){
                              typeController.stateList.value.clear();
                            }
                            typeController.stateListChange(stateListData[index]);
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: AppTextView(
                                  text: stateListData[index].name,
                                ),
                              ),
                              const Divider(height: 1,color: Color(0x1A101828),),
                            ],
                          ),
                        );
                      },
                    )
                ).modalBottomSheetMenu(context);
              },
              child: AppBorderBox(
                myChild: Obx((){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextView(
                        text: typeController.stateList.value.isEmpty?'Select State':typeController.stateList.value.first.name,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Color(0xff667085),
                        size: 24.0,
                      )
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 15.0,),
            compulsoryField('City'),
            AppEditText(
              hint: 'Enter the city',
              textEditingController: cityCtrl,
            ),
            const SizedBox(height: 15.0),
            const AppTextView(
              text: 'Email',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            AppEditText(
              hint: 'Enter email',
              textEditingController: emailCtrl,
              textInputType: TextInputType.emailAddress,),
            const SizedBox(height: 15.0),
            compulsoryField('Hospital Contact Info.'),
            Obx((){
              String countryCode = typeController.countryCode.value;
              String flagCode = typeController.flagCode.value;
              return AppMobileField(
                hint: 'Enter number',
                countryCode: countryCode.isEmpty?'+91':countryCode,
                textEditingController: phoneCtrl,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                ],
                flagUri: flagCode.isEmpty?'${mFlagUri}in.png':'$mFlagUri$flagCode.png',
                countryCallback: () async {
                  // Show the country code picker when tapped.
                  final picked =
                  await countryPicker.showPicker(context: context);
                  // Null check
                  if (picked != null){
                    print(picked);
                    typeController.countryCodeChange(picked.dialCode);
                    typeController.flagCodeChange(picked.code.toLowerCase());
                  }
                },
              );
            }),
            const SizedBox(height: 15.0),
            compulsoryField('Reason for Doctor Consultation'),
            AppEditText(
              hint: 'Enter Reason',
              textEditingController: diagnosisCtrl,
              textInputType: TextInputType.name,),
            const SizedBox(height: 15.0),
            const AppTextView(
              text: 'Additional Information',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            AppEditText(
              hint: 'Enter Additional Information',
              textEditingController: remarkCtrl,
              textInputType: TextInputType.name,),


            const SizedBox(height: 15.0),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppTextView(
                        text: 'Doctor Fees',
                        size: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D2939),
                      ),
                      AppEditText(
                        hint: 'Enter value',
                        textEditingController: docFeeCtrl,
                        textInputType: TextInputType.number,
                        mOnChanged: (value){
                          docFee(value: value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0,),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppTextView(
                        text: 'Claimable Amt.',
                        size: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D2939),
                      ),
                      AppEditText(
                        disableText: true,
                        hint: '',
                        textEditingController: docFeeClCtrl,
                        textInputType: TextInputType.number,
                        mOnChanged: (value){
                          docFee(value : value);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 15.0),
            AppTextView(
              text: claimCombination == '2'?'Pharmacy + Diagnostics':'Bill Amt. for Pharmacy',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1D2939),
            ),
            Row(
              children: [
                Flexible(child: AppEditText(
                  hint: 'Enter value',
                  textEditingController: billAmntPhrCtrl,
                  textInputType: TextInputType.number,
                  mOnChanged: (value){
                    pharmaBill(value: value);

                  },
                )),
                const SizedBox(width: 10,),
                Flexible(child: AppEditText(
                  hint: '',
                  disableText: true,
                  textEditingController: billAmntPhrClCtrl,
                  textInputType: TextInputType.number,
                  mOnChanged: (value){
                    pharmaBill(value: value);
                  },
                ))
              ],
            ),
            const SizedBox(height: 15.0),
            claimCombination == '2'?Container():Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppTextView(
                  text: 'Bill Amt. for Diagnostics',
                  size: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D2939),
                ),
                Row(
                  children: [
                    Flexible(child: AppEditText(hint: 'Enter value',
                      textEditingController: billAmntDiaCtrl,
                      textInputType: TextInputType.number,
                      mOnChanged: (value){
                        labBill(value: value);
                      },
                    )),
                    const SizedBox(width: 10,),
                    Flexible(child: AppEditText(hint: '',
                      disableText: true,
                      textEditingController: billAmntDiaClCtrl,
                      textInputType: TextInputType.number,
                      mOnChanged: (value){
                        labBill(value: value);
                      },
                    ))
                  ],
                ),
                const SizedBox(height: 15.0),
              ],
            ),
            const AppTextView(
              text: 'Grand Total',
              size: 14.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1D2939),
            ),
            Row(
              children: [
                Flexible(
                  child: AppBorderBox(
                    myChild: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AppTextView(
                        text: '$totalBillAmnt',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0,),
                Flexible(
                  child: AppBorderBox(
                    myChild: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AppTextView(
                        text: '$totalClaimableAmnt',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15.0),
            AppButton(
              text: 'Next',
              onClick: (){
                if(typeController.selectClaim.value.isEmpty){
                  CommonMethods.showToast('select claim type');
                  return;
                }
                if(typeController.memberList.value.isEmpty){
                  CommonMethods.showToast('select user');
                  return;
                }
                if(typeController.opdVisitDate.value.isEmpty){
                  CommonMethods.showToast('select opd visit date');
                  return;
                }
                if(docNameCtrl.text.isEmpty){
                  CommonMethods.showToast('enter doctor name.');
                  return;
                }
                if(regNumCtrl.text.isEmpty){
                  CommonMethods.showToast('enter doctor regs no.');
                  return;
                }else{
                  if(regNumCtrl.text.length < 4){
                    CommonMethods.showToast('doctor regs no should be 4 digit');
                    return;
                  }
                }
                if(hsptlNameCtrl.text.isEmpty){
                  CommonMethods.showToast('enter hospital name.');
                  return;
                }
                if(typeController.stateList.value.isEmpty){
                  CommonMethods.showToast('select state');
                  return;
                }
                if(cityCtrl.text.isEmpty){
                  CommonMethods.showToast('enter city.');
                  return;
                }
                if(phoneCtrl.text.isEmpty){
                  CommonMethods.showToast('enter phone no.');
                  return;
                }
                if(diagnosisCtrl.text.isEmpty){
                  CommonMethods.showToast('enter diagnosis details no.');
                  return;
                }
                if(docFeeCtrl.text.isEmpty){
                  docFeeCtrl.text ='0';
                }
                if(billAmntPhrCtrl.text.isEmpty){
                  billAmntPhrCtrl.text ='0';
                }
                if(billAmntDiaCtrl.text.isEmpty){
                  billAmntDiaCtrl.text ='0';
                }
                if(docFeeClCtrl.text.isEmpty){
                  docFeeClCtrl.text ='0';
                }
                if(billAmntPhrClCtrl.text.isEmpty){
                  billAmntPhrClCtrl.text ='0';
                }
                if(billAmntDiaClCtrl.text.isEmpty){
                  billAmntDiaClCtrl.text ='0';
                }


                ClaimJsonModel claimJsonModel = ClaimJsonModel(
                  memberId: typeController.memberList.value.first.id,
                  opdDate: typeController.opdVisitDate.value,
                  docCountryCode: typeController.countryCode.value,
                  docPhone: phoneCtrl.text,
                  doctorFee: docFeeCtrl.text,
                  userRemark: remarkCtrl.text.isEmpty?null:remarkCtrl.text,
                  id: widget.isUpdate!?singleClaimModel!.data!.id:null,
                  docEmail: emailCtrl.text.isEmpty?null:emailCtrl.text,
                  pharmacyFee: claimCombination=='1'?billAmntPhrCtrl.text:null,
                  labTestFee: claimCombination=='1'?billAmntDiaCtrl.text:null,
                  claimableDoctorFee: int.tryParse(docFeeClCtrl.text),
                  claimablePharmacyFee: claimCombination=='1'?int.tryParse(billAmntPhrClCtrl.text):null,
                  claimableLabTestFee: claimCombination=='1'?int.tryParse(billAmntDiaClCtrl.text):null,
                  claimType: typeController.selectClaim.value,
                  docName: docNameCtrl.text,
                  docRegistration: regNumCtrl.text,
                  diagonosisDetail: diagnosisCtrl.text,
                  hospital: hsptlNameCtrl.text,
                  city: cityCtrl.text,
                  state: typeController.stateList.value.first.id,
                  specialization: specialCtrl.text.isEmpty ? null : specialCtrl.text,
                  billAmount: '$totalBillAmnt',
                  claimableAmount: '$totalClaimableAmnt',
                  prescription: widget.isUpdate!?singleClaimModel!.data!.prescription:[],
                  feeReceipt: widget.isUpdate!?singleClaimModel!.data!.feeReceipt:[],
                  pharmacyReceipt: widget.isUpdate!?singleClaimModel!.data!.pharmacyReceipt:[],
                  testReceipt: widget.isUpdate!?singleClaimModel!.data!.testReceipt:[],
                  claimCombination: claimCombination.isEmpty?'1':claimCombination,
                  combinedPharmacyTestFees: claimCombination=='2'?billAmntPhrCtrl.text:null,
                  claimableCombinedPharmacyTestFees: claimCombination=='2'?billAmntPhrClCtrl.text:null
                );
                typeController.prescriptionList.clear();
                typeController.docFeeRcpt.clear();
                typeController.pharmacyRcpt.clear();
                typeController.labTestRcpt.clear();
                Map<String,dynamic>? docMap;
                if(widget.isUpdate!) {
                  docMap = {
                    'prescription_d': cRecords!.prescription,
                    'doc_fee_d': cRecords!.feeReceipt,
                    'pharmacy_d': cRecords!.pharmacyReceipt,
                    'test_d': cRecords!.testReceipt,
                  };
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>UploadFileClaimDoc(claimJsonModel,isUpdate: widget.isUpdate,claimId: claimId,documentMap: docMap,)),
                );
              },
            ),
            const SizedBox(height: 20.0),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'Disclaimer: ',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: buttonColor
                      )),
                  TextSpan(
                    text: 'All the documents that are uploaded in the OPDSure Application, will be used only for the claim settlement. The uploaded documents will not be used for any other use in any scenario.',
                    style: GoogleFonts.montserrat(color: buttonColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}