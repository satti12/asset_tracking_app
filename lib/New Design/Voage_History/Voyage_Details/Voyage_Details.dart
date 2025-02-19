import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VoyageDetailsPage extends StatefulWidget {
  String? vessel_name;
  String? origin;
  String? Destination;
  VoyageDetailsPage({
    super.key,
    this.vessel_name,
    this.origin,
    this.Destination,
  });

  @override
  State<VoyageDetailsPage> createState() => _VoyageDetailsPageState();
}

class _VoyageDetailsPageState extends State<VoyageDetailsPage> {
  bool isCheckBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Voyage Details',
              style: GoogleFonts.inter(
                color: Color(0xFF262626),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.48,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            // details about the voage container
            SizedBox(
              height: 150.h,
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
                                  'Vessel:',
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
                                SizedBox(height: 8.h),
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
                                  'Dispatched Packages:',
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF808080),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: 0.48,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Voyage #',
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF808080),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0.14,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'In-Transit',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: Color(0xFFFF0000),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                                Text(
                                  widget.vessel_name.toString(),
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
                                  'Enfield',
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF808080),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: 0.48,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '(Sep 03,2023 8:14UTC)',
                                        style: GoogleFonts.inter(
                                          color: Color(0xFF808080),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                          height: 0.25,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' \n',
                                        style: GoogleFonts.inter(
                                          color: Color(0xFF262626),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          height: 0.14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  'Dampier Quayside',
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
                                  '(TBA)',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF808080),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    height: 0.25,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '01',
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
                                  'RPA0001',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: Color(0xFF262626),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 0.14,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
            // here comes the
            Container(
              width: 385,
              height: 167,
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
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFFA80303),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isCheckBox,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckBox = value ?? false;
                      });
                    },
                    activeColor: Color(0xFFA80303),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TFMC ID# GR-FX-2IN-1',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              letterSpacing: 0.56,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            'Bundle# 0001',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF808080),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              height: 1,
                              letterSpacing: 0.40,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'SC-2 to DS1/2 Flowline',
                        style: TextStyle(
                          color: Color(0xFF424242),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          letterSpacing: 0.48,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            'RFID - 1245349683829405739284721',
                            style: TextStyle(
                              color: Color(0xFFB9B9B9),
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              height: 1,
                              letterSpacing: 0.32,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                          ),
                          Container(
                            child: InkWell(
                              // onTap: () {
                              //   setState(() {
                              //     _isExpanded = !_isExpanded;
                              //   });
                              // },
                              child: Text(
                                'Details',
                                style: TextStyle(
                                  color: Color(0xFFA80303),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  height: 1,
                                  letterSpacing: -0.20,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
