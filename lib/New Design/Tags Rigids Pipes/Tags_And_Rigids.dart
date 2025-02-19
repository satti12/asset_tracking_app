// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Tags%20Rigids%20Pipes/Tag_Batch.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/main.dart';

class TagsRigidsPipes extends StatefulWidget {
  String? currentLocation;
  String? title;
  TagsRigidsPipes({super.key, this.currentLocation, this.title});

  @override
  State<TagsRigidsPipes> createState() => _TagsRigidsPipesState();
}

class _TagsRigidsPipesState extends State<TagsRigidsPipes> {
  bool isChecked = false;
  //TextEditingController rf_id = TextEditingController();
  Asset containerData = new Asset();
  List<Asset>? batchItems = [];
  int count = 0;

  Future<Asset> fetchAvailableContainer(String rfId) async {
    if (rfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        ['rf_id', '=', rfId],
        ['asset_type', '=', AssetType.CONTAINER],
      ], {});

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        setState(() {
          containerData = response[0];
        });

        return response[0];
      } else {
        Utils.SnackBar('Error', 'Cannot Find Container with this RFID');

        throw Exception('Cannot Find Container with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  Future<List<Asset>?>? fetchContainerBatch(Asset container) async {
    final groups = await DatabaseHelper.instance.queryList('asset_groups', [
      ['group_id', '=', '${container.asset_id}']
    ], {});

    if (groups != null && groups.length > 0) {
      final groupsJson =
          groups.map((json) => AssetGroup.fromJson(json)).toList();

      final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
      final childAssetIdsString = makeIdsForIN(childAssetIds);

      final batches = await await DatabaseHelper.instance.queryList('assets', [
        ['asset_id', 'IN', '($childAssetIdsString)'],
        widget.title == 'Tag Ancillary Batch'
            ? ['asset_type', '=', AssetType.ANCILLARY_BATCH]
            : ['asset_type', '=', AssetType.BATCH],
        ['status', '<>', AssetStatus.UNBUNDLED],
      ], {});

      if (batches != null && batches.length > 0) {
        final List<Asset> response =
            batches.map((json) => Asset.fromJson(json)).toList();
        batchItems = response;
        return response;
      }
    }
    return null;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
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
                  widget.title == 'Tag Ancillary Batch'
                      ? 'Tag - Ancillary Batch'
                      : 'Tag - Rigid Pipes',
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
                  widget.currentLocation.toString(),
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
                  fetchAvailableContainer(rf_id.text);
                },
                decoration: InputDecoration(
                    hintText: 'Scan  Container RFID',
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
                                fetchAvailableContainer(rf_id.text);
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
              height: 104.h,
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(children: [
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120.w,
                            child: Text(
                              'Container Type:',
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
                            width: 190.w,
                            child: Text(
                              containerData.container_type == null
                                  ? ''
                                  : containerData.container_type.toString(),
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
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 120.w,
                              child: Text(
                                'Serial Number:',
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
                              containerData.container_serial_number == null
                                  ? ''
                                  : containerData.container_serial_number
                                      .toString(),
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
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80.w,
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
                            width: 230.w,
                            child: Text(
                              containerData.rf_id == null
                                  ? ''
                                  : containerData.rf_id.toString(),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                color: Color(0xFF808080),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 0.14,
                                letterSpacing: -0.24,
                              ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ]),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // Container(
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Container(
                  //           width: 130.w,
                  //           child: Text(
                  //             'Rigid Pipe Quantity:',
                  //             style: GoogleFonts.inter(
                  //               color: Color(0xFF808080),
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w500,
                  //               height: 0.14,
                  //               letterSpacing: -0.24,
                  //             ),
                  //           ),
                  //         ),
                  //         Container(
                  //           width: 180.w,
                  //           child: Text(
                  //             containerData.no_of_lengths == null
                  //                 ? ''
                  //                 : containerData.no_of_lengths.toString(),
                  //             textAlign: TextAlign.right,
                  //             style: GoogleFonts.inter(
                  //               color: Color(0xFF808080),
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w700,
                  //               height: 0.14,
                  //               letterSpacing: -0.24,
                  //             ),
                  //             // overflow: TextOverflow.ellipsis,
                  //           ),
                  //         )
                  //       ]),
                  // ),
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  // Container(
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Container(
                  //           width: 130.w,
                  //           child: Text(
                  //             'Rigid Pipe Batch #:',
                  //             style: GoogleFonts.inter(
                  //               color: Color(0xFF808080),
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w500,
                  //               height: 0.14,
                  //               letterSpacing: -0.24,
                  //             ),
                  //           ),
                  //         ),
                  //         Container(
                  //           width: 180.w,
                  //           child: Text(
                  //             containerData.batch_no == null
                  //                 ? ''
                  //                 : containerData.batch_no.toString(),
                  //             textAlign: TextAlign.right,
                  //             style: GoogleFonts.inter(
                  //               color: Color(0xFF808080),
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w700,
                  //               height: 0.14,
                  //               letterSpacing: -0.24,
                  //             ),
                  //             // overflow: TextOverflow.ellipsis,
                  //           ),
                  //         )
                  //       ]),
                  // ),
                ]),
              ),
            ),

            // here comes the
            SizedBox(height: 15.h),
            Text(
              widget.title == 'Tag Ancillary Batch'
                  ? 'Ancillary Batch Details'
                  : 'Rigid Pipes Details',
              style: GoogleFonts.mulish(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.32,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),

            // Text.rich(
            //   TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Count ',
            //         style: GoogleFonts.inter(
            //           color: Color(0xFFA80303),
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //           height: 0,
            //           letterSpacing: 0.56,
            //         ),
            //       ),
            //       // TextSpan(
            //       //   text: '001 ',
            //       //   style: GoogleFonts.inter(
            //       //     color: Color(0xFFA80303),
            //       //     fontSize: 14,
            //       //     fontWeight: FontWeight.w700,
            //       //     height: 0,
            //       //     letterSpacing: 0.56,
            //       //   ),
            //       // ),
            //       TextSpan(
            //         text: 'of  ${batchItems!.length.toString()}',
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

            SizedBox(
              height: 15.h,
            ),
            // here will be cards for having Rigids And Pipes Containters

            FutureBuilder<List<Asset>?>(
              future: fetchContainerBatch(containerData),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(child: CircularProgressIndicator());
                // } else
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No Asset available');
                } else {
                  return Column(
                    children: snapshot.data!.asMap().entries.map((entry) {
                      //final index = entry.key;
                      final container = entry.value;

                      return InkWell(
                        onTap: () {
                          Get.to(TagsRigidsBatch(
                            currentLocation: widget.currentLocation,
                            title: widget.title,
                            SelectedBatch: container,
                          ));
                        },
                        child: Center(
                          child: InsideContent(
                            color: container.classification ==
                                    Classification.HAZARDOUS
                                ? Colors.orange
                                : container.classification ==
                                        Classification.NON_CONTAMINATED
                                    ? Colors.green
                                    : Colors.red,
                            tfmcId: 'TFMC ID# ${container.product_no}',
                            productionFlowline: widget.title ==
                                    'Tag Ancillary Batch'
                                ? 'Ancillary Batch# ${container.batch_no} '
                                : 'Rigid Pipe Batch# ${container.batch_no} ',
                            rigidPipeBatch: '${container.product}',
                            rfid: '',
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class InsideContent extends StatelessWidget {
  final String tfmcId;
  final String productionFlowline;
  final String rigidPipeBatch;
  Color color = Colors.green;
  final String rfid;

  InsideContent({
    required this.tfmcId,
    required this.productionFlowline,
    required this.rigidPipeBatch,
    required this.color,
    required this.rfid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: 365.w,
        height: 100.h,
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
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 280,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        tfmcId,
                        style: GoogleFonts.inter(
                          color: Color(0xFF262626),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.40,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 250,
                    child: Text(
                      productionFlowline,
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
                    height: 6,
                  ),
                  Text(
                    rfid,
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.40,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    rigidPipeBatch,
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
 
 