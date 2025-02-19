// ignore_for_file: must_be_immutable

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Repository/CreateShipment_Repository/Voyages_Repository/create_voyage_repository.dart';
import 'package:asset_tracking/Repository/CreateShipment_Repository/Voyages_Repository/fetch_voyage_containerList_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'Review_Voyage_comp.dart';

class PreviewPage extends StatefulWidget {
  List<Asset>? selectedContainers;
  String? VesslsName;
  String? wheretolocationid;
  String? CrunnetName;
  String? fromName;
  String? fromlocationid;
  String? Vesselid;
  List<String>? selectedIds = [];

  PreviewPage(
      {super.key,
      this.VesslsName,
      this.selectedContainers,
      this.fromlocationid,
      this.wheretolocationid,
      this.Vesselid,
      this.selectedIds,
      this.CrunnetName,
      this.fromName});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  String getCurrentFormattedTime() {
    DateTime now = DateTime.now().toUtc(); // Get current UTC time
    String formattedTime = DateFormat("MMM dd, yyyy HH:mm 'UTC'").format(now);
    return '($formattedTime)';
  }

  late String currentFormattedTime;
  @override
  void initState() {
    // TODO: implement initState
    currentFormattedTime = getCurrentFormattedTime();
    super.initState();
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
              LoadingScreen.showLoading(context);
              VoyageController.create_voyage(
                widget.wheretolocationid.toString(),
                widget.selectedContainers!.toList(),
                widget.fromlocationid.toString(),
                widget.Vesselid.toString(),
                widget.VesslsName.toString(),
                widget.CrunnetName.toString(),
                widget.fromName.toString(),
              );
            },
            child: Text(
              'Confirm',
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
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Review Voyage Info',
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.48,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Add your functionality here
                    },
                    child: Container(
                      width: 34.w,
                      height: 34.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F9F9),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'images/svg/text.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              // here comes the details to confirm voyeage info
              SizedBox(
                height: 130.h,
                child: Review_Voyage_Coponenets(
                  Vessls: widget.VesslsName.toString(),
                  Origin: widget.CrunnetName.toString(),
                  time: '$currentFormattedTime',
                  Destination: widget.fromName.toString(),
                  Dispatch_Packages: widget.selectedIds!.length.toString(),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              // here comes the Divider for ui
              Divider(
                height: 1.h,
                color: Colors.grey,
                thickness: 1,
              ),

              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 540,
                child: ListView.builder(
                  itemCount: widget.selectedContainers!.length,
                  itemBuilder: (context, index) {
                    var container = widget.selectedContainers![index];

                    return FutureBuilder<List<Asset>?>(
                      future: fetchAssetItemInVessel(container),
                      builder: (context, itemSnapshot) {
                        if (itemSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (itemSnapshot.hasError) {
                          return Text('Error: ${itemSnapshot.error}');
                        } else {
                          // Process and extract data from itemSnapshot
                          List<Asset>? items = itemSnapshot.data;
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
                          String getProduct() {
                            if (container.asset_type.toString() ==
                                'Container') {
                              var result;

                              result = productName != null &&
                                      productName.length > 0
                                  ? '${productName.map((item) => '* $item').join('\n')}'
                                  : '* ${container.asset_type}';
                              return result;
                            } else {
                              return '${container.product_no}';
                            }
                          }

                          String getTFMCID() {
                            if (container.asset_type.toString() ==
                                'Container') {
                              var result;

                              result = productNos != null &&
                                      productNos.length > 0
                                  ? ' ${productNos.map((item) => ' • $item').join('\n')}'
                                  : ' ${drum_no?.map((item) => ' • $item').join('\n')}';
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

                          String details =
                              getTFMCID(); // Customize this to extract the details you want

                          // Now, build the ReviewVoyageComp with the details
                          return ReviewVoyageComp(
                            containerWidth: 345.w,
                            containerHeight: 95.h,
                            Details: details, // Pass the details as a parameter
                            Maintitle:
                                container.asset_type.toString() == 'Container'
                                    ? container.container_type.toString()
                                    : container.asset_type.toString(),
                            title: container.product_no == null
                                ? ''
                                : 'TFMC ID# ${container.product_no}',
                            subTitle: 'RFID : ${container.rf_id}',
                            color: container.classification ==
                                    Classification.HAZARDOUS
                                ? Colors.orange
                                : container.classification ==
                                        Classification.NON_CONTAMINATED
                                    ? Colors.green
                                    : Colors.red,
                          );
                        }
                      },
                    );
                  },
                ),
              )

              // Container(
              //   height: 540,
              //   child: ListView.builder(
              //     itemCount: widget.selectedContainers!.length,
              //     itemBuilder: (context, index) {
              //       var container = widget.selectedContainers![index];
              //       return ReviewVoyageComp(
              //         containerWidth: 345.w,
              //         containerHeight: 95.h,

              //         Details:  FutureBuilder<List<Asset>?>(
              //   future:
              //       fetchAssetItemInVessel(widget.selectedContainers as Asset),
              //   builder: (context, itemSnapshot) {
              //     if (itemSnapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator(); // Show a loading indicator while data is being fetched
              //     } else if (itemSnapshot.hasError) {
              //       return Text('Error: ${itemSnapshot.error}');
              //     } else {
              //       // Process and display detailed information here
              //       // Example:
              //       return Text('Details: ${(itemSnapshot)}');
              //     }
              //   },
              // ),

              //         container.product.toString(),
              //         Maintitle: container.asset_type.toString() == 'Container'
              //             ? container.container_type.toString()
              //             : container.asset_type.toString(),

              //         title: container.product_no == null
              //             ? ''
              //             : 'TFMC ID# ${container.product_no}',
              //         subTitle: 'RFID : ${container.rf_id}',
              //         //'Your expanded content goes here',
              //         color:
              //             container.classification == Classification.HAZARDOUS
              //                 ? Colors.orange
              //                 : container.classification ==
              //                         Classification.NON_CONTAMINATED
              //                     ? Colors.green
              //                     : Colors.red,
              //       );
              //     },
              //   ),
              // )

              // here is rounded parent container
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewVoyageComp extends StatefulWidget {
  final double containerWidth;
  final double containerHeight;
  final String title;
  final String Maintitle;
  final String subTitle;
  final Color color;
  String Details;

  ReviewVoyageComp({
    required this.containerWidth,
    required this.containerHeight,
    required this.title,
    required this.Maintitle,
    required this.subTitle,
    required this.color,
    required this.Details,
  });

  @override
  _ReviewVoyageCompState createState() => _ReviewVoyageCompState();
}

class _ReviewVoyageCompState extends State<ReviewVoyageComp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: widget.containerWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
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
            ),
          ],
        ),
        child: ExpansionTile(
          title: buildCustomRow(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: widget.containerWidth,
                child: Text(
                  widget.Details,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildLeftContainer(),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: buildMiddleContent(),
        ),
      ],
    );
  }

  Widget buildLeftContainer() {
    return Container(
      width: 5,
      height: widget.containerHeight,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
    );
  }

  Widget buildMiddleContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: 0.56,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            widget.subTitle,
            style: TextStyle(
              color: Color(0xFF424242),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0.48,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 240,
            child: Text(
              widget.Maintitle,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// components for container

// class ReviewVoyageComp extends StatefulWidget {
//   final double containerWidth;
//   final double containerHeight;
//   final bool isExpanded;
//   final Function() onTap;
//   final String title;
//   final String Maintitle;
//   final String subTitle;

//   Color color;

//   ReviewVoyageComp({
//     required this.containerWidth,
//     required this.containerHeight,
//     required this.isExpanded,
//     required this.onTap,
//     required this.title,
//     required this.Maintitle,
//     required this.subTitle,
//     required this.color,
//   });

//   @override
//   _ReviewVoyageCompState createState() => _ReviewVoyageCompState();
// }

// class _ReviewVoyageCompState extends State<ReviewVoyageComp> {
//   late bool _isExpanded;

//   @override
//   void initState() {
//     _isExpanded = widget.isExpanded;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Container(
//         width: widget.containerWidth,
//         height: _isExpanded ? 200.h : widget.containerHeight,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x66AEAEC0),
//               blurRadius: 3,
//               offset: Offset(1.50, 1.50),
//               spreadRadius: 0,
//             ),
//             BoxShadow(
//               color: Color(0xFFFFFFFF),
//               blurRadius: 3,
//               offset: Offset(-3, 0),
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         child: buildCustomRow(),
//       ),
//     );
//   }

//   Widget buildCustomRow() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         buildLeftContainer(),
//         Padding(
//           padding: const EdgeInsets.only(left: 20),
//           child: buildMiddleContent(),
//         ),
//       ],
//     );
//   }

//   Widget buildLeftContainer() {
//     return Container(
//       width: 5,
//       decoration: BoxDecoration(
//         color: widget.color,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15),
//           bottomLeft: Radius.circular(15),
//         ),
//       ),
//     );
//   }

//   Widget buildMiddleContent() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 widget.title,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   height: 1,
//                   letterSpacing: 0.56,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 2),
//           Text(
//             widget.subTitle,
//             style: TextStyle(
//               color: Color(0xFF424242),
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               height: 1,
//               letterSpacing: 0.48,
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               SizedBox(
//                 width: 250.w,
//                 // height: 19,
//                 child: Text(
//                   widget.Maintitle,
//                   style: GoogleFonts.inter(
//                     color: Colors.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     height: 0,
//                     letterSpacing: 0.72,
//                   ),
//                 ),
//               ),
//               Icon(Icons.keyboard_arrow_down_outlined)
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
