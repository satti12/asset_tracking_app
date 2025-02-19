import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
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
                  //   radius: 20,
                  // ),
                  Container(
                      width: 248,
                      height: 100,
                      child: Image(
                        image: AssetImage('images/logo.png'),
                      )),
                  // SizedBox(
                  //   width: 5,
                  // ),
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
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                    child: Center(
                  child: Image(
                    image: AssetImage('images/boarding2.png'),
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
                      text: 'Scan ',
                      style: GoogleFonts.mulish(
                        color: Color(0xFF262626),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.48,
                      ),
                    ),
                    TextSpan(
                      text: 'Asset ',
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
                  'Asset is scanned in every destination through out the delivery process',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    color: Color(0xFF262626),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.24,
                  ),
                ),
              )

              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
