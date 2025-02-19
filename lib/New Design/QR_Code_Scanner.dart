import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:async';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:asset_tracking/main.dart';

class AssetContainer {
  Asset? asset;
  List<dynamic>?
      notes; // Adjust the type if you have a specific class for notes

  AssetContainer({this.asset, this.notes});
}

class QRCodeScanner extends StatefulWidget {
  QRCodeScanner({
    super.key,
  });

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  bool isChecked = false;
  TextEditingController commentController = TextEditingController();

  // TextEditingController rf_id = TextEditingController();
  int count = 0;
  // Asset? containerData;
  AssetContainer? containerData;
  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  Future<Asset> fetchAssets(String RfId) async {
    if (RfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        // ['status', '=', AssetStatus.ARRIVED_AT_QUAYSIDE],
        ['rf_id', '=', RfId]
      ], {});

      if (data != null) {
        final resp = data.map((json) => Asset.fromJson(json)).toList();
        Asset asset = resp[0];

        final notes = await DatabaseHelper.instance.queryList('asset_notes', [
          // ['status', '=', AssetStatus.ARRIVED_AT_QUAYSIDE],
          ['asset_id', '=', asset.asset_id]
        ], {});

        // Sort notes by date_added descending
        notes?.sort((a, b) => b['date_added'].compareTo(a['date_added']));

        setState(() {
          containerData = AssetContainer(asset: asset, notes: notes);
        });

        print(asset.toMap());
        return asset;
      } else {
        Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
        throw Exception('Cannot Find Asset with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  String? formattedTime;

  insertNotes(
    String Asset_ID,
    String Commits,
    String AssetStatus,
  ) async {
    AssetNotes assetNotes = new AssetNotes();
    assetNotes.asset_id = Asset_ID;
    assetNotes.description = Commits;
    assetNotes.status = AssetStatus;
    assetNotes.is_sync = 0;
    await DatabaseHelper.instance.createAssetNotes(assetNotes);
    Get.to(NewBottomNavigation());
  }

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

    if (containerData?.asset?.date_updated != null) {
      formattedTime =
          convertUnixTimestamp(containerData!.asset!.date_updated!.toInt());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
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
                  'Scan & Search',
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
                  fetchAssets(rf_id.text);
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
                                fetchAssets(rf_id.text);
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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: []),

            SizedBox(
              height: 15.h,
            ),
            if (containerData != null)
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
                note: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          title: Text('Add Notes'),
                          content: Container(
                            width: 700.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(
                                  width: 2, color: Colors.grey.shade300),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                maxLines: 1000,
                                controller: commentController,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Write a note...',
                                  hintStyle: GoogleFonts.inter(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                if (commentController.text.isEmpty) {
                                  Utils.toastMessage(
                                      '  Please enter a comment');
                                } else {
                                  insertNotes(
                                    containerData?.asset?.asset_id ?? '',
                                    commentController.text,
                                    containerData?.asset?.status?.toString() ??
                                        '',
                                  );
                                  Navigator.of(context).pop();
                                } // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 34.w,
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child:
                            //  SvgPicture.asset(
                            //   'images/svg/text.svg',
                            //   width: 20.w,
                            //   height: 20.h,
                            // ),
                            Icon(
                      Icons.edit,
                      color: Color(0xFFA80303),
                    )),
                  ),
                ),

                tfmcId: containerData?.asset?.product_no == null
                    ? (containerData?.asset?.drum_no != null
                        ? 'Drum # ${containerData?.asset?.drum_no}'
                        : '')
                    : 'TFMC ID# ${containerData?.asset?.product_no}',
                // container.product_no == null
                //     ? container.drum_no.toString()
                //     : 'TFMC ID# ${container.product_no}',
                // structureType:
                //     '${(container.product == null && container.asset_type == 'Container') ? container.container_type : (container.product != null ? container.product : container.asset_type)}',

                structureType: containerData?.asset?.asset_type == null
                    ? ''
                    : containerData?.asset?.asset_type.toString() == 'Container'
                        ? '${containerData?.asset?.container_type}'
                        : '${containerData?.asset?.asset_type}',

                rfid: containerData?.asset?.rf_id == null
                    ? ''
                    : 'RFID# ${containerData?.asset?.rf_id}',
                description: containerData?.asset?.description == null
                    ? ''
                    : '${containerData?.asset?.description}',
                quantity: containerData?.asset?.no_of_lengths == null
                    ? '${containerData?.asset?.toString()}'
                    : '${containerData?.asset?.no_of_lengths.toString()}',
                edc: '',
                dimensions: containerData?.asset?.dimensions == null
                    ? ''
                    : '${containerData?.asset?.dimensions.toString()}',
                location: containerData?.asset?.pulling_line == null
                    ? ''
                    : '${containerData?.asset?.pulling_line}',
                weight: containerData?.asset?.weight_in_air == null
                    ? ''
                    : '${containerData?.asset?.weight_in_air}',
                vessel: ' ', // 'Miss Nora Barge',
                origin: containerData?.asset?.no_of_joints != null
                    ? 'No of Joint:                                        ${containerData?.asset?.no_of_joints.toString()}'
                    : containerData?.asset?.no_of_lengths != null &&
                            containerData?.asset?.no_of_lengths != 0.0
                        ? 'No of Length:                                   ${containerData?.asset?.no_of_lengths.toString()}'
                        : containerData?.asset?.no_of_lengths != null
                            ? 'Weight in Air:                                   ${containerData?.asset?.weight_in_air.toString()}'
                            : '',

                //markquayside.from_location,
                time: containerData == null ? '' : '$formattedTime',
                //'Enfield',
                destination: containerData == null
                    ? ''
                    : 'Status                                                    ${containerData?.asset?.status}', //'Dampier Quayside',
                contamination: containerData?.asset?.classification == null
                    ? ''
                    : '${containerData?.asset?.classification}',

                leftcolor: containerData?.asset?.classification ==
                        Classification.HAZARDOUS
                    ? Colors.orange
                    : containerData?.asset?.classification ==
                            Classification.NON_CONTAMINATED
                        ? Colors.green
                        : Colors.red,
              ),

            if (containerData != null &&
                containerData!.notes != null &&
                containerData!.notes!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Asset Notes',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      // background: Paint()..color = Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: 250.h,
                    child: ListView.builder(
                      itemCount: containerData?.notes?.length,
                      itemBuilder: (context, index) {
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

                        final note = containerData?.notes?[index];
                        String formattedTime =
                            convertUnixTimestamp(note?['date_added']);
                        print(note);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.white, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                            ),

                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            title: Text(note['description']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Status: ${note?['status']}',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFA80303),
                                    // background: Paint()..color = Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                                Text(
                                  ' Date: ${formattedTime}',
                                  style: GoogleFonts.mulish(
                                    color: Colors.black,
                                    // background: Paint()..color = Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                              ],
                            ),
                            leading: Icon(
                              Icons.note,
                              color: Color(0xFFA80303),
                            ), // Just an example icon
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
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
  final Widget note;

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
    required this.note,
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
        height: 200.h,
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
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 300, bottom: 20),
                      child: widget.note),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 300.w,
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
