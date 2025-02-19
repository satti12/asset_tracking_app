// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_comparison, must_be_immutable

import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/New%20Design/Screening%20Assets/Post%20Screening/ScreenAssets.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:intl/intl.dart';

class PreviewScreening extends StatefulWidget {
  String? scanRfidValue;
  String? tfmcText;
  String? scText;
  bool? contaminatedvalue;
  bool? HydrocarbonsValue;
  String? benzenevalue;
  String? vocvalue;
  bool? mercuryvalue;
  String? normsurfacevalue;
  String? ctc_number;
  String? surfacevalue_ugvalue;
  String? surfacevalue_ppmvalue;
  bool? normvalue;
  String? vaporsurfacereading;
  String? dose_rate;
  bool? remnant_ugvalue;
  String? hs2_value;
  String? lel_value;
  String? condition;
  String? Prduct_id;
  String? dimensions;
  String? weight_in_air;
  Asset object;
  List<String> imagepath;
  List<ImageModel> imageUrls;
  String ScreeningType;

  PreviewScreening(
      {Key? key,
      this.scanRfidValue,
      this.tfmcText,
      this.scText,
      this.contaminatedvalue,
      this.HydrocarbonsValue,
      this.benzenevalue,
      this.vocvalue,
      this.mercuryvalue,
      this.normsurfacevalue,
      this.ctc_number,
      this.dose_rate,
      this.surfacevalue_ugvalue,
      this.surfacevalue_ppmvalue,
      this.normvalue,
      this.vaporsurfacereading,
      this.remnant_ugvalue,
      this.hs2_value,
      this.lel_value,
      this.condition,
      this.Prduct_id,
      this.dimensions,
      this.weight_in_air,
      required String vaporsurfacereadingthis,
      required this.imagepath,
      required this.imageUrls,
      required this.object,
      required this.ScreeningType})
      : super(key: key);

  @override
  State<PreviewScreening> createState() => _PreviewScreeningState();
}

class _PreviewScreeningState extends State<PreviewScreening> {
  TextEditingController commentController = TextEditingController();

  void postscreening() async {
    // widget.object.is_contaminated = widget.contaminatedvalue == true ? 1 : 0;
    widget.object.is_hydrocarbon = widget.HydrocarbonsValue == true ? 1 : 0;
    widget.object.benzene =
        double.tryParse(widget.benzenevalue.toString()) ?? 0.0;
    widget.object.voc = double.tryParse(widget.vocvalue.toString()) ?? 0.0;
    widget.object.is_mercury = widget.mercuryvalue == true ? 1 : 0;
    widget.object.surface_reading_gm =
        double.tryParse(widget.surfacevalue_ugvalue.toString()) ?? 0.0;
    widget.object.surface_reading_ppm =
        double.tryParse(widget.surfacevalue_ppmvalue.toString()) ?? 0.0;

    if (widget.ScreeningType == ScreeningType.SCREENING &&
        (widget.object.asset_type == AssetType.FLEXIBLES ||
            widget.object.asset_type == AssetType.RIGID_PIPE)) {
      final existingCTCNumbers = await DatabaseHelper.instance
          .queryUnique('assets', 'ctc_number', widget.ctc_number);
      if (existingCTCNumbers?.length != 0 &&
          widget.ctc_number.toString().isNotEmpty) {
        return Utils.SnackBar('Error',
            "CTC Number already exists. Please enter a different number.");
      } else // Check if the ctc_number is empty
      if (widget.ctc_number.toString().isEmpty) {
        // If empty, set ctc_number to null
        widget.object.ctc_number = null;
      } else {
        widget.object.ctc_number = widget.ctc_number.toString();
      }

      //   widget.object.ctc_number = widget.ctc_number.toString();
    }
    widget.object.dose_rate =
        double.tryParse(widget.dose_rate.toString()) ?? 0.0;
    widget.object.vapour =
        double.tryParse(widget.vaporsurfacereading.toString()) ?? 0.0;
    widget.object.is_radiation = widget.normvalue == true ? 1 : 0;
    widget.object.surface_contamination =
        double.tryParse(widget.normsurfacevalue.toString()) ?? 0.0;
    widget.object.is_rph = widget.remnant_ugvalue == true ? 1 : 0;
    widget.object.h2s = double.tryParse(widget.hs2_value.toString()) ?? 0.0;
    widget.object.lel = double.tryParse(widget.lel_value.toString()) ?? 0.0;
    widget.object.status = widget.condition == Classification.CONTAMINATED ||
            widget.condition == Classification.HAZARDOUS
        ? AssetStatus.IN_CLEANING
        : AssetStatus.IN_CLEARANCE;
    widget.object.classification = widget.condition;
    widget.object.description = commentController.text;

    await DatabaseHelper.instance.updateAsset(widget.object);

    final get_rf_id = await DatabaseHelper.instance
        .queryUnique('assets', 'rf_id', widget.object.rf_id);
    final assetId = get_rf_id?[0]['asset_id'];

    AssetScreening screening = new AssetScreening(
      asset_id: assetId,
      screening_type: widget.ScreeningType,
      is_hydrocarbon: widget.object.is_hydrocarbon,
      is_mercury: widget.object.is_mercury,
      is_radiation: widget.object.is_radiation,
      is_rph: widget.object.is_rph,
      is_contaminated: widget.object.is_contaminated,
      benzene: widget.object.benzene,
      voc: widget.object.voc,
      surface_reading_gm: widget.object.surface_reading_gm,
      surface_reading_ppm: widget.object.surface_reading_ppm,
      vapour: widget.object.vapour,
      h2s: widget.object.h2s,
      lel: widget.object.lel,
      surface_contamination: widget.object.surface_contamination,
      adg_class: widget.object.adg_class,
      un_number: widget.object.un_number,
      dose_rate: widget.object.dose_rate,
      class_7_category: widget.object.class_7_category,
      classification: widget.object.classification,
      description: widget.object.description,
    );
    String screeningId =
        await DatabaseHelper.instance.createAssetScreening(screening);

    if (widget.object.asset_type.toString() != AssetType.HAZMAT_WASTE) {
      AssetLog screeninglog = new AssetLog();
      final userInfo =
          await SharedPreferencesHelper.retrieveUserInfo('userInfo');
      String ScreeningEventType = EventType.SCREENING;
      String ScreeningAssetType = widget.ScreeningType;
      var eventDesc;
      var template = (eventDefinition[ScreeningEventType]
              as Map<Object, dynamic>?)?[ScreeningAssetType]
          ?.toString();
      Map<String, String> variables = {
        'asset_type': widget.object.asset_type.toString(),
        'rf_id': widget.object.rf_id.toString(),
        'product_no': widget.object.product_no.toString(),
        'current_location': userInfo['location_name'],
        'user': userInfo['user_name'],
        'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
      };
      eventDesc = replaceVariables(template!, variables);
      screeninglog.asset_id = widget.object.asset_id.toString();
      screeninglog.asset_type = widget.object.asset_type.toString();
      screeninglog.current_transaction = jsonEncode(screeningId);
      screeninglog.rf_id = widget.object.rf_id.toString();
      screeninglog.event_type = widget.ScreeningType == ScreeningType.SCREENING
          ? 'Initial Yard Screening'
          : 'Post De-Contam Screening';
      screeninglog.product_id = widget.object.product_id;
      screeninglog.event_description = eventDesc;
      screeninglog.status = widget.object.status.toString();
      screeninglog.current_location_id = userInfo['locationId'];
      DatabaseHelper.instance.createAssetLog(screeninglog);
    }
    if (widget.imagepath != null && widget.imagepath.length > 0) {
      for (var image in widget.imagepath) {
        Asset_Image asset_image = new Asset_Image();
        asset_image.screening_id = screeningId;
        asset_image.image_path = image;
        await DatabaseHelper.instance.createImage(asset_image);
      }
    }

    Get.to(NewBottomNavigation());
  }

  Color determineColor() {
    String textResult = widget.condition.toString();

    if (textResult == Classification.HAZARDOUS) {
      return Colors.orange; // Red
    } else if (textResult == Classification.NON_CONTAMINATED) {
      return Colors.green; // Orange
    } else {
      return Colors.red; // Green
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              LoadingScreen.showLoading(context);
              postscreening();
            },
            child: Container(
              width: 100.w,
              height: 60.h,
              child: Center(
                child: Text(
                  'Confirm',
                  style: GoogleFonts.mulish(
                    color: Color(0xFFA80303),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.28,
                  ),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yard Screening Review ',
                    style: GoogleFonts.mulish(
                      color: Color(0xFF262626),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.44,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TFMC ID# ${widget.object.product_no}',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.56,
                        ),
                      ),
                      Text(
                        '${widget.object.product}',
                        style: GoogleFonts.inter(
                          color: Color(0xFF424242),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.48,
                        ),
                      ),
                      Text(
                        'RFID - ${widget.object.rf_id}',
                        style: GoogleFonts.inter(
                          color: Color(0xFFB9B9B9),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Text(
                    'Classification',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.40,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categorizes  as:',
                          style: GoogleFonts.mulish(
                            color: Color(0xFF808080),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.24,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: determineColor(),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Text(
                            '${widget.condition}',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.mulish(
                              color: determineColor(),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: -0.44,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Card(
                color: determineColor() == Colors.orange
                    ? Colors.orange.shade800
                    : determineColor() == Colors.green
                        ? Color.fromRGBO(229, 255, 237, 1)
                        : Color(0xFFFFEEEE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    width: 2,
                    color: determineColor() == Colors.orange
                        ? Colors.orange.shade800
                        : determineColor() == Colors.green
                            ? Colors.green
                            : Color(0xFFFF0000),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      widget.condition.toString() == Classification.HAZARDOUS
                          ? Container()
                          : PreviewComp(
                              label: "Contaminated",
                              detail:
                                  //'${widget.contaminatedvalue}',
                                  '${widget.condition.toString() == Classification.CONTAMINATED ? 'Yes' : 'No'}',
                            ),
                      PreviewComp(
                          label: "Hydrocarbons:",
                          detail:
                              '${widget.HydrocarbonsValue != null && widget.HydrocarbonsValue == true ? 'Yes' : 'No'}'),
                      PreviewComp(
                          label: "Benzene:",
                          detail: '${widget.benzenevalue} (ppm)'),
                      PreviewComp(
                          label: "VOC: ", detail: '${widget.vocvalue} (ppm)'),
                      PreviewComp(
                        label: "Mercury: ",
                        detail:
                            '${widget.mercuryvalue != null && widget.mercuryvalue == true ? 'Yes' : 'No'}',
                      ),
                      PreviewComp(
                        label: "Surface Reading (µg/m)\u00B3 ",
                        detail: '${widget.surfacevalue_ugvalue}(µg/m\u00B3)',
                      ),
                      PreviewComp(
                        label: "Surface Reading (ppm) ",
                        detail: '${widget.surfacevalue_ppmvalue} (ppm)',
                      ),
                      PreviewComp(
                        label: "Vapour : ",
                        detail: '${widget.vaporsurfacereading} (mg/m\u00B3)',
                      ),
                      PreviewComp(
                        label: "NORM/Radiation: ",
                        detail:
                            '${widget.normvalue != null && widget.normvalue == true ? 'Yes' : 'No'}',
                      ),
                      PreviewComp(
                        label: "Surface Reading: ",
                        detail: '${widget.normsurfacevalue} (Bq/cm\u00B2)',
                      ),
                      PreviewComp(
                        label: "Dose Rate: ",
                        detail: '${widget.dose_rate} (µSv/hr)',
                      ),
                      PreviewComp(
                          label: "Remnant Product Hazard: ",
                          detail:
                              '${widget.remnant_ugvalue != null && widget.remnant_ugvalue == true ? 'Yes' : 'No'}'),
                      PreviewComp(
                        label: "H2S: ",
                        detail: '${widget.hs2_value} (ppm)',
                      ),
                      PreviewComp(
                        label: "LEL: ",
                        detail: '${widget.lel_value}(%)',
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Comment:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 700,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.grey.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: commentController,
                        maxLines: 1000,
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
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Uploaded Images',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 300.h,
                    child: Scrollbar(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: widget.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Image.file(widget.imageUrls[index].imageFile);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                  // Center(
                  //   child: Container(
                  //     width: 100,
                  //     height: 100,
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: FileImage(File(widget.imagePath
                  //             .toString())), // Load the image from the file path
                  //         fit: BoxFit.cover,
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  // ),
                  //             ListTile(
                  //               leading: Image.network('https://via.placeholder.com/150'),
                  //             ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreviewComp extends StatelessWidget {
  final String label;
  final String detail;

  PreviewComp({required this.label, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Color(0xFFCCCCCC),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 0.14,
              letterSpacing: -0.24,
            ),
          ),
          Text(
            detail,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 0.14,
              letterSpacing: -0.24,
            ),
          ),
        ],
      ),
    );
  }
}
