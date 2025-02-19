import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
void showSnackBar(BuildContext context) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Container(
          height: 30,
          width: 30,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved',
              style: GoogleFonts.mulish(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.28,
              ),
            ),
            Text(
              'Your changes has been changed.',
              style: GoogleFonts.inter(
                color: Color(0xFF808080),
                fontSize: 8,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.16,
              ),
            )
          ],
        )
      ],
    ),
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Dismiss',
      disabledTextColor: Colors.white,
      textColor: Color(0xFF808080),
      onPressed: () {
        //Do whatever you want
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
