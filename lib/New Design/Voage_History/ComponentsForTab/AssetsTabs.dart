// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VoyageAssetsTab extends StatefulWidget {
  const VoyageAssetsTab({Key? key});

  @override
  State<VoyageAssetsTab> createState() => _VoyageAssetsTabState();
}

class _VoyageAssetsTabState extends State<VoyageAssetsTab> {
  Future<List<Asset>?> fetchAssets() async {
    //final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    var filter = [
      ['asset_type', '<>', AssetType.CONTAINER],
      ['asset_type', '<>', AssetType.DRUM],
      ['asset_type', '<>', AssetType.FLEXIBLES],
      // ['operating_location_id', '=', userInfo['locationId']],
    ];

    final result = await DatabaseHelper.instance.queryList('assets', filter, {
      // 'searchColumns': ['rf_id', 'product_id'],
      // 'searchValue': searchTerm
    });
    if (result != null) {
      final resp = result.map((json) => Asset.fromJson(json)).toList();
      return resp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<Asset>?>(
            future: fetchAssets(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // print('${snapshot.error}');
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Text('No Assets found.');
              } else {
                final assets = snapshot.data!;

                return Container(
                  height: 590,
                  child: ListView.builder(
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final record = assets[index];
                      String convertUnixTimestamp(int unixTimestamp) {
                        // Convert Unix timestamp to milliseconds (Dart uses milliseconds, not seconds)
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                            unixTimestamp * 1000,
                            isUtc: true);

                        // Format the DateTime object as '(Mon DD, YYYY HH:mm UTC)'
                        String formattedTime =
                            DateFormat("MMM dd, yyyy HH:mm 'UTC'")
                                .format(dateTime);

                        return '($formattedTime)';
                      }

                      String formattedTime =
                          convertUnixTimestamp(record.date_added!.toInt());

                      // print(record.no_of_joints);
                      return AssetHistoryTab(
                        leftBorderColor:
                            record.classification == Classification.HAZARDOUS
                                ? Colors.orange
                                : record.classification ==
                                        Classification.NON_CONTAMINATED
                                    ? Colors.green
                                    : Colors.red,

                        tfmcId: 'TFMC ID# ${record.product_no}',
                        bundle: record.bundle_no.toString(),
                        title: record.asset_type == 'Container'
                            ? record.container_type.toString()
                            : record.asset_type.toString(),

                        rfid: 'RFID# ${record.rf_id}',
                        description: record.product.toString(),
                        //'Description',
                        quantity:
                            record.asset_type == AssetType.SUBSEA_STRUCTURE
                                ? 'Quantity - 1'
                                : '',
                        line_name: record.pulling_line == null
                            ? ''
                            : 'Start End -${record.pulling_line}',

                        dimensions: (record.dimensions == null &&
                                record.no_of_joints == null)
                            ? '' // Return empty string if both are null
                            : (record.dimensions == null)
                                ? 'No of Joint ${record.no_of_joints}'
                                : (record.dimensions != null &&
                                        record.no_of_joints == 0.0)
                                    ? 'Dimensions - ${record.dimensions}'
                                    : 'No of Joint   ${record.no_of_joints?.toInt()}',
                        // record.pulling_line == null
                        //     ? ''
                        //     : 'Bundle - ${record.pulling_line}', //'EDC5',
                        weight: (record.weight_in_air == null &&
                                record.no_of_lengths == null)
                            ? '' // Return empty string if both are null
                            : (record.weight_in_air == 0.0 &&
                                    record.no_of_lengths != null)
                                ? 'No of Length ${record.no_of_lengths}'
                                : (record.weight_in_air != null)
                                    ? 'Weight in the Air - ${record.weight_in_air}'
                                    : '',
                        contamination: '${record.classification}',
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class AssetHistoryTab extends StatefulWidget {
  final String tfmcId;
  final String title;
  final String rfid;
  final String description;
  final String quantity;
  final String line_name;
  final String dimensions;
  final String weight;
  final String contamination;
  final String bundle;
  final leftBorderColor;

  AssetHistoryTab({
    Key? key,
    required this.tfmcId,
    required this.title,
    required this.rfid,
    required this.description,
    required this.quantity,
    required this.line_name,
    required this.dimensions,
    required this.weight,
    required this.contamination,
    required this.bundle,
    required this.leftBorderColor,
  }) : super(key: key);

  @override
  _AssetHistoryTabState createState() => _AssetHistoryTabState();
}

class _AssetHistoryTabState extends State<AssetHistoryTab> {
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
              height: 220,
              decoration: BoxDecoration(
                color: widget.leftBorderColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.w,
                          child: Text(
                            widget.title,
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
                  ],
                ),
                SizedBox(height: 10.h),
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
                        widget.line_name,
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
          ],
        ),
      ),
    );
  }
}
