// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Move%20To%20Yard%20Storage/Racks.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/main.dart';

class Ancillary_StorageScreen extends StatefulWidget {
  final String? title;

  Ancillary_StorageScreen({Key? key, this.title}) : super(key: key);

  @override
  _Ancillary_StorageScreenState createState() =>
      _Ancillary_StorageScreenState();
}

class _Ancillary_StorageScreenState extends State<Ancillary_StorageScreen> {
  Asset containerData = Asset();
  List<Asset>? container = [];
  // TextEditingController rf_id = TextEditingController();
  List<Asset> selectedId = [];

  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  Future<void> fetchAncillary(String rfId) async {
    if (rfId.isNotEmpty) {
      try {
        final data = await DatabaseHelper.instance.queryList(
            'assets',
            [
              ['rf_id', '=', rfId],
              ['asset_type', '=', AssetType.ANCILLARY_EQUIPMENT],
              [
                'status',
                'IN',
                '("${AssetStatus.TAGGED}","${AssetStatus.ARRIVED_AT_YARD}")'
              ]
            ],
            {},
            limit: null);

        if (data != null && data.isNotEmpty) {
          final List<Asset> response =
              data.map((json) => Asset.fromJson(json)).toList();

          setState(() {
            containerData = response[0];
            container?.add(containerData);
            selectedId.add(containerData);
          });
        } else {
          Utils.SnackBar('Error', 'Cannot Find Result with this RFID');
          throw Exception('Cannot Find Bundle with this RFID');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          selectedId.isEmpty
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    Get.to(showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return StorageAllocation(selectedId: selectedId);
                      },
                    ));
                  },
                  child: Text(
                    'Select Location',
                    style: GoogleFonts.mulish(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title ?? '',
                  style: GoogleFonts.mulish(
                    color: Color(0xFF262626),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.44,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF9F9F9),
                        shape: const CircleBorder(),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'images/svg/text.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
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
                  fetchAncillary(rf_id.text);
                },
                decoration: InputDecoration(
                    hintText: 'Scan Ancillary RFID',
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
                                fetchAncillary(rf_id.text);
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
            SizedBox(height: 15),
            Container(
              height: 630.h,
              child: ListView.builder(
                itemCount: container?.length ?? 0,
                itemBuilder: (context, index) {
                  //  print(container![index].pulling_line);
                  return Ancilary(
                    productionFlowline:
                        '${(container![index].asset_type == null && container![index].asset_type == 'Container') ? container![index].asset_type : (container![index].product != null ? container![index].product : container![index].asset_type)}',

                    // container != null &&
                    //         container![index].asset_type.toString() ==
                    //             'Container'
                    //     ? container![index].container_type.toString()
                    //     : container != null
                    //         ? container![index].asset_type.toString()
                    //         : container![index].product.toString(),
                    rfid: 'RFID - ${container?[index].rf_id}',
                    rigidPipeBatch: '',
                    TFMC: 'TFMCID - ${container?[index].product_no}',
                    leftBorderColor: container?[index].classification ==
                            Classification.HAZARDOUS
                        ? Colors.orange
                        : container?[index].classification ==
                                Classification.NON_CONTAMINATED
                            ? Colors.green
                            : Colors.red,

                    Location: container?[index].dimensions == null
                        ? ''
                        : 'Dimension -${container?[index].dimensions}',
                  );
                },
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
  final String Location;
  final Color leftBorderColor;

  Ancilary({
    required this.productionFlowline,
    required this.rfid,
    required this.rigidPipeBatch,
    required this.TFMC,
    required this.Location,
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
            Container(
              width: 300.w,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 170,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                widget.Location,
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
