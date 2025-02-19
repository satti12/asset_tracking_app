// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/error_dailog.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Repository/Container_Repository/create_container_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerContamDetails extends StatefulWidget {
  String? ContainerType;
  String? ContainerTypeId;
  bool? NoContainerFlag;
  String? ContainerSerialNum;
  String? ContainerRFID;
  String? ContainerClassification;
  int? BundelCount;
  String? id;
  List<Asset> items;
  Asset container;

  //String? ContainerType;

  ContainerContamDetails({
    Key? key,
    this.ContainerType,
    this.ContainerTypeId,
    this.ContainerSerialNum,
    this.ContainerRFID,
    this.ContainerClassification,
    this.NoContainerFlag,
    this.BundelCount,
    this.id,
    required this.items,
    required this.container,
  }) : super(key: key);

  @override
  State<ContainerContamDetails> createState() => _ContainerContamDetailsState();
}

class _ContainerContamDetailsState extends State<ContainerContamDetails> {
  String? adgClassValue;
  String? unValue;
  String? Class7Value;
  String? DoseValue;
  String? _selectedADGClass;
  String? _selectedClassCategory;
  String? _selectedUN;
  bool shouldHideDropdowns = false;
  TextEditingController un_number = TextEditingController(text: '3369');
  TextEditingController dose_rate = TextEditingController();
  TextEditingController contaierweight = TextEditingController();
  String classification = Classification.NON_CONTAMINATED;

  RxInt bundlecount = 0.obs;
  RxInt batchcount = 0.obs;
  bool isNonContaminated = false;
  void CheckContamination() {
    if (widget.ContainerClassification == Classification.NON_CONTAMINATED) {
      for (var item in widget.items) {
        if (item.classification == Classification.HAZARDOUS) {
          setState(() {
            classification = Classification.HAZARDOUS;
          });
          break;
        }
        if (item.classification == Classification.CONTAMINATED) {
          setState(() {
            classification = Classification.CONTAMINATED;
          });
        }
      }
    } else {
      classification = widget.ContainerClassification.toString();
    }
  }

  void count() {
    var result;
    for (var item in widget.items) {
      if (item.asset_type == AssetType.BUNDLE) {
        result = bundlecount.value++;
      }
      if (item.asset_type == AssetType.BATCH) {
        result = batchcount.value++;
      }
    }
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      CheckContamination();

      count();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement initState
    CheckContamination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('ContainerClassification');
    print(widget.ContainerClassification);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                if ((classification == Classification.CONTAMINATED ||
                        classification == Classification.HAZARDOUS) &&
                    (_selectedADGClass == null)) {
                  // Show the first error dialog
                  ErrorDialog.showError(
                      context, 'Error', 'Please Select ADG Class ....');
                } else if ((classification == Classification.CONTAMINATED ||
                        classification == Classification.HAZARDOUS) &&
                    (_selectedADGClass == '7' &&
                        (_selectedUN == null ||
                            _selectedClassCategory == null ||
                            dose_rate.text.isEmpty))) {
                  // Show the second error dialog
                  ErrorDialog.showError(
                      context, 'Error', 'Please fill All Field ....');
                } else if (classification == Classification.NON_CONTAMINATED &&
                    widget.items.length != 1 &&
                    !isNonContaminated) {
                  if (_selectedADGClass == null) {
                    ErrorDialog.showError(
                        context, 'Error', 'Please Select ADG Class ....');
                  } else if ((_selectedADGClass == '7' &&
                      (_selectedUN == null ||
                          _selectedClassCategory == null ||
                          dose_rate.text.isEmpty))) {
                    ErrorDialog.showError(
                        context, 'Error', 'Please fill All Field ....');
                  } else {
                    loadNewContainer(widget.container, widget.items)
                        .whenComplete(() async {
                      AssetScreening screening = AssetScreening(
                        screening_type: ScreeningType.INITIAL_SCREENING,
                        asset_id: widget.id,
                        adg_class:
                            _selectedADGClass, // Use the adg_class from the current item
                        un_number: _selectedADGClass == '9'
                            ? un_number.text
                            : _selectedUN,
                        dose_rate: double.tryParse(dose_rate.text) ?? 0.0,
                        class_7_category: _selectedClassCategory,
                        classification: classification,
                        //   description: container.description,
                        is_sync: 0,
                      );

                      String screeningId = await DatabaseHelper.instance
                          .createAssetScreening(screening);
                    });
                  }
                } else {
                  loadNewContainer(widget.container, widget.items)
                      .whenComplete(() async {
                    AssetScreening screening = AssetScreening(
                      screening_type: ScreeningType.INITIAL_SCREENING,
                      asset_id: widget.id,
                      adg_class:
                          _selectedADGClass, // Use the adg_class from the current item
                      un_number: _selectedADGClass == '9'
                          ? un_number.text
                          : _selectedUN,
                      dose_rate: double.tryParse(dose_rate.text) ?? 0.0,
                      class_7_category: _selectedClassCategory,
                      classification: classification,
                      //   description: container.description,
                      is_sync: 0,
                    );

                    String screeningId = await DatabaseHelper.instance
                        .createAssetScreening(screening);
                  });
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: Color(0xFFA80303),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Container Contam Details',
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
                          shape: CircleBorder(),
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
                height: 20.h,
              ),
              // here comes the container details in an invisible sized box
              SizedBox(
                height: 130.h,
                child: Container(
                  width: 345.w,
                  height: 78.h,
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
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Container Type:',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF808080),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Serial Number:',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF808080),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'RFID:',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF808080),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Obx(
                                    () => Text(
                                      bundlecount == 0 ? '' : 'Bundle Count#',
                                      style: GoogleFonts.inter(
                                        color: Color(0xFF808080),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: 0.48,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Obx(
                                    () => Text(
                                      batchcount == 0 ? '' : 'Batch Count#',
                                      style: GoogleFonts.inter(
                                        color: Color(0xFF808080),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: 0.48,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${widget.ContainerType}',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF808080),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '${widget.ContainerSerialNum}',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF808080),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '${widget.ContainerRFID}',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFF808080),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Obx(
                                    () => Text(
                                      bundlecount == 0
                                          ? ''
                                          : bundlecount.toString(),
                                      style: GoogleFonts.inter(
                                        color: Color(0xFF808080),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: 0.48,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Obx(
                                    () => Text(
                                      batchcount == 0
                                          ? ''
                                          : batchcount.toString(),
                                      style: GoogleFonts.inter(
                                        color: Color(0xFF808080),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: 0.48,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              // classification == Classification.NON_CONTAMINATED
              //     ? SizedBox()
              //    :
              widget.items.length == 1 &&
                      classification == Classification.NON_CONTAMINATED
                  ? SizedBox()
                  : Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value:
                                  isNonContaminated, // Set the value based on the boolean variable
                              onChanged: classification ==
                                          Classification.CONTAMINATED ||
                                      classification == Classification.HAZARDOUS
                                  ? null
                                  : (bool? value) {
                                      setState(() {
                                        widget.container.adg_class = null;
                                        widget.container.un_number = null;
                                        widget.container.dose_rate = null;
                                        widget.container.class_7_category =
                                            null;
                                        dose_rate.clear();
                                        _selectedADGClass = null;
                                        _selectedClassCategory = null;
                                        _selectedUN = null;

                                        isNonContaminated = value ?? false;
                                      });
                                    },
                              activeColor: Color(0xFFA80303),
                              tristate: false,
                              visualDensity: VisualDensity.standard,
                            ),
                            Text(
                              'Non Contaminated',
                              style: GoogleFonts.mulish(
                                color: Color(0xFFCCCCCC),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: -0.28,
                              ),
                            ),
                          ],
                        ),
                        isNonContaminated == true
                            ? SizedBox()
                            : Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 20,
                                        top: 0,
                                        bottom: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ADG Class',
                                                  style: GoogleFonts.mulish(
                                                    color: Color(0xFF262626),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    height: 0,
                                                    letterSpacing: -0.28,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    value: _selectedADGClass,
                                                    underline: SizedBox(),
                                                    items: <String>['7', '9']
                                                        .map((String valueAGD) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: valueAGD,
                                                        child: Text(
                                                          valueAGD,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Color(
                                                                0xFF23262F),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        _selectedADGClass =
                                                            newValue;
                                                        shouldHideDropdowns =
                                                            newValue == '9';
                                                        widget.container
                                                                .adg_class =
                                                            _selectedADGClass;
                                                        if (_selectedADGClass ==
                                                            '9') {
                                                          setState(() {
                                                            _selectedUN = null;
                                                            widget.container
                                                                    .un_number =
                                                                '3369';
                                                            widget.container
                                                                    .class_7_category =
                                                                null;
                                                            widget.container
                                                                    .dose_rate =
                                                                null;
                                                            _selectedClassCategory =
                                                                null;
                                                            dose_rate.clear();
                                                          });
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'UN#',
                                                  style: GoogleFonts.mulish(
                                                    color: Color(0xFF262626),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    height: 0,
                                                    letterSpacing: -0.28,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                _selectedADGClass == '9'
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: TextFormField(
                                                          controller: un_number,
                                                          onChanged: (value) {
                                                            widget.container
                                                                    .un_number =
                                                                un_number.text;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText: '',
                                                            hintStyle:
                                                                GoogleFonts
                                                                    .inter(
                                                              color: Color(
                                                                  0xFFB9B9B9),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 0,
                                                              letterSpacing:
                                                                  0.40,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: DropdownButton<
                                                            String>(
                                                          isExpanded: true,
                                                          value: _selectedUN,
                                                          underline: SizedBox(),
                                                          items: <String>[
                                                            '2910',
                                                            '2911',
                                                            '2912',
                                                            '2913',
                                                            '3326'
                                                          ].map(
                                                              (String valueUN) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: valueUN,
                                                              child: Text(
                                                                valueUN,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: Color(
                                                                      0xFF23262F),
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              _selectedUN =
                                                                  newValue;

                                                              widget.container
                                                                      .un_number =
                                                                  _selectedUN;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  shouldHideDropdowns
                                      ? SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 20,
                                              top: 0,
                                              bottom: 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Dose Rate',
                                                        style:
                                                            GoogleFonts.mulish(
                                                          color:
                                                              Color(0xFF262626),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                          letterSpacing: -0.28,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.0),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: TextFormField(
                                                          controller: dose_rate,
                                                          onChanged: (value) {
                                                            widget.container
                                                                    .dose_rate =
                                                                double.tryParse(
                                                                    dose_rate
                                                                        .text);
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            suffix:
                                                                Text('µSv/h'),
                                                            suffixStyle:
                                                                GoogleFonts
                                                                    .inter(
                                                              color: Color(
                                                                  0xFFCCCCCC),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0,
                                                              letterSpacing:
                                                                  -0.24,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              shouldHideDropdowns
                                                  ? SizedBox()
                                                  : Expanded(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Class 7 Category',
                                                              style: GoogleFonts
                                                                  .mulish(
                                                                color: Color(
                                                                    0xFF262626),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height: 0,
                                                                letterSpacing:
                                                                    -0.28,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              child:
                                                                  DropdownButton<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                value:
                                                                    _selectedClassCategory,
                                                                underline:
                                                                    SizedBox(),
                                                                items: <String>[
                                                                  'Excepted',
                                                                  'I - White',
                                                                  'II - Yellow',
                                                                  'III - Yellow',
                                                                ].map((String
                                                                    valueClassCat) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        valueClassCat,
                                                                    child: Text(
                                                                      valueClassCat,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        color: Color(
                                                                            0xFF23262F),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        height:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    _selectedClassCategory =
                                                                        newValue;

                                                                    widget.container
                                                                            .class_7_category =
                                                                        _selectedClassCategory;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                      ],
                    ),
              Text(
                'Container Weight',
                style: GoogleFonts.mulish(
                  color: Color(0xFF262626),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.28,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                height: 46,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.sizeOf(context).width / 1.1,
                child: TextFormField(
                  controller: contaierweight,
                  onChanged: (value) {
                    widget.container.crane_weight =
                        double.tryParse(contaierweight.text);
                  },
                  decoration: InputDecoration(
                      suffixText: 'MT',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'Classification',
                style: GoogleFonts.mulish(
                  color: Color(0xFF262626),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.40,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'The Container\nCategorizes as:',
                    style: GoogleFonts.mulish(
                      color: Color(0xFF808080),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.24,
                    ),
                  ),
                  Text(
                    classification,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.mulish(
                      color: classification == Classification.CONTAMINATED
                          ? Color(0xFFFF0000)
                          : classification == Classification.HAZARDOUS
                              ? Colors.orange
                              : Colors.green,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      decorationColor: classification ==
                              Classification.HAZARDOUS
                          ? Colors.orange
                          : classification == Classification.NON_CONTAMINATED
                              ? Colors.green
                              : Colors.red,
                      height: 0,
                      letterSpacing: -0.44,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
