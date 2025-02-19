import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  FToast fToast = FToast();

  CustomToast(context) {
    fToast.init(context);
  }

  success(String text) {
    fToast.removeCustomToast();
    _showToast(text, Colors.greenAccent[100]!, Icons.check);
  }

  warn(String text) {
    fToast.removeCustomToast();
    _showToast(text, Colors.orangeAccent[100]!, Icons.info_outline_rounded);
  }

  error(String text) {
    fToast.removeCustomToast();
    _showToast(text, Colors.redAccent[100]!, Icons.cancel);
  }

  _showToast(String text, Color color, icon) {
    Widget toast = Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 2),
      gravity: ToastGravity.BOTTOM,
    );
  }
}
