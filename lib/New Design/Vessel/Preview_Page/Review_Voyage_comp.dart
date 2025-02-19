import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Review_Voyage_Coponenets extends StatelessWidget {
  final String Vessls;
  final String Origin;
  final String time;
  final String Destination;
  final String Dispatch_Packages;

  Review_Voyage_Coponenets({
    required this.Vessls,
    required this.Origin,
    required this.time,
    required this.Destination,
    required this.Dispatch_Packages,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                          'Vessels:',
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
                          'Origin:',
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.48,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Destination:',
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
                          'Dispatch Packages#',
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Vessls,
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
                          Origin,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.48,
                          ),
                        ),
                        Text(
                          time,
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
                          Destination,
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
                          Dispatch_Packages,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.48,
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
    );
  }
}
