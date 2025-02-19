// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/Repository/CreateProcess_Repository/fetch_product_repository.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:asset_tracking/main.dart';

class Tag_Sreeen_New extends StatefulWidget {
  String? Status;
  String? filter;
  String? Location;

  Tag_Sreeen_New({
    super.key,
    this.Status,
    this.filter,
    this.Location,
  });

  @override
  State<Tag_Sreeen_New> createState() => _Tag_Sreeen_NewState();
}

class _Tag_Sreeen_NewState extends State<Tag_Sreeen_New> {
  //TextEditingController rf_id = TextEditingController();
  TextEditingController commits = TextEditingController();
  TextEditingController search = TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey();

  updateRFID(
    String Asset_ID,
    String Pre_RFID,
    String New_RFID,
    String Commits,
  ) async {
    final rfIdExists =
        await DatabaseHelper.instance.queryUnique('assets', 'rf_id', New_RFID);
    if (rfIdExists?.length != 0) {
      Utils.SnackBar('Error', 'RFID already exists.');
      throw Exception('RFID already exists.');
    }

    await DatabaseHelper.instance.update(
        'assets', 'asset_id', Asset_ID, {'rf_id': New_RFID, 'is_sync': 0});
    AssetColumnHistory assetColumnHistory = new AssetColumnHistory();
    assetColumnHistory.asset_id = Asset_ID;
    assetColumnHistory.column_name = 'rf_id';
    assetColumnHistory.old_value = Pre_RFID;
    assetColumnHistory.new_value = New_RFID;
    assetColumnHistory.comments = Commits;
    assetColumnHistory.is_sync = 0;

    await DatabaseHelper.instance.createAssetColumnHistory(assetColumnHistory);
    Get.to(NewBottomNavigation());
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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${widget.Status}',
                      style: GoogleFonts.mulish(
                        color: Color(0xFF262626),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.44,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),

              // SizedBox(
              //   height: 30.h,
              // ),

              // Padding(
              //   padding: EdgeInsets.only(left: 20, right: 20),
              //   child: Container(
              //     width: MediaQuery.sizeOf(context).width / .9,
              //     height: 50.h,
              //     decoration: ShapeDecoration(
              //       shape: RoundedRectangleBorder(
              //         side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 4),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             width: MediaQuery.sizeOf(context).width /
              //                 1.6, // Adjust the width as needed
              //             height: 50, // Match the container height
              //             child: TextFormField(
              //               autofocus: true,
              //               controller: rf_id,
              //               decoration: InputDecoration(
              //                   hintText: 'Scan RFID ',
              //                   helperStyle: GoogleFonts.mulish(
              //                     color: Colors.black,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w700,
              //                     height: 0,
              //                     letterSpacing: -0.28,
              //                   ),
              //                   border: InputBorder.none,
              //                   contentPadding: EdgeInsets.all(8)),
              //             ),
              //           ),

              //           Container(
              //             width: 40.w,
              //             height: 40.h,
              //             decoration: BoxDecoration(
              //               color: Color(0xFFA80303),
              //               shape: BoxShape
              //                   .circle, // Use BoxShape.circle for a circular shape
              //             ),
              //             child: Center(
              //               child: SvgPicture.asset(
              //                 'images/svg/scaner.svg',
              //                 height: 25,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 15.h,
              ),
              //Search Field And Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 350.w,
                  height: 50.h,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF9F9F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextFormField(
                    controller: search,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onTapOutside: (value) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        //suffixIcon:
                        // InkWell(
                        //   onTap: () {
                        //     showModalBottomSheet(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return NewFilterCustomSnackbar(
                        //           type: widget.Status.toString(),
                        //           CurrentLocation: widget.Location,
                        //         );
                        //       },
                        //     );
                        //   },
                        //   child: Icon(Icons.filter_list),
                        // ),
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
              ),

              // S

              SizedBox(
                height: 15.h,
              ),
              //Extend Able Card  which load data from api
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 630.h,
                  child: FutureBuilder<List<Asset>>(
                    future: fetchAssetsList(
                      widget.Status.toString(), search.text,
                      // Pass the search term
                      // Pass the filter value (can be null if not selected)
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.data!.isEmpty) {
                        return Text('No Asset found.');
                      } else {
                        final products = snapshot.data!;

                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final record = products[index];

                            String convertUnixTimestamp(int unixTimestamp) {
                              // Convert Unix timestamp to milliseconds (Dart uses milliseconds, not seconds)
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      unixTimestamp * 1000,
                                      isUtc: true);

                              // Format the DateTime object as '(Mon DD, YYYY HH:mm UTC)'
                              String formattedTime =
                                  DateFormat("MMM dd, yyyy HH:mm 'UTC'")
                                      .format(dateTime);

                              return '($formattedTime)';
                            }

                            String formattedTime = convertUnixTimestamp(
                                record.date_added!.toInt());

                            print(record.no_of_joints);

                            return InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: 500,
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        surfaceTintColor: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        title: Text(
                                          'Update RFID',
                                          style: GoogleFonts.mulish(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            height: 0,
                                            letterSpacing: -0.28,
                                          ),
                                        ),
                                        content: Container(
                                          height: 400,
                                          // Adjust the height as needed
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Previous RFID',
                                                      style: GoogleFonts.mulish(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 0,
                                                        letterSpacing: -0.28,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      child: Container(
                                                        width: 350.w,
                                                        height: 50.h,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color:
                                                              Color(0xFFF9F9F9),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        child: TextFormField(
                                                          enabled: false,
                                                          controller:
                                                              TextEditingController(
                                                                  text: record
                                                                      .rf_id),
                                                          onChanged: (value) {
                                                            setState(() {});
                                                          },
                                                          onTapOutside:
                                                              (value) {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Scan New RFID',
                                                      style: GoogleFonts.mulish(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 0,
                                                        letterSpacing: -0.28,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 10),
                                                      child: Container(
                                                        width: 350.w,
                                                        decoration:
                                                            ShapeDecoration(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                width: 2,
                                                                color: Color(
                                                                    0xFFF4F5F6)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                        child: TextFormField(
                                                          autofocus: true,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please fill out this field';
                                                            } else if (value ==
                                                                record.rf_id) {
                                                              return 'Please Use Different RFID';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {});
                                                          },
                                                          controller: rf_id,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Scan RFID ',
                                                                  suffixIcon:
                                                                      Container(
                                                                    width: 91.w,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        if (rf_id
                                                                            .text
                                                                            .isNotEmpty)
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.clear),
                                                                            onPressed:
                                                                                () {
                                                                              rf_id.clear();
                                                                            },
                                                                          ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            sendActionToNative("Pressed");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                40.w,
                                                                            height:
                                                                                40.h,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color(0xFFA80303),
                                                                              shape: BoxShape.circle, // Use BoxShape.circle for a circular shape
                                                                            ),
                                                                            child:
                                                                                Center(
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
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8)),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Comment:',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Container(
                                                            width: 700,
                                                            height: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: TextField(
                                                                maxLines: 1000,
                                                                controller:
                                                                    commits,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Write a note...',
                                                                  hintStyle:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xFFCCCCCC),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                LoadingScreen.showLoading(
                                                    context,
                                                    duration:
                                                        Duration(seconds: 5));
                                                updateRFID(
                                                  record.asset_id.toString(),
                                                  record.rf_id.toString(),
                                                  rf_id.text.toString(),
                                                  commits.text.toString(),
                                                ).whenComplete(() async {
                                                  AssetLog log = new AssetLog();
                                                  final userInfo =
                                                      await SharedPreferencesHelper
                                                          .retrieveUserInfo(
                                                              'userInfo');
                                                  String eventType = EventType
                                                      .TAG_NUMBER_SWAPPED;
                                                  var template =
                                                      eventDefinition[eventType]
                                                          .toString();
                                                  Map<String, String>
                                                      variables = {
                                                    'asset_type': record
                                                        .asset_type
                                                        .toString(),
                                                    'old_rfid':
                                                        record.rf_id.toString(),
                                                    'new_rfid':
                                                        rf_id.text.toString(),
                                                    'user':
                                                        userInfo['user_name'],
                                                    'time': DateFormat(
                                                            'hh:mm a MMM dd yyyy')
                                                        .format(DateTime.now()),
                                                  };

                                                  var eventDesc =
                                                      replaceVariables(
                                                          template, variables);

                                                  log.asset_id = record.asset_id
                                                      .toString();
                                                  log.event_type = eventType;
                                                  log.event_description =
                                                      eventDesc;
                                                  log.current_transaction =
                                                      jsonEncode(
                                                          record.toMap());
                                                  log.status =
                                                      record.status.toString();
                                                  log.current_location_id =
                                                      userInfo['locationId'];

                                                  log.asset_type = record
                                                      .asset_type
                                                      .toString();
                                                  DatabaseHelper.instance
                                                      .createAssetLog(log);
                                                });
                                                Navigator.of(context).pop();
                                              }

                                              // Close the dialog
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: NewTagedItem(
                                leftBorderColor: record.classification ==
                                        Classification.HAZARDOUS
                                    ? Colors.orange
                                    : record.classification ==
                                            Classification.NON_CONTAMINATED
                                        ? Colors.green
                                        : Colors.red,

                                tfmcId: record.product_no.toString(),
                                bundle: record.bundle_no.toString(),
                                structureType: record.asset_type == 'Container'
                                    ? record.container_type.toString()
                                    : record.asset_type.toString(),

                                rfid: 'RFID# ${record.rf_id}',
                                description: record.product.toString(),
                                //'Description',
                                quantity: record.asset_type ==
                                        AssetType.SUBSEA_STRUCTURE
                                    ? 'Quantity - 1'
                                    : '',
                                edc: record.description?.isEmpty.toString() ??
                                    '', // 'EDC 5 - Manifold',
                                dimensions: (record.dimensions == null &&
                                        record.no_of_joints == null)
                                    ? '' // Return empty string if both are null
                                    : (record.dimensions == null)
                                        ? 'No of Joint ${record.no_of_joints}'
                                        : (record.dimensions != null &&
                                                record.no_of_joints == 0.0)
                                            ? 'Dimensions - ${record.dimensions}'
                                            : 'No of Joint   ${record.no_of_joints?.toInt()}',
                                location: record.pulling_line == null
                                    ? ''
                                    : 'Location - ${record.pulling_line}', //'EDC5',
                                weight: (record.weight_in_air == null &&
                                        record.no_of_lengths == null)
                                    ? '' // Return empty string if both are null
                                    : (record.weight_in_air == 0.0 &&
                                            record.no_of_lengths != null)
                                        ? 'No of Length ${record.no_of_lengths}'
                                        : (record.weight_in_air != null)
                                            ? 'Weight in the Air - ${record.weight_in_air}'
                                            : '',
                                vessel: '',
                                origin: record.status == null
                                    ? 'N/A'
                                    : 'Status    ${record.status}',
                                date: '$formattedTime',
                                destination:
                                    'Destination:  ', //'Dampier Quayside',
                                contamination: '${record.classification}',
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class NewTagedInfoContainer extends StatefulWidget {
  final String id;
  final String title;

  NewTagedInfoContainer({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  _NewTagedInfoContainerState createState() => _NewTagedInfoContainerState();
}

class _NewTagedInfoContainerState extends State<NewTagedInfoContainer> {
  bool isSelected = false;
  var isChecked = false.obs;

  bool shouldHideDropdowns = false;

  // String? _selectedADGClass = '7';
  // String? _selectedClassCategory = 'Expected';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 5, top: 20),
      child: Column(
        children: [
          Container(
            height: 109.h,
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
                )
              ],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 200.w,
                                child: Text(
                                  '${widget.id}',
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: 0.36,
                                  ),
                                ),
                              ),
                              Container(
                                width: 205.w,
                                // color: Colors.red,
                                child: Text(
                                  widget.title,
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                    letterSpacing: 0.64,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 125.w,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                color: Color(0xFF808080),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: 0.48,
              ),
            ),
          ),
          Container(
            width: 125.w,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: Color(0xFF262626),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewTagedItem extends StatefulWidget {
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
  final String date;
  final String destination;
  final String contamination;
  final String bundle;

  final leftBorderColor;

  NewTagedItem({
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
    required this.date,
    required this.destination,
    required this.contamination,
    required this.bundle,
    required this.leftBorderColor,
  }) : super(key: key);

  @override
  _NewTagedItemState createState() => _NewTagedItemState();
}

class _NewTagedItemState extends State<NewTagedItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 360.w,
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
          children: [
            Container(
              width: 5,
              height: 300,
              decoration: BoxDecoration(
                color: widget.leftBorderColor,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10.w,
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(
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
                                // Text(
                                //   widget.bundle,
                                //   textAlign: TextAlign.right,
                                //   style: GoogleFonts.inter(
                                //     color: Colors.black,
                                //     fontSize: 10,
                                //     fontWeight: FontWeight.w500,
                                //     height: 0,
                                //     letterSpacing: 0.40,
                                //   ),
                                // ),
                              ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.w.w,
                        child: Text(
                          widget.description,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.36,
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        child: Text(
                          widget.quantity,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.36,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.w,
                        child: Text(
                          widget.edc,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: widget.dimensions,
                                style: GoogleFonts.inter(
                                  color: Color(0xFF262626),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                  letterSpacing: 0.36,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        width: 150.w,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: widget.location,
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                  letterSpacing: 0.40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: widget.weight,
                                style: GoogleFonts.inter(
                                  color: Color(0xFF262626),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                  letterSpacing: 0.36,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 300,
                    child: Text(
                      widget.vessel,
                      style: GoogleFonts.inter(
                        color: Color(0xFF262626),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 0.20,
                        letterSpacing: -0.20,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 300.w,
                        child: Text(
                          widget.origin,
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
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 150),
                    child: Container(
                      width: 150.w,
                      child: Text(
                        widget.date,
                        style: GoogleFonts.inter(
                          color: Color(0xFF808080),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          height: 0.56,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 300.w,
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
                          'Contamination: ',
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.40,
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
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
