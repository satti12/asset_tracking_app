// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
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
import 'package:sqflite/sqflite.dart';

class ReceivelPage extends StatefulWidget {
  String? CurrentLocation;
  String? ActiveLocationid;
  ReceivelPage({Key? key, this.CurrentLocation, this.ActiveLocationid})
      : super(key: key);
  @override
  _ReceivelPageState createState() => _ReceivelPageState();
}

class _ReceivelPageState extends State<ReceivelPage> {
  List<Asset> receivelItem = [];
  List<Asset> selectedId = [];
  Asset? containerData;
  Set<int> _selectedItemIndices = {};

  Future<void> receival(
    String RfId,
  ) async {
    if (RfId.isNotEmpty) {
      var data = await DatabaseHelper.instance.queryList(
          'assets',
          [
            ['rf_id', '=', RfId],
            [
              'status',
              'IN',
              '("${AssetStatus.IN_TRANSIT}","${AssetStatus.IN_DISPOSAL}")'
            ],
          ],
          {},
          limit: null);
      print(data);
      print(data?[0]['operating_location_id']);
      print(widget.ActiveLocationid);
      if (data != null &&
          (data[0]['yard_location_id'] == widget.ActiveLocationid ||
              data[0]['operating_location_id'] == widget.ActiveLocationid)) {
        if (data.length > 0) {
          final List<Asset> response =
              data.map((json) => Asset.fromJson(json)).toList();
          final asset = response[0];
          setState(() {
            receivelItem.add(asset);
          });
        } else {
          var result = await DatabaseHelper.instance.queryList('assets', [
            ['rf_id', '=', RfId],
            ['asset_type', '=', AssetType.HAZMAT_WASTE]
          ], {});

          if (result != null && result.length > 0) {
            final List<Asset> response =
                result.map((json) => Asset.fromJson(json)).toList();
            final asset = response[0];
            setState(() {
              receivelItem.add(asset);
            });
          } else {
            Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
            throw Exception('Cannot Find Asset with this RFID');
          }
        }
      } else {
        return Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  void completeReceivel() async {
    for (final asset in selectedId) {
      final data = await DatabaseHelper.instance.queryList(
        'asset_track_logs',
        [
          ['asset_id', '=', asset.asset_id],
          ['previous_status', '=', AssetStatus.READY_FOR_DISPOSAL],
          ['current_status', '=', AssetStatus.IN_DISPOSAL],
        ],
        {},
        limit: null,
      );

      var fromLocationId = null;
      var fromLocation = '';
      if (data != null && data.isNotEmpty) {
        fromLocationId = data[0]['from_location'];
        final location = await DatabaseHelper.instance.queryUnique(
          'operating_locations',
          'operating_location_id',
          fromLocationId,
        );

        fromLocation = location?[0]['name'] + ' ' + location?[0]['type'] ?? '';
      }

      asset.status = AssetStatus.ARRIVED_AT_DISPOSAL_YARD;
      Asset modifiedAsset = await DatabaseHelper.instance.updateAsset(asset);

      AssetLog log = new AssetLog();
      final userInfo =
          await SharedPreferencesHelper.retrieveUserInfo('userInfo');
      String eventType = EventType.ARRIVED_AT_DISPOSAL_YARD;

      var template = eventDefinition[eventType].toString();
      Map<String, String> variables = {
        'asset_type': asset.asset_type.toString(),
        'rf_id': asset.rf_id.toString(),
        'of product_no': asset.asset_type == AssetType.HAZMAT_WASTE
            ? ''
            : asset.product_no.toString(),
        'current_location': userInfo['location_name'],
        'from_location': fromLocation,
        'user': userInfo['user_name'],
        'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
      };

      var eventDesc = replaceVariables(template, variables);

      log.asset_id = asset.asset_id.toString();
      log.rf_id = asset.rf_id.toString();
      log.event_type = eventType;
      log.event_description = eventDesc;
      log.status = asset.status;
      log.current_transaction = jsonEncode(modifiedAsset.toMap());
      log.from_location_id = fromLocationId;
      log.current_location_id = userInfo['locationId'];
      log.asset_type = asset.asset_type.toString();
      DatabaseHelper.instance.createAssetLog(log);

      // Handling child assets if any
      final List<dynamic>? groups = await DatabaseHelper.instance.queryList(
        'asset_groups',
        [
          ['group_id', '=', asset.asset_id],
        ],
        {},
      );

      if (groups != null && groups.isNotEmpty) {
        var child_assets = groups.map((group) => group['asset_id']).toList();

        if (child_assets.isNotEmpty) {
          final childAssetIdsString = makeIdsForIN(child_assets);

          final child_items = await DatabaseHelper.instance.queryList(
            'assets',
            [
              ['asset_id', 'IN', '($childAssetIdsString)'],
            ],
            {},
          );

          var previousLocations = {};
          if (child_items != null && child_items.isNotEmpty) {
            for (var childAsset in child_items) {
              previousLocations[childAsset['asset_id']] =
                  childAsset['operating_location_id'];
            }
          }

          for (var child_item in child_items!) {
            // Update the status of each child asset
            await DatabaseHelper.instance
                .update('assets', 'asset_id', child_item['asset_id'], {
              'status': AssetStatus.ARRIVED_AT_DISPOSAL_YARD,
              'operating_location_id': userInfo['locationId'],
              'is_sync': 0
            });

            final logData = {
              'asset_track_log_id': await timedId(),
              'asset_id': child_item['asset_id'],
              'from_location':
                  previousLocations[child_item['asset_id']] ?? null,
              'to_location': widget.ActiveLocationid,
              'previous_status': AssetStatus.IN_TRANSIT,
              'current_status': AssetStatus.ARRIVED_AT_DISPOSAL_YARD,
              'added_by_id': userInfo['user_id'],
              'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
              'is_sync': 0
            };

            await DatabaseHelper.instance.InsertTrackLog(logData);

            AssetLog childLog = new AssetLog();
            final result = await DatabaseHelper.instance.queryUnique(
              'assets',
              'asset_id',
              child_item['asset_id'],
            );

            final resp = result?.map((json) => Asset.fromJson(json)).toList();
            Asset? res = resp?[0];

            String? childTemplate;
            if (eventDefinition[eventType] is Map<Object, dynamic>) {
              childTemplate = (eventDefinition[eventType]
                      as Map<Object, dynamic>?)?[INSIDE_CONTAINER]
                  ?.toString();
            } else {
              childTemplate = eventDefinition[eventType]?.toString();
            }

            if (childTemplate != null) {
              Map<String, String> childVariables = {
                'asset_type': child_item['asset_type'].toString(),
                'container_type': asset.container_type.toString(),
                'container_rfid': asset.rf_id.toString(),
                'rf_id': child_item['rf_id'].toString(),
                'from_location': fromLocation,
                'current_location': userInfo['location_name'],
                'user': userInfo['user_name'],
                'time':
                    DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
              };
              var childEventDesc =
                  replaceVariables(childTemplate, childVariables);
              childLog.asset_id = child_item['asset_id'].toString();
              childLog.rf_id = child_item['rf_id'].toString();
              childLog.asset_type = child_item['asset_type'].toString();
              childLog.current_transaction = jsonEncode(res?.toMap());
              childLog.event_type = eventType;
              childLog.status = res?.status;
              childLog.from_location_id =
                  previousLocations[child_item['asset_id']];
              childLog.current_location_id = userInfo['locationId'];
              childLog.event_description = childEventDesc;
              DatabaseHelper.instance.createAssetLog(childLog);
            }
          }
        }
      }
    }

    Get.to(NewBottomNavigation());
  }

  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          selectedId.isEmpty
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      completeReceivel();
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFFA80303),
                      ),
                    ),
                  ),
                )
        ],
      ),
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
                    'Receival',
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.48,
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
                    receival(rf_id.text);
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
                                  receival(rf_id.text);
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

              Container(
                height: 630.h,
                child: ListView.builder(
                    itemCount: receivelItem.length,
                    itemBuilder: (context, index) {
                      final item = receivelItem[index];
                      return ReceievelCom(
                        structureType:
                            '${(item.product == null && item.asset_type == 'Container') ? item.container_type : (item.product != null ? item.product : item.asset_type)}',

                        // structureType:
                        //     '${item.product == null && item.asset_type == 'Container' ? item.container_type : item.asset_type? item.product}',
                        rfid: 'RFID# ${item.rf_id}',
                        BundleID: item.bundle_no == null &&
                                item.batch_no == null
                            ? '' // both are null, return empty string
                            : item.bundle_no == null
                                ? 'Batch#                                                       ${item.batch_no ?? ' '}' // bundle_no is null, use batch_no
                                : 'Bundle#                                                       ${item.bundle_no ?? ' '}',
                        ORIGIN: item.starting_point.toString(),
                        Contamination:
                            '${item.classification == null ? '' : item.classification}',
                        TFMCID: item.product_no == null
                            ? ''
                            //'Drum # ${item.drum_no}'
                            : 'TFMC ID# ${item.product_no == null ? '' : item.product_no} ',
                        leftBorderColor:
                            item.classification == Classification.HAZARDOUS
                                ? Colors.orange
                                : item.classification ==
                                        Classification.NON_CONTAMINATED
                                    ? Colors.green
                                    : Colors.red,

                        Check: Checkbox(
                          value: _selectedItemIndices.contains(index),
                          activeColor: Color(0xFFA80303),
                          onChanged: (value) {
                            setState(() {
                              if (value == null) return;
                              if (value) {
                                _selectedItemIndices.add(index);

                                selectedId.add((item));
                              } else {
                                _selectedItemIndices.remove(index);

                                selectedId.removeWhere(
                                    (record) => record.rf_id == item.rf_id);
                              }
                            });
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceievelCom extends StatefulWidget {
  final String structureType;
  final String rfid;
  final String TFMCID;
  final String BundleID;
  final String ORIGIN;
  final String Contamination;
  final Widget Check;
  final Color leftBorderColor;

  ReceievelCom({
    Key? key,
    required this.structureType,
    required this.rfid,
    required this.TFMCID,
    required this.BundleID,
    required this.ORIGIN,
    required this.Contamination,
    required this.Check,
    required this.leftBorderColor,
  }) : super(key: key);

  @override
  _ReceievelComState createState() => _ReceievelComState();
}

class _ReceievelComState extends State<ReceievelCom> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 345.w,
        height: 180.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: widget.leftBorderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // here comes the
                      widget.Check,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.TFMCID,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: 0.72,
                            ),
                          ),
                          Container(
                            width: 300.w,
                            child: Text(
                              widget.structureType,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: 0.72,
                              ),
                            ),
                          ),
                          Text(
                            widget.rfid,
                            style: GoogleFonts.inter(
                              color: Color(0xFF808080),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: 0.40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 150,
                  //       child: Text(
                  //         'Discription',
                  //         style: GoogleFonts.inter(
                  //           color: Color(0xFF808080),
                  //           fontSize: 10,
                  //           fontWeight: FontWeight.w500,
                  //           height: 0.20,
                  //           letterSpacing: -0.20,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 300,
                        child: Text(
                          widget.BundleID,
                          style: GoogleFonts.inter(
                            color: Color(0xFF262626),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 0.20,
                            letterSpacing: -0.20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Text(
                          'Origin:',
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0.20,
                            letterSpacing: -0.20,
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          widget.ORIGIN,
                          style: GoogleFonts.inter(
                            color: Color(0xFF262626),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 0.20,
                            letterSpacing: -0.20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Text(
                          'Contamination:',
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0.20,
                            letterSpacing: -0.20,
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          widget.Contamination,
                          style: GoogleFonts.inter(
                            color:
                                widget.Contamination == Classification.HAZARDOUS
                                    ? Colors.orange
                                    : widget.Contamination ==
                                            Classification.NON_CONTAMINATED
                                        ? Colors.green
                                        : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 0.20,
                            letterSpacing: -0.20,
                          ),
                        ),
                      ),
                    ],
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
