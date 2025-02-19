// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/New%20Design/Arrival_At_Quayside/Quasidefilter.dart';
import 'package:asset_tracking/Repository/Arival_At_Quayside_Repostiory/fetch_list_container.dart';
import 'package:asset_tracking/Repository/Arival_At_Quayside_Repostiory/mark_arrivedQuayside_repository.dart';
import 'package:asset_tracking/Repository/CreateShipment_Repository/Voyages_Repository/fetch_voyage_containerList_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:asset_tracking/main.dart';

class ArrivalAtQuaysidePage extends StatefulWidget {
  String? FromLocationid;
  String? Vesselid;
  String? ActiveLocationid;
  String? CurrentLocation;
  ArrivalAtQuaysidePage(
      {super.key,
      this.ActiveLocationid,
      this.Vesselid,
      this.FromLocationid,
      this.CurrentLocation});

  @override
  State<ArrivalAtQuaysidePage> createState() => _ArrivalAtQuaysidePageState();
}

class _ArrivalAtQuaysidePageState extends State<ArrivalAtQuaysidePage> {
  bool isChecked = false;
  List<Asset> selectedIds = [];
  // TextEditingController rf_id = TextEditingController();
  int count = 0;
  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.FromLocationid != null || widget.Vesselid != null) {
          // Navigate back to the bottom screen if filter is not null
          //Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                context,
              ) {
                // Return the widget that represents the screen you want to navigate to
                return NewBottomNavigation();
                //BottomNavigation();
              },
            ),
          );
          return false; // Prevent default back button behavior
        }
        return true; // Allow default back button behavior
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate to the bottom navigation screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (
                    context,
                  ) {
                    // Return the widget that represents the screen you want to navigate to
                    return NewBottomNavigation();
                    //BottomNavigation();
                  },
                ),
              );
              return null; // Prevent default back button behavior
            },
          ),
          actions: [
            InkWell(
              onTap: () {
                // here it goea to

                if (count == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please Select Item ....'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  LoadingScreen.showLoading(context);
                  mark_arrived_at_yard(selectedIds);
                }
              },
              child: Container(
                height: 45,
                width: 95,
                // color: Colors.red,
                child: Center(
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
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receipt Yard & Offload',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
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
                    decoration: InputDecoration(
                        //  hintText: 'RFID# 3829382372874827832',
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
                                  sendActionToNative("Pressed");
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
                        contentPadding: EdgeInsets.all(8)),
                  ),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),
              // here comes the row for text and filter
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Count :${count}',
                  style: GoogleFonts.inter(
                    color: Color(0xFFA80303),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.56,
                  ),
                ),
                InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return QuaysideFilter(
                              currentlocation: widget.CurrentLocation,
                              ActiveLocationid: widget.ActiveLocationid);
                        },
                      );
                    },
                    child: SvgPicture.asset('images/svg/filter.svg')),
              ]),

              SizedBox(
                height: 20.h,
              ),
              // here actually we use components for usage of this
              FutureBuilder<List<Asset>?>(
                future: fetch_voyage_assets(widget.ActiveLocationid,
                    widget.Vesselid, widget.FromLocationid, rf_id.text),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No containers available');
                  } else {
                    return Column(
                      children: snapshot.data!.asMap().entries.map((entry) {
                        //  final index = entry.key;
                        final markquayside = entry.value;

                        return FutureBuilder<List<Asset>?>(
                            future: fetchAssetItemInVessel(
                              markquayside,
                            ),
                            builder: (context, itemSnapshot) {
                              if (itemSnapshot.hasError) {
                                return Text('Error: ${itemSnapshot.error}');
                              } else {
                                // final index = entry.key;
                                var items = itemSnapshot.data;
                                List<String>? productNos;
                                List<String>? productName;
                                List<String>? bundle;
                                List<String>? batch;
                                List<String>? drum_no;
                                List<String>? no_of_joint;
                                List<String>? no_of_length;

                                if (items != null && items.length > 0) {
                                  productNos = items
                                      .where((obj) => obj.product_no != null)
                                      .map((obj) => obj.product_no!)
                                      .toList();

                                  productName = items
                                      .where((obj) => obj.product != null)
                                      .map((obj) => obj.product!)
                                      .toList();

                                  bundle = items
                                      .where((obj) => obj.bundle_no != null)
                                      .map((obj) => obj.bundle_no.toString())
                                      .toList();

                                  batch = items
                                      .where((obj) => obj.batch_no != null)
                                      .map((obj) => obj.batch_no.toString())
                                      .toList();

                                  drum_no = items
                                      .where((obj) => obj.drum_no != null)
                                      .map((obj) => obj.drum_no.toString())
                                      .toList();

                                  no_of_joint = items
                                      .where((obj) => obj.no_of_joints != null)
                                      .map((obj) => obj.no_of_joints.toString())
                                      .toList();

                                  no_of_length = items
                                      .where((obj) => obj.no_of_lengths != null)
                                      .map(
                                          (obj) => obj.no_of_lengths.toString())
                                      .toList();
                                }

                                String getTFMCID() {
                                  if (markquayside.asset_type.toString() ==
                                      'Container') {
                                    var result;

                                    result = productNos != null &&
                                            productNos.length > 0
                                        ? '${productNos.map((item) => 'TFMC ID# $item').join('\n')}'
                                        : 'Drum # ${drum_no?.map((item) => 'Drum# $item').join('\n')}';

                                    //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                    return result;
                                  } else {
                                    return 'TFMC ID # ${markquayside.product_no}';
                                  }
                                }

                                String getProduct() {
                                  if (markquayside.asset_type.toString() ==
                                      'Container') {
                                    var result;

                                    result = productName != null &&
                                            productName.length > 0
                                        ? '${productName.map((item) => '$item').join('\n')}'
                                        : 'Drum # ${productName?.map((item) => '$item').join('\n')}';

                                    //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                    return result;
                                  } else {
                                    return '${markquayside.product}';
                                  }
                                }

                                String getbndle() {
                                  if (markquayside.asset_type.toString() ==
                                      'Container') {
                                    var result;

                                    result = bundle != null && bundle.length > 0
                                        ? '${bundle.map((item) => 'Bundle# $item').join('\n')}'
                                        : '';

                                    result += batch != null && batch.length > 0
                                        ? '\n${batch.map((item) => 'Batch # $item').join('\n')}'
                                        : '';

                                    //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                    return result;
                                  } else {
                                    return '';
                                  }
                                }

                                String getlength() {
                                  if (markquayside.asset_type.toString() ==
                                      'Container') {
                                    var result;

                                    result = no_of_joint != null &&
                                            no_of_joint.length > 0
                                        ? '${no_of_joint.map((item) => 'No of joint$item').join('\n')}'
                                        : ' ${no_of_length?.map((item) => 'No of Length $item').join('\n')}';

                                    //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                    return result;
                                  } else {
                                    return '${markquayside.product}';
                                  }
                                }

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
                                    markquayside.date_added!.toInt());
                                List<Widget> buildDialogContent(markquayside) {
                                  List<Widget> content = [];

                                  content.add(
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('${getProduct()}'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (markquayside.asset_type
                                                      .toString() ==
                                                  'Container')
                                                Text('${getlength()}'),
                                              if (markquayside.asset_type
                                                      .toString() ==
                                                  'Container')
                                                Text('${getlength()}'),
                                              // Add more details based on your requirements
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                  return content;
                                }

                                // snapshot.data!.sort((a, b) =>
                                //     b.date_added!.compareTo(a.date_added!));

                                return GestureDetector(
                                  onTap: () {
                                    // Show dialog here and print the selected index
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return Container(
                                    //       width: 500,
                                    //       child: AlertDialog(
                                    //         title: Text('Details'),
                                    //         content: Container(
                                    //           height: 400,
                                    //           // Adjust the height as needed
                                    //           child: Column(
                                    //             crossAxisAlignment:
                                    //                 CrossAxisAlignment.start,
                                    //             children: buildDialogContent(
                                    //                 markquayside),
                                    //             //   children: [
                                    //             //     Container(
                                    //             //       height: 200,
                                    //             //       color: Colors.red,
                                    //             //       child: Row(children: [
                                    //             //         Container(
                                    //             //           width: 150,
                                    //             //           color: Colors.yellow,
                                    //             //           child: Column(
                                    //             //             children: [
                                    //             //               // Text('${getTFMCID()}'),
                                    //             //               Text(
                                    //             //                   '${getProduct()}'),
                                    //             //             ],
                                    //             //           ),
                                    //             //         ),
                                    //             //         Column(
                                    //             //           children: [
                                    //             //             Text('${getlength()}'),
                                    //             //             // Text('${getbndle()}'),
                                    //             //             // Text('${getlength()}'),
                                    //             //           ],
                                    //             //         )
                                    //             //       ]),
                                    //             //     )

                                    //             //     // Add more details based on your requirements
                                    //             //   ],
                                    //           ),
                                    //         ),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             onPressed: () {
                                    //               Navigator.of(context)
                                    //                   .pop(); // Close the dialog
                                    //             },
                                    //             child: Text('OK'),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: Container(
                                    child: QuaysideContainers(
                                      leftBorderColor:
                                          markquayside.classification ==
                                                  Classification.HAZARDOUS
                                              ? Colors.orange
                                              : markquayside.classification ==
                                                      Classification
                                                          .NON_CONTAMINATED
                                                  ? Colors.green
                                                  : Colors.red,

                                      tfmcId: getTFMCID(),
                                      bundle: getbndle(),
                                      structureType: markquayside.asset_type ==
                                              'Container'
                                          ? markquayside.container_type
                                              .toString()
                                          : markquayside.asset_type.toString(),

                                      rfid: 'RFID# ${markquayside.rf_id}',
                                      description: getProduct(),
                                      //'Description',
                                      quantity: markquayside.asset_type ==
                                              AssetType.SUBSEA_STRUCTURE
                                          ? 'Quantity - 1'
                                          : '',
                                      edc: markquayside.description?.isEmpty
                                              .toString() ??
                                          '', // 'EDC 5 - Manifold',
                                      dimensions: (markquayside.dimensions ==
                                                  null &&
                                              markquayside.no_of_joints == null)
                                          ? '' // Return empty string if both are null
                                          : (markquayside.dimensions == null &&
                                                  markquayside.no_of_joints !=
                                                      0.0)
                                              ? 'No of Joint ${markquayside.no_of_joints}'
                                              : (markquayside.dimensions != 0.0)
                                                  ? 'Dimensions - ${markquayside.dimensions}'
                                                  : '', //'3.46mx8.45mx8.5m',
                                      location: markquayside.pulling_line ==
                                              null
                                          ? ''
                                          : 'Location - ${markquayside.pulling_line}', //'EDC5',
                                      weight: (markquayside.weight_in_air ==
                                                  null &&
                                              markquayside.no_of_lengths ==
                                                  null)
                                          ? '' // Return empty string if both are null
                                          : (markquayside.weight_in_air ==
                                                      null &&
                                                  markquayside.no_of_lengths !=
                                                      null)
                                              ? 'No of Length ${markquayside.no_of_lengths}'
                                              : (markquayside.weight_in_air !=
                                                      null)
                                                  ? 'Weight in the Air - ${markquayside.weight_in_air}'
                                                  : '',

                                      //  markquayside.weight_in_air == null
                                      //     ? 'No of Length ${markquayside.no_of_lengths}'
                                      //     : 'Weight in the Air -${markquayside.weight_in_air}'
                                      //         .toString(), // markquayside.weight_in_air, //'70.3 Te',
                                      vessel: '${markquayside.vessel}',
                                      origin: '${markquayside.voyage_origin}',
                                      date: '$formattedTime',
                                      destination:
                                          '${markquayside.voyage_destination}',

                                      contamination: markquayside.classification
                                          .toString(),

                                      onCheckboxChanged: (isChecked) {
                                        setState(() {
                                          if (isChecked) {
                                            count++;
                                            selectedIds.add(markquayside);
                                          } else {
                                            count--;
                                            //selectedIds.remove(markquayside);

                                            selectedIds.removeWhere((item) =>
                                                item.rf_id ==
                                                markquayside.rf_id);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }
                            });
                      }).toList(),
                    );
                  }
                },
              ),

              // FutureBuilder<List<QuaySide>>(
              //   future: fetchVissels(widget.ActiveLocationid.toString()),
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
              //           final quayside = entry.value;

              //           return InkWell(
              //             onTap: () {
              //               print(quayside.voyage_id);
              //               print(quayside.vessel);

              //               setState(() {
              //                 // RFID = container.rf_id;
              //                 // Get.to(MarkArival(
              //                 //   vesselid: quayside.voyage_id,
              //                 // ));
              //               });
              //             },
              //             child: Center(
              //                 child: Padding(
              //               padding: const EdgeInsets.only(top: 20),
              //               child: QuaysideContainers(
              //                 tfmcId: quayside.voyage_id,
              //                 structureType: 'Subsea Structure',
              //                 rfid: 'RFID# 3829382372874827832',
              //                 description: 'Description',
              //                 quantity: 'Quantity - 1',
              //                 edc: 'EDC 5 - Manifold',
              //                 dimensions: '3.46mx8.45mx8.5m',
              //                 location: 'EDC5',
              //                 weight: '70.3 Te',
              //                 vessel: quayside.vessel,
              //                 origin: 'Enfield',
              //                 destination: 'Dampier Quayside',
              //                 contamination: 'Hazardous',

              //               ),
              //             )),
              //           );
              //         }).toList(),
              //       );
              //     }
              //   },
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}

// here come the componenet for above Quaside containers

class QuaysideContainers extends StatefulWidget {
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
  final ValueChanged<bool> onCheckboxChanged;
  final leftBorderColor;

  QuaysideContainers({
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
    required this.onCheckboxChanged,
    required this.leftBorderColor,
  }) : super(key: key);

  @override
  _QuaysideContainersState createState() => _QuaysideContainersState();
}

class _QuaysideContainersState extends State<QuaysideContainers> {
  bool isChecked = false;

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
                      Checkbox(
                        value: isChecked,
                        activeColor: Color(0xFFA80303),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                            widget.onCheckboxChanged(isChecked);
                          });
                        },
                      ),
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
                            width: 270.w,
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
                        width: 150,
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
                        width: 150,
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
                        width: 150,
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
                        width: 150,
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
                        width: 150,
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
                        width: 150,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Text(
                          'Vessel:',
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
                    ],
                  ),
                  SizedBox(height: 15.h),
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
                      width: 150,
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
                        width: 150,
                        child: Text(
                          'Destination:', //'Destination:',
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
