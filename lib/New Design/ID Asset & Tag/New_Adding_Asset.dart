// ignore_for_file: must_be_immutable

import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/Tag%20_Assets.dart';
import 'package:asset_tracking/New%20Design/Tag%20HazMat%20Waste/Tag_Hazmat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/main.dart';

class NewAssetsAdding extends StatefulWidget {
  String? CrunnetLocation;
  NewAssetsAdding({Key? key, this.CrunnetLocation}) : super(key: key);

  @override
  State<NewAssetsAdding> createState() => _NewAssetsAddingState();
}

class _NewAssetsAddingState extends State<NewAssetsAdding> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rf_id.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(NewBottomNavigation());
        return true; // Allow default back button behavior
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                Get.to(NewBottomNavigation());
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Select Asset Type',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 0,
                      letterSpacing: -0.56,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(
                            //CustomPage()
                            Tag_Flexibles(
                          //                      // call -> ScanBundles
                          Status: 'Flexibles',
                          IsBatch: '0',
                          Location: widget.CrunnetLocation,
                        ));
                      },
                      child: Container(
                        width: 146.w,
                        height: 118.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFAFAFA),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SvgPicture.asset('images/svg/flexibles.svg'),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                'Flexibles',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: 0.64,
                                ),
                              ),
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // call -> ScanBundles

                        Get.to(Tag_Flexibles(
                          Status: 'Rigid Pipe',
                          IsBatch: '0',
                          Location: widget.CrunnetLocation,
                        ));
                      },
                      child: Container(
                        width: 146.w,
                        height: 118.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFAFAFA),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SvgPicture.asset('images/svg/rigids.svg'),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                'Rigids',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: 0.64,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    // call -> SubSea Structures
                    GestureDetector(
                      onTap: () {
                        //
                        Get.to(Tag_Flexibles(
                          Status: 'Subsea Structure',
                          IsBatch: '0',
                          Location: widget.CrunnetLocation,
                        ));
                      },
                      child: Container(
                        width: 146.w,
                        height: 118.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFAFAFA),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SvgPicture.asset('images/svg/subsea.svg'),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                ' SubSea\nStructure',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: 0.64,
                                ),
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                        // call -> SubSea Structures
                        Get.to(Tag_Flexibles(
                          Status: 'Ancillary Equipment',
                          IsBatch: '0',
                          Location: widget.CrunnetLocation,
                        ));
                      },
                      child: Container(
                        width: 146.w,
                        height: 118.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFAFAFA),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SvgPicture.asset('images/svg/ancillaries.svg'),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                'Ancillary \nProducts',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: 0.64,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    // call -> SubSea Structures

                    GestureDetector(
                      onTap: () {
                        Get.to(TagHazmatWaste(
                            //Status: 'Ancillary Equipment',
                            ));
                      },
                      child: Container(
                        width: 146.w,
                        height: 118.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFAFAFA),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SvgPicture.asset('images/svg/ancillaries.svg'),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                'HazMat\n Waste',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: 0.64,
                                ),
                              )
                            ]),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        //
                        Get.to(Tag_Flexibles(
                          Status: 'Ancillary Equipment',
                          IsBatch: '1',
                          Location: widget.CrunnetLocation,
                        ));
                      },
                      child: Container(
                        width: 146.w,
                        height: 118.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFFFAFAFA),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SvgPicture.asset('images/svg/subsea.svg'),
                              SizedBox(
                                height: 7.h,
                              ),
                              Text(
                                'Ancillary \n (Batch)',
                                style: GoogleFonts.inter(
                                  color: Color(0xFF808080),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: 0.64,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
