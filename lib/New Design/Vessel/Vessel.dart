// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Vessel/Preview_Page/Preview_Page.dart';
import 'package:asset_tracking/Repository/CreateShipment_Repository/Voyages_Repository/fetch_voyage_containerList_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VesselsPages extends StatefulWidget {
  String? currentlocationid;
  String? currentID;
  VesselsPages({Key? key, this.currentlocationid, this.currentID});
  @override
  State<VesselsPages> createState() => _VesselsPagesState();
}

class _VesselsPagesState extends State<VesselsPages> {
  String? _selectedFullName;
  String? _selectedOperatingLocationId;
  List<Map<String, dynamic>> _locations = [];
  String? selectVessels;
  String? selectLocation;
  String? _selectedVesselName;
  String? _selectedVesselId;
  List<Map<String, dynamic>> _vessels = [];
  List<String> selectedIds = [];
  List<Asset>? selectedContainersList;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLocations();
    fetchVessel();
  }

//  For Fetch Location List Which We Move Vessel
  // Future<void> fetchLocations() async {
  //   final response =
  //       await DatabaseHelper.instance.queryList('operating_locations', [
  //     [
  //       'type',
  //       'IN',
  //       '("${LocationType.DECONTAM_YARD}", "${LocationType.DISPOSAL_YARD}")'
  //     ],
  //   ], {});

  //   setState(() {
  //     _locations = (response as List)
  //         .map((record) => {
  //               'operating_location_id': record['operating_location_id'],
  //               'full_name': record['name'] + ' ' + record['type'],
  //             })
  //         .toList();

  //     _locations.sort((a, b) => a['full_name'].compareTo(b['full_name']));

  //     if (_locations.isNotEmpty) {
  //       _selectedFullName = _locations[1]['full_name'].toString();
  //       _selectedOperatingLocationId =
  //           _locations[1]['operating_location_id'].toString();
  //     }
  //   });
  // }

  Future<void> fetchLocations() async {
    final response =
        await DatabaseHelper.instance.queryList('operating_locations', [
      [
        'type',
        'IN',
        '("${LocationType.DECONTAM_YARD}", "${LocationType.DISPOSAL_YARD}")'
      ],
    ], {});

    setState(() {
      // Map the response to the desired format and filter locations that start with "Onslow"
      _locations = (response as List)
          .map((record) => {
                'operating_location_id': record['operating_location_id'],
                'full_name': record['name'] + ' ' + record['type'],
              })
          .where((location) => location['full_name'].startsWith('Onslow'))
          .toList();

      // Sort the filtered locations by full_name
      _locations.sort((a, b) => a['full_name'].compareTo(b['full_name']));

      // Select the first location if available
      // if (_locations.isNotEmpty) {
      //   _selectedFullName = _locations[0]['full_name'].toString();
      //   _selectedOperatingLocationId =
      //       _locations[0]['operating_location_id'].toString();
      // }
    });
  }

//  For Fetch Vessel List
  Future<void> fetchVessel() async {
    final response = await DatabaseHelper.instance.queryAllRows('vessels');

    setState(() {
      _vessels = (response as List)
          .map((record) => {
                'name': record['name'],
                'id': record['vessel_id'],
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedIds.length == 0) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please Select Item ....'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (_selectedOperatingLocationId == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please Select Destination ....'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (_selectedVesselId == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please Select Vessel ....'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (_selectedOperatingLocationId == 'GQGGSOA18I') {
                LoadingScreen.showLoading(context);

                bool allNonContaminated =
                    true; // Flag to check if all assets are non-contaminated

                for (int i = 0;
                    i < (selectedContainersList?.length ?? 0);
                    i++) {
                  final asset = selectedContainersList![i];

                  if (asset.classification != Classification.NON_CONTAMINATED) {
                    allNonContaminated = false;

                    // Show the dialog indicating the presence of contaminated assets
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'Only Non-Contaminated Assets Should Move To The Disposal Yard'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break; // Exit the loop if any asset is contaminated
                  }
                }

                if (allNonContaminated) {
                  Get.to(PreviewPage(
                    selectedContainers: selectedContainersList,
                    wheretolocationid: widget.currentID,
                    fromlocationid: _selectedOperatingLocationId,
                    Vesselid: _selectedVesselId,
                    selectedIds: selectedIds,
                    VesslsName: _selectedVesselName,
                    fromName: _selectedFullName,
                    CrunnetName: widget.currentlocationid,
                  ));
                }
              } else {
                Get.to(PreviewPage(
                  selectedContainers: selectedContainersList,
                  wheretolocationid: widget.currentID,
                  fromlocationid: _selectedOperatingLocationId,
                  Vesselid: _selectedVesselId,
                  selectedIds: selectedIds,
                  VesslsName: _selectedVesselName,
                  fromName: _selectedFullName,
                  CrunnetName: widget.currentlocationid,
                ));
              }
            },
            child: Text(
              'Preview',
              style: GoogleFonts.mulish(
                color: Color(0xFFA80303),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vessel',
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.48,
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // Add your functionality here

                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           backgroundColor: Colors.white,
                  //           surfaceTintColor: Colors.white,
                  //           title: Text('Comment'),
                  //           content: Container(
                  //             width: 700.w,
                  //             height: 150.h,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: Colors.white,
                  //               border: Border.all(
                  //                   width: 2, color: Colors.grey.shade300),
                  //             ),
                  //             child: Padding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(horizontal: 10),
                  //               child: TextField(
                  //                 maxLines: 1000,
                  //                 controller: commentController,
                  //                 decoration: InputDecoration(
                  //                   hintText: 'Write a note...',
                  //                   hintStyle: GoogleFonts.inter(
                  //                     color: Color(0xFFCCCCCC),
                  //                     fontSize: 12,
                  //                     fontWeight: FontWeight.w400,
                  //                     height: 0,
                  //                   ),
                  //                   border: InputBorder.none,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           actions: <Widget>[
                  //             TextButton(
                  //               child: Text('OK'),
                  //               onPressed: () {
                  //                 Navigator.of(context)
                  //                     .pop(); // Close the dialog
                  //               },
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Container(
                  //     width: 34.w,
                  //     height: 34.h,
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFFF9F9F9),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Center(
                  //       child: SvgPicture.asset(
                  //         'images/svg/text.svg',
                  //         width: 20.w,
                  //         height: 20.h,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Select Vessel',
                style: GoogleFonts.mulish(
                  color: Color(0xFF262626),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.28,
                ),
              ),
              SizedBox(
                height: 6.h,
              ),

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
                        border:
                            InputBorder.none, // Removes the underline border
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

              SizedBox(
                height: 15.h,
              ),
              // here will be ves
              Container(
                width: 350.w,
                height: 42.h,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border:
                //    Border(
                //     bottom: BorderSide(width: 1, color: Color(0xFFCCCCCC)),
                //   ),
                // ),

                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset('images/svg/location2.svg'),
                      Text(
                        '${widget.currentlocationid}',
                        style: GoogleFonts.mulish(
                          color: Color(0xFF262626),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Select Destination Port',
                style: GoogleFonts.mulish(
                  color: Color(0xFF262626),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.28,
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Container(
                width: 350.w,
                height: 42.h,

                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // BoxDecoration(
                //   color: Colors.white,
                //   border: Border(
                //     bottom: BorderSide(width: 1, color: Color(0xFFCCCCCC)),

                //   ),
                // ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 180.w,
                    height: 48.h,
                    child: DropdownButtonFormField<String>(
                      // hint: Text('Select Location'),
                      decoration: InputDecoration(
                        // Set decoration to null or customize it as needed
                        border:
                            InputBorder.none, // Removes the underline border
                        contentPadding: EdgeInsets.only(
                            // horizontal: 10,
                            bottom: 5), // Optional: Adjust content padding
                      ),
                      value: _selectedFullName,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFullName = newValue!;
                          _selectedOperatingLocationId = _locations.firstWhere(
                              (location) =>
                                  location['full_name'] ==
                                  newValue)['operating_location_id'] as String;
                        });
                      },
                      items: _locations
                          .map((location) => DropdownMenuItem<String>(
                                child: Text(location['full_name']),
                                value: location['full_name'] as String,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              // here comes the cards containers
              Text(
                'Select Assets / Containers',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 0,
                  letterSpacing: -0.32,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              FutureBuilder<List<Asset>>(
                future: fetchvogeContainers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No containers available');
                  } else {
                    return Column(
                      children: snapshot.data!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final container = entry.value;
                        // Call the first function
                        return FutureBuilder<List<Asset>?>(
                          future: fetchAssetItemInVessel(container),
                          builder: (context, itemSnapshot) {
                            if (itemSnapshot.hasError) {
                              return Text('Error: ${itemSnapshot.error}');
                            } else {
                              final index = entry.key;
                              var items = itemSnapshot.data;
                              List<String>? productNos;
                              List<String>? productName;
                              List<String>? bundle;
                              List<String>? batch;
                              List<String>? drum_no;

                              if (items != null && items.length > 0) {
                                productNos = items
                                    .where((obj) => obj.product_no != null)
                                    .map((obj) => obj.product_no!)
                                    .toList();

                                productName = items
                                    .where((obj) => obj.product != null)
                                    .map((obj) => obj.product!)
                                    .toList();

                                bundle = items
                                    .where((obj) => obj.bundle_no != null)
                                    .map((obj) => obj.bundle_no.toString())
                                    .toList();

                                batch = items
                                    .where((obj) => obj.batch_no != null)
                                    .map((obj) => obj.batch_no.toString())
                                    .toList();

                                drum_no = items
                                    .where((obj) => obj.drum_no != null)
                                    .map((obj) => obj.drum_no.toString())
                                    .toList();
                              }
                              String getTFMCID() {
                                if (container.asset_type.toString() ==
                                    'Container') {
                                  var result;

                                  result = productNos != null &&
                                          productNos.length > 0
                                      ? 'TFMC ID ${productNos.map((item) => '$item').join('\n')}'
                                      : 'Drum # ${drum_no?.map((item) => '$item').join('\n')}';
                                  return result;
                                } else {
                                  return 'TFMC ID # ${container.product_no}';
                                }
                              }

                              String getbndle() {
                                if (container.asset_type.toString() ==
                                    'Container') {
                                  var result;

                                  result = bundle != null && bundle.length > 0
                                      ? '${bundle.map((item) => 'Bundle# $item').join('\n')}'
                                      : '';

                                  result += batch != null && batch.length > 0
                                      ? '\n${batch.map((item) => 'Batch # $item').join('\n')}'
                                      : '';

                                  return result;
                                } else {
                                  // If asset_type is not 'Container', you can customize the behavior here
                                  return '';
                                }
                              }

                              // String getTFMCID() {
                              //   if (container.asset_type.toString() ==
                              //       'Container') {
                              //     var result;

                              //     result = productNos != null &&
                              //             productNos.length > 0
                              //         ? 'TFMC ID ${productNos.map((item) => '$item').join('\n')}'
                              //         : 'Drum # ${drum_no?.map((item) => '$item').join('\n')}';
                              //     return result;
                              //   } else {
                              //     return 'TFMC ID # ${container.product_no}';
                              //   }
                              // }

                              // String getbndle() {
                              //   if (container.asset_type.toString() ==
                              //       'Container') {
                              //     var result;

                              //     result = bundle != null && bundle.length > 0
                              //         ? '${bundle.map((item) => 'Bundle# $item').join('\n')}'
                              //         : '';

                              //     result += batch != null && batch.length > 0
                              //         ? '\n${batch.map((item) => 'Batch # $item').join('\n')}'
                              //         : '';

                              //     //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                              //     return result;
                              //   } else {
                              //     return '';
                              //   }
                              // }

                              return Card(
                                color: Colors.white,
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x66AEAEC0),
                                        blurRadius: 3,
                                        offset: Offset(1.50, 1.50),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Color(0xFFFFFFFF),
                                        blurRadius: 3,
                                        offset: Offset(-3, 0),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: VesselsComponents(
                                    headerText1: 'RFID : ${container.rf_id}',
                                    headerText2: getTFMCID(),
                                    headerText3: container.asset_type
                                                .toString() ==
                                            'Container'
                                        ? container.container_type.toString()
                                        : container.asset_type.toString(),
                                    bundleNumber: '',
                                    // getbndle(),
                                    product: '${productName?.join('\n') ?? ''}',
                                    onCheckboxChanged: (isChecked) {
                                      setState(() {
                                        if (isChecked) {
                                          selectedIds
                                              .add(container.asset_id ?? "");
                                          selectedContainersList =
                                              snapshot.data!.where((container) {
                                            return selectedIds
                                                .contains(container.asset_id);
                                          }).toList();
                                        } else {
                                          selectedIds
                                              .remove(container.asset_id ?? "");
                                          selectedContainersList =
                                              snapshot.data!.where((container) {
                                            return selectedIds.contains(
                                                container.asset_id.toString());
                                          }).toList();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),

              //   FutureBuilder<List<Asset>>(
              //     future: fetchvogeContainers().whenComplete(() {

              //      var item = fetchAssetItemInVessel(container);

              //     }
              //     ),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasError) {
              //         return Text('Error: ${snapshot.error}');
              //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //         return Text('No containers available');
              //       } else {
              //         return Column(
              //           children: snapshot.data!.asMap().entries.map((entry) {
              //             final index = entry.key;
              //             final container = entry.value;
              //             var item = fetchAssetItemInVessel(container);
              //             return VesselsComponents(
              //               headerText1: 'RFID : ${container.rf_id}',
              //               headerText2: 'TFMID : ${item}',
              //               headerText3:
              //                   container.asset_type.toString() == 'Container'
              //                       ? container.container_type.toString()
              //                       : container.asset_type.toString(),
              //               bundleNumber: container.container_serial_number ==
              //                       null
              //                   ? ''
              //                   : 'Serial# ${container.container_serial_number}',
              //               // descriptions: [
              //               //   container.description,
              //               //   '',
              //               //   '',
              //               //   '',
              //               //   '',
              //               //   '',
              //               //   '',
              //               //   // 'Description 7',
              //               // ],
              //               onCheckboxChanged: (isChecked) {
              //                 setState(() {
              //                   if (isChecked) {
              //                     selectedIds.add(container.asset_id ?? "");
              //                     selectedContainersList =
              //                         snapshot.data!.where((container) {
              //                       return selectedIds
              //                           .contains(container.asset_id);
              //                     }).toList();
              //                   } else {
              //                     selectedIds.remove(container.asset_id ?? "");
              //                     selectedContainersList =
              //                         snapshot.data!.where((container) {
              //                       return selectedIds
              //                           .contains(container.asset_id.toString());
              //                     }).toList();
              //                   }
              //                 });
              //               },
              //             );
              //           }).toList(),
              //         );
              //       }
              //     },
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

// componenet for above details container

class VesselsComponents extends StatefulWidget {
  final String headerText1;
  final String headerText2;
  final String headerText3;
  final String product;
  final String bundleNumber;
  final List<String>? descriptions;
  final ValueChanged<bool> onCheckboxChanged;

  const VesselsComponents(
      {Key? key,
      required this.headerText1,
      required this.headerText2,
      required this.headerText3,
      required this.product,
      required this.bundleNumber,
      this.descriptions,
      required this.onCheckboxChanged})
      : super(key: key);

  @override
  _VesselsComponentsState createState() => _VesselsComponentsState();
}

class _VesselsComponentsState extends State<VesselsComponents> {
  bool isCheckBox = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      widget.headerText2,
                      style: GoogleFonts.inter(
                        color: Color(0xFFAEAEAE),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        height: 0,
                        letterSpacing: 0.32,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${widget.bundleNumber}',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    color: Color(0xFFB9B9B9),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ),
          // here goes the checkbox and container name
          Row(
            children: [
              Checkbox(
                value: isCheckBox,
                onChanged: (bool? value) {
                  setState(() {
                    isCheckBox = value ?? false;
                    widget.onCheckboxChanged(isCheckBox);
                  });
                },
                activeColor: Color(0xFFA80303),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.headerText3,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: 0.72,
                    ),
                  ),
                  Text(
                    widget.headerText1,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: widget.descriptions!
          //             .sublist(0, 3)
          //             .map((desc) => descriptionTextWithDot(desc))
          //             .toList(),
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: widget.descriptions
          //             .sublist(3, 6)
          //             .map((desc) => descriptionTextWithDot(desc))
          //             .toList(),
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           widget.descriptions.length >= 7
          //               ? Row(
          //                   children: [
          //                     CircleAvatar(
          //                       radius: 2.5,
          //                       backgroundColor: Color(0xFF808080),
          //                     ),
          //                     SizedBox(width: 5),
          //                     Text(
          //                       widget.descriptions[6],
          //                       style: GoogleFonts.inter(
          //                         color: Color(0xFF808080),
          //                         fontSize: 10,
          //                         fontWeight: FontWeight.w500,
          //                         height: 0,
          //                         letterSpacing: 0.40,
          //                       ),
          //                     ),
          //                   ],
          //                 )
          //               : SizedBox(),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Text(
              widget.product,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: 0.40,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget descriptionTextWithDot(String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 2.5,
          backgroundColor: Color(0xFF808080),
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.inter(
            color: Color(0xFF808080),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 0,
            letterSpacing: 0.40,
          ),
        ),
      ],
    );
  }
}
