import 'package:asset_tracking/Component/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DecontanContainer extends StatefulWidget {
  final String structureType;
  final String rfid;
  final String BundleID;
  final String TFMC;
  final String ContamClassInitial;
  final Color leftBorderColor;

  DecontanContainer({
    Key? key,
    required this.structureType,
    required this.rfid,
    required this.BundleID,
    required this.TFMC,
    required this.ContamClassInitial,
    required this.leftBorderColor,
  }) : super(key: key);

  @override
  _DecontanContainerState createState() => _DecontanContainerState();
}

class _DecontanContainerState extends State<DecontanContainer> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 130.h,
      clipBehavior: Clip.antiAlias,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
          SizedBox(width: 14.w),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 300.w,
                          child: Text(
                            widget.structureType,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: 0.72,
                            ),
                          ),
                        ),
                        Text(
                          widget.rfid,
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
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        widget.BundleID,
                        style: GoogleFonts.inter(
                          color: Color(0xFF262626),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 0.20,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   width: 150,
                    //   child: Text(
                    //     'TFMC ID:',
                    //     style: GoogleFonts.inter(
                    //       color: Color(0xFF808080),
                    //       fontSize: 10,
                    //       fontWeight: FontWeight.w500,
                    //       height: 0.20,
                    //       letterSpacing: -0.20,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: 300,
                      child: Text(
                        widget.TFMC,
                        style: GoogleFonts.inter(
                          color: Color(0xFF262626),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 0.20,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        'Contam Class - Initial:',
                        style: GoogleFonts.inter(
                          color: Color(0xFF808080),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 0.20,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Text(
                        widget.ContamClassInitial,
                        style: GoogleFonts.inter(
                          color: widget.ContamClassInitial ==
                                  Classification.HAZARDOUS
                              ? Colors.orange
                              : widget.ContamClassInitial ==
                                      Classification.NON_CONTAMINATED
                                  ? Colors.green
                                  : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 0.20,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
