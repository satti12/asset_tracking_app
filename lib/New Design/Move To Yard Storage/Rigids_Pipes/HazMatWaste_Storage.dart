// ignore_for_file: must_be_immutable

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

class HazmawasteStorage extends StatefulWidget {
  List<Asset> selectedId = [];
  HazmawasteStorage({super.key, required this.selectedId});

  @override
  State<HazmawasteStorage> createState() => _HazmawasteStorageState();
}

class _HazmawasteStorageState extends State<HazmawasteStorage> {
  late List<List<String>> matrix;
  int? selectedRow;
  int? selectedColumn;
  String? SelectedRack;

  void assignStorage() async {
    for (final asset in widget.selectedId) {
      asset.storage_area = StorageArea.YARD_STORAGE;
      asset.storage_rack = SelectedRack.toString();
      asset.status = AssetStatus.MOVED_TO_YARD_STORAGE;
      await DatabaseHelper.instance.update(
        'asset_groups',
        'asset_id',
        asset.asset_id,
        {'is_cleared': 1, 'is_sync': 0},
      );
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
  void initState() {
    super.initState();
    // Initialize the matrix with 2 rows and 5 columns
    matrix = List.generate(1, (_) => List.generate(3, (_) => ''));
  }

  void onBoxSelected(int row, int column) {
    setState(() {
      // Update the selected box value in the matrix
      matrix[row][column] = '${['C'][row]}$column';
      selectedRow = row; // Update the selected row index
      selectedColumn = column;

      // Update the selected column index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              width: 318,
              height: 163,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xCCCCCCCC)),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Column(
                children: <Widget>[
                  // Row for column numbers (1 to 5)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          child: Text(
                            'C${index + 1}',
                            style: TextStyle(
                                fontSize: 12,
                                color: selectedColumn == index
                                    ? Color(0xFFA80303)
                                    : Colors.black),
                          ),
                        ),
                      );
                    }),
                  ),
                  // Matrix with row labels 'N' and 'S' and selectable boxes
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, row) {
                        return Row(
                          children: <Widget>[
                            // Row label 'N' or 'S'
                            // Container(
                            //   width: 25,
                            //   height: 25,
                            //   alignment: Alignment.center,
                            //   child: Text(
                            //     ['C'][row],
                            //     style: TextStyle(
                            //         fontSize: 16,
                            //         color: selectedRow == row
                            //             ? Color(0xFFA80303)
                            //             : Colors.black),
                            //   ),
                            // ),
                            // Boxes in the row
                            SizedBox(
                              height: 50,
                            ),

                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(3, (column) {
                                  return InkWell(
                                    onTap: () {
                                      onBoxSelected(row, column);
                                      setState(() {
                                        SelectedRack = matrix[row][column];
                                      });
                                    },
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Color(0xFFA80303)),
                                        color: (selectedRow == row &&
                                                selectedColumn == column)
                                            ? Color(0xFFA80303)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            10), // Add rounded corners
                                      ),
                                      alignment: Alignment.center,
                                      // child: Text(
                                      //   matrix[row][column],
                                      //   style:
                                      //       TextStyle(fontSize: 8, color: Colors.black),
                                      // ),
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
                ],
              ),
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
                    // borderColor: Color(0xFFA80303),
                  ),
                ),
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
                    // buttonColor: Color(0xFFA80303),
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
