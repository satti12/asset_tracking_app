// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Clean%20&%20Decontam/Comp_for_decontam.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:asset_tracking/main.dart';

class DecontaminationPage extends StatefulWidget {
  String? CurrentLocation;
  DecontaminationPage({super.key, this.CurrentLocation});
  @override
  _DecontaminationPageState createState() => _DecontaminationPageState();
}

class _DecontaminationPageState extends State<DecontaminationPage> {
  Asset containerData = new Asset();

  Future<Asset> fetchDecontamination(String rfId) async {
    if (rfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList(
          'assets',
          [
            ['rf_id', '=', rfId],
            ['status', '=', AssetStatus.IN_CLEANING],
          ],
          {},
          limit: null);

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        setState(() {
          containerData = response[0];
        });
        // await DatabaseHelper.instance.updateAsset(containerData);
        return response[0];
      } else {
        Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
        throw Exception('Cannot Find Bundle with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  void decontaminated() async {
    containerData.status = AssetStatus.IN_CLEARANCE;
    containerData.batch_no = batch_no.text.toString();
    var modifiedAsset =
        await DatabaseHelper.instance.updateAsset(containerData);

    AssetLog log = new AssetLog();
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.IN_CLEARANCE;

    var template = eventDefinition[eventType].toString();
    Map<String, String> variables = {
      'asset_type': containerData.asset_type.toString(),
      'rf_id': containerData.rf_id.toString(),
      'current_location': userInfo['location_name'],
      'product_no': containerData.product_no.toString(),
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    var eventDesc = replaceVariables(template, variables);

    log.asset_id = containerData.asset_id.toString();
    log.rf_id = containerData.rf_id.toString();
    log.event_type = eventType;
    log.status = containerData.status.toString();
    log.current_transaction = jsonEncode(modifiedAsset.toMap());
    log.event_description = eventDesc;
    log.current_location_id = userInfo['locationId'];
    log.asset_type = containerData.asset_type.toString();

    DatabaseHelper.instance.createAssetLog(log);

    Get.to(NewBottomNavigation());
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   rf_id.clear();
  //   super.dispose();
  // }
  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  TextEditingController batch_no = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            (containerData.rf_id == null || batch_no.text.isEmpty)
                ? SizedBox()
                : TextButton(
                    onPressed: () {
                      decontaminated();
                    },
                    child: Center(
                      child: Text(
                        'Done',
                        style: GoogleFonts.mulish(
                          color: Color(0xFFA80303),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ),
                  ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // here goes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Decontaminate',
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.48,
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // Add your functionality here
                  //   },
                  //   child: Container(
                  //     width: 34.w,
                  //     height: 34.h,
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFFF9F9F9),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Center(
                  //       child: SvgPicture.asset(
                  //         'images/svg/text.svg',
                  //         width: 20.w,
                  //         height: 20.h,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'images/svg/loca_icon.svg',
                    height: 20.h,
                    width: 20.w,
                    color: Color(0xFFA80303),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.CurrentLocation.toString(),
                    style: GoogleFonts.mulish(
                      color: Color(0xFF808080),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 0,
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),
              // here comes the RFID Scanner for scaning

              Container(
                width: MediaQuery.sizeOf(context).width / .9,
                height: 50,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: TextFormField(
                  controller: rf_id,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onEditingComplete: () {
                    fetchDecontamination(rf_id.text);
                  },
                  decoration: InputDecoration(
                      hintText: 'Scan  RFID',
                      suffixIcon: Container(
                        width: 91.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (rf_id.text.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  rf_id.clear();
                                },
                              ),
                            InkWell(
                              onTap: () {
                                if (rf_id.text.isNotEmpty) {
                                  fetchDecontamination(rf_id.text);
                                } else {
                                  sendActionToNative("Pressed");
                                }
                              },
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: Color(0xFFA80303),
                                  shape: BoxShape
                                      .circle, // Use BoxShape.circle for a circular shape
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'images/svg/scaner.svg',
                                    height: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      helperStyle: GoogleFonts.mulish(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.28,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 8, left: 15)),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),
              // here come the Card that containes all containers info Scanned from RFID
              DecontanContainer(
                structureType:
                    '${(containerData.product == null && containerData.asset_type == 'Container') ? containerData.container_type : (containerData.product != null ? containerData.product : containerData.asset_type) ?? ''}',

                // '${(containerData.product == null && containerData.asset_type == 'Container') ? containerData.container_type : (containerData.product != null ? containerData.product : containerData.asset_type)}',

                // structureType: '${containerData.product ?? ''}',
                rfid: 'RFID# ${containerData.rf_id ?? ''}',
                BundleID: containerData.bundle_no == null &&
                        containerData.batch_no == null
                    ? '' // both are null, return empty string
                    : containerData.bundle_no == null
                        ? 'Batch#        ${containerData.batch_no ?? ' '}' // bundle_no is null, use batch_no
                        : 'Bundle#       ${containerData.bundle_no ?? ' '}', // bundle_no is not null, use it

                TFMC: (containerData.product_no == null &&
                        containerData.drum_no == null)
                    ? '' // If both are null, return an empty string
                    : (containerData.product_no == null
                        ? 'Drum # ${containerData.drum_no}'
                        : 'TFMC ID# ${containerData.product_no}'),

                // containerData.product_no == null
                //     ? 'Drum # ${containerData.drum_no} '
                //     : 'TFMC ID# ${containerData.product_no} ',
                //' ${containerData.product_no ?? ''}',
                ContamClassInitial: '${containerData.classification ?? ''}',
                leftBorderColor:
                    containerData.classification == Classification.HAZARDOUS
                        ? Colors.orange
                        : containerData.classification ==
                                Classification.NON_CONTAMINATED
                            ? Colors.green
                            : Colors.red,
              ),

              SizedBox(height: 15.h),
              // here comes the RFID Scanner for scaning

              Container(
                width: MediaQuery.sizeOf(context).width / .9,
                height: 50,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: TextFormField(
                  controller: batch_no,
                  onChanged: (text) {
                    setState(() {}); // Update the state to refresh the UI
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Decon Batch No',
                      suffixIcon: Container(
                        width: 91.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (batch_no.text.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  batch_no.clear();
                                },
                              ),
                          ],
                        ),
                      ),
                      helperStyle: GoogleFonts.mulish(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.28,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 8, left: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
