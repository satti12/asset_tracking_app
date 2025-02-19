// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Arrival_At_Quayside/ArrivalAtQuaysaide.dart';
import 'package:asset_tracking/Repository/Arival_At_Quayside_Repostiory/fetch_list_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class QuaysideFilter extends StatefulWidget {
  String? currentlocation;
  String? ActiveLocationid;
  QuaysideFilter({super.key, this.ActiveLocationid, this.currentlocation});

  @override
  State<QuaysideFilter> createState() => _QuaysideFilterState();
}

class _QuaysideFilterState extends State<QuaysideFilter> {
  String? _selectedFullName;
  String? _selectedOperatingLocationId;
  List<Map<String, dynamic>> _locations = [];
  // String? selectVessels;
  // String? selectLocation;
  //late List<Map<String, String>> vessels;
  //late String selectedVesselId;
  String? _selectedVesselName;
  String? _selectedVesselId;
  List<Map<String, dynamic>> _vessels = [];
  List<String> selectedIds = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _fetchVessel();
  }

  Future<void> _fetchLocations() async {
    // final response =
    //     await DatabaseHelper.instance.queryAllRows('operating_locations');

    final response =
        await DatabaseHelper.instance.queryList('operating_locations', [
      ['type', '=', LocationType.FIELD]
    ], {});
    setState(() {
      _locations = (response as List)
          .map((record) => {
                'operating_location_id': record['operating_location_id'],
                'full_name': record['name'] + record['type'],
              })
          .toList();

      _locations.sort((a, b) => a['full_name'].compareTo(b['full_name']));
    });
  }

  Future<void> _fetchVessel() async {
    final response = await DatabaseHelper.instance.queryAllRows('vessels');

    setState(() {
      _vessels = (response as List)
          .map((record) => {
                'name': record['name'] ?? '',
                'id': record['vessel_id'] ?? '',
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Filter & Sort',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.24,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            'Origin',
            style: GoogleFonts.mulish(
              color: Color(0xFF262626),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 0,
              letterSpacing: -0.28,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            width: 380.w,
            height: 48.h,
            decoration: BoxDecoration(
              border: Border.all(width: 0.50, color: Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: InputBorder.none, // Removes the underline border
                contentPadding:
                    EdgeInsets.symmetric(vertical: 3), // Adjust content padding
              ),
              value: _selectedFullName,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFullName = newValue!;
                  _selectedOperatingLocationId = _locations.firstWhere(
                    (location) => location['full_name'] == newValue,
                  )['operating_location_id'] as String;
                });
              },
              items: _locations.map((location) {
                return DropdownMenuItem<String>(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(location['full_name'] as String),
                  ),
                  value: location['full_name'] as String,
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            'Vessel',
            style: GoogleFonts.mulish(
              color: Color(0xFF262626),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 0,
              letterSpacing: -0.28,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          // Container(
          //   width: 380.w,
          //   height: 48.h,
          //   decoration: BoxDecoration(
          //     border: Border.all(width: 0.50, color: Color(0xFFD9D9D9)),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: DropdownButtonFormField<String>(
          //     // hint: Text('Select Location'),
          //     decoration: InputDecoration(
          //       border: InputBorder.none, // Removes the underline border
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 3), // Adjust content padding
          //     ),
          //     value: _selectedVesselName,
          //     onChanged: (newValue) {
          //       setState(() {
          //         _selectedVesselName = newValue;
          //         _selectedVesselId = _vessels.firstWhere(
          //             (vessel) => vessel['id'] == newValue)['id'] as String;
          //       });
          //     },
          //     items: _vessels
          //         .map((vessel) => DropdownMenuItem<String>(
          //               child: Text(vessel['name']),
          //               value: vessel['id'] as String,
          //             ))
          //         .toList(),
          //   ),
          // ),

          Container(
            width: 350.w,
            height: 42.h,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.50, color: Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: 180.w,
                height: 48.h,
                child: DropdownButtonFormField<String>(
                  // hint: Text('Select Location'),
                  decoration: InputDecoration(
                    // Set decoration to null or customize it as needed
                    border: InputBorder.none, // Removes the underline border
                    contentPadding: EdgeInsets.symmetric(
                        // horizontal: 10,
                        vertical: 3), // Optional: Adjust content padding
                  ),
                  value: _selectedVesselName,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedVesselName = newValue!;
                      _selectedVesselId = _vessels.firstWhere(
                              (vessel) => vessel['name'] == newValue)['id']
                          as String;
                    });
                  },
                  items: _vessels
                      .map((vessel) => DropdownMenuItem<String>(
                            child: Text(vessel['name']),
                            value: vessel['name'] as String,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 108.w,
                  height: 40.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,

                        //  color: Color(0xFFA80303)
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x66AEAEC0),
                        blurRadius: 6.54,
                        offset: Offset(2.18, 2.18),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0xFFFFFFFF),
                        blurRadius: 6.54,
                        offset: Offset(-2.18, -2.18),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: RoundButton(
                      title: 'Clear',
                      buttonColor: Colors.white,
                      textColor: Colors.grey,
                      onPress: () {
                        Navigator.pop(context);

                        // setState(() {
                        //   //  Vvesselid = _selectedVesselId;
                        //   // Ffrom_location_id = _selectedOperatingLocationId;
                        //   // fetch_voyage_assets(
                        //   //     _selectedVesselId, _selectedOperatingLocationId);

                        //   //     Navigator.pop(context, filterid);
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (
                        //         context,
                        //       ) {
                        //         // Return the widget that represents the screen you want to navigate to
                        //         return ArrivalAtQuaysidePage(
                        //           FromLocationid: _selectedOperatingLocationId,
                        //           Vesselid: _selectedVesselId,
                        //           CurrentLocation: widget.currentlocation,
                        //           ActiveLocationid: widget.ActiveLocationid,
                        //           // Status: widget.type,
                        //           // filter: filterid,
                        //         );
                        //   },
                        //   ),
                        //  );
                        // });
                      }),
                ),
                Container(
                  width: 108.w,
                  height: 40.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,

                        //  color: Color(0xFFA80303)
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x66AEAEC0),
                        blurRadius: 6.54,
                        offset: Offset(2.18, 2.18),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0xFFFFFFFF),
                        blurRadius: 6.54,
                        offset: Offset(-2.18, -2.18),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: RoundButton(
                      title: 'Done',
                      buttonColor: Color(0xFFA80303),
                      onPress: () {
                        print('_selectedVesselId');
                        print(_selectedVesselId);
                        setState(() {
                          //  Vvesselid = _selectedVesselId;
                          // Ffrom_location_id = _selectedOperatingLocationId;
                          // fetch_voyage_assets(
                          //   _selectedVesselId,
                          //   _selectedOperatingLocationId,
                          // );

                          //     Navigator.pop(context, filterid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) {
                                // Return the widget that represents the screen you want to navigate to
                                return ArrivalAtQuaysidePage(
                                  FromLocationid: _selectedOperatingLocationId,
                                  Vesselid: _selectedVesselId,
                                  CurrentLocation: widget.currentlocation,
                                  ActiveLocationid: widget.ActiveLocationid,
                                  // Status: widget.type,
                                  // filter: filterid,
                                );
                              },
                            ),
                          );
                        });
                      }),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
