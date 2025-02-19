// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/error_dailog.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Repository/Container_Repository/create_container_repository.dart';
import 'package:asset_tracking/Repository/Assets_Controller.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/main.dart';
import 'ContainerContam/Container_ContamDetails.dart';
import 'Add_Container.dart';

class TransportContainerPage extends StatefulWidget {
  const TransportContainerPage({super.key});

  @override
  State<TransportContainerPage> createState() => _TransportContainerPageState();
}

class _TransportContainerPageState extends State<TransportContainerPage> {
  bool isNoContainerSelected = false;
  bool isNonContaminated = false; // Declare the variable here
  // TextEditingController rf_id = new TextEditingController();
  TextEditingController search_rf_id = new TextEditingController();
  String? selectedContainerType;
  List<Asset> selectedId = [];
  late Asset container;
  String containerType = '';
  String containerSerialNo = '';
  String containerId = '';
  String container_classification = '';
  String id = '';
  String error = '';
  int count = 0;
  bool isChecked = false;
  int _selectedItemIndex = -1;
  bool isCardSelected = false;
  bool shouldHideDropdowns = false;
  TextEditingController un_number = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController dose_rate = TextEditingController();
  String? _selectedADGClass;
  String? _selectedUN;
  String? _selectedClassCategory;
  bool isSelected = false;

  List<Asset> selectedAssets = [];
  List<Asset> displayedAssets = [];
  List<Asset> allAssets = [];

  Future<Asset> fetchAvailableContainer(String rfId) async {
    if (rfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        ['rf_id', '=', rfId],
        [
          'status',
          'IN',
          '("${AssetStatus.READY_TO_LOAD}","${AssetStatus.CONTAINER_RELEASED}","${AssetStatus.LOADED}")'
        ],
      ], {});

      if (data != null && data.length > 0) {
        final List<Asset> response =
            data.map((json) => Asset.fromJson(json)).toList();
        return response[0];
      } else {
        Utils.SnackBar('Error', 'Cannot Find Container with this RFID');
        throw Exception('Cannot Find Container with this RFID');
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  Future<void> fetchContainerType() async {
    final Asset response = await fetchAvailableContainer(rf_id.text);

    //try {
    setState(() {
      container = response;
      containerType = response.container_type.toString();
      containerSerialNo = response.container_serial_number.toString();
      containerId = response.container_type_id.toString();
      id = response.asset_id.toString();
      container_classification = response.classification.toString();
      error = '';
      // Reset error message if it was previously set
    });

    // } catch (e) {
    //   // Handle the error, set error message
    //   setState(() {
    //     containerType = '';
    //     error = 'Failed to load data';
    //   });
    // }
  }

  // List<String> extractValues(List<Map<String, String>> selectedIds) {
  //   List<String> values = [];
  //   for (var item in selectedIds) {
  //     String value = 'id: ${item['id']},';
  //     values.add(value);
  //   }
  //   return values;
  // }

  bool isExpanded = false;
  Set<int> _selectedItemIndices = {};
  Asset selectedContainerData = new Asset();

  void filterAssets(String query) {
    if (query.isNotEmpty) {
      setState(() {
        displayedAssets = allAssets
            .where((asset) =>
                asset.rf_id!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        displayedAssets = allAssets;
      });
    }
  }

  void toggleSelection(Asset asset) {
    setState(() {
      if (selectedAssets.contains(asset)) {
        selectedAssets.remove(asset);
      } else {
        selectedAssets.add(asset);
      }
    });
  }

  void removeSelectedAsset(Asset asset) {
    setState(() {
      selectedAssets.remove(asset);
    });
  }
  // @overrides
  // void initState() {
  //   rf_id.clear();
  //   super.initState();
  // }

  @override
  void initState() {
    rf_id.clear();
    super.initState();

    fetchAssets(
      isNoContainerSelected,
      search_rf_id.text,
    ).then((assets) {
      setState(() {
        allAssets = assets!;
        displayedAssets = allAssets;
      });
    });
  }

  Future<void> updateAssets() async {
    print(isNoContainerSelected);
    final assets = await fetchAssets(isNoContainerSelected, search_rf_id.text);
    setState(() {
      allAssets = assets!;
      displayedAssets = allAssets;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Container ClASSIFICATION' + container_classification);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          isNoContainerSelected
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      print(isNonContaminated);
                      if (count == 0) {
                        ErrorDialog.showError(
                            context, 'Error', 'Please Select Item ....');
                      } else if ((selectedContainerData.classification ==
                                  Classification.CONTAMINATED ||
                              selectedContainerData.classification ==
                                  Classification.HAZARDOUS) &&
                          (_selectedADGClass == null)) {
                        ErrorDialog.showError(
                            context, 'Error', 'Please Select  ADG Class....');
                      } else if ((selectedContainerData.classification ==
                                  Classification.CONTAMINATED ||
                              selectedContainerData.classification ==
                                  Classification.HAZARDOUS) &&
                          (_selectedADGClass == '7' &&
                              (_selectedUN == null ||
                                  _selectedClassCategory == null ||
                                  dose_rate.text.isEmpty))) {
                        ErrorDialog.showError(
                            context, 'Error', 'Please fill  All Field ....');
                      } else if (selectedContainerData.classification ==
                              Classification.NON_CONTAMINATED &&
                          !isNonContaminated) {
                        if (_selectedADGClass == null) {
                          ErrorDialog.showError(context, 'Error',
                              'Please Select  ADG Class ....');
                        } else if ((_selectedADGClass == '7' &&
                            (_selectedUN == null ||
                                _selectedClassCategory == null ||
                                dose_rate.text.isEmpty))) {
                          ErrorDialog.showError(
                              context, 'Error', 'Please fill  All Field ....');
                        } else {
                          LoadingScreen.showLoading(context);
                          loadNoContainer([selectedContainerData])
                              .whenComplete(() async {
                            AssetScreening screening = AssetScreening(
                              screening_type: ScreeningType.INITIAL_SCREENING,
                              asset_id: selectedContainerData.asset_id,
                              adg_class: selectedContainerData.adg_class,
                              un_number: selectedContainerData.un_number,
                              dose_rate: selectedContainerData.dose_rate,
                              class_7_category:
                                  selectedContainerData.class_7_category,
                              is_sync: 0,
                            );

                            await DatabaseHelper.instance
                                .updateAssetScreening(screening);
                          });
                        }
                      } else {
                        LoadingScreen.showLoading(context);
                        loadNoContainer([selectedContainerData])
                            .whenComplete(() async {
                          AssetScreening screening = AssetScreening(
                            screening_type: ScreeningType.INITIAL_SCREENING,
                            asset_id: selectedContainerData.asset_id,
                            adg_class: selectedContainerData.adg_class,
                            un_number: selectedContainerData.un_number,
                            dose_rate: selectedContainerData.dose_rate,
                            class_7_category:
                                selectedContainerData.class_7_category,
                            is_sync: 0,
                          );

                          await DatabaseHelper.instance
                              .updateAssetScreening(screening);
                        });
                      }
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFFA80303),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      if (selectedAssets.length == 0 || rf_id.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: selectedAssets.length == 0
                                  ? Text('Please Select Asset ....')
                                  : Text('Please Select Container  ....'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        // AwesomeDialog(
                        //   context: context,
                        //   dialogType: DialogType.error,
                        //   headerAnimationLoop: false,
                        //   animType: AnimType.bottomSlide,
                        //   title: 'ERROR',
                        //   desc: 'Please Select Atleast One  Asset',
                        //   buttonsTextStyle:
                        //       const TextStyle(color: Colors.black),
                        //   showCloseIcon: true,
                        //   btnCancelOnPress: () {},
                        //   btnOkOnPress: () {},
                        // ).show();
                      } else {
                        LoadingScreen.showLoading(context);

                        Get.to(ContainerContamDetails(
                          BundelCount: count,
                          ContainerRFID: rf_id.text,
                          ContainerSerialNum: containerSerialNo,
                          ContainerType: containerType.toString(),
                          ContainerTypeId: containerId,
                          ContainerClassification: container_classification,
                          NoContainerFlag: isNoContainerSelected,
                          items: selectedAssets,
                          container: container,
                          id: id,
                        ));
                      }

                      // it will navigate to  Container Contam Details
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Color(0xFFA80303),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      // here comes the  body of this page
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transport Container',
                      style: GoogleFonts.mulish(
                        color: Color(0xFF262626),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.44,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InkWell(
                        //   onTap: () {
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
                        //                   width: 2,
                        //                   color: Colors.grey.shade300),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.symmetric(
                        //                   horizontal: 10),
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
                        //     decoration: ShapeDecoration(
                        //       color: Color(0xFFF9F9F9),
                        //       shape: OvalBorder(),
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

                        SizedBox(
                          width: 5.h,
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return SizedBox(
                                    height: 500.h, child: AddContainer());
                              },
                            );
                          },
                          child: Container(
                            width: 34.w,
                            height: 34.h,
                            decoration: ShapeDecoration(
                              color: Color(0xFFF9F9F9),
                              shape: OvalBorder(),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'images/svg/add.svg',
                                color: Color(0xFFA80303),
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),

                Container(
                  width: MediaQuery.sizeOf(context).width / .9,
                  height: 50,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextFormField(
                    controller: rf_id,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onEditingComplete: () {
                      // Call the API when the user finishes typing and presses done/return key
                      fetchContainerType();
                    },
                    decoration: InputDecoration(
                        hintText: 'Scan Container RFID',
                        suffixIcon: Container(
                          width: 91.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (rf_id.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    rf_id.clear();
                                  },
                                ),
                              InkWell(
                                onTap: () {
                                  if (rf_id.text.isNotEmpty) {
                                    fetchContainerType();
                                  } else {
                                    sendActionToNative("Pressed");
                                  }
                                },
                                child: Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFA80303),
                                    shape: BoxShape
                                        .circle, // Use BoxShape.circle for a circular shape
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'images/svg/scaner.svg',
                                      height: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        helperStyle: GoogleFonts.mulish(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8)),
                  ),
                ),

                // here comes the checkboxe for no container

                Row(
                  children: [
                    Checkbox(
                      value:
                          isNoContainerSelected, // Set the value based on the boolean variable
                      onChanged: (bool? value) {
                        setState(() {
                          isNoContainerSelected = value ?? false;
                          updateAssets();
                        });
                      },
                      activeColor:
                          Color(0xFFA80303), // Set the selection color here
                    ),
                    Text(
                      'No Container Required',
                      style: GoogleFonts.mulish(
                        color: Color(0xFFCCCCCC),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ],
                ),

                //
                Text(
                  'Container Description',
                  style: GoogleFonts.mulish(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.28,
                  ),
                ),
                SizedBox(height: 6.h),

                Container(
                  width: 350.w,
                  height: 48.h,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF4F5F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 179.w,
                        child: Text(
                          !isNoContainerSelected
                              ? error.isNotEmpty
                                  ? error
                                  : containerType
                              : 'No Container',
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),

                SizedBox(
                  height: 10,
                ),
                // here comes the
                Text(
                  'Load Container',
                  style: GoogleFonts.mulish(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.44,
                  ),
                ),

                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: 350.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('images/svg/searching.svg'),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: TextField(
                            controller: search_rf_id,
                            onChanged: (value) {
                              filterAssets(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: GoogleFonts.inter(
                                color: Color(0xFFCCCCCC),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 0,
                                letterSpacing: 0.48,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // SvgPicture.asset(
                        //     'images/svg/filter.svg'), // Assuming the filter icon is named 'filter.svg'
                      ],
                    ),
                  ),
                ),
                if (selectedAssets.isNotEmpty) ...[
                  SizedBox(height: 5),
                  Text(
                    'Selected Assets',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                  ),
                  SizedBox(height: 10),
                  buildSelectedAssetsList(),
                ],

                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'Available Assets to be Loaded',
                  style: GoogleFonts.mulish(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
                SizedBox(height: 10.h),
                if (!isNoContainerSelected)
                  Text(
                    'Selected: ${selectedAssets.length}',
                    style: GoogleFonts.inter(
                      color: Color(0xFFCCCCCC),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.56,
                    ),
                  ),
                SizedBox(
                  height: 10.h,
                ),

                FutureBuilder<List<Asset>?>(
                  future: fetchAssets(
                    isNoContainerSelected,
                    search_rf_id.text,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // print('${snapshot.error}');
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Text('No Assets found.');
                    } else {
                      return Container(
                        height: selectedAssets.isNotEmpty ? 295.h : 365.h,
                        child: ListView.builder(
                          itemCount: displayedAssets.length,
                          itemBuilder: (context, index) {
                            isChecked = _selectedItemIndex == index;
                            final record = displayedAssets[index];
                            final isSelected = selectedAssets.contains(record);
                            record.description =
                                commentController.text.toString();
                            return isNoContainerSelected
                                ? Card(
                                    child: Container(
                                      width: 345.w,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5, top: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 80.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 5,
                                                    decoration: BoxDecoration(
                                                      color: record
                                                                  .classification ==
                                                              Classification
                                                                  .CONTAMINATED
                                                          ? Color(0xFFFF0000)
                                                          : record.classification ==
                                                                  Classification
                                                                      .HAZARDOUS
                                                              ? Colors.orange
                                                              : Colors.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                      ),
                                                    ),
                                                  ),
                                                  // Checkbox(
                                                  //   value: _selectedItemIndices
                                                  //       .contains(index),
                                                  //   activeColor:
                                                  //       Color(0xFFA80303),
                                                  //   onChanged: (bool? value) {
                                                  //     setState(() {
                                                  //       // if (value != null && value) {
                                                  //       isChecked =
                                                  //           value ?? false;
                                                  //       _selectedItemIndices
                                                  //           .add(index);
                                                  //       _selectedItemIndex =
                                                  //           index;

                                                  //       if (isChecked) {
                                                  //         count++;

                                                  //         record.adg_class =
                                                  //             _selectedADGClass;
                                                  //         record.un_number =
                                                  //             un_number.text;
                                                  //         record.dose_rate =
                                                  //             double.tryParse(
                                                  //                 dose_rate
                                                  //                     .text);
                                                  //         record.class_7_category =
                                                  //             _selectedClassCategory;
                                                  //         selectedContainerData
                                                  //             .add(record);
                                                  //       } else {
                                                  //         count--;
                                                  //         selectedContainerData
                                                  //             .removeWhere((data) =>
                                                  //                 data.rf_id ==
                                                  //                 record.rf_id);
                                                  //         _selectedItemIndices
                                                  //             .remove(index);
                                                  //       }
                                                  //     });
                                                  //   },
                                                  // ),
                                                  Radio(
                                                    value: index,
                                                    activeColor:
                                                        Color(0xFFA80303),
                                                    groupValue:
                                                        _selectedItemIndex,
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        // if (value != null && value) {
                                                        isChecked = true;
                                                        _selectedItemIndex =
                                                            value!;
                                                        _selectedItemIndices
                                                            .add(index);
                                                        _selectedItemIndex =
                                                            index;

                                                        if (isChecked) {
                                                          count = 1;

                                                          selectedContainerData =
                                                              record;
                                                        }
                                                        // else {
                                                        //   count--;
                                                        //   selectedContainerData
                                                        //       .removeWhere((data) =>
                                                        //           data.rf_id ==
                                                        //           record.rf_id);
                                                        //   _selectedItemIndices
                                                        //       .remove(index);
                                                        // }
                                                      });
                                                    },
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 200.w,
                                                            child: Text(
                                                              record.product_no ==
                                                                      null
                                                                  ? ''
                                                                  : 'TFMC ID# ${record.product_no}',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 0,
                                                                letterSpacing:
                                                                    0.36,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 82.w,
                                                            child: Text(
                                                              record.pulling_line ==
                                                                      null
                                                                  ? ''
                                                                  : 'Location:${record.pulling_line}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height: 0,
                                                                letterSpacing:
                                                                    0.36,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 170.w,
                                                            child: Text(
                                                              record.asset_type
                                                                          .toString() ==
                                                                      'Container'
                                                                  ? record
                                                                      .container_type
                                                                      .toString()
                                                                  : record
                                                                      .asset_type
                                                                      .toString(),
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height: 0,
                                                                letterSpacing:
                                                                    0.64,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 112.w,
                                                            child: Text(
                                                              record.dimensions ==
                                                                      null
                                                                  ? ''
                                                                  : 'Dimension -${record.dimensions}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height: 0,
                                                                letterSpacing:
                                                                    0.36,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 250.w,
                                                        // color: Colors.red,
                                                        child: Text(
                                                          'RFID: ${record.rf_id ?? ''}',
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 0,
                                                            letterSpacing: 0.36,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (isChecked)
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                        value:
                                                            isNonContaminated, // Set the value based on the boolean variable
                                                        onChanged: record
                                                                        .classification ==
                                                                    Classification
                                                                        .CONTAMINATED ||
                                                                record.classification ==
                                                                    Classification
                                                                        .HAZARDOUS
                                                            ? null
                                                            : (bool? value) {
                                                                setState(() {
                                                                  selectedContainerData
                                                                          .adg_class =
                                                                      null;
                                                                  selectedContainerData
                                                                          .un_number =
                                                                      null;
                                                                  selectedContainerData
                                                                          .dose_rate =
                                                                      null;
                                                                  selectedContainerData
                                                                          .class_7_category =
                                                                      null;
                                                                  dose_rate
                                                                      .clear();
                                                                  _selectedADGClass =
                                                                      null;
                                                                  _selectedClassCategory =
                                                                      null;
                                                                  _selectedUN =
                                                                      null;

                                                                  isNonContaminated =
                                                                      value ??
                                                                          false;
                                                                });
                                                              },
                                                        activeColor:
                                                            Color(0xFFA80303),
                                                        tristate: false,
                                                        visualDensity:
                                                            VisualDensity
                                                                .standard,
                                                      ),
                                                      Text(
                                                        'Non Contaminated',
                                                        style:
                                                            GoogleFonts.mulish(
                                                          color:
                                                              Color(0xFFCCCCCC),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                          letterSpacing: -0.28,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  isNonContaminated == true
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15.0,
                                                                  right: 20,
                                                                  top: 0,
                                                                  bottom: 0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'ADG Class',
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              Color(0xFF262626),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          height:
                                                                              0,
                                                                          letterSpacing:
                                                                              -0.28,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 12),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.grey[200],
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child: DropdownButton<
                                                                            String>(
                                                                          isExpanded:
                                                                              true,
                                                                          value:
                                                                              _selectedADGClass,
                                                                          underline:
                                                                              SizedBox(),
                                                                          items:
                                                                              <String>[
                                                                            '7',
                                                                            '9'
                                                                          ].map((String valueAGD) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: valueAGD,
                                                                              child: Text(
                                                                                valueAGD,
                                                                                textAlign: TextAlign.left,
                                                                                style: GoogleFonts.poppins(
                                                                                  color: Color(0xFF23262F),
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  height: 0,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }).toList(),

                                                                          onChanged:
                                                                              (String? newValue) {
                                                                            setState(() {
                                                                              _selectedADGClass = newValue;

                                                                              selectedContainerData.adg_class = newValue;
                                                                              if (_selectedADGClass == '9') {
                                                                                setState(() {
                                                                                  _selectedUN = null;
                                                                                  selectedContainerData.un_number = '3369';
                                                                                  selectedContainerData.class_7_category = null;
                                                                                  selectedContainerData.dose_rate = null;
                                                                                  _selectedClassCategory = null;
                                                                                  dose_rate.clear();
                                                                                });
                                                                              }
                                                                              shouldHideDropdowns = newValue == '9';
                                                                            });
                                                                          },

                                                                          // onChanged: (String? newValue) {
                                                                          //   setState(() {
                                                                          //     _selectedADGClass = newValue;
                                                                          //     shouldHideDropdowns =
                                                                          //         newValue == '9';
                                                                          //   });
                                                                          // },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'UN#',
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              Color(0xFF262626),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          height:
                                                                              0,
                                                                          letterSpacing:
                                                                              -0.28,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      _selectedADGClass ==
                                                                              '9'
                                                                          ? Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 12),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey[200],
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              child: TextFormField(
                                                                                controller: TextEditingController(text: '3369'),
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedContainerData.un_number = '3369';
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  border: InputBorder.none,
                                                                                  hintText: '',
                                                                                  hintStyle: GoogleFonts.inter(
                                                                                    color: Color(0xFFB9B9B9),
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    height: 0,
                                                                                    letterSpacing: 0.40,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 12),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey[200],
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              child: DropdownButton<String>(
                                                                                isExpanded: true,
                                                                                value: _selectedUN,
                                                                                underline: SizedBox(),
                                                                                items: <String>[
                                                                                  '2910',
                                                                                  '2911',
                                                                                  '2912',
                                                                                  '2913',
                                                                                  '3326',
                                                                                ].map((String valueUN) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: valueUN,
                                                                                    child: Text(
                                                                                      valueUN,
                                                                                      textAlign: TextAlign.left,
                                                                                      style: GoogleFonts.poppins(
                                                                                        color: Color(0xFF23262F),
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        height: 0,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }).toList(),

                                                                                onChanged: (String? newValue) {
                                                                                  setState(() {
                                                                                    _selectedUN = newValue;

                                                                                    selectedContainerData.un_number = _selectedUN;
                                                                                  });
                                                                                },

                                                                                // onChanged: (String? newValue) {
                                                                                //   setState(() {
                                                                                //     _selectedADGClass = newValue;
                                                                                //     shouldHideDropdowns =
                                                                                //         newValue == '9';
                                                                                //   });
                                                                                // },
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  isNonContaminated == true
                                                      ? SizedBox()
                                                      : shouldHideDropdowns
                                                          ? SizedBox()
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          15.0,
                                                                      right: 20,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Dose Rate',
                                                                            style:
                                                                                GoogleFonts.mulish(
                                                                              color: Color(0xFF262626),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w700,
                                                                              height: 0,
                                                                              letterSpacing: -0.28,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 8.0),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 12),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.grey[200],
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            child:
                                                                                TextFormField(
                                                                              controller: dose_rate,

                                                                              onChanged: (value) {
                                                                                // Update the last added object in the list with the completed data

                                                                                selectedContainerData.dose_rate = double.tryParse(value);
                                                                              },

                                                                              // onEditingComplete: () {
                                                                              //   // Update the last added object in the list with the completed data
                                                                              //   if (isChecked &&
                                                                              //       selectedContainerData
                                                                              //           .isNotEmpty) {
                                                                              //     selectedContainerData
                                                                              //         .last.doseRate = dose_rate.text;
                                                                              //   }
                                                                              // },
                                                                              decoration: InputDecoration(
                                                                                border: InputBorder.none,
                                                                                suffix: Text('µSv/h'),
                                                                                suffixStyle: GoogleFonts.inter(
                                                                                  color: Color(0xFFCCCCCC),
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  height: 0,
                                                                                  letterSpacing: -0.24,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  shouldHideDropdowns
                                                                      ? SizedBox()
                                                                      : Expanded(
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'Class 7 Category',
                                                                                  style: GoogleFonts.mulish(
                                                                                    color: Color(0xFF262626),
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    height: 0,
                                                                                    letterSpacing: -0.28,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 8.0),
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.grey[200],
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  child: DropdownButton<String>(
                                                                                    isExpanded: true,
                                                                                    value: _selectedClassCategory,
                                                                                    underline: SizedBox(),
                                                                                    items: <String>[
                                                                                      'Excepted',
                                                                                      'I - White',
                                                                                      'II - Yellow',
                                                                                      'III - Yellow',
                                                                                    ].map((String valueClassCat) {
                                                                                      return DropdownMenuItem<String>(
                                                                                        value: valueClassCat,
                                                                                        child: Text(
                                                                                          valueClassCat,
                                                                                          textAlign: TextAlign.left,
                                                                                          style: GoogleFonts.poppins(
                                                                                            color: Color(0xFF23262F),
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.w400,
                                                                                            height: 0,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }).toList(),
                                                                                    onChanged: (String? newValue) {
                                                                                      setState(() {
                                                                                        _selectedClassCategory = newValue;

                                                                                        selectedContainerData.class_7_category = newValue ?? '';

                                                                                        shouldHideDropdowns = newValue == '9';
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : CustomInfoContainer(
                                    id: record.product_no == null
                                        ? ''
                                        : 'TFMC ID# ${record.product_no}', // Handle null value
                                    title: record.asset_type.toString() ==
                                            'Container'
                                        ? record.container_type.toString()
                                        : record.asset_type.toString(),

                                    leftBorderColor: record.classification ==
                                            Classification.CONTAMINATED
                                        ? Color(0xFFFF0000)
                                        : record.classification ==
                                                Classification.HAZARDOUS
                                            ? Colors.orange
                                            : Colors.green,
                                    bundle: record.bundle_no == null
                                        ? ''
                                        : 'Bundle # ${record.bundle_no}',

                                    batch: record.asset_type == 'Batch'
                                        ? 'Rigid Pipe Batch# ${record.batch_no ?? ''}'
                                        : record.asset_type == 'Ancillary Batch'
                                            ? 'Ancillary Batch# ${record.batch_no ?? ''}'
                                            : 'RFID: ${record.rf_id ?? ''}',
                                    Check: Checkbox(
                                      // value:
                                      //     _selectedItemIndices.contains(index),
                                      activeColor: Color(0xFFA80303),

                                      value: isSelected,
                                      onChanged: (value) {
                                        toggleSelection(record);
                                      },
                                    ),

                                    Start_End: record.pulling_line == null
                                        ? ''
                                        : 'Start End:                                                           ${record.pulling_line}',
                                    Line_End: record.no_of_lengths == 0.0
                                        ? ''
                                        : 'Quantiy :                                                            ${record.no_of_lengths?.toInt()}',
                                    No_of_Joints: record.no_of_joints == 0.0
                                        ? ''
                                        : 'No.of Joints:                                                      ${record.no_of_joints?.toInt()}',
                                    Approx_Weight: record.approximate_weight ==
                                            0.0
                                        ? ''
                                        : 'Approx. Weight:                                                ${record.approximate_weight}',
                                    Approx_length: record.approximate_length ==
                                            0.0
                                        ? ''
                                        : 'Approx. Length                                                 ${record.approximate_length}',
                                    NoConatinerfalse: isNoContainerSelected,

                                    //Handle null value
                                    // Other fields...
                                  );
                          },
                        ),
                      );
                    }
                  },
                )
              ]),
        ),
      ),
    );
  }

  Widget buildSelectedAssetsList() {
    return Container(
      height: 35.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedAssets.length,
        itemBuilder: (context, index) {
          final asset = selectedAssets[index];

          return Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  asset.rf_id.toString(),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    removeSelectedAsset(asset);
                  },
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// components for transport containers
class CustomInfoContainer extends StatefulWidget {
  final String id;
  final String title;
  final Widget Check;
  final Color leftBorderColor;
  String? Start_End;
  String? Line_End;
  String? No_of_Joints;
  String? Approx_length;
  String? Approx_Weight;
  String? bundle;
  String? batch;
  bool? NoConatinerfalse;
  CustomInfoContainer({
    Key? key,
    required this.id,
    required this.title,
    required this.Check,
    required this.leftBorderColor,
    required this.Start_End,
    required this.Line_End,
    required this.No_of_Joints,
    required this.Approx_length,
    required this.Approx_Weight,
    this.NoConatinerfalse,
    required this.bundle,
    required this.batch,
  }) : super(key: key);

  @override
  _CustomInfoContainerState createState() => _CustomInfoContainerState();
}

class _CustomInfoContainerState extends State<CustomInfoContainer> {
  bool isSelected = false;
  var isChecked = false.obs;

  bool shouldHideDropdowns = false;

  // String? _selectedADGClass = '7';
  // String? _selectedClassCategory = 'Expected';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            child: Container(
              height: 109.h,
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
              child: Row(
                children: [
                  buildLeftContainer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widget.Check,
                          Container(
                            width: 200.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200.w,
                                  child: Text(
                                    '${widget.id}',
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.36,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 205.w,
                                  // color: Colors.red,
                                  child: Text(
                                    widget.title,
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                      letterSpacing: 0.64,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 220.w,
                                  child: Text(
                                    widget.batch.toString(),
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.36,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 88.w,
                                child: Text(
                                  widget.bundle.toString(),
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: 0.36,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              widget.NoConatinerfalse == false
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSelected = !isSelected;
                                            });
                                          },
                                          child: Text(
                                            'Details',
                                            style: GoogleFonts.mulish(
                                              color: Color(0xFFA80303),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                                  TextDecoration.underline,
                                              height: 1.0,
                                              letterSpacing: -0.20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            // curve: Curves.easeInOut,
            height: isSelected ? 60 : 0,
            child: isSelected
                ? buildExpanded()
                : SizedBox.shrink(), // Hides the content when not expanded
          ),
        ],
      ),
    );
  }

  Widget buildExpanded() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: SizedBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Details',
          //   style: GoogleFonts.mulish(
          //     color: Color(0xFF262626),
          //     fontSize: 14,
          //     fontWeight: FontWeight.w700,
          //     height: 0,
          //     letterSpacing: -0.28,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                width: 320.w,
                child: Text(
                  widget.Start_End.toString(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.48,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                width: 320.w,
                child: Text(
                  widget.Line_End.toString(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.48,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                width: 320.w,
                child: Text(
                  widget.No_of_Joints.toString(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.48,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                width: 320.w,
                child: Text(
                  widget.Approx_length.toString(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.48,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                width: 320.w,
                child: Text(
                  widget.Approx_Weight.toString(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    color: Color(0xFF262626),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.48,
                  ),
                )),
          )
        ],
      )),
    );
  }

  Widget buildLeftContainer() {
    return Container(
      width: 5.w,
      decoration: BoxDecoration(
        color: widget.leftBorderColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 125.w,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                color: Color(0xFF808080),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: 0.48,
              ),
            ),
          ),
          Container(
            width: 125.w,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: Color(0xFF262626),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
