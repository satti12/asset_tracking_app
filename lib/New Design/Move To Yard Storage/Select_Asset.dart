import 'package:asset_tracking/New%20Design/Move%20To%20Yard%20Storage/Ancillary_Storage.dart';
import 'package:asset_tracking/New%20Design/Move%20To%20Yard%20Storage/Rigids_Pipes/Rigid_Pipe_Store.dart';
import 'package:asset_tracking/New%20Design/Move%20To%20Yard%20Storage/Storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MoveToYardStorage extends StatefulWidget {
  const MoveToYardStorage({Key? key}) : super(key: key);

  @override
  State<MoveToYardStorage> createState() => _MoveToYardStorageState();
}

class _MoveToYardStorageState extends State<MoveToYardStorage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
                      Get.to(StorageScreen(
                        title: 'Flexibles',
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
                      Get.to(RigidPipeStore(
                        title: 'Rigids Pipes',
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
                            // SvgPicture.asset('images/svg/rigids.svg'),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              'Rigids\nPipes',
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
                      Get.to(StorageScreen(
                        title: 'HazMat Waste',
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
                            // SvgPicture.asset('images/svg/subsea.svg'),
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
                      Get.to(Ancillary_StorageScreen(
                        title: 'Ancillary Products',
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
              //   ),
              //   Padding(
              //     padding: const EdgeInsets.only(top: 20),
              //     child: GestureDetector(
              //       onTap: () {
              //         //
              //         // call -> SubSea Structures

              //         Get.to(TagHazmatWaste(
              //             //Status: 'Ancillary Equipment',
              //             ));
              //       },
              //       child: Container(
              //         width: 146.w,
              //         height: 118.h,
              //         decoration: ShapeDecoration(
              //           color: Color(0xFFFAFAFA),
              //           shape: RoundedRectangleBorder(
              //             side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
              //             borderRadius: BorderRadius.circular(15),
              //           ),
              //         ),
              //         child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               // SvgPicture.asset('images/svg/ancillaries.svg'),
              //               SizedBox(
              //                 height: 7.h,
              //               ),
              //               Text(
              //                 'HazMat\n Waste',
              //                 style: GoogleFonts.inter(
              //                   color: Color(0xFF808080),
              //                   fontSize: 16.sp,
              //                   fontWeight: FontWeight.w600,
              //                   height: 0,
              //                   letterSpacing: 0.64,
              //                 ),
              //               )
              //             ]),
              //       ),
              //     ),
            ),
          ],
        ),
      ),
    );
  }
}
