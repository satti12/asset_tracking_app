///
import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// class StorageAllocation extends StatefulWidget {
//   List<Asset> selectedId = [];
//   StorageAllocation({required this.selectedId});
//   @override
//   _StorageAllocationState createState() => _StorageAllocationState();
// }

// class _StorageAllocationState extends State<StorageAllocation> {
//   late List<List<String>> matrix;
//   int? selectedRow;
//   int? selectedColumn;
//   String? SelectedRack;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the matrix with 2 rows and 6 columns
//     matrix = List.generate(2, (_) => List.generate(7, (_) => ''));
//     // Add N0 rack
//     matrix[0][0] = 'N0';
//     // Initialize other racks
//     for (int i = 1; i < 7; i++) {
//       matrix[0][i] = 'N$i';
//       matrix[1][i] = 'S$i';
//     }
//   }

//   void onBoxSelected(int row, int column) {
//     setState(() {
//       SelectedRack = matrix[row][column];
//       selectedRow = row;
//       selectedColumn = column;
//     });
//   }

//   void assignStorage() async {
//     for (final asset in widget.selectedId) {
//       asset.storage_area = StorageArea.YARD_STORAGE;
//       asset.storage_rack = SelectedRack.toString();
//       asset.status = AssetStatus.MOVED_TO_YARD_STORAGE;
//       print(widget.selectedId);
//       await DatabaseHelper.instance.update(
//         'asset_groups',
//         'asset_id',
//         asset.asset_id,
//         {'is_cleared': 1, 'is_sync': 0},
//       );

//       print(asset.toMap());

//       await DatabaseHelper.instance.updateAsset(asset);

//       AssetLog log = new AssetLog();
//       final userInfo =
//           await SharedPreferencesHelper.retrieveUserInfo('userInfo');
//       String eventType = EventType.MOVED_TO_YARD_STORAGE;
//       var template = eventDefinition[eventType].toString();
//       Map<String, String> variables = {
//         'asset_type': asset.asset_type.toString(),
//         'rf_id': asset.rf_id.toString(),
//         'rack': SelectedRack.toString(),
//         'current_location': userInfo['location_name'],
//         'user': userInfo['user_name'],
//         'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
//       };
//       var eventDesc = replaceVariables(template, variables);

//       log.asset_id = asset.asset_id.toString();
//       log.rf_id = asset.rf_id.toString();
//       log.event_type = eventType;
//       log.asset_type = asset.asset_type.toString();
//       log.current_transaction = jsonEncode(asset.toMap());
//       log.event_description = eventDesc;
//       log.status = asset.status.toString();
//       log.current_location_id = userInfo['locationId'];
//       DatabaseHelper.instance.createAssetLog(log);
//     }

//     Get.to(NewBottomNavigation());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.9,
//             height: 163,
//             decoration: ShapeDecoration(
//               shape: RoundedRectangleBorder(
//                 side: BorderSide(width: 1, color: Color(0xCCCCCCCC)),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   height: 20,
//                 ),
//                 // Row for column numbers (0 to 5)
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 //   children: List.generate(7, (index) {
//                 //     return Container(
//                 //       width: 35,
//                 //       height: 35,
//                 //       alignment: Alignment.center,
//                 //       child: Padding(
//                 //         padding: const EdgeInsets.only(left: 20, top: 10),
//                 //         child: Text(
//                 //           '${index == 0 ? '0' : index}',
//                 //           style: TextStyle(
//                 //               fontSize: 12,
//                 //               color: selectedColumn == index
//                 //                   ? Color(0xFFA80303)
//                 //                   : Colors.black),
//                 //         ),
//                 //       ),
//                 //     );
//                 //   }),
//                 // ),
//                 // // Matrix with row labels 'N' and 'S' and selectable boxes
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: 2,
//                     itemBuilder: (context, row) {
//                       return Row(
//                         children: <Widget>[
//                           // Row label 'N' or 'S'
//                           // Container(
//                           //   width: 25,
//                           //   height: 25,
//                           //   alignment: Alignment.center,
//                           //   child: Text(
//                           //     ['N', 'S'][row],
//                           //     style: TextStyle(
//                           //         fontSize: 12,
//                           //         color: selectedRow == row
//                           //             ? Color(0xFFA80303)
//                           //             : Colors.black),
//                           //   ),
//                           // ),
//                           // Boxes in the row
//                           SizedBox(
//                             height: 60,
//                           ),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: List.generate(7, (column) {
//                                 if (row == 1 && column == 0) {
//                                   return Container(
//                                       width: 45, height: 45); // Skip S0
//                                 }
//                                 return InkWell(
//                                   onTap: () {
//                                     onBoxSelected(row, column);
//                                   },
//                                   child: Container(
//                                     width: 45,
//                                     height: 45,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           width: 1, color: Color(0xFFA80303)),
//                                       color: (selectedRow == row &&
//                                               selectedColumn == column)
//                                           ? Color(0xFFA80303)
//                                           : Colors.white,
//                                       borderRadius: BorderRadius.circular(
//                                           10), // Add rounded corners
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       matrix[row][column],
//                                       style: TextStyle(
//                                           fontSize: 8,
//                                           color: (selectedRow == row &&
//                                                   selectedColumn == column)
//                                               ? Colors.white
//                                               : Colors.black),
//                                     ),
//                                   ),
//                                 );
//                               }),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 150,
//                   height: 48,
//                   decoration: ShapeDecoration(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(width: 1, color: Color(0xFFA80303)),
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     shadows: [
//                       BoxShadow(
//                         color: Color(0x66AEAEC0),
//                         blurRadius: 6.54,
//                         offset: Offset(2.18, 2.18),
//                         spreadRadius: 0,
//                       ),
//                       BoxShadow(
//                         color: Color(0xFFFFFFFF),
//                         blurRadius: 6.54,
//                         offset: Offset(-2.18, -2.18),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: RoundButton(
//                     onPress: () {
//                       Navigator.pop(context);
//                     },
//                     title: 'Cancel',
//                     buttonColor: Colors.white,
//                     textColor: Colors.black,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Container(
//                   width: 150,
//                   height: 48,
//                   decoration: ShapeDecoration(
//                     color: Color(0xFFA80303),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     shadows: [
//                       BoxShadow(
//                         color: Color(0xFFFFFFFF),
//                         blurRadius: 6.54,
//                         offset: Offset(-2.18, -2.18),
//                         spreadRadius: 0,
//                       ),
//                       BoxShadow(
//                         color: Color(0x66AEAEC0),
//                         blurRadius: 6.54,
//                         offset: Offset(2.18, 2.18),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: RoundButton(
//                     buttonColor: Color(0xFFA80303),
//                     onPress: () {
//                       assignStorage();
//                     },
//                     title: 'Store Asset',
//                     textColor: Colors.white,
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class StorageAllocation extends StatefulWidget {
  List<Asset> selectedId = [];
  StorageAllocation({required this.selectedId});
  @override
  _StorageAllocationState createState() => _StorageAllocationState();
}

class _StorageAllocationState extends State<StorageAllocation> {
  late List<List<String>> matrix;
  int? selectedRow;
  int? selectedColumn;
  String? SelectedRack;

  bool isAncillaryEquipment = false;

  @override
  void initState() {
    super.initState();
    // Check if the asset type is Ancillary Equipment
    isAncillaryEquipment = widget.selectedId.isNotEmpty &&
        widget.selectedId.first.asset_type == AssetType.ANCILLARY_EQUIPMENT;

    // Initialize the matrix based on asset type
    if (isAncillaryEquipment) {
      // Initialize matrix with only racks "N" and "S" for Ancillary Equipment
      matrix = List.generate(2, (_) => List.generate(7, (_) => ''));
      matrix[0][0] = 'N0';
      for (int i = 1; i < 7; i++) {
        matrix[0][i] = 'N$i';
        matrix[1][i] = 'S$i';
      }
    } else {
      // Initialize matrix with the default rack names for other asset types
      matrix = List.generate(2, (_) => List.generate(7, (_) => ''));
      matrix[0][0] = 'N0';
      for (int i = 1; i < 7; i++) {
        matrix[0][i] = 'N$i';
        matrix[1][i] = 'S$i';
      }
    }
  }

  void onBoxSelected(int row, int column) {
    setState(() {
      SelectedRack = matrix[row][column];
      selectedRow = row;
      selectedColumn = column;
    });
  }

  void assignStorage() async {
    for (final asset in widget.selectedId) {
      asset.storage_area = StorageArea.YARD_STORAGE;
      asset.storage_rack = SelectedRack.toString();
      asset.status = AssetStatus.MOVED_TO_YARD_STORAGE;

      print(widget.selectedId);

      await DatabaseHelper.instance.update(
        'asset_groups',
        'asset_id',
        asset.asset_id,
        {'is_cleared': 1, 'is_sync': 0},
      );

      print(asset.toMap());

      await DatabaseHelper.instance.updateAsset(asset);

      AssetLog log = new AssetLog();
      final userInfo =
          await SharedPreferencesHelper.retrieveUserInfo('userInfo');
      String eventType = EventType.MOVED_TO_YARD_STORAGE;
      var template = eventDefinition[eventType].toString();
      Map<String, String> variables = {
        'asset_type': asset.asset_type.toString(),
        'rf_id': asset.rf_id.toString(),
        'rack': SelectedRack.toString(),
        'current_location': userInfo['location_name'],
        'user': userInfo['user_name'],
        'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
      };
      var eventDesc = replaceVariables(template, variables);

      log.asset_id = asset.asset_id.toString();
      log.rf_id = asset.rf_id.toString();
      log.event_type = eventType;
      log.asset_type = asset.asset_type.toString();
      log.current_transaction = jsonEncode(asset.toMap());
      log.event_description = eventDesc;
      log.status = asset.status.toString();
      log.current_location_id = userInfo['locationId'];
      DatabaseHelper.instance.createAssetLog(log);
    }

    Get.to(NewBottomNavigation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: isAncillaryEquipment
                ? 200
                : 163, // Adjust height based on rack type
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xCCCCCCCC)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, row) {
                      return Row(
                        children: <Widget>[
                          SizedBox(height: 60),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(7, (column) {
                                if (row == 1 && column == 0) {
                                  return Container(
                                      width: 45, height: 45); // Skip S0
                                }
                                return InkWell(
                                  onTap: () {
                                    onBoxSelected(row, column);
                                  },
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0xFFA80303)),
                                      color: (selectedRow == row &&
                                              selectedColumn == column)
                                          ? Color(0xFFA80303)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      matrix[row][column],
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: (selectedRow == row &&
                                                selectedColumn == column)
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Conditionally show the third row for Ancillary Equipment
                if (isAncillaryEquipment)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              SelectedRack = 'Ancillary Equipment Area';
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 45,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(0xFFA80303)),
                              color: SelectedRack == 'Ancillary Equipment Area'
                                  ? Color(0xFFA80303)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Ancillary Equipment Area',
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    SelectedRack == 'Ancillary Equipment Area'
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFA80303)),
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
                    onPress: () {
                      Navigator.pop(context);
                    },
                    title: 'Cancel',
                    buttonColor: Colors.white,
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 150,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Color(0xFFA80303),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0xFFFFFFFF),
                        blurRadius: 6.54,
                        offset: Offset(-2.18, -2.18),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x66AEAEC0),
                        blurRadius: 6.54,
                        offset: Offset(2.18, 2.18),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: RoundButton(
                    buttonColor: Color(0xFFA80303),
                    onPress: () {
                      assignStorage();
                    },
                    title: 'Store Asset',
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
