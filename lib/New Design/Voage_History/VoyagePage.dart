import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ComponentsForTab/AssetsTabs.dart';
import 'ComponentsForTab/VoyageHistoryTab.dart';

class VoyagePage extends StatefulWidget {
  const VoyagePage({Key? key}) : super(key: key);

  @override
  State<VoyagePage> createState() => _VoyagePageState();
}

class _VoyagePageState extends State<VoyagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voyage',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                  letterSpacing: -0.56,
                ),
              ),
              Text(
                'Here’s the list of your Voyages',
                style: GoogleFonts.mulish(
                  color: Color(0xFF808080),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: -0.24,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 100),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Color(0xFFA80303),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  indicatorSize: TabBarIndicatorSize
                      .tab, // Set indicatorSize to TabBarIndicatorSize.tab

                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text('History'),
                    ),
                    Tab(
                      child: Text('Assets'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 700,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Home Tab Content
                    VoyageHistoryTab(),
                    // Agent Tab Content
                    VoyageAssetsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
