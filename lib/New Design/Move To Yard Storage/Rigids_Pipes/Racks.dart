import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Component/roundbutton.dart';

class RigidsPipes extends StatefulWidget {
  const RigidsPipes({super.key});

  @override
  State<RigidsPipes> createState() => _RigidsPipesState();
}

class _RigidsPipesState extends State<RigidsPipes> {
  void AlertDilaogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              height: 400.h,
              width: 400.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompofRigids(
                    productionFlowline: 'Rigid Pipe Batch# RGD-EN-0001',
                    rfid: 'RFID - 124534968382940543484721',
                    rigidPipeBatch: 'SC-2 Production Flowline ',
                    TFMC: 'TFMC ID# GR-SC2-RPL-1',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Select Storage Location',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.36,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // here comes the box for selecting location insided alertdialogbox
                  buildMatrix(),
                  SizedBox(height: 30.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 108.w,
                        height: 40.h,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xFFA80303)),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x66AEAEC0),
                              blurRadius: 6.54,
                              offset: Offset(2.18, 2.18),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Color(0xFFFFFFFF),
                              blurRadius: 6.54,
                              offset: Offset(-2.18, -2.18),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: RoundButton(
                          onPress: () {},
                          title: 'Cancle',
                          buttonColor: Colors.white,
                          textColor: Colors.black,
                          // borderColor: Color(0xFFA80303),
                        ),
                      ),
                      Container(
                        width: 108,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Color(0xFFA80303),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0xFFFFFFFF),
                              blurRadius: 6.54,
                              offset: Offset(-2.18, -2.18),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Color(0x66AEAEC0),
                              blurRadius: 6.54,
                              offset: Offset(2.18, 2.18),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: RoundButton(
                          buttonColor: Color(0xFFA80303),
                          onPress: () {},
                          title: 'Store Assets',
                          textColor: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              )),
        );
      },
    );
  }

  Widget buildMatrix() {
    return Column(
      children: [
        buildRow(['N1', 'N2', 'N3', 'N4', 'nN']),
        buildRow(['S1', 'S2', 'S3', 'S4', 'S5']),
      ],
    );
  }

  Widget buildRow(List<String> elements) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: elements
          .map((element) => Row(
                children: [
                  CustomBox(id: element),
                  SizedBox(width: 2.w),
                ],
              ))
          .expand((element) => [element, SizedBox(width: 2.w)])
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                AlertDilaogBox(context);
              },
              child: Text(
                'DialogBox',
                style: GoogleFonts.mulish(
                  color: Color(0xFFA80303),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rigid Pipes',
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
                        shape: OvalBorder(),
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
              height: 15.h,
            ),

            // Scan RFID again

            Container(
              width: MediaQuery.sizeOf(context).width / .9,
              height: 50.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width /
                          1.6, // Adjust the width as needed
                      height: 50, // Match the container height
                      child: TextFormField(
                        // enabled: !isNoContainerSelected,
                        // controller: rf_id,
                        // onEditingComplete: () {
                        //   // Call the API when the user finishes typing and presses done/return key
                        //   fetchContainerType();
                        // },
                        decoration: InputDecoration(
                            hintText: 'Scan Rigid Pipes RFID',
                            helperStyle: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: -0.28,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        //  fetchContainerType();
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Color(0xFFA80303),
                          shape: BoxShape
                              .circle, // Use BoxShape.circle for a circular shape
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'images/svg/scaner.svg',
                            height: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 15.h,
            ),
            // here comes the
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Scan Count : ',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  TextSpan(
                    text: '001',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                  TextSpan(
                    text: ' of 015',
                    style: GoogleFonts.inter(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            // here comes the cards that holding scnned info
            CompofRigids(
              productionFlowline: 'Rigid Pipe Batch# RGD-EN-0001',
              rfid: 'RFID - 124534968382940543484721',
              rigidPipeBatch: 'SC-2 Production Flowline ',
              TFMC: 'TFMC ID# GR-SC2-RPL-1',
            ),
          ]),
        )));
  }
}

class CompofRigids extends StatefulWidget {
  final String TFMC;
  final String productionFlowline;
  final String rfid;
  final String rigidPipeBatch;

  CompofRigids({
    required this.productionFlowline,
    required this.rfid,
    required this.rigidPipeBatch,
    required this.TFMC,
  });

  @override
  State<CompofRigids> createState() => _CompofRigidsState();
}

class _CompofRigidsState extends State<CompofRigids> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      height: 77,
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
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  widget.TFMC,
                  style: GoogleFonts.inter(
                    color: Color(0xFF424242),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.56,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  widget.productionFlowline,
                  style: GoogleFonts.inter(
                    color: Color(0xFF424242),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.56,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  widget.rfid,
                  style: GoogleFonts.inter(
                    color: Color(0xFFB9B9B9),
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.32,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  widget.rigidPipeBatch,
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//

class CustomBox extends StatefulWidget {
  final String id;

  const CustomBox({Key? key, required this.id}) : super(key: key);

  @override
  _CustomBoxState createState() => _CustomBoxState();
}

class _CustomBoxState extends State<CustomBox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.id,
          style: TextStyle(fontSize: 18.sp),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFA80303) : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
