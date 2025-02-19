import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/login.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding/onboarding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'Page1.dart';
import 'Page2.dart';

class Boarding extends StatefulWidget {
  @override
  State<Boarding> createState() => _MyBoarding();
}

class _MyBoarding extends State<Boarding> {
  final _controller = PageController();

  late Material materialButton;

  late int index;

  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Page1(),
            ],
          ),
        ),
      ),
    ),
    // for page 2
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Page2(),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the content vertically

                children: [
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      children: [
                        Page1(),
                        Page2(),
                      ],
                    ),
                  ),
                  SizedBox(
                      height:
                          25), // Add some spacing between PageView and SmoothPageIndicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 2,
                    effect: ExpandingDotsEffect(
                      dotWidth: 5,
                      dotHeight: 4,
                      dotColor: Colors.grey,
                      activeDotColor: Color(0xFFA80303),
                      spacing: 6,
                    ),
                  ),
                  SizedBox(height: 67), // Add some spacing before the buttons
                  Padding(
                    padding: const EdgeInsets.all(21),
                    child: RoundButton(
                      title: 'LOGIN',
                      onPress: () {
                        try {
                          DatabaseHelper.instance.syncDataFromApi();
                          Get.to(NewLoginScreen());
                        } catch (e) {
                          Utils.SnackBar('Error',
                              'Data Could not be Fetched from the Server. Please check your internet connection');
                        }

                        // LoginScreen()
                      },
                    ),
                  ),
                  SizedBox(height: 93),
                ],
              ),
            ],
          )),
    );
  }
}
