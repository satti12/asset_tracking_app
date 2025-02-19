// ignore_for_file: must_be_immutable
import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/Component/loading.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Tags%20Rigids%20Pipes/Tags_And_Rigids.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:asset_tracking/main.dart';

class TagsRigidsBatch extends StatefulWidget {
  String? currentLocation;
  String? title;
  Asset SelectedBatch;
  TagsRigidsBatch(
      {super.key,
      this.currentLocation,
      required this.SelectedBatch,
      this.title});

  @override
  State<TagsRigidsBatch> createState() => _TagsRigidsBatchState();
}

class _TagsRigidsBatchState extends State<TagsRigidsBatch> {
  //TextEditingController rf_id = TextEditingController();

  List<Asset>? batchItems = [];
  int count = 0;
  Future<void> create_batch(
    Asset parent,
    String rfid,
  ) async {
    try {
      LoadingScreen.showLoading(context);
      Asset? newAsset;
      await DatabaseHelper.instance
          .createIndividualAsset(parent, rfid)
          .then((result) {
        newAsset = result;
      }).whenComplete(() async {
        await fetchBatchItem(widget.SelectedBatch);
        if (newAsset != null) {
          await logAssetCreation(newAsset!, parent, rfid);
        }
        setState(() {
          rf_id.clear();
        });
        Loading.hideLoading();
      });
      //Get.to(NewBottomNavigation());
    } catch (e) {
      Loading.hideLoading();

      // Utils.SnackBar('Error', 'RFID already exists.');
      //  Utils.SnackBar('Error', e.toString());
      // throw Exception(e.toString());
    }
  }

  Future<void> logAssetCreation(
      Asset newAsset, Asset parent, String rfId) async {
    AssetLog log = new AssetLog();
    // final result = await DatabaseHelper.instance
    //     .queryUnique('assets', 'asset_id', newAsset?.asset_id);

    // final resp = result?.map((json) => Asset.fromJson(json)).toList();
    // Asset? res = resp?[0];
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.ASSET_CREATED;
    String assetType = parent.asset_type.toString() == AssetType.BATCH
        ? AssetType.RIGID_PIPE
        : AssetType.ANCILLARY_EQUIPMENT;
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            ?.toString();
    Map<String, String> variables = {
      'asset_type': assetType,
      'rf_id': rfId,
      'parent_batch_no': parent.product_no.toString(),
      'product_no': parent.product_no.toString(),
      'parent_asset_type': parent.asset_type.toString(),
      'parent_rfid': parent.rf_id.toString(),
      'batch_no': parent.batch_no.toString(),
      'current_location': userInfo['location_name'],
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = parent.asset_id.toString();
    log.event_type = eventType;
    log.rf_id = rfId;
    log.asset_type = assetType.toString();
    log.current_transaction = jsonEncode(newAsset.toMap());
    log.status = newAsset.status.toString();
    log.event_description = eventDesc;
    log.current_location_id = userInfo['locationId'];
    DatabaseHelper.instance.createAssetLog(log);
  }

  Future<void> fetchBatchItem(Asset batch) async {
    final groups = await DatabaseHelper.instance.queryList(
        'asset_groups',
        [
          ['group_id', '=', '${batch.asset_id}']
        ],
        {},
        limit: null);

    if (groups != null && groups.length > 0) {
      final groupsJson =
          groups.map((json) => AssetGroup.fromJson(json)).toList();

      final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
      final childAssetIdsString = makeIdsForIN(childAssetIds);

      final items = await DatabaseHelper.instance.queryList(
          'assets',
          [
            ['asset_id', 'IN', '($childAssetIdsString)'],
            widget.title == 'Tag Ancillary Batch'
                ? ['asset_type', '=', AssetType.ANCILLARY_EQUIPMENT]
                : ['asset_type', '=', AssetType.RIGID_PIPE]
          ],
          {},
          limit: null);

      if (items != null && items.length > 0) {
        final response = items.map((json) => Asset.fromJson(json)).toList();
        // Update the state variable with the fetched data
        setState(() {
          batchItems = response;
          count = batchItems!.length;
        });
      }
    }
  }

  void completeBatchTag(Asset asset) async {
    asset.status = AssetStatus.UNBUNDLED;
    Asset modifiedAsset = await DatabaseHelper.instance.updateAsset(asset);
    await DatabaseHelper.instance.update(
      'asset_groups',
      'asset_id',
      asset.asset_id,
      {'is_cleared': 1, 'is_sync': 0},
    );

    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.UNBUNDLED;
    String assetType = asset.asset_type.toString();
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            .toString();

    Map<String, String> variables = {
      'asset_type': asset.asset_type.toString(),
      'rf_id': asset.rf_id.toString(),
      'current_location': userInfo['location_name'],
      'batch_no': asset.batch_no.toString(),
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    AssetLog log = new AssetLog();
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = asset.asset_id.toString();
    log.rf_id = asset.rf_id.toString();
    log.event_type = eventType;
    log.status = asset.status;
    log.event_description = eventDesc;
    log.current_transaction = jsonEncode(modifiedAsset.toMap());
    log.current_location_id = userInfo['locationId'];
    log.asset_type = asset.asset_type.toString();
    DatabaseHelper.instance.createAssetLog(log);
    Navigator.pop(context);
  }

  @override
  void initState() {
    setState(() {
      rf_id.clear();
    });
    super.initState();
    fetchBatchItem(widget.SelectedBatch);
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
        actions: [
          if (widget.title == 'Tag Ancillary Batch' &&
              count == widget.SelectedBatch.quantity?.toInt())
            TextButton(
              onPressed: () {
                completeBatchTag(widget.SelectedBatch);
              },
              child: Text(
                'Complete',
                style: GoogleFonts.mulish(
                  color: Color(0xFFA80303),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          if (widget.title != 'Tag Ancillary Batch' &&
              widget.SelectedBatch.no_of_lengths?.toInt() == count)
            TextButton(
              onPressed: () {
                completeBatchTag(widget.SelectedBatch);
              },
              child: Text(
                'Complete',
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
            TagSelectedCard(
              tfmcId: 'TFMC ID# ${widget.SelectedBatch.product_no}',
              productionFlowline:
                  '${(widget.SelectedBatch.asset_type != null && widget.SelectedBatch.asset_type == 'Container') ? widget.SelectedBatch.container_type : (widget.SelectedBatch.product != null ? widget.SelectedBatch.product : widget.SelectedBatch.asset_type)}',

              //  '${widget.SelectedBatch.asset_type == 'Container' ? widget.SelectedBatch.container_type : widget.SelectedBatch.asset_type} ',
              rigidPipeBatch: widget.title == 'Tag Ancillary Batch'
                  ? 'Quantity - ${widget.SelectedBatch.quantity?.toInt()} '
                  : 'Quantity - ${widget.SelectedBatch.no_of_lengths?.toInt()} ',
              BatchNo: widget.title == 'Tag Ancillary Batch'
                  ? 'Ancillary Batch# ${widget.SelectedBatch.batch_no} '
                  : 'Rigid Pipe Batch# ${widget.SelectedBatch.batch_no} ',
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget.title == 'Tag Ancillary Batch'
                  ? 'Ancillary Batch - Install RFID Tags'
                  : 'Rigid Pipe - Install RFID Tags',
              style: GoogleFonts.mulish(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            if (widget.title == 'Tag Ancillary Batch' &&
                count != widget.SelectedBatch.quantity?.toInt())
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
                    //  LoadingScreen.showLoading(context);
                    create_batch(widget.SelectedBatch, rf_id.text);
                  },
                  decoration: InputDecoration(
                      hintText: widget.title == 'Tag Ancillary Batch'
                          ? 'Scan Ancillary  RFID'
                          : 'Scan Rigid Pipe RFID',
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
                                  //  LoadingScreen.showLoading(context);
                                  create_batch(
                                      widget.SelectedBatch, rf_id.text);
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
            if (widget.title != 'Tag Ancillary Batch' &&
                count != widget.SelectedBatch.no_of_lengths?.toInt())
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
                    //   LoadingScreen.showLoading(context);
                    create_batch(widget.SelectedBatch, rf_id.text);
                  },
                  decoration: InputDecoration(
                      hintText: widget.title == 'Tag Ancillary Batch'
                          ? 'Scan Ancillary  RFID'
                          : 'Scan Rigid Pipe RFID',
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
                                //  LoadingScreen.showLoading(context);
                                if (rf_id.text.isNotEmpty) {
                                  create_batch(
                                      widget.SelectedBatch, rf_id.text);
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
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'RFID Tag installed ',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  TextSpan(
                    text: count.toString(),
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  TextSpan(
                    text: widget.title == 'Tag Ancillary Batch'
                        ? 'of ${widget.SelectedBatch.quantity?.toInt()}'
                        : 'of ${widget.SelectedBatch.no_of_lengths?.toInt()}',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  TextSpan(
                    text: '',
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
            _buildTaggedAssetsList(),
          ]),
        ),
      ),
    );
  }

  Widget _buildTaggedAssetsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        if (batchItems!.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'No Tagged Batch.',
                style: GoogleFonts.mulish(
                  color: const Color(0xFFB8B9C0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: batchItems!.length,
            itemBuilder: (context, index) {
              return InsideContent(
                color: batchItems?[index].classification ==
                        Classification.HAZARDOUS
                    ? Colors.orange
                    : batchItems?[index].classification ==
                            Classification.NON_CONTAMINATED
                        ? Colors.green
                        : Colors.red,
                tfmcId: 'TFMC ID# ${batchItems?[index].product_no}',
                productionFlowline: '${batchItems?[index].product} ',
                rigidPipeBatch:
                    'Rigid Pipe Batch# ${batchItems?[index].batch_no} ',
                rfid: 'RFID# ${batchItems?[index].rf_id}',
              );
            },
          ),
      ],
    );
  }
}

class TagSelectedCard extends StatelessWidget {
  final String tfmcId;
  final String productionFlowline;
  final String rigidPipeBatch;
  final String BatchNo;

  TagSelectedCard({
    required this.tfmcId,
    required this.productionFlowline,
    required this.rigidPipeBatch,
    required this.BatchNo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: 365.w,
        height: 80.h,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
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
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: 205.w,
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
                      BatchNo,
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
            ),
            Column(
              children: [
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    rigidPipeBatch,
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.40,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
