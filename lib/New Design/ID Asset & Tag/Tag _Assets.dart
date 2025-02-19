// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/error_dailog.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/Filter.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/Screen_Asset.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/New_Adding_Asset.dart';
import 'package:asset_tracking/Repository/CreateProcess_Repository/fetch_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/main.dart';

class Tag_Flexibles extends StatefulWidget {
  String? Status;
  String? IsBatch;
  String? filter;
  String? Location;

  Tag_Flexibles({
    super.key,
    this.Status,
    this.IsBatch,
    this.filter,
    this.Location,
  });
  @override
  State<Tag_Flexibles> createState() => _Tag_FlexiblesState();
}

class _Tag_FlexiblesState extends State<Tag_Flexibles> {
  bool isChecked = false;
  int selectedCardIndex = -1;
  //TextEditingController rf_id = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController Num_of_joint = TextEditingController();
  TextEditingController no_of_lengths = TextEditingController();
  TextEditingController approximate_length = TextEditingController();
  TextEditingController approximate_weight = TextEditingController();
  TextEditingController crane_weight = TextEditingController();
  TextEditingController dimensions = TextEditingController();
  TextEditingController weight_in_air = TextEditingController();
  String? Productid;
  bool setvalue = false;
  String? selectedPullingvalue;
  String? selectedPullingname;
  int _selectedItemIndex = -1;
  String? storedata;
  bool? selectedPullingEnd; // Default selected value for Contamination
  TextEditingController selectedPullingEndController = TextEditingController();
  TextEditingController quanity = TextEditingController();
  String? Flowline;
  String? Startend;
  String? LineEnd;
  String calculatedResult = '';
  String calculatedNewAirWeight = '';
  double totalAirWeight = 0.0;
  double CalculateAirWeight = 0.0;
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  double? weight_in_air_value;
  bool isButtonSelected = false;
  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.filter != null) {
          // Navigate back to the bottom screen if filter is not null
          //Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                context,
              ) {
                // Return the widget that represents the screen you want to navigate to
                return NewAssetsAdding(
                  CrunnetLocation: widget.Location,
                );
                //BottomNavigation();
              },
            ),
          );
          return false; // Prevent default back button behavior
        }
        return true; // Allow default back button behavior
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: widget.filter != null
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigate to the bottom navigation screen

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (
                          context,
                        ) {
                          // Return the widget that represents the screen you want to navigate to
                          return NewAssetsAdding(
                            CrunnetLocation: widget.Location,
                          );
                          //BottomNavigation();
                        },
                      ),
                    );
                  },
                )
              : null,
          actions: [
            GestureDetector(
              onTap: () {
                if ((widget.Status == 'Rigid Pipe' || widget.IsBatch == '1') &&
                    rf_id.text.isEmpty) {
                  if (_selectedItemIndex != -1) {
                    if (widget.Status == 'Rigid Pipe' &&
                        (no_of_lengths.text == '0' ||
                            no_of_lengths.text.isEmpty)) {
                      ErrorDialog.showError(
                          context, 'Error', 'Please Enter Valid No Of Length');
                    } else if ((widget.IsBatch == '1') &&
                        (quanity.text == '0' || quanity.text.isEmpty)) {
                      ErrorDialog.showError(
                          context, 'Error', 'Please Enter Valid No Of Qty');
                    } else {
                      LoadingScreen.showLoading(context);
                      Get.to(Screen_Assets(
                        tfmcText: storedata,
                        scText: Flowline,
                        rfid_value: rf_id.text,
                        startvalue: Startend,
                        lineEndvalue: LineEnd,
                        numOfJointsValue: Num_of_joint.text,
                        numOflength: no_of_lengths.text,
                        approxLengthValue: calculatedResult.toString(),
                        approxWeightValue: calculatedNewAirWeight.toString(),
                        carneWeightValue: crane_weight.text,
                        Status: widget.Status,
                        Productid: Productid,
                        puling_id: selectedPullingvalue,
                        puling_name: selectedPullingname,
                        dimensions: dimensions.text,
                        weight_in_air: weight_in_air.text,
                        CurrentLocation: widget.Location,
                        Quantity: quanity.text,
                        IsBatch: widget.IsBatch,
                      ));
                    }
                  } else {
                    ErrorDialog.showError(
                        context, 'Error', 'Please Select Asset');
                  }
                } else if (rf_id.text.isEmpty) {
                  // Show a dialog informing the user to enter the RFID first
                  ErrorDialog.showError(
                      context, 'Error', 'Please enter RFID first.');
                }

                if (rf_id.text.isNotEmpty) {
                  if (_selectedItemIndex != -1) {
                    if (widget.Status == 'Flexibles' &&
                        (Num_of_joint.text == '0' ||
                            Num_of_joint.text.isEmpty)) {
                      ErrorDialog.showError(
                          context, 'Error', 'Please Enter Valid No of Joint.');
                    } else {
                      LoadingScreen.showLoading(context);
                      Get.to(Screen_Assets(
                        tfmcText: storedata,
                        scText: Flowline,
                        rfid_value: rf_id.text,
                        startvalue: Startend,
                        lineEndvalue: LineEnd,
                        numOfJointsValue: Num_of_joint.text,
                        numOflength: no_of_lengths.text,
                        approxLengthValue: calculatedResult.toString(),
                        approxWeightValue: calculatedNewAirWeight.toString(),
                        carneWeightValue: crane_weight.text,
                        Status: widget.Status,
                        Productid: Productid,
                        puling_id: selectedPullingvalue,
                        puling_name: selectedPullingname,
                        dimensions: dimensions.text,
                        weight_in_air: weight_in_air.text,
                        CurrentLocation: widget.Location,
                        Quantity: quanity.text,
                        IsBatch: widget.IsBatch,
                      ));
                    }
                  } else {
                    ErrorDialog.showError(
                        context, 'Error', 'Please Select Asset');
                  }
                }
              },
              child: SizedBox(
                width: 100.w,
                height: 60.h,
                child: Center(
                  child: Text(
                    'Next',
                    style: GoogleFonts.mulish(
                      color: Color(0xFFA80303),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Tag - ${widget.Status}',
                        style: GoogleFonts.mulish(
                          color: Color(0xFF262626),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.44,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'images/svg/loca_icon.svg',
                        height: 20.h,
                        width: 20.w,
                        color: Color(0xFFA80303),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        widget.Location.toString(),
                        style: GoogleFonts.mulish(
                          color: Color(0xFF808080),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                // if (widget.Status == 'Rigid Pipe')
                widget.Status == 'Rigid Pipe' || widget.IsBatch == '1'
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / .9,
                          height: 50,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2, color: Color(0xFFF4F5F6)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: TextFormField(
                            controller: rf_id,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                hintText: 'Scan RFID',
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
                                          sendActionToNative("Pressed");
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
                      ),

                SizedBox(
                  height: 15.h,
                ),
                //Search Field And Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: 350.w,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: TextFormField(
                      controller: search,
                      onChanged: (value) {
                        setState(() {});
                      },
                      onTapOutside: (value) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return NewFilterCustomSnackbar(
                                    type: widget.Status.toString(),
                                    isbatch: widget.IsBatch.toString(),
                                    CurrentLocation: widget.Location,
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.filter_list),
                          ),
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Select Items for dispatch',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                //Extend Able Card  which load data from api
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 510.h,
                    child: FutureBuilder<List<Product>>(
                      future: fetchProductsList(widget.Status.toString(),
                          search.text, widget.filter, widget.IsBatch.toString()
                          // Pass the search term
                          // Pass the filter value (can be null if not selected)
                          ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.data!.isEmpty) {
                          return Text('No products found.');
                        } else {
                          final products = snapshot.data!;
                          // print('${widget.IsBatch}');
                          return ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              bool isSelected = _selectedItemIndex == index;
                              isButtonSelected == index;
                              return Card(
                                elevation: 3,
                                color: Colors.white,
                                // margin: EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    // print('CalculateAirWeight');
                                    // print(CalculateAirWeight);
                                    setState(() {
                                      _selectedItemIndex = index;
                                      storedata = product.product_no;
                                      Productid = '${product.product_id}';
                                      Flowline = '${product.product_name}';
                                      Startend = '${product.line_end_1_name}';
                                      LineEnd = '${product.line_end_2_name}';
                                      //
                                      dimensions.text =
                                          product.dimensions == null
                                              ? ''
                                              : product.dimensions.toString();
                                      weight_in_air.text =
                                          product.air_weight != null
                                              ? product.air_weight.toString()
                                              : '0';
                                      List<String> weightValues =
                                          product.air_weight?.split(' - ') ??
                                              [];

                                      // print("Weight Values: $weightValues");
                                      if (weightValues.length >= 1) {
                                        double lowerValue =
                                            double.tryParse(weightValues[0]) ??
                                                0.0;
                                        double upperValue =
                                            weightValues.length == 2
                                                ? (double.tryParse(
                                                        weightValues[1]) ??
                                                    0.0)
                                                : lowerValue;
                                        // print("Lower Value: $lowerValue");
                                        // print("Upper Value: $upperValue");
                                        double averageValue =
                                            (lowerValue + upperValue) / 2;
                                        CalculateAirWeight = averageValue;

                                        // print("Average Value: $averageValue");
                                      }

                                      // print(
                                      //     "CalculateAirWeight: $CalculateAirWeight");
                                      // print(
                                      //     "Original Air Weight: ${product.air_weight}");
                                    });
                                  },
                                  child: Container(
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: index,
                                                  activeColor:
                                                      Color(0xFFA80303),
                                                  groupValue:
                                                      _selectedItemIndex,
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      _selectedItemIndex =
                                                          value!;
                                                      storedata =
                                                          product.product_no;
                                                      Flowline =
                                                          '${product.product_name}';
                                                      Startend =
                                                          '${product.line_end_1_name}';
                                                      LineEnd =
                                                          '${product.line_end_2_name}';
                                                      Productid =
                                                          '${product.product_id}';
                                                      //
                                                      dimensions.text = product
                                                                  .dimensions ==
                                                              null
                                                          ? ''
                                                          : product.dimensions
                                                              .toString();

                                                      weight_in_air.text =
                                                          product.air_weight
                                                              .toString();
                                                      List<String>
                                                          weightValues =
                                                          (product.air_weight ??
                                                                  '')
                                                              .split(' - ');
                                                      if (weightValues
                                                          .isNotEmpty) {
                                                        double lowerValue =
                                                            double.tryParse(
                                                                    weightValues[
                                                                        0]) ??
                                                                0.0;
                                                        double upperValue = weightValues
                                                                    .length ==
                                                                2
                                                            ? (double.tryParse(
                                                                    weightValues[
                                                                        1]) ??
                                                                0.0)
                                                            : lowerValue;
//

                                                        // print(
                                                        //     "Weight Values: $weightValues");

                                                        // print(
                                                        //     "Lower Value: $lowerValue");
                                                        // print(
                                                        //     "Upper Value: $upperValue");

                                                        double averageValue =
                                                            (lowerValue +
                                                                    upperValue) /
                                                                2;
                                                        CalculateAirWeight =
                                                            averageValue;

                                                        // print(
                                                        //     "Average Value: $averageValue");
                                                      }

                                                      // print(
                                                      //     "CalculateAirWeight: $CalculateAirWeight");
                                                      // print(
                                                      //     "Original Air Weight: ${product.air_weight}");
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                          width: 140.w,
                                                          child: Text(
                                                            'TFMC ID# ${product.product_no}',
                                                            // textAlign: TextAlign.right,
                                                            style: GoogleFonts
                                                                .inter(
                                                              color: Color(
                                                                  0xFF808080),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              height: 0,
                                                              letterSpacing:
                                                                  0.40,
                                                            ),
                                                          )),
                                                      Container(
                                                        width: 125.w,
                                                        child: Text(
                                                          widget.Status ==
                                                                  'Flexibles'
                                                              ? 'Line Ends:${product.line_end_1_name}-${product.line_end_2_name}'
                                                              : 'Location :${product.line_end_1_name}',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style:
                                                              GoogleFonts.inter(
                                                            color: Color(
                                                                0xFF808080),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 0,
                                                            letterSpacing: 0.40,
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
                                            padding: const EdgeInsets.only(
                                                left: 40,
                                                right: 40,
                                                // top: 10,
                                                bottom: 20),
                                            //Radio Button in extandable card
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    width: 205.w,
                                                    child: Text(
                                                        product.product_name
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                          letterSpacing: 0.56,
                                                        ))),
                                                Icon(isSelected
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down)
                                              ],
                                            ),
                                          ),
                                          if (isSelected)
                                            Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(
                                                    height: 1,
                                                    color: Colors.black,
                                                  ),
                                                  widget.Status ==
                                                              'Subsea Structure' ||
                                                          widget.Status ==
                                                              'Ancillary Equipment'
                                                      ? Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                                right: 70,
                                                                top: 20,
                                                                bottom: 0,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Dimensions',
                                                                    style: GoogleFonts
                                                                        .mulish(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      height: 0,
                                                                      letterSpacing:
                                                                          -0.24,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Weight in Air',
                                                                    style: GoogleFonts
                                                                        .mulish(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      height: 0,
                                                                      letterSpacing:
                                                                          -0.24,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 25,
                                                                top: 10,
                                                                bottom: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <Widget>[
                                                                  Container(
                                                                    width:
                                                                        140.w,
                                                                    height:
                                                                        48.h,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      color: Color(
                                                                          0xFFFFFFFF),
                                                                      // Change the background color if needed
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.grey.shade200),
                                                                        // Change the border color and width
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          dimensions,

                                                                      // TextEditingController(text: dimensions.toString()),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                10.0,
                                                                            horizontal:
                                                                                8),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none, // Set to none if you want to remove the inner border
                                                                        ),
                                                                        // hintText:
                                                                        //     '15',
                                                                        hintStyle:
                                                                            GoogleFonts.poppins(
                                                                          color:
                                                                              Color(0xFF23262F),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          height:
                                                                              0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 125,
                                                                    height: 48,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      color: Color(
                                                                          0xFFFFFFFF),
                                                                      // Change the background color if needed
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.grey.shade200),
                                                                        // Change the border color and width
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          weight_in_air,
                                                                      enabled:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          borderSide:
                                                                              BorderSide.none, // Set to none if you want to remove the inner border
                                                                        ),
                                                                        // hintText:
                                                                        //     '11',
                                                                        hintStyle:
                                                                            GoogleFonts.poppins(
                                                                          color:
                                                                              Color(0xFF23262F),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          height:
                                                                              0,
                                                                        ),
                                                                        suffix:
                                                                            Text('MT'),
                                                                        suffixStyle:
                                                                            GoogleFonts.mulish(
                                                                          color:
                                                                              Color(0xFFCCCCCC),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              0,
                                                                          letterSpacing:
                                                                              -0.24,
                                                                        ),
                                                                        contentPadding:
                                                                            EdgeInsets.all(8),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            widget.IsBatch ==
                                                                    '0'
                                                                ? SizedBox()
                                                                : Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                20,
                                                                            vertical:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          'Quantity',
                                                                          style:
                                                                              GoogleFonts.mulish(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            height:
                                                                                0,
                                                                            letterSpacing:
                                                                                -0.24,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                10),
                                                                        child:
                                                                            Container(
                                                                          //width: 140.w,
                                                                          height:
                                                                              48.h,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            color:
                                                                                Color(0xFFFFFFFF), // Change the background color if needed
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 1, color: Colors.black45), // Change the border color and width
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              TextField(
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            controller:
                                                                                quanity,
                                                                            onChanged:
                                                                                (value) {
                                                                              var remaining = double.parse(product.quantity.toString()) - double.parse(product.used.toString());
                                                                              if (double.parse(quanity.text.toString()) > remaining) {
                                                                                ErrorDialog.showError(context, 'Warning', 'Only ${remaining.toInt()} Quantity left');
                                                                                quanity.clear();
                                                                              }
                                                                            },

                                                                            // TextEditingController(text: dimensions.toString()),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                borderSide: BorderSide.none, // Set to none if you want to remove the inner border
                                                                              ),
                                                                              // hintText:
                                                                              //     '15',

                                                                              hintStyle: GoogleFonts.poppins(
                                                                                color: Color(0xFF23262F),
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ],
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                  'Start End',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    height: 1.0,
                                                                    letterSpacing:
                                                                        -0.28,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 6.h,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      product.line_end_1_name ==
                                                                              null
                                                                          ? Container()
                                                                          : Radio(
                                                                              activeColor: Color(0xFFA80303),
                                                                              value: true,
                                                                              groupValue: selectedPullingEnd,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  selectedPullingEnd = value as bool;
                                                                                  selectedPullingvalue = product.line_end_1.toString();
                                                                                  selectedPullingname = product.line_end_1_name.toString();
                                                                                });
                                                                              },
                                                                            ),
                                                                      Text(
                                                                        (product.line_end_1_name ??
                                                                            ''.toString()),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  //   SizedBox(wi
                                                                  Row(
                                                                    children: [
                                                                      product.line_end_2_name ==
                                                                              null
                                                                          ? Container()
                                                                          : Radio(
                                                                              activeColor: Color(0xFFA80303),
                                                                              value: false,
                                                                              groupValue: selectedPullingEnd,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  selectedPullingEnd = value as bool;
                                                                                  selectedPullingvalue = product.line_end_2.toString();
                                                                                  selectedPullingname = product.line_end_2_name.toString();

                                                                                  if (!selectedPullingEnd!) {
                                                                                    // If False is selected, clear the intensity field
                                                                                    selectedPullingEndController.clear();
                                                                                  }
                                                                                });
                                                                              },
                                                                            ),
                                                                      Text(product
                                                                              .line_end_2_name ??
                                                                          ''.toString()),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    widget.Status ==
                                                                            'Rigid Pipe'
                                                                        ? Container(
                                                                            child:
                                                                                Text(
                                                                              'Lengths to be loaded',
                                                                              style: GoogleFonts.mulish(
                                                                                color: Colors.black,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w700,
                                                                                height: 0,
                                                                                letterSpacing: -0.24,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            child:
                                                                                Text(
                                                                              'No. of Joints in a bundle',
                                                                              style: GoogleFonts.mulish(
                                                                                color: Colors.black,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w700,
                                                                                height: 0,
                                                                                letterSpacing: -0.24,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    Container(
                                                                      width:
                                                                          120,
                                                                      child:
                                                                          Text(
                                                                        'Approx. Length',
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              Color(0xFFCCCCCC),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          height:
                                                                              0,
                                                                          letterSpacing:
                                                                              -0.24,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  widget.Status ==
                                                                          'Rigid Pipe'
                                                                      ? Container(
                                                                          width:
                                                                              124,
                                                                          height:
                                                                              48,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            color:
                                                                                Color(0xFFFFFFFF), // Change the background color if needed
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 2, color: Colors.grey.shade200), // Change the border color and width
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                285,
                                                                            height:
                                                                                48,
                                                                            child:
                                                                                TextField(
                                                                              controller: no_of_lengths,
                                                                              keyboardType: TextInputType.number,
                                                                              onChanged: (value) {
                                                                                // Calculate the result and update the state
                                                                                double result = double.tryParse(value) ?? 0.0; // Convert text to double or use 0.0 if parsing fails
                                                                                result *= 11.5; // Multiply by 11.5
                                                                                // Update the state with the calculated result
                                                                                setState(() {
                                                                                  // Update a variable to store the result for further use if needed
                                                                                  calculatedResult = result.toString();
                                                                                  totalAirWeight = double.tryParse(calculatedResult.toString()) ?? 0.0;

                                                                                  double newValue = (CalculateAirWeight * totalAirWeight) / 1000;
                                                                                  calculatedNewAirWeight = newValue
                                                                                      .
                                                                                      //toString();
                                                                                      toStringAsFixed(2);

                                                                                  double calculatedNewAirWeightInKg = double.tryParse(calculatedNewAirWeight) ?? 0.0;
                                                                                  double kgToTonConversionFactor = 1000;
                                                                                  double calculatedNewAirWeightInTons = calculatedNewAirWeightInKg / kgToTonConversionFactor;
                                                                                  //  print("Calculated New Air Weight in Tons: $calculatedNewAirWeightInTons");
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  borderSide: BorderSide.none, // Set to none if you want to remove the inner border
                                                                                ),
                                                                                // hintText: '15',
                                                                                hintStyle: GoogleFonts.poppins(
                                                                                  color: Color(0xFF23262F),
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  height: 0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          width:
                                                                              124,
                                                                          height:
                                                                              48,
                                                                          decoration:
                                                                              ShapeDecoration(
                                                                            color:
                                                                                Color(0xFFFFFFFF), // Change the background color if needed
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side: BorderSide(width: 1, color: Colors.black45), // Change the border color and width
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                285,
                                                                            height:
                                                                                48,
                                                                            child:
                                                                                TextField(
                                                                              controller: Num_of_joint,
                                                                              focusNode: _focusNode1,
                                                                              keyboardType: TextInputType.number,
                                                                              onSubmitted: (value) {
                                                                                FocusScope.of(context).requestFocus(_focusNode2);
                                                                              },
                                                                              onChanged: (value) {
                                                                                // Calculate the result and update the state
                                                                                double result = double.tryParse(value) ?? 0.0; // Convert text to double or use 0.0 if parsing fails
                                                                                result *= 11.5; // Multiply by 11.5
                                                                                // Update the state with the calculated result
                                                                                setState(() {
                                                                                  // Update a variable to store the result for further use if needed
                                                                                  calculatedResult = result.toString();

                                                                                  totalAirWeight = double.tryParse(calculatedResult.toString()) ?? 0.0;

                                                                                  double newValue = (CalculateAirWeight * totalAirWeight) / 1000;

                                                                                  //  print(calculatedNewAirWeight);
                                                                                  calculatedNewAirWeight = newValue
                                                                                      .
                                                                                      //toString();
                                                                                      toStringAsFixed(2);

                                                                                  // Store the result as a string

//
                                                                                  double calculatedNewAirWeightInKg = double.tryParse(calculatedNewAirWeight) ?? 0.0;

// Conversion factor from kilograms to tons (1000 kg in a ton)
                                                                                  double kgToTonConversionFactor = 1000;

// Convert calculatedNewAirWeight from kilograms to tons
                                                                                  double calculatedNewAirWeightInTons = calculatedNewAirWeightInKg / kgToTonConversionFactor;

// Now calculatedNewAirWeightInTons contains the weight in tons
                                                                                  //  print("Calculated New Air Weight in Tons: $calculatedNewAirWeightInTons");
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  borderSide: BorderSide.none, // Set to none if you want to remove the inner border
                                                                                ),
                                                                                // hintText: '15',
                                                                                hintStyle: GoogleFonts.poppins(
                                                                                  color: Color(0xFF23262F),
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  height: 0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  Container(
                                                                    width: 124,
                                                                    height: 48,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      color: Color(
                                                                          0xFFFFFFFF), // Change the background color if needed
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.grey.shade200), // Change the border color and width
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          285,
                                                                      height:
                                                                          48,
                                                                      child:
                                                                          TextField(
                                                                        readOnly:
                                                                            true, // Prevent user input
                                                                        controller:
                                                                            TextEditingController(text: calculatedResult),
                                                                        decoration:
                                                                            InputDecoration(
                                                                          contentPadding: EdgeInsets.only(
                                                                              bottom: 10,
                                                                              left: 10),
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            borderSide:
                                                                                BorderSide.none, // Set to none if you want to remove the inner border
                                                                          ),
                                                                          // hintText:
                                                                          //     '11.5',
                                                                          hintStyle:
                                                                              GoogleFonts.poppins(
                                                                            color:
                                                                                Color(0xFF23262F),
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                0,
                                                                          ),
                                                                          suffixIcon: Padding(
                                                                              padding: const EdgeInsets.only(top: 13, right: 10),
                                                                              child: Text(
                                                                                'm',
                                                                                textAlign: TextAlign.right,
                                                                                style: GoogleFonts.mulish(
                                                                                  color: Color(0xFFCCCCCC),
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  height: 0,
                                                                                  letterSpacing: -0.24,
                                                                                ),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            10),
                                                                child: Text(
                                                                  'Bundle Approx. Weight',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left, // Aligns the text to the left side
                                                                  style:
                                                                      GoogleFonts
                                                                          .mulish(
                                                                    color: Color(
                                                                        0xFFCCCCCC),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        -0.24,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 285,
                                                                height: 48,
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  // Change the background color if needed
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200), // Change the border color and width
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                ),
                                                                child:
                                                                    TextField(
                                                                  // controller:
                                                                  //     approximate_weight,
                                                                  readOnly:
                                                                      true, // Prevent user input
                                                                  controller:
                                                                      TextEditingController(
                                                                          text:
                                                                              calculatedNewAirWeight),

                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding: EdgeInsets.only(
                                                                        bottom:
                                                                            10,
                                                                        left:
                                                                            10),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none, // Set to none if you want to remove the inner border
                                                                    ),
                                                                    // hintText:
                                                                    //     '3.98',
                                                                    hintStyle:
                                                                        GoogleFonts
                                                                            .poppins(
                                                                      color: Color(
                                                                          0xFF808080),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                    suffixIcon:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              13,
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        'MT',
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: GoogleFonts
                                                                            .mulish(
                                                                          color:
                                                                              Color(0xFFCCCCCC),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              0,
                                                                          letterSpacing:
                                                                              -0.24,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    suffixStyle:
                                                                        GoogleFonts
                                                                            .mulish(
                                                                      color: Color(
                                                                          0xFFCCCCCC),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      height: 0,
                                                                      letterSpacing:
                                                                          -0.24,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // widget.Status ==
                                                              //         'Rigid Pipe'
                                                              //     ? Container()
                                                              //     :
                                                            ],
                                                          ),
                                                        ),
                                                  widget.Status ==
                                                              'Rigid Pipe' ||
                                                          widget.IsBatch == '1'
                                                      ? Container()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      20),
                                                          child: Text(
                                                            'Crane Weight',
                                                            // textAlign:
                                                            //     TextAlign.right,
                                                            overflow: TextOverflow
                                                                .ellipsis, // Sets overflow to ellipsis
                                                            style: GoogleFonts
                                                                .mulish(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 1,
                                                              letterSpacing:
                                                                  -0.24,
                                                            ),
                                                          ),
                                                        ),
                                                  widget.Status ==
                                                              'Rigid Pipe' ||
                                                          widget.IsBatch == '1'
                                                      ? Container()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 14),
                                                          child: Container(
                                                            width: 124,
                                                            height: 48,
                                                            decoration:
                                                                ShapeDecoration(
                                                              color: Color(
                                                                  0xFFFFFFFF), // Change the background color if needed
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black45), // Change the border color and width
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            child: SizedBox(
                                                              width: 285,
                                                              height: 48,
                                                              child: TextField(
                                                                controller:
                                                                    crane_weight,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                focusNode:
                                                                    _focusNode2,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top:
                                                                                  13,
                                                                              right:
                                                                                  10),
                                                                          child:
                                                                              Text(
                                                                            'MT',
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style:
                                                                                GoogleFonts.mulish(
                                                                              color: Color(0xFFCCCCCC),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                              height: 0,
                                                                              letterSpacing: -0.24,
                                                                            ),
                                                                          )),
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              10),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none, // Set to none if you want to remove the inner border
                                                                  ),
                                                                  // hintText:
                                                                  //     '15',
                                                                  hintStyle:
                                                                      GoogleFonts
                                                                          .poppins(
                                                                    color: Color(
                                                                        0xFF23262F),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      )),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
