import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    this.buttonColor = Colors.black,
    this.textColor = Colors.white,
    required this.title,
    required this.onPress,
    this.width,
    this.height,
    this.loading = false,
    this.icon, // Optional image/icon
    this.borderColor, // Optional border color
  }) : super(key: key);

  final bool loading;
  final String title;
  final String? height, width;
  final VoidCallback onPress;
  final Color textColor, buttonColor;
  final Color? borderColor; // Use Color? for borderColor
  final Widget? icon; // Optional image/icon

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: loading ? null : onPress,
        child: Container(
          height: height != null ? double.parse(height!) : 58.h,
          width: width != null ? double.parse(width!) : double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
            border: borderColor != null
                ? Border.all(
                    color: borderColor!,
                    width: 1.0, // You can adjust the border width as needed
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: icon,
                ),
              ],
              loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mulish(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.32,
                      ),
                    ),
            ],
          ),
        ));
  }
}
