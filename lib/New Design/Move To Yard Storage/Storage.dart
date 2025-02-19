// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Move%20To%20Yard%20Storage/Racks.dart';
import 'package:asset_tracking/New%20Design/Move%20To%20Yard%20Storage/Rigids_Pipes/HazMatWaste_Storage.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/main.dart';

class StorageScreen extends StatefulWidget {
  String? title;
  StorageScreen({super.key, this.title});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  Asset containerData = new Asset();
  List<Asset>? batchItems = [];
  var item;

  Future<Asset> fetchcontainer(String rfId) async {
    if (rfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        ['rf_id', '=', rfId],
        ['asset_type', '=', AssetType.CONTAINER],
        ['status','=',AssetStatus.ARRIVED_AT_YARD]

      ], {},limit: null);

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        setState(() {
          containerData = response[0];
        });

        //await DatabaseHelper.instance.updateAsset(containerData);
        return response[0];
      } else {
        Utils.SnackBar('Error', 'Cannot Find Result with this RFID');
        throw Exception('Cannot Find Bundle with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  Future<List<Asset>?>? fetchContainerItems(Asset container) async {
    final groups = await DatabaseHelper.instance.queryList('asset_groups', [
      ['group_id', '=', '${container.asset_id}']
    ], {},limit: null);

    if (groups != null && groups.length > 0) {
      final groupsJson =
          groups.map((json) => AssetGroup.fromJson(json)).toList();

      final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
      final childAssetIdsString = makeIdsForIN(childAssetIds);
      var assetType = AssetType.BUNDLE;
      if (widget.title == 'Rigids Pipes') {
        assetType = AssetType.BATCH;
      } else if (widget.title == 'HazMat Waste') {
        assetType = AssetType.HAZMAT_WASTE;
      } else if (widget.title == 'Ancillary Products') {
        assetType = AssetType.ANCILLARY_EQUIPMENT;
      }

      final batches = await await DatabaseHelper.instance.queryList('assets', [
        ['asset_id', 'IN', '($childAssetIdsString)'],
        ['asset_type', '=', assetType],
      ], {});

      if (batches != null && batches.length > 0) {
        final List<Asset> response =
            batches.map((json) => Asset.fromJson(json)).toList();
        batchItems = response;
        return response;
      }
    }
  }

  // TextEditingController asset_rf_id = TextEditingController();
  //TextEditingController bundle_rf_id = TextEditingController();
  List<Asset> selectedId = [];
  bool isCheckBox = false;
  Set<int> _selectedItemIndices = {};

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
            selectedId.isEmpty
                ? SizedBox()
                : TextButton(
                    onPressed: () {
                      widget.title == 'HazMat Waste'
                          ? Get.to(showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return HazmawasteStorage(
                                  selectedId: selectedId,
                                );
                              },
                            ))
                          : Get.to(showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return StorageAllocation(
                                    selectedId: selectedId);
                              },
                            ));
                    },
                    child: Text(
                      'Select Location',
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
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title.toString(),
                  style: GoogleFonts.mulish(
                    color: Color(0xFF262626),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.44,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 34.w,
                      height: 34.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF9F9F9),
                        shape: OvalBorder(),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'images/svg/text.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                  ],
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
                  fetchcontainer(rf_id.text);
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
                                fetchcontainer(rf_id.text);
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Bundle Details',
                //   style: GoogleFonts.mulish(
                //     color: Colors.black,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w700,
                //     height: 0,
                //     letterSpacing: -0.28,
                //   ),
                // ),
                // SizedBox(
                //   height: 15.h,
                // ),
                // // here comes the Container Details
                Container(
                  width: 350.w,
                  height: 120.h,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                  width: 190.w,
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
                                  width: 70,
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
                                  width: 240.w,
                                  child: Text(
                                    containerData.container_serial_number ==
                                            null
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
                                  width: 70,
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
                                  width: 240.w,
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
                          // SizedBox(
                          //   height: 20.h,
                          // ),
                          // Row(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Container(
                          //         width: 70,
                          //         child: Text(
                          //           'No.of Bundles-',
                          //           style: GoogleFonts.inter(
                          //             color: Color(0xFF808080),
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w500,
                          //             height: 0.14,
                          //             letterSpacing: -0.24,
                          //           ),
                          //         ),
                          //       ),
                          //       Container(
                          //         width: 250,
                          //         child: Text(
                          //           containerData.bundle_no == null
                          //               ? ''
                          //               : '${containerData.bundle_no}',
                          //           textAlign: TextAlign.right,
                          //           style: GoogleFonts.inter(
                          //             color: Color(0xFF808080),
                          //             fontSize: 12,
                          //             fontWeight: FontWeight.w700,
                          //             height: 0.14,
                          //             letterSpacing: -0.24,
                          //           ),
                          //         ),
                          //       )
                          //     ]),

                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100.w,
                                  child: Text(
                                    '',
                                    // 'Bundle #',
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
                                  width: 210.w,
                                  child: Text(
                                    ' ',
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
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),

                Text(
                  'Asset Details',
                  style: GoogleFonts.mulish(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ), // here comes the
                SizedBox(
                  height: 15.h,
                ),

                //   Container(
                //     width: MediaQuery.sizeOf(context).width / .9,
                //     height: 50.h,
                //     decoration: ShapeDecoration(
                //       shape: RoundedRectangleBorder(
                //         side:
                //             BorderSide(width: 2, color: Color(0xFFF4F5F6)),
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
                //               // enabled: !isNoContainerSelected,
                //               controller: asset_rf_id,
                //               // onEditingComplete: () {
                //               //   // Call the API when the user finishes typing and presses done/return key
                //               //   fetchContainerType();
                //               // },
                //               decoration: InputDecoration(
                //                   hintText: 'Scan Asset RFID',
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
                //           InkWell(
                //             onTap: () {
                //               //  fetchContainerType();
                //             },
                //             child: Container(
                //               width: 40.w,
                //               height: 40.h,
                //               decoration: BoxDecoration(
                //                 color: Color(0xFFA80303),
                //                 shape: BoxShape
                //                     .circle, // Use BoxShape.circle for a circular shape
                //               ),
                //               child: Center(
                //                 child: SvgPicture.asset(
                //                   'images/svg/scaner.svg',
                //                   height: 25,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
              ],
            ),

            // Scan RFID again

            SizedBox(
              height: 15,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Scan Count : ${_selectedItemIndices.length}',
                    // text: 'Scan Count : ${selectedId.length}',
                    //Count :${selectedId.length}
                    // text: ' ',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              height: 430,
              child: FutureBuilder<List<Asset>?>(
                future: fetchContainerItems(containerData),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No Asset available');
                  } else {
                    var record = snapshot.data;
                    return ListView.builder(
                      itemCount: record?.length,
                      itemBuilder: (context, index) {
                        item = record?[index];

                        return CompofRigids(
                          productionFlowline:
                              '${(item.product == null && item.asset_type == 'Container') ? item.container_type : (item.product != null ? item.product : item.asset_type)}',

                          // container.asset_type.toString() ==
                          //         'Container'
                          //     ? container.container_type.toString()
                          //     : container.asset_type.toString(),
                          rfid: 'RFID - ${item.rf_id}',
                          rigidPipeBatch: '',
                          TFMC: item.product_no == null
                              ? ''
                              : 'TFMCID ${item.product_no}',
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

                                  // Add the entire item to the selectedId list
                                  selectedId.add(record?[index] ?? Asset());
                                } else {
                                  _selectedItemIndices.remove(index);

                                  // Remove the corresponding item from selectedId
                                  selectedId.removeWhere((result) =>
                                      result.rf_id == record?[index].rf_id);

                                  print('item');
                                  print(record?[index].rf_id);
                                  // Clear all selected IDs if all checkboxes are unchecked
                                  if (_selectedItemIndices.isEmpty) {
                                    selectedId.clear();
                                  }
                                }
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ]),
        )));
  }
}

class CompofRigids extends StatefulWidget {
  final String TFMC;
  final String productionFlowline;
  final String rfid;
  final String rigidPipeBatch;
  final Widget Check;
  final leftBorderColor;

  CompofRigids(
      {required this.productionFlowline,
      required this.rfid,
      required this.rigidPipeBatch,
      required this.TFMC,
      required this.Check,
      required this.leftBorderColor});

  @override
  State<CompofRigids> createState() => _CompofRigidsState();
}

class _CompofRigidsState extends State<CompofRigids> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: 390.w,
        height: 100,
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
                color: widget.leftBorderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            // Checkbox(
            //   value: isChecked,
            //   activeColor: Color(0xFFA80303),
            //   onChanged: (bool? value) {
            //     setState(() {
            //       isChecked = value ?? false;
            //       widget.onCheckboxChanged(isChecked);
            //     });
            //   },
            // ),
            widget.Check,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    widget.TFMC,
                    style: GoogleFonts.inter(
                      color: Color(0xFF424242),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    width: 250.w,
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
                  SizedBox(
                    height: 3.h,
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
                    height: 3.h,
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

class Ancilary extends StatefulWidget {
  final String TFMC;
  final String productionFlowline;
  final String rfid;
  final String rigidPipeBatch;
  final Color leftBorderColor;

  Ancilary({
    required this.productionFlowline,
    required this.rfid,
    required this.rigidPipeBatch,
    required this.TFMC,
    required this.leftBorderColor,
  });

  @override
  State<Ancilary> createState() => _AncilaryState();
}

class _AncilaryState extends State<Ancilary> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: 390.w,
        height: 77,
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
                color: widget.leftBorderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    widget.TFMC,
                    style: GoogleFonts.inter(
                      color: Color(0xFF424242),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    widget.productionFlowline,
                    style: GoogleFonts.inter(
                      color: Color(0xFF424242),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
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
                    height: 3.h,
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

//

