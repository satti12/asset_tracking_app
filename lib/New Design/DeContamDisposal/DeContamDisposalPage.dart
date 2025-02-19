// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';

import 'package:asset_tracking/Utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:asset_tracking/main.dart';

class DisposalPage extends StatefulWidget {
  String? CurrentLocation;
  DisposalPage({Key? key, this.CurrentLocation}) : super(key: key);
  @override
  _DisposalPageState createState() => _DisposalPageState();
}

class _DisposalPageState extends State<DisposalPage> {
  String? selectedOperatingLocationId;
  String? _selectedFullName;
  List<Map<String, dynamic>> _locations = [];

  Future<void> _fetchLocations() async {
    final response = await DatabaseHelper.instance.queryList(
      'operating_locations',
      [
        ['type', '=', LocationType.DISPOSAL_YARD]
      ],
      {},
    );

    setState(() {
      _locations = (response as List)
          .map((record) => {
                'operating_location_id': record['operating_location_id'],
                'full_name': record['name'] + ' ' + record['type'],
              })
          .toList();

      _locations.sort((a, b) => a['full_name'].compareTo(b['full_name']));
    });
  }

  //TextEditingController rf_id = TextEditingController();

  List<Asset> disposalItem = [];
  List<Asset> selectedId = [];
  Set<int> _selectedItemIndices = {};

  Future<void> disposal(
    String RfId,
  ) async {
    if (RfId.isNotEmpty) {
      var data = await DatabaseHelper.instance.queryList(
          'assets',
          [
            ['rf_id', '=', RfId],
            ['status', '=', AssetStatus.READY_FOR_DISPOSAL]
          ],
          {},
          limit: null);

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        final asset = response[0];
        setState(() {
          disposalItem.add(asset);
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
            disposalItem.add(asset);
          });
        } else {
          Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
          throw Exception('Cannot Find Asset with this RFID');
        }
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  disposed() async {
    print(selectedOperatingLocationId);
    for (final asset in selectedId) {
      asset.status = AssetStatus.IN_DISPOSAL;
      asset.operating_location_id = selectedOperatingLocationId;
      Asset modifiedAsset = await DatabaseHelper.instance
          .updateAsset(asset, selectedId: selectedOperatingLocationId);

      AssetLog log = new AssetLog();
      final userInfo =
          await SharedPreferencesHelper.retrieveUserInfo('userInfo');
      String eventType = EventType.IN_DISPOSAL;

      var template = eventDefinition[eventType].toString();
      Map<String, String> variables = {
        'asset_type': asset.asset_type.toString(),
        'rf_id': asset.rf_id.toString(),
        'of product_no': asset.asset_type == AssetType.HAZMAT_WASTE
            ? ''
            : asset.product_no.toString(),
        'current_location': _selectedFullName.toString(),
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
      log.current_location_id = userInfo['locationId'];
      log.asset_type = asset.asset_type.toString();
      DatabaseHelper.instance.createAssetLog(log);
    }

    Get.to(NewBottomNavigation());
  }

  @override
  void initState() {
    rf_id.clear();
    super.initState();
    _fetchLocations();
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
                      disposed();
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFFA80303),
                      ),
                    ),
                  ),
                ),
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
                    'Disposal',
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
              Text(
                'Select Disposable Location',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.28,
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                width: MediaQuery.sizeOf(context).width / .9,
                height: 50,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 180,
                    height: 42,
                    child: DropdownButtonFormField<String>(
                      // hint: Text('Select Location'),
                      decoration: InputDecoration(
                        // Set decoration to null or customize it as needed
                        border:
                            InputBorder.none, // Removes the underline border
                        contentPadding: EdgeInsets.only(
                            // horizontal: 10,
                            bottom: 1), // Optional: Adjust content padding
                      ),
                      value: _selectedFullName,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFullName = newValue!;
                          selectedOperatingLocationId = _locations.firstWhere(
                              (location) =>
                                  location['full_name'] ==
                                  newValue)['operating_location_id'] as String;
                        });
                      },
                      items: _locations
                          .map((location) => DropdownMenuItem<String>(
                                child: Text(location['full_name']),
                                value: location['full_name'] as String,
                              ))
                          .toList(),
                    ),
                  ),
                ),
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
                    disposal(rf_id.text);
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
                                  disposal(rf_id.text);
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
                height: 500,
                child: ListView.builder(
                    itemCount: disposalItem.length,
                    itemBuilder: (context, index) {
                      final item = disposalItem[index];
                      return DisposalCom(
                        structureType:
                            '${(item.product == null && item.asset_type == 'Container') ? item.container_type : (item.product != null ? item.product : item.asset_type)}',

                        // structureType: item.asset_type.toString() == 'Container'
                        //     ? item.container_type.toString()
                        //     : item.asset_type.toString(),
                        //'${item.product}',
                        rfid: 'RFID# ${item.rf_id}',
                        // BundleID: item.status.toString(),
                        ORIGIN: item.starting_point.toString(),
                        BundleID: item.bundle_no == null &&
                                item.batch_no == null
                            ? '' // both are null, return empty string
                            : item.bundle_no == null
                                ? 'Batch#                                                       ${item.batch_no ?? ' '}' // bundle_no is null, use batch_no
                                : 'Bundle#                                                       ${item.bundle_no ?? ' '}', // bundle_no is not null, use it
                        Contamination:
                            '${item.classification == null ? '' : item.classification}',
                        TFMCID: item.product_no == null
                            ? 'Drum # ${item.drum_no}'
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

              // here come the Card that containes all containers info Scanned from RFID
              // DisposalCom(
              //   structureType: 'SC-2 to DS1/2 Flowline',
              //   rfid: 'RFID# 3829382372874827832',
              //   BundleID: '001',
              //   ORIGIN: 'Enfeild',
              //   Contamination: 'Not Contaminated',
              //   TFMCID: 'TFMC ID# GR-FX-2IN-1 ',
              //   leftBorderColor: Colors.red,
              //   onCheckboxChanged: (isChecked) {
              //     setState(() {
              //       // if (isChecked) {
              //       //   selectedId.add((record));
              //       // } else {
              //       //   selectedId.remove(record);
              //       // }
              //     });
              //   },
              // ),
              // // here comes the Disposed Button
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisposalCom extends StatefulWidget {
  final String structureType;
  final String rfid;
  final String TFMCID;
  final String BundleID;
  final String ORIGIN;
  final String Contamination;
  final Widget Check;
  final leftBorderColor;

  DisposalCom({
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
  _DisposalComState createState() => _DisposalComState();
}

class _DisposalComState extends State<DisposalCom> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 345.w,
        height: 150.h,
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
                            width: 305,
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
                      // Container(
                      //   width: 150,
                      //   child: Text(
                      //     'Status:',
                      //     style: GoogleFonts.inter(
                      //       color: Color(0xFF808080),
                      //       fontSize: 10,
                      //       fontWeight: FontWeight.w500,
                      //       height: 0.20,
                      //       letterSpacing: -0.20,
                      //     ),
                      //   ),
                      // ),
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
