// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/Screen_Asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/Repository/CreateProcess_Repository/create_asset_repository.dart';

class PreviewScreen extends StatefulWidget {
  String? scanRfidValue;
  String? tfmcText;
  String? scText;
  String? startvalue;
  String? lineEndvalue;
  String? numOfJointsValue;
  String? numOflength;
  String? pulling_id;
  String? pulling_name;
  String? approxLengthValue;
  String? approxWeightValue;
  String? carneWeightValue;
  bool? contaminatedvalue;
  bool? HydrocarbonsValue;
  String? benzenevalue;
  String? vocvalue;
  bool? mercuryvalue;
  String? normsurfacevalue;
  String? dose_rate;
  String? surfacevalue_ugvalue;
  String? surfacevalue_ppmvalue;
  bool? is_radiation;
  String? vaporsurfacereading;
  bool? is_rph;
  String? hs2_value;
  String? lel_value;
  String? Status;
  String? condition;
  final List<ImageModel> imageUrls;
  String? Prduct_id;
  String? dimensions;
  String? weight_in_air;
  List<String>? imagepath;
  String? Quantity;
  String? IsBatch;

  PreviewScreen({
    Key? key,
    this.scanRfidValue,
    this.tfmcText,
    this.scText,
    this.startvalue,
    this.lineEndvalue,
    this.numOfJointsValue,
    this.numOflength,
    this.pulling_id,
    this.pulling_name,
    this.approxLengthValue,
    this.approxWeightValue,
    this.carneWeightValue,
    this.contaminatedvalue,
    this.HydrocarbonsValue,
    this.benzenevalue,
    this.vocvalue,
    this.mercuryvalue,
    this.normsurfacevalue,
    this.dose_rate,
    this.surfacevalue_ugvalue,
    this.surfacevalue_ppmvalue,
    this.is_radiation,
    this.vaporsurfacereading,
    this.is_rph,
    this.hs2_value,
    this.lel_value,
    this.Status,
    this.condition,
    required this.imageUrls,
    this.Prduct_id,
    this.dimensions,
    this.weight_in_air,
    this.imagepath,
    this.Quantity,
    this.IsBatch,
  }) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
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

  TextEditingController commentController = TextEditingController();
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

              create_bundle(
                widget.scanRfidValue,
                widget.Prduct_id,
                // widget.pulling_name == null
                //     ? widget.startvalue
                //     : widget.pulling_name,
                widget.pulling_id,
                widget.IsBatch == '1'
                    ? AssetType.ANCILLARY_BATCH
                    : widget.Status,
                widget.numOfJointsValue,
                widget.numOflength,
                widget.approxLengthValue,
                widget.approxWeightValue,
                widget.carneWeightValue,
                widget.dimensions,
                widget.weight_in_air,
                null, //widget.contaminatedvalue as bool,
                widget.HydrocarbonsValue as bool,
                widget.mercuryvalue as bool,
                widget.is_radiation as bool,
                widget.is_rph as bool,
                widget.benzenevalue,
                widget.vocvalue,
                widget.surfacevalue_ugvalue,
                widget.surfacevalue_ppmvalue,
                widget.vaporsurfacereading,
                widget.hs2_value,
                widget.lel_value,
                widget.normsurfacevalue,
                null,
                null,
                widget.dose_rate,
                null,
                null,
                null,
                widget.imagepath,
                widget.condition,
                commentController.text,
                (widget.Status == AssetType.ANCILLARY_EQUIPMENT ||
                            widget.Status == AssetType.SUBSEA_STRUCTURE) &
                        (widget.IsBatch != '1')
                    ? '1'
                    : widget.Quantity.toString(),

                // widget.imageUrls,
              );
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Review ${widget.Status} Info',
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
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 210,
                            child: Text(
                              'TFMC ID# ${widget.tfmcText}',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: 0.56,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(
                                  text: '${widget.tfmcText}'));
                            },
                            child: SvgPicture.asset(
                              'images/svg/copy.svg',
                              height: 18,
                              width: 15,
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 230,
                        // color: Colors.red,
                        child: Text(
                          '${widget.scText}',
                          style: GoogleFonts.inter(
                            color: Color(0xFF424242),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ),
                      Text(
                        widget.Status == 'Rigid Pipe'
                            ? ''
                            : 'RFID - ${widget.scanRfidValue}',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.Status == 'Flexibles'
                            ? 'Start End: ${widget.startvalue}'
                            : '',
                        style: GoogleFonts.inter(
                          color: Color(0xFF808080),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: 0.40,
                        ),
                      ),
                      Text(
                        widget.Status == 'Flexibles'
                            ? 'Line End:  ${widget.lineEndvalue}'
                            : '',
                        style: GoogleFonts.inter(
                          color: Color(0xFF808080),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.40,
                        ),
                      ),
                      Text(
                        widget.Status == 'Flexibles'
                            ? 'No. of Joints: ${widget.numOfJointsValue}'
                            : widget.Status == 'Rigid Pipe'
                                ? 'Quantity - ${widget.numOflength}'
                                : 'Location - ${widget.startvalue}',
                        style: GoogleFonts.inter(
                          color: Color(0xFF808080),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.40,
                        ),
                      ),
                      Text(
                        widget.Status == 'Flexibles'
                            ? 'Approx. Length: ${widget.approxLengthValue} m'
                            : '',
                        style: GoogleFonts.inter(
                          color: Color(0xFF808080),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.40,
                        ),
                      ),
                      Text(
                        widget.Status == 'Flexibles'
                            ? 'Approx. Weight: ${widget.approxWeightValue} MT'
                            : widget.Status == 'Rigid Pipe'
                                ? 'Container Weight - ${widget.approxWeightValue}'
                                : 'Dimension - ${widget.dimensions}',
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
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'TFMC ID# ${widget.tfmcText}',
            //             style: GoogleFonts.inter(
            //               color: Colors.black,
            //               fontSize: 14,
            //               fontWeight: FontWeight.w700,
            //               height: 0,
            //               letterSpacing: 0.56,
            //             ),
            //           ),
            //           Text(
            //             '${widget.scText}',
            //             style: GoogleFonts.inter(
            //               color: Color(0xFF424242),
            //               fontSize: 12,
            //               fontWeight: FontWeight.w700,
            //               height: 0,
            //               letterSpacing: 0.48,
            //             ),
            //           ),
            //           Text(
            //             'RFID - ${widget.scanRfidValue}',
            //             style: GoogleFonts.inter(
            //               color: Color(0xFFB9B9B9),
            //               fontSize: 10,
            //               fontWeight: FontWeight.w500,
            //               height: 0,
            //               letterSpacing: 0.40,
            //             ),
            //           ),
            //         ],
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //           Text(
            //             'Start End: ${widget.startvalue}',
            //             style: GoogleFonts.inter(
            //               color: Color(0xFF808080),
            //               fontSize: 10,
            //               fontWeight: FontWeight.w400,
            //               height: 0,
            //               letterSpacing: 0.40,
            //             ),
            //           ),
            //           Text(
            //             'Line End:  ${widget.lineEndvalue}',
            //             style: GoogleFonts.inter(
            //               color: Color(0xFF808080),
            //               fontSize: 10,
            //               fontWeight: FontWeight.w500,
            //               height: 0,
            //               letterSpacing: 0.40,
            //             ),
            //           ),
            //           Text(
            //             'No. of Joints: ${widget.numOfJointsValue}',
            //             style: GoogleFonts.inter(
            //               color: Color(0xFF808080),
            //               fontSize: 10,
            //               fontWeight: FontWeight.w500,
            //               height: 0,
            //               letterSpacing: 0.40,
            //             ),
            //           ),
            //           Text(
            //             'Approx. Length: ${widget.approxLengthValue}',
            //             style: GoogleFonts.inter(
            //               color: Color(0xFF808080),
            //               fontSize: 10,
            //               fontWeight: FontWeight.w500,
            //               height: 0,
            //               letterSpacing: 0.40,
            //             ),
            //           ),
            //           Text(
            //             'Approx. Length: ${widget.approxWeightValue} MT',
            //             style: GoogleFonts.inter(
            //               color: Color(0xFF808080),
            //               fontSize: 10,
            //               fontWeight: FontWeight.w500,
            //               height: 0,
            //               letterSpacing: 0.40,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Classification',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.40,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'The ${widget.Status} \n Categorizes as:',
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
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: determineColor() == Colors.orange
                    ? Colors.orange.shade800
                    : determineColor() == Colors.green
                        ? Color.fromRGBO(229, 255, 237, 1)
                        : Color(0xFFFFEEEE),

                //determineColor(),
                // widget.contaminatedvalue == true
                //     ? Color(0xFFFFEEEE)
                //     : widget.contaminatedvalue == false
                //         ? Color.fromRGBO(229, 255, 237, 1)
                //         : Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    width: 2,
                    color: determineColor() == Colors.orange
                        ? Colors.orange.shade800
                        : determineColor() == Colors.green
                            ? Colors.green
                            : Color(0xFFFF0000),
                    // determineColor(),
                    // widget.contaminatedvalue == true
                    //     ? Color(0xFFFF0000)
                    //     : widget.contaminatedvalue == false
                    //         ? Color(0xFF22C553)
                    //         : Colors.brown.shade100,
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
                        detail: '${widget.surfacevalue_ugvalue} (µg/m\u00B3)',
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
                            '${widget.is_radiation != null && widget.is_radiation == true ? 'Yes' : 'No'}',
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
                              '${widget.is_rph != null && widget.is_rph == true ? 'Yes' : 'No'}'),
                      PreviewComp(
                        label: "H2S: ",
                        detail: '${widget.hs2_value} (ppm)',
                      ),
                      PreviewComp(
                        label: "LEL: ",
                        detail: '${widget.lel_value} (%)',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
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
                        maxLines: 1000,
                        controller: commentController,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
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
            ),
          ],
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
