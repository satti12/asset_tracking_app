import 'package:asset_tracking/New%20Design/Voage_History/Voyage_Details/Voyage_Details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HistorytabContainer extends StatelessWidget {
  final String voyageNumber;
  final String deliveryStatus;
  final String personName;
  final String location1;
  final String location2;
  final String dispatched1;
  final String dispatched2;
  final String dateTime1;
  final String dateTime2;

  HistorytabContainer({
    required this.voyageNumber,
    required this.deliveryStatus,
    required this.personName,
    required this.location1,
    required this.location2,
    required this.dispatched1,
    required this.dispatched2,
    required this.dateTime1,
    required this.dateTime2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 350.w,
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              '$voyageNumber',
                              style: GoogleFonts.inter(
                                color: Color(0xFF262626),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ),

                          // SvgPicture.asset('images/svg/copy.svg'),
                          Container(
                            width: 120,
                            child: Text(
                              deliveryStatus,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                color: Color(0xFF22C553),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.22,
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        personName,
                        style: GoogleFonts.inter(
                          color: Color(0xFF808080),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 13.h,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('images/svg/copy.svg'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: SvgPicture.asset(
                          'images/svg/line2.svg',
                          height: 16,
                        ),
                      ),
                      SvgPicture.asset('images/svg/copy.svg'),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location1,
                        style: GoogleFonts.mulish(
                          color: Color(0xFF262626),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.24,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        location2,
                        style: GoogleFonts.mulish(
                          color: Color(0xFF262626),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 80.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 53.w,
                              child: Text(
                                dispatched1,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.mulish(
                                  color: Color(0xFF808080),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 74.w,
                              child: Text(
                                dateTime1,
                                style: GoogleFonts.mulish(
                                  color: Color(0xFF808080),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              width: 53.w,
                              child: Text(
                                dispatched2,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.mulish(
                                  color: Color(0xFF808080),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 74.w,
                              child: Text(
                                dateTime2,
                                style: GoogleFonts.mulish(
                                  color: Color(0xFF808080),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.16,
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
              SizedBox(
                height: 10.h,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(VoyageDetailsPage());
                },
                child: Text(
                  'Details',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    color: Color(0xFFA80303),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    height: 0,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
