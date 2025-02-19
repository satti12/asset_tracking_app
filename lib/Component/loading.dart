import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Loading {
  static OverlayEntry? _overlayEntry;

  static void showLoading(BuildContext context,
      {Duration duration = const Duration(seconds: 1)}) {
    if (_overlayEntry != null) {
      return; // Loading overlay is already shown
    }

    OverlayState overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: <Widget>[
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color:
                  Colors.black.withOpacity(0), // Adjust the opacity as needed
            ),
          ),
          // Loading indicator
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  static void hideLoading() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null; // Ensure the overlay entry is reset after removal
    }
  }
}
