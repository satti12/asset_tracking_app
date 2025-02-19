// ignore_for_file: must_be_immutable
import 'dart:convert';

import 'package:http/http.dart';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Unbundle/TagBundle.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:asset_tracking/main.dart';

class UnbundlingAndTagFlexiblePage extends StatefulWidget {
  String? CurrentLocation;
  UnbundlingAndTagFlexiblePage({super.key, this.CurrentLocation});

  @override
  State<UnbundlingAndTagFlexiblePage> createState() =>
      _UnbundlingAndTagFlexiblePageState();
}

class _UnbundlingAndTagFlexiblePageState
    extends State<UnbundlingAndTagFlexiblePage> {
  //TextEditingController rf_id = TextEditingController();
  TextEditingController scan_rf_id = TextEditingController();
  bool isChecked = false;
  List<Asset> selectedId = [];
  Asset containerData = new Asset();
  List<Asset>? bundleItems = [];
  int count = 0;
  Future<Asset> fetchBundle(String rfId) async {
    if (rfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        ['rf_id', '=', rfId],
        ['asset_type', '=', AssetType.BUNDLE],
        [
          'status',
          'IN',
          '("${AssetStatus.MOVED_TO_YARD_STORAGE}","${AssetStatus.ARRIVED_AT_DISPOSAL_YARD}")'
        ],
      ], {});

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        setState(() {
          containerData = response[0];
        });

        return response[0];
      } else {
        Utils.SnackBar('Error', 'Cannot Find Bundle with this RFID');
        throw Exception('Cannot Find Bundle with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  Future<List<Asset>?>? fetchBundleItems(Asset bundle) async {
    final groups = await DatabaseHelper.instance.queryList(
        'asset_groups',
        [
          ['group_id', '=', '${bundle.asset_id}']
        ],
        {},
        limit: null);

    if (groups != null && groups.length > 0) {
      final groupsJson =
          groups.map((json) => AssetGroup.fromJson(json)).toList();

      final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
      final childAssetIdsString = makeIdsForIN(childAssetIds);

      final batches = await await DatabaseHelper.instance.queryList(
          'assets',
          [
            ['asset_id', 'IN', '($childAssetIdsString)'],
            ['asset_type', '=', AssetType.FLEXIBLES],
          ],
          {},
          limit: null);

      if (batches != null && batches.length > 0) {
        final List<Asset> response =
            batches.map((json) => Asset.fromJson(json)).toList();

        bundleItems = response;
        setState(() {
          count = bundleItems!.length;
        });

        return response;
      }
    }
    return null;
  }

  Future<void> create_bundle(
    Asset parent,
    String rf_id,
  ) async {
    try {
      Asset? newAsset;
      await DatabaseHelper.instance
          .createIndividualAsset(parent, rf_id)
          .then((result) {
        newAsset = result;
      }).whenComplete(() async {
        setState(() {
          fetchBundleItems(containerData);
        });
        AssetLog log = new AssetLog();
        final result = await DatabaseHelper.instance
            .queryUnique('assets', 'asset_id', newAsset?.asset_id);

        final resp = result?.map((json) => Asset.fromJson(json)).toList();
        Asset? res = resp?[0];
        final userInfo =
            await SharedPreferencesHelper.retrieveUserInfo('userInfo');
        String eventType = EventType.ASSET_CREATED;
        String assetType = AssetType.FLEXIBLES;
        var eventDesc;
        var template =
            (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
                ?.toString();
        Map<String, String> variables = {
          'asset_type': assetType,
          'rf_id': rf_id,
          'parent_asset_type': parent.asset_type.toString(),
          'parent_rfid': parent.rf_id.toString(),
          'current_location': userInfo['location_name'],
          'user': userInfo['user_name'],
          'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
        };
        eventDesc = replaceVariables(template!, variables);
        log.asset_id = parent.asset_id.toString();
        log.event_type = eventType;
        log.asset_type = assetType.toString();
        log.rf_id = rf_id;
        log.status = res?.status.toString();
        log.event_description = eventDesc;
        log.current_transaction = jsonEncode(res?.toMap());
        log.current_location_id = userInfo['locationId'];
        DatabaseHelper.instance.createAssetLog(log);
      });

      // Get.to(NewBottomNavigation());
    } catch (e) {
      Utils.SnackBar('Error', e.toString());
      throw Exception(e.toString());
    }
  }

  completeBundleTag(Asset asset) async {
    asset.status = AssetStatus.UNBUNDLED;
    Asset modifiedAsset = await DatabaseHelper.instance.updateAsset(asset);

    AssetLog log = new AssetLog();
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.UNBUNDLED;
    String assetType = AssetType.BUNDLE;
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            .toString();

    Map<String, String> variables = {
      'asset_type': asset.asset_type.toString(),
      'rf_id': asset.rf_id.toString(),
      'current_location': userInfo['location_name'],
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = asset.asset_id.toString();
    log.rf_id = asset.rf_id.toString();
    log.event_type = eventType;
    log.asset_type = asset.asset_type.toString();
    log.status = asset.status;
    log.current_transaction = jsonEncode(modifiedAsset.toMap());
    log.event_description = eventDesc;
    log.current_location_id = userInfo['locationId'];
    log.asset_type = asset.asset_type.toString();
    DatabaseHelper.instance.createAssetLog(log);

    Navigator.pop(context);
  }

  @override
  void initState() {
    rf_id.clear();
    super.initState();
    setState(() {
      count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          if (count == containerData.no_of_joints?.toInt())
            TextButton(
              onPressed: () {
                completeBundleTag(containerData);
              },
              child: Text(
                'Complete',
                style: GoogleFonts.mulish(
                  color: Color(0xFFA80303),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unbundling',
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.48,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Add your functionality here
                  },
                  child: Container(
                    width: 34.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'images/svg/text.svg',
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                ),
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
            SizedBox(
              height: 15.h,
            ),

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
                  fetchBundle(rf_id.text);
                },
                decoration: InputDecoration(
                    hintText: 'Scan Bundle RFID',
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
                                fetchBundle(rf_id.text);
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

            Text(
              'Bundle Details',
              style: GoogleFonts.mulish(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            // here comes the Container Details

            InkWell(
              onTap: () {
                Get.to(TagFlexiblePage(
                  SelectedBundle: containerData,
                ));
              },
              child: Container(
                width: 350.w,
                height: 175.h,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x66AEAEC0),
                      blurRadius: 3,
                      offset: Offset(1.50, 1.50),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0xFFFFFFFF),
                      blurRadius: 3,
                      offset: Offset(-3, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 70.w,
                                child: Text(
                                  'Bundle#',
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF808080),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0.14,
                                    letterSpacing: -0.24,
                                  ),
                                )),
                            Container(
                              width: 235.w,
                              child: Text(
                                containerData.bundle_no == null
                                    ? ''
                                    : containerData.bundle_no.toString(),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 70.w,
                                child: Text(
                                  'TFMC ID:',
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF808080),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0.14,
                                    letterSpacing: -0.24,
                                  ),
                                )),
                            Container(
                              width: 235.w,
                              child: Text(
                                containerData.product_no == null
                                    ? ''
                                    : containerData.product_no.toString(),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70.w,
                              child: Text(
                                'Length: ',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                            Container(
                              width: 235.w,
                              child: Text(
                                containerData.approximate_length == null
                                    ? ''
                                    : '${containerData.approximate_length}(m)',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70.w,
                              child: Text(
                                'Weight:',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                            Container(
                              width: 235.w,
                              child: Text(
                                containerData.approximate_weight == null
                                    ? ''
                                    : '${containerData.approximate_weight} (MT)',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100.w,
                              child: Text(
                                'No. of Joints',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                            Container(
                              width: 205.w,
                              child: Text(
                                containerData.no_of_joints == null
                                    ? ''
                                    : '${containerData.no_of_joints?.toInt()}',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100.w,
                              child: Text(
                                'Classification',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                            Container(
                              width: 205.w,
                              child: Text(
                                containerData.classification == null
                                    ? ''
                                    : containerData.classification.toString(),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                  color: containerData.classification ==
                                          Classification.HAZARDOUS
                                      ? Colors.orange
                                      : containerData.classification ==
                                              Classification.NON_CONTAMINATED
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 0.14,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            )
                          ]),
                    ]),
                  )
                ]),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            if (containerData.no_of_joints != null)
              Text(
                'Press the Detail  and Tag Bundle',
                style: TextStyle(color: Colors.red),
              )
            // // here comes the
            // SizedBox(height: 15.h),
            // Text(
            //   'Bundle - Install Individual RFID Tags',
            //   style: GoogleFonts.mulish(
            //     color: Colors.black,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w700,
            //     height: 0,
            //     letterSpacing: -0.32,
            //   ),
            // ),
            // SizedBox(
            //   height: 15.h,
            // ),
            // if (count != containerData.no_of_joints?.toInt())
            //   Container(
            //     width: MediaQuery.sizeOf(context).width / .9,
            //     height: 50.h,
            //     decoration: ShapeDecoration(
            //       shape: RoundedRectangleBorder(
            //         side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //     ),
            //     child: TextFormField(
            //       controller: rf_id,
            //       onChanged: (value) {
            //         setState(() {});
            //       },
            //       onEditingComplete: () {
            //         create_bundle(containerData, scan_rf_id.text);
            //       },
            //       decoration: InputDecoration(
            //           hintText: 'Scan RFID',
            //           suffixIcon: Container(
            //             width: 91.w,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.end,
            //               children: [
            //                 if (rf_id.text.isNotEmpty)
            //                   IconButton(
            //                     icon: Icon(Icons.clear),
            //                     onPressed: () {
            //                       rf_id.clear();
            //                     },
            //                   ),
            //                 InkWell(
            //                   onTap: () {
            //                     if (rf_id.text.isNotEmpty) {
            //                       create_bundle(containerData, scan_rf_id.text);
            //                     } else {
            //                       sendActionToNative("Pressed");
            //                     }
            //                   },
            //                   child: Container(
            //                     width: 40.w,
            //                     height: 40.h,
            //                     decoration: BoxDecoration(
            //                       color: Color(0xFFA80303),
            //                       shape: BoxShape
            //                           .circle, // Use BoxShape.circle for a circular shape
            //                     ),
            //                     child: Center(
            //                       child: SvgPicture.asset(
            //                         'images/svg/scaner.svg',
            //                         height: 25,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           helperStyle: GoogleFonts.mulish(
            //             color: Colors.black,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //             height: 0,
            //             letterSpacing: -0.28,
            //           ),
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.only(top: 13, left: 15)),
            //     ),
            //   ),

            // SizedBox(
            //   height: 15.h,
            // ),
            // Text.rich(
            //   TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'RFID Tag installed ',
            //         style: GoogleFonts.inter(
            //           color: Color(0xFFA80303),
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //           height: 0,
            //           letterSpacing: 0.56,
            //         ),
            //       ),
            //       TextSpan(
            //         text: count.toString(),
            //         style: GoogleFonts.inter(
            //           color: Color(0xFFA80303),
            //           fontSize: 14,
            //           fontWeight: FontWeight.w700,
            //           height: 0,
            //           letterSpacing: 0.56,
            //         ),
            //       ),
            //       TextSpan(
            //         text: containerData.no_of_joints == null
            //             ? ''
            //             : 'of ${containerData.no_of_joints?.toInt()}',
            //         style: GoogleFonts.inter(
            //           color: Color(0xFFA80303),
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //           height: 0,
            //           letterSpacing: 0.56,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 15.h,
            // ),

            // // here will be cards for having Rigids And Pipes Containters

            // FutureBuilder<List<Asset>?>(
            //   future: fetchBundleItems(containerData),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //       return Text('No Asset available');
            //     } else {
            //       return Column(
            //         children: snapshot.data!.asMap().entries.map((entry) {
            //           // final index = entry.key;
            //           final container = entry.value;

            //           return InkWell(
            //             onTap: () {},
            //             child: InsideContent(
            //               productionFlowline: '${container.product} ',
            //               rfid: 'RFID -${container.rf_id}',
            //               rigidPipeBatch: 'TFMC ID # ${container.product_no}',
            //               color: container.classification ==
            //                       Classification.HAZARDOUS
            //                   ? Colors.orange
            //                   : container.classification ==
            //                           Classification.NON_CONTAMINATED
            //                       ? Colors.green
            //                       : Colors.red,
            //             ),
            //           );
            //         }).toList(),
            //       );
            //     }
            //   },
            // ),

            // // InsideContent(
            // //   productionFlowline: 'SC-2 Production Flowline ',
            // //   rfid: 'RFID - 124534968382940543484721',
            // //   rigidPipeBatch: 'Rigid Pipe Batch# RGD-EN-0001',
            // //   color: Colors.red,
            // //   onCheckboxChanged: (isChecked) {
            // //     // setState(() {
            // //     //   if (isChecked) {
            // //     //     selectedId.add((1));
            // //     //   } else {
            // //     //     selectedId.remove(record);
            // //     //   }
            // //     // });
            // //   },
            // // ),
            // SizedBox(
            //   height: 15.h,
            // ),
          ]),
        ),
      ),
    );
  }
}

class InsideContent extends StatefulWidget {
  final String productionFlowline;
  final String rfid;
  final String rigidPipeBatch;
  Color color = Colors.green;

  InsideContent(
      {required this.productionFlowline,
      required this.rfid,
      required this.rigidPipeBatch,
      required this.color});

  @override
  State<InsideContent> createState() => _InsideContentState();
}

class _InsideContentState extends State<InsideContent> {
  bool isChecked = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: 380.w,
        height: 85.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x66AEAEC0),
              blurRadius: 3,
              offset: Offset(1.50, 1.50),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0xFFFFFFFF),
              blurRadius: 3,
              offset: Offset(-3, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    child: Text(
                      widget.productionFlowline,
                      style: GoogleFonts.inter(
                        color: Color(0xFF424242),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.56,
                      ),
                    ),
                  ),
                  Text(
                    widget.rfid,
                    style: GoogleFonts.inter(
                      color: Color(0xFFB9B9B9),
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.32,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    widget.rigidPipeBatch,
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // Example usage inside the container
// Container(
