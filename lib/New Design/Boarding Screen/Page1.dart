import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final double spacing = 5.0;
    final double dotSize = 2.0;

    for (double i = 0; i < 360; i += spacing) {
      final double radians = i * (pi / 180);
      final Offset startingPoint = Offset(
          radius + radius * cos(radians), radius + radius * sin(radians));
      final Offset endPoint = Offset(radius + (radius - dotSize) * cos(radians),
          radius + (radius - dotSize) * sin(radians));
      canvas.drawLine(startingPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   backgroundImage: AssetImage('images/logo.png'),
                  //   // radius: 20,
                  // ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  Container(
                      width: 248,
                      height: 100,
                      child: Image(
                        image: AssetImage('images/logo.png'),
                      ))
                  // Text(
                  //   'Radiation Professionals Australia',
                  //   style: GoogleFonts.mulish(
                  //     color: Color(0xFF262626),
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w800,
                  //     letterSpacing: -0.24,
                  //   ),
                  // ),
                ],
              ),

              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Container(
                    child: Center(
                  child: Image(
                    image: AssetImage('images/boarding1.png'),
                  ),
                )),
              ),
              SizedBox(
                height: 48,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Real Time ',
                      style: GoogleFonts.mulish(
                        color: Color(0xFF262626),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.48,
                      ),
                    ),
                    TextSpan(
                      text: 'Asset Tracking',
                      style: GoogleFonts.mulish(
                        color: Color(0xFFA80303),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.48,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 280,
                child: Text(
                  'Package can be tracked in real-time through out the delivery process',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    color: Color(0xFF262626),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.24,
                  ),
                ),
              ),

              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
