// ignore_for_file: unused_local_variable

import 'package:asset_tracking/New%20Design/Boarding%20Screen/boarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // if (FirebaseAuth.instance.currentUser != null) {
      // } else {
      Get.to(Boarding());

      //   }
    });
  }

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.sizeOf(context);
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF410000), Color(0xFF910100)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 310,
                  height: 310,
                  decoration: ShapeDecoration(
                    color: Color(0x28E7E7E7),
                    shape: OvalBorder(),
                  ),
                  child: Container(
                    width: 308,
                    height: 308,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF410000), Color(0xFF910100)],
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'images/background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
