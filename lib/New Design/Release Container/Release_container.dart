import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
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

class ContainerRelease extends StatefulWidget {
  ContainerRelease({
    super.key,
  });

  @override
  State<ContainerRelease> createState() => _ContainerReleaseState();
}

class _ContainerReleaseState extends State<ContainerRelease> {
  Asset containerData = new Asset();

  Future<void> fetchreleasecontainer(
    String RfId,
  ) async {
    if (RfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        ['rf_id', '=', RfId],
        ['asset_type', '=', AssetType.CONTAINER],
        [
          'status',
          'IN',
          '("${AssetStatus.ARRIVED_AT_YARD}","${AssetStatus.ARRIVED_AT_DISPOSAL_YARD}")'
        ],
      ], {});

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        setState(() {
          containerData = response[0];
        });
      } else {
        Utils.SnackBar(
            'Error', 'Cannot Find Container with this RFID  at Decontam Yard');
        throw Exception('Cannot Find Container with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  ReleaseContainer(Asset container) async {
    container.is_contaminated = _radioValue == true ? 1 : 0;

    container.classification = _radioValue == true
        ? Classification.CONTAMINATED
        : Classification.NON_CONTAMINATED;
    container.crane_weight = 0.0;
    container.status = AssetStatus.CONTAINER_RELEASED;

    final groups = await DatabaseHelper.instance.queryList('asset_groups', [
      ['group_id', '=', '${container.asset_id}']
    ], {});

    if (groups != null && groups.length > 0) {
      final groupsJson =
          groups.map((json) => AssetGroup.fromJson(json)).toList();

      final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
      final childAssetIdsString = makeIdsForIN(childAssetIds);

      final items = await await DatabaseHelper.instance.queryList('assets', [
        ['asset_id', 'IN', '($childAssetIdsString)'],
        ['status', '=', AssetStatus.MOVED_TO_YARD_STORAGE]
        // ['status', '=', AssetStatus.ARRIVED_AT_YARD]
      ], {});

      if (items != null && items.length > 0) {
        return Utils.SnackBar('Error', 'Please Unload the Continer First!');
      }
    } else {
      if (container.classification == Classification.NON_CONTAMINATED) {
        await DatabaseHelper.instance.updateAsset(container);

        Get.to(NewBottomNavigation());
        AssetLog log = new AssetLog();
        final userInfo =
            await SharedPreferencesHelper.retrieveUserInfo('userInfo');
        String eventType = EventType.CONTAINER_RELEASED;

        var template = eventDefinition[eventType].toString();
        Map<String, String> variables = {
          'container_type': container.container_type.toString(),
          'rf_id': container.rf_id.toString(),
          'current_location': userInfo['location_name'],
          'user': userInfo['user_name'],
          'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
        };

        var eventDesc = replaceVariables(template, variables);

        log.asset_id = container.asset_id.toString();
        log.rf_id = container.rf_id.toString();
        log.event_type = eventType;
        log.asset_type = container.asset_type.toString();
        log.current_transaction = jsonEncode(container.toMap());
        log.event_description = eventDesc;
        log.status = container.status.toString();
        log.current_location_id = userInfo['locationId'];
        log.container_type_id = container.container_type_id.toString();
        DatabaseHelper.instance.createAssetLog(log);
      } else {
        Utils.SnackBar('Error', "Can't Release Container is Contaminated!");
      }
    }
  }

  //TextEditingController rf_id = TextEditingController();
  bool isCheckBox = false;
  bool _radioValue = false;

  void _handleRadioValueChange(bool? value) {
    setState(() {
      _radioValue = value!;
    });
  }

  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            containerData.asset_id != null
                ? TextButton(
                    onPressed: () {
                      ReleaseContainer(containerData);
                    },
                    child: Text(
                      'Release',
                      style: GoogleFonts.mulish(
                        color: Color(0xFFA80303),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Release Container',
                  style: GoogleFonts.mulish(
                    color: Color(0xFF262626),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.44,
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       width: 34.w,
                //       height: 34.h,
                //       decoration: ShapeDecoration(
                //         color: Color(0xFFF9F9F9),
                //         shape: OvalBorder(),
                //       ),
                //       child: Center(
                //         child: SvgPicture.asset(
                //           'images/svg/text.svg',
                //           width: 20.w,
                //           height: 20.h,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
                  fetchreleasecontainer(rf_id.text);
                },
                decoration: InputDecoration(
                    hintText: 'Scan Container RFID',
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
                                fetchreleasecontainer(rf_id.text);
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
                    contentPadding: EdgeInsets.only(top: 8, left: 13)),
              ),
            ),

            SizedBox(
              height: 15.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Container Details',
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
                Container(
                  width: 350.w,
                  height: 110.h,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFCFCFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x1C000000),
                        blurRadius: 9,
                        offset: Offset(-3, 4),
                        spreadRadius: -3,
                      )
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
                                  width: 100.w,
                                  child: Text(
                                    'Container Type:',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF808080),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0.14,
                                      letterSpacing: -0.24,
                                    ),
                                  )),
                              Container(
                                width: 205.w,
                                child: Text(
                                  containerData.container_type == null
                                      ? ''
                                      : '${containerData.container_type}',
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
                                  'Serial No ',
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
                                  containerData.container_serial_number == null
                                      ? ''
                                      : '${containerData.container_serial_number}',
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
                                  'RFID:',
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
                                  containerData.rf_id == null
                                      ? ''
                                      : '${containerData.rf_id}',
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
                      ]),
                    )
                  ]),
                ),
                SizedBox(
                  height: 15.h,
                ),

                containerData.classification == Classification.CONTAMINATED
                    ? Text(
                        'Contaminated',
                        style: GoogleFonts.mulish(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.32,
                        ),
                      )
                    : SizedBox(), // here comes the
                SizedBox(
                  height: 15.h,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Radio(
                      //   activeColor: Colors.red.shade900,
                      //   value: true,
                      //   groupValue: _radioValue,
                      //   onChanged: _handleRadioValueChange,
                      // ),
                      // Text('Contaminated'
                      //     // widget.Status == 'Flexible'
                      //     //     ? 'Contaminated'
                      //     //     : 'Potentially Contaminated',
                      //     ),
                      // SizedBox(
                      //   width: 17,
                      // ),
                      containerData.classification ==
                              Classification.CONTAMINATED
                          ? Radio(
                              value: false,
                              activeColor: Colors.red.shade900,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            )
                          : SizedBox(),
                      containerData.classification ==
                              Classification.CONTAMINATED
                          ? Text('Non Contaminated')
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),

            // Scan RFID again

            SizedBox(
              height: 15,
            ),
          ]),
        )));
  }
}


//
