// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';

import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Arrival_At_Quayside/ArrivalAtQuaysaide.dart';
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

class ReceiptYardPage extends StatefulWidget {
  String? Location;
  String? ActiveLocationid;
  ReceiptYardPage({super.key, this.Location, this.ActiveLocationid});

  @override
  State<ReceiptYardPage> createState() => _ReceiptYardPageState();
}

class _ReceiptYardPageState extends State<ReceiptYardPage> {
  bool isChecked = false;
  // TextEditingController rf_id = TextEditingController();
  int count = 0;
  Asset? containerData;
  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  Future<Asset> fetchReciveYardAssets(String RfId) async {
    if (RfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList(
          'assets',
          [
            ['status', '=', AssetStatus.IN_TRANSIT],
            ['yard_location_id', '=', widget.ActiveLocationid],
            ['rf_id', '=', RfId]
          ],
          {},
          limit: null);

      if (data != null && data.isNotEmpty) {
        final resp = data.map((json) => Asset.fromJson(json)).toList();
        Asset asset = resp[0];

        var child_assets = [];
        final List<dynamic>? groups =
            await DatabaseHelper.instance.queryList('asset_groups', [
          ['asset_id', '=', asset.asset_id],
        ], {});

        if (groups != null && groups.length > 0) {
          for (var group in groups) {
            child_assets.add(group['asset_id']);
          }
        }

        if (!child_assets.contains(asset.asset_id)) {
          setState(() {
            containerData = asset;
          });

          return asset;
        } else {
          Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
          throw Exception('Cannot Find Asset with this RFID');
        }
      } else {
        Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
        throw Exception('Cannot Find Asset with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  //Asset containerData = new Asset();
  // Future<Asset> fetchReciveYardAssets(String rfId) async {
  //   final data = await DatabaseHelper.instance.queryList('assets', [
  //     ['rf_id', '=', rfId],
  //     ['status', '=', AssetStatus.ARRIVED_AT_YARD],
  //   ], {});

  //   if (data != null && data.length > 0) {
  //     final List<Asset> response =
  //         data.map((json) => Asset.fromJson(json)).toList();
  //     setState(() {
  //       containerData = response[0];
  //     });

  //     await DatabaseHelper.instance.updateAsset(containerData);
  //     return response[0];
  //   } else {
  //     Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
  //     throw Exception('Cannot Find Bundle with this RFID');
  //   }
  // }
  Future<void> marked_at_arrival_at_yard() async {
    if (containerData != null) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        ['rf_id', '=', containerData?.rf_id]
      ], {});

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        final asset = response[0];
        try {
          LoadingScreen.showLoading(context);
          await DatabaseHelper.instance
              .markArrivedAtYard(
            asset,
          )
              .whenComplete(() async {
            Get.to(NewBottomNavigation());
            final data = await DatabaseHelper.instance.queryList(
                'asset_track_logs',
                [
                  ['asset_id', '=', asset.asset_id],
                  ['previous_status', '=', AssetStatus.LOADED],
                  ['current_status', '=', AssetStatus.IN_TRANSIT],
                ],
                {},
                attachFks: true);

            var fromLocationId = null;
            var fromLocation = '';
            if (data != null && data.length > 0) {
              fromLocationId = data[0]['from_location'];
              final location = await DatabaseHelper.instance.queryUnique(
                  'operating_locations',
                  'operating_location_id',
                  fromLocationId);
              fromLocation =
                  location?[0]['name'] + ' ' + location?[0]['type'] ?? '';
            }

            final voyage = await DatabaseHelper.instance
                .queryUnique('voyage_assets', 'asset_id', asset.asset_id);
            var voyageID = voyage?[0]['voyage_id'];
            final vessel = await DatabaseHelper.instance
                .queryUnique('voyages', 'voyage_id', voyageID);
            var vesselId = vessel?[0]['vessel_id'];

            AssetLog log = new AssetLog();
            final result = await DatabaseHelper.instance
                .queryUnique('assets', 'asset_id', asset.asset_id);

            final resp = result?.map((json) => Asset.fromJson(json)).toList();
            Asset? res = resp?[0];

            final userInfo =
                await SharedPreferencesHelper.retrieveUserInfo('userInfo');
            String eventType = EventType.ARRIVED_AT_YARD;
            String assetType = asset.asset_type == AssetType.CONTAINER
                ? WITH_CONTAINER
                : WITHOUT_CONTAINER;
            var eventDesc;
            var template = (eventDefinition[eventType]
                    as Map<Object, dynamic>?)?[assetType]
                ?.toString();
            Map<String, String> variables = {
              'asset_type': asset.asset_type.toString() == AssetType.CONTAINER
                  ? asset.container_type.toString()
                  : asset.asset_type.toString(),
              'container_type': asset.container_type.toString(),
              'rf_id': asset.rf_id.toString(),
              'from_location': fromLocation,
              'current_location': userInfo['location_name'],
              'user': userInfo['user_name'],
              'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
            };
            eventDesc = replaceVariables(template!, variables);
            log.asset_id = asset.asset_id.toString();
            log.rf_id = asset.rf_id.toString();
            log.asset_type = asset.asset_type;
            log.current_transaction = jsonEncode(res?.toMap());
            log.event_type = eventType;
            log.vessel_id = vesselId;
            log.status = res?.status;

            log.container_type_id = asset.container_type_id;
            log.from_location_id = fromLocationId;
            log.current_location_id = userInfo['locationId'];
            ;
            log.event_description = eventDesc;
            DatabaseHelper.instance.createAssetLog(log);

            var child_assets = [];
            final List<dynamic>? groups =
                await DatabaseHelper.instance.queryList('asset_groups', [
              ['group_id', '=', asset.asset_id],
            ], {});
            if (groups != null && groups.length > 0) {
              for (var group in groups) {
                child_assets.add(group['asset_id']);
              }
            }

            if (child_assets.length > 0) {
              final childAssetIdsString = makeIdsForIN(child_assets);

              final child_items =
                  await DatabaseHelper.instance.queryList('assets', [
                ['asset_id', 'IN', '($childAssetIdsString)'],
              ], {});

              if (child_items != null) {
                for (var child_item in child_items) {
                  AssetLog childLog = new AssetLog();
                  final result = await DatabaseHelper.instance.queryUnique(
                      'assets', 'asset_id', child_item['asset_id']);

                  final resp =
                      result?.map((json) => Asset.fromJson(json)).toList();
                  Asset? res = resp?[0];
                  var eventDesc;
                  var template = (eventDefinition[eventType]
                          as Map<Object, dynamic>?)?[INSIDE_CONTAINER]
                      ?.toString();
                  Map<String, String> variables = {
                    'asset_type': child_item['asset_type'].toString(),
                    'container_type': asset.container_type.toString(),
                    'container_rfid': asset.rf_id.toString(),
                    'rf_id': child_item['rf_id'].toString(),
                    'from_location': fromLocation,
                    'current_location': userInfo['location_name'],
                    'user': userInfo['user_name'],
                    'time': DateFormat('hh:mm a MMM dd yyyy')
                        .format(DateTime.now()),
                  };
                  eventDesc = replaceVariables(template!, variables);
                  childLog.asset_id = child_item['asset_id'].toString();
                  childLog.rf_id = child_item['rf_id'].toString();
                  childLog.asset_type = child_item['asset_type'].toString();
                  log.current_transaction = jsonEncode(res?.toMap());
                  childLog.event_type = eventType;
                  childLog.vessel_id = vesselId;
                  childLog.status = res?.status;
                  childLog.from_location_id = fromLocationId;
                  childLog.current_location_id = userInfo['locationId'];
                  childLog.event_description = eventDesc;
                  DatabaseHelper.instance.createAssetLog(childLog);
                }
              }
            }
          });
        } catch (e) {
          Utils.SnackBar('Error', e.toString());
          throw Exception(e);
        }
      } else {
        Utils.SnackBar('Error', 'Cannot Find Container with this RFID');
        throw Exception('Cannot Find Container with this RFID');
      }
    }
  }

  String? formattedTime;
  // Future<void> _handleRefresh() async {
  //   await fetchReciveYardAssets();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchReciveYardAssets().then((List<Asset>? items) {
  //     if (items != null && items.isNotEmpty) {
  //       setState(() {
  //         count = items.length;
  //       });
  //     }
  //   });
  // }
  // Asset containerData = new Asset();
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   rf_id.clear();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    String convertUnixTimestamp(int unixTimestamp) {
      // Convert Unix timestamp to milliseconds (Dart uses milliseconds, not seconds)
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          unixTimestamp * 1000,
          isUtc: true);
      // Format the DateTime object as '(Mon DD, YYYY HH:mm UTC)'
      String formattedTime =
          DateFormat("MMM dd, yyyy HH:mm 'UTC'").format(dateTime);

      return '($formattedTime)';
    }

    if (containerData?.date_updated != null) {
      formattedTime =
          convertUnixTimestamp(containerData!.date_updated!.toInt());
    }

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
          containerData == null
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    marked_at_arrival_at_yard();
                  },
                  child: Text(
                    'Done',
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
      body:
          //  RefreshIndicator(
          //   onRefresh: _handleRefresh,
          //   child:
          SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Asset Receipt & Offload',
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.48,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(ArrivalAtQuaysidePage(
                      ActiveLocationid: '${widget.ActiveLocationid}',
                      CurrentLocation: '${widget.Location.toString()}',
                    ));
                  },
                  child: Container(
                    width: 34.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.check_box,
                      size: 25,
                      color: Color(0xFFA80303),
                    )
                        // SvgPicture.asset(
                        //   'images/svg/text.svg',
                        //   width: 20.w,
                        //   height: 20.h,
                        // ),
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
                  widget.Location.toString(),
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
                  fetchReciveYardAssets(rf_id.text);
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
                                fetchReciveYardAssets(rf_id.text);
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
              height: 10.h,
            ),
            // here comes the row for text and filter
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // Text(
              //   'Scan Count : $count',
              //   //${countItems?.length}',
              //   style: GoogleFonts.inter(
              //     color: Color(0xFFA80303),
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //     height: 0,
              //     letterSpacing: 0.56,
              //   ),
              // ),
              // SvgPicture.asset('images/svg/filter.svg'),
            ]),

            SizedBox(
              height: 15.h,
            ),
            Text(
              'Asset Details',
              style: GoogleFonts.mulish(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            // here actually we use components for usage of this

            // StreamBuilder<List<ContainerData>>(
            //   stream: fetchReceiveYardAssetsStream(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //       return Text('No containers available');
            //     } else {
            //       return Column(
            //         children: snapshot.data!.asMap().entries.map((entry) {
            //           final index = entry.key;
            //           final container = entry.value;

            //           return InkWell(
            //             onTap: () {
            //               print(container.rf_id);
            //               print(container.containerType);
            //               // Add your onTap logic here
            //             },
            //             child: Center(
            //               child: ReceiptYard(
            //                 tfmcId: 'TFMC ID# ${container.id}',
            //                 structureType: container.containerType,
            //                 rfid: 'RFID# ${container.rf_id}',
            //                 description: container.description,
            //                 quantity: '', //'Quantity - 1',
            //                 edc: '', //'EDC 5 - Manifold',
            //                 dimensions: container.dimensions,
            //                 location: container.pulling_line_id,
            //                 weight: '', //'${container.weight_in_air}',
            //                 vessel: 'NA', // 'Miss Nora Barge',
            //                 origin: '', //'Enfield',
            //                 destination: widget.Location
            //                     .toString(), //'Dampier Quayside',
            //                 contamination: container.is_contaminated == true
            //                     ? 'Hazardous'
            //                     : 'NA',
            //                 // Add other properties as needed
            //               ),
            //             ),
            //           );
            //         }).toList(),
            //       );
            //     }
            //   },
            // ),
            if (containerData != null)
              ReceiptYard(
                tfmcId: containerData?.product_no == null
                    ? (containerData?.drum_no != null
                        ? 'Drum # ${containerData?.drum_no}'
                        : '')
                    : 'TFMC ID# ${containerData?.product_no}',
                // container.product_no == null
                //     ? container.drum_no.toString()
                //     : 'TFMC ID# ${container.product_no}',
                // structureType:
                //     '${(container.product == null && container.asset_type == 'Container') ? container.container_type : (container.product != null ? container.product : container.asset_type)}',

                structureType: containerData?.asset_type == null
                    ? ''
                    : containerData?.asset_type.toString() == 'Container'
                        ? '${containerData?.container_type}'
                        : '${containerData?.asset_type}',

                rfid: containerData?.rf_id == null
                    ? ''
                    : 'RFID# ${containerData?.rf_id}',
                description: containerData?.description == null
                    ? ''
                    : '${containerData?.description}',
                quantity: '', //'Quantity - 1',
                edc: '', //'EDC 5 - Manifold',
                dimensions: containerData?.dimensions == null
                    ? ''
                    : '${containerData?.dimensions.toString()}',
                location: containerData?.pulling_line == null
                    ? ''
                    : '${containerData?.pulling_line}',
                weight: containerData?.weight_in_air == null
                    ? ''
                    : '${containerData?.weight_in_air}', //'${container.weight_in_air}',
                vessel: ' ', // 'Miss Nora Barge',
                origin: containerData?.starting_point == null
                    ? ''
                    : '${containerData?.starting_point}', //markquayside.from_location,
                time: formattedTime == null ? '' : '$formattedTime',
                //'Enfield',
                destination: widget.Location.toString(), //'Dampier Quayside',
                contamination: containerData?.classification == null
                    ? ''
                    : '${containerData?.classification}',

                leftcolor:
                    containerData?.classification == Classification.HAZARDOUS
                        ? Colors.orange
                        : containerData?.classification ==
                                Classification.NON_CONTAMINATED
                            ? Colors.green
                            : Colors.red,
              ),

            // Container(
            //   height: 540.h,
            //   child:
            //    FutureBuilder<List<Asset>>(
            //     future: item(),
            //     builder: (context, snapshot) {
            //       // if (snapshot.connectionState == ConnectionState.waiting) {
            //       //   return Center(child: CircularProgressIndicator());
            //       // } else
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Center(child: CircularProgressIndicator());
            //       } else if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //       } else if (countItems!.isEmpty) {
            //         return Center(child: Text('No Items available'));
            //       } else {
            //         snapshot.data!.sort(
            //             (a, b) => b.date_updated!.compareTo(a.date_updated!));

            //         count = countItems!.length;
            //         print('count${count}');
            //         return ListView.builder(
            //             itemCount: countItems!.length,
            //             itemBuilder: (context, index) {
            //               final container = countItems![index];

            //               return Center(
            //                 child:

            //               );
            //             });
            //       }
            //     },
            //   ),

            // ),
          ]),
        ),
      ),
      // ),
    );
  }
}

// here come the componenet for above Quaside containers

class ReceiptYard extends StatefulWidget {
  final String tfmcId;
  final String structureType;
  final String rfid;
  final String description;
  final String quantity;
  final String edc;
  final String dimensions;
  final String location;
  final String weight;
  final String vessel;
  final String origin;
  final String destination;
  final String time;
  final String contamination;
  final leftcolor;

  ReceiptYard({
    Key? key,
    required this.tfmcId,
    required this.structureType,
    required this.rfid,
    required this.description,
    required this.quantity,
    required this.edc,
    required this.dimensions,
    required this.location,
    required this.weight,
    required this.vessel,
    required this.origin,
    required this.destination,
    required this.contamination,
    required this.time,
    required this.leftcolor,
  }) : super(key: key);

  @override
  _ReceiptYardState createState() => _ReceiptYardState();
}

class _ReceiptYardState extends State<ReceiptYard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 352.w,
        height: 160.h,
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
                color: widget.leftcolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Checkbox(
                      //   value: isChecked,
                      //   activeColor: Color(0xFFA80303),
                      //   onChanged: (bool? value) {
                      //     setState(() {
                      //       isChecked = value ?? false;
                      //     });
                      //   },
                      // ),
                      // SizedBox(
                      //   width: 10.w,
                      //   height: 10,
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 320.w,
                            child: Text(
                              widget.tfmcId,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: 0.40,
                              ),
                            ),
                          ),
                          Container(
                            width: 300.w,
                            child: Text(
                              widget.structureType,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 18,
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
                  SizedBox(height: 20.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 150,
                  //       child: Text(
                  //         widget.description,
                  //         style: GoogleFonts.inter(
                  //           color: Colors.black,
                  //           fontSize: 9,
                  //           fontWeight: FontWeight.w500,
                  //           height: 0,
                  //           letterSpacing: 0.36,
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       width: 150,
                  //       child: Text(
                  //         widget.quantity,
                  //         style: GoogleFonts.inter(
                  //           color: Colors.black,
                  //           fontSize: 9,
                  //           fontWeight: FontWeight.w500,
                  //           height: 0,
                  //           letterSpacing: 0.36,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 8.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 150,
                  //       child: Text(
                  //         widget.edc,
                  //         style: GoogleFonts.inter(
                  //           color: Color(0xFF808080),
                  //           fontSize: 10,
                  //           fontWeight: FontWeight.w500,
                  //           height: 0,
                  //           letterSpacing: 0.40,
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       width: 150,
                  //       child: Text.rich(
                  //         TextSpan(
                  //           children: [
                  //             // TextSpan(
                  //             //   text: 'Dimensions - ',
                  //             //   style: GoogleFonts.inter(
                  //             //     color: Color(0xFF808080),
                  //             //     fontSize: 9.sp,
                  //             //     fontWeight: FontWeight.w500,
                  //             //     height: 0,
                  //             //     letterSpacing: 0.36,
                  //             //   ),
                  //             // ),
                  //             TextSpan(
                  //               text: widget.dimensions,
                  //               style: GoogleFonts.inter(
                  //                 color: Color(0xFF262626),
                  //                 fontSize: 9.sp,
                  //                 fontWeight: FontWeight.w700,
                  //                 height: 0,
                  //                 letterSpacing: 0.36,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 8.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 150,
                  //       child: Text.rich(
                  //         TextSpan(
                  //           children: [
                  //             // TextSpan(
                  //             //   text: 'Location - ',
                  //             //   style: GoogleFonts.inter(
                  //             //     color: Color(0xFF808080),
                  //             //     fontSize: 10,
                  //             //     fontWeight: FontWeight.w500,
                  //             //     height: 0,
                  //             //     letterSpacing: 0.40,
                  //             //   ),
                  //             // ),
                  //             TextSpan(
                  //               text: widget.location,
                  //               style: GoogleFonts.inter(
                  //                 color: Colors.black,
                  //                 fontSize: 10,
                  //                 fontWeight: FontWeight.w700,
                  //                 height: 0,
                  //                 letterSpacing: 0.40,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       width: 150,
                  //       child: Text.rich(
                  //         TextSpan(
                  //           children: [
                  //             // TextSpan(
                  //             //   text: 'Weight in the Air - ',
                  //             //   style: GoogleFonts.inter(
                  //             //     color: Color(0xFF808080),
                  //             //     fontSize: 9,
                  //             //     fontWeight: FontWeight.w500,
                  //             //     height: 0,
                  //             //     letterSpacing: 0.36,
                  //             //   ),
                  //             // ),
                  //             TextSpan(
                  //               text: widget.weight,
                  //               style: GoogleFonts.inter(
                  //                 color: Color(0xFF262626),
                  //                 fontSize: 9,
                  //                 fontWeight: FontWeight.w700,
                  //                 height: 0,
                  //                 letterSpacing: 0.36,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 10.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 150,
                  //       // child: Text(
                  //       //   'Vessel:',
                  //       //   style: GoogleFonts.inter(
                  //       //     color: Color(0xFF808080),
                  //       //     fontSize: 10,
                  //       //     fontWeight: FontWeight.w500,
                  //       //     height: 0.20,
                  //       //     letterSpacing: -0.20,
                  //       //   ),
                  //       //  ),
                  //     ),
                  //     Container(
                  //       width: 150,
                  //       child: Text(
                  //         widget.vessel,
                  //         style: GoogleFonts.inter(
                  //           color: Color(0xFF262626),
                  //           fontSize: 10,
                  //           fontWeight: FontWeight.w700,
                  //           height: 0.20,
                  //           letterSpacing: -0.20,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.w,
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
                        width: 150.w,
                        child: Text(
                          widget.origin,
                          style: TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.20,
                            letterSpacing: -0.20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 150),
                    child: Container(
                      width: 190.w,
                      child: Text(
                        widget.time,
                        style: GoogleFonts.inter(
                          color: Color(0xFF262626),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 0.20,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.w,
                        child: Text(
                          'Destination:',
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
                        width: 150.w,
                        child: Text(
                          widget.destination,
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
                        width: 150.w,
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
                        width: 150.w,
                        child: Text(
                          widget.contamination,
                          style: GoogleFonts.inter(
                            color:
                                widget.contamination == Classification.HAZARDOUS
                                    ? Colors.orange
                                    : widget.contamination ==
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
