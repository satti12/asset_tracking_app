import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Utils {
  static void fieldFocusChage(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM);
  }

  static SnackBar(String title, String message, {Duration? duration}) {
    Get.snackbar(
      title,
      message,
      duration: duration ?? Duration(seconds: 3),
    );
  }
}
