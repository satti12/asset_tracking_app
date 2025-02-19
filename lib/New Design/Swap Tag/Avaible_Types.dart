// ignore_for_file: must_be_immutable

import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/Tag%20_Assets.dart';
import 'package:asset_tracking/New%20Design/Swap%20Tag/TagedScreen.dart';
import 'package:asset_tracking/New%20Design/Tag%20HazMat%20Waste/Tag_Hazmat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NewAssetTagSwap extends StatefulWidget {
  NewAssetTagSwap({
    Key? key,
  }) : super(key: key);

  @override
  State<NewAssetTagSwap> createState() => _NewAssetTagSwapState();
}

class _NewAssetTagSwapState extends State<NewAssetTagSwap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'SWAP RFID TAG',
                  style: GoogleFonts.mulish(
                    color: Colors.black,
                    fontSize: 24,
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
                      Get.to(Tag_Sreeen_New(
                        Status: 'Flexibles',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                      Get.to(Tag_Sreeen_New(
                        Status: 'Rigid Pipe',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                  GestureDetector(
                    onTap: () {
                      Get.to(Tag_Sreeen_New(
                        Status: 'Subsea Structure',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                      Get.to(Tag_Sreeen_New(
                        Status: 'Ancillary Equipment',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(Tag_Sreeen_New(
                        Status: 'HazMat Waste',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              ' HazMat\n Waste',
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
                      Get.to(Tag_Sreeen_New(
                        Status: 'Bundle',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              'Bundle',
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
                  GestureDetector(
                    onTap: () {
                      Get.to(Tag_Sreeen_New(
                        Status: 'Container',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              'Container',
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
                      Get.to(Tag_Sreeen_New(
                        Status: 'Drum',
                      ));
                    },
                    child: Container(
                      width: 146.w,
                      height: 118.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              'Drum',
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
    );
  }
}
