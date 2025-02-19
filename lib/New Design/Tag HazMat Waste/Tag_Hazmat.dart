import 'dart:convert';
import 'dart:io';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/error_dailog.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Dashboard.dart';
import 'package:asset_tracking/Repository/CreateProcess_Repository/create_asset_repository.dart';
import 'package:asset_tracking/URL/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:asset_tracking/main.dart';

class TagHazmatWaste extends StatefulWidget {
  const TagHazmatWaste({super.key});

  @override
  State<TagHazmatWaste> createState() => _TagHazmatWasteState();
}

class _TagHazmatWasteState extends State<TagHazmatWaste> {
  String? _selectedADGClass;
  String? _selectedUN;
  String? _selectedClassCategory;
  bool shouldHideDropdowns = false;
  //TextEditingController rf_id = TextEditingController();
  TextEditingController un_number = TextEditingController(text: '3369');
  TextEditingController dose_rate = TextEditingController();
  List<String> capturedImagePaths = [];
  List<String> uploadedFileUrls = [];
  String? _selectedDrumTypeId;
  String? _selectedWasteTypeId;

  List<ImageModel> imageList = [];

  //late Future<List<Map<String, dynamic>>> _drumTypes;
  //late Future<List<Map<String, dynamic>>> _wasteTypes;

  Future<String> uploadImage(XFile pickedFile) async {
    try {
      var request = http.MultipartRequest(
        'Post',
        Uri.parse('$baseurl/api/assets/upload_image'),
      );

      var pic = await http.MultipartFile.fromPath('UserFile', pickedFile.path);
      request.files.add(pic);

      request.headers['Authorization'] = 'Bearer $Newaccesskey';

      var response = await request.send();

      if (response.statusCode == 200) {
        var imageUrl = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(imageUrl);
        String fileUrl = jsonResponse['file']['file_url'];
        uploadedFileUrls.add(fileUrl);

        ///uploadedFileUrls.add('$baseurl$fileUrl');
        // print('api ${fileUrl}');
        // print(uploadedFileUrls);
        return imageUrl;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (error) {
      print('Error occurred during image upload: $error');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _onUploadButtonPressed() async {
    final picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = await picker.pickImage(
          source: ImageSource.camera, maxHeight: 200, maxWidth: 200);
      if (pickedFile == null) {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedFile != null) {
        String imageUrl = await uploadImage(XFile(pickedFile.path));
        print('Image URL: $imageUrl');

        if (imageUrl.isNotEmpty) {
          // Add the imageUrl to the capturedImagePaths list
          setState(() {
            capturedImagePaths.add(imageUrl);
          });
        } else {
          // Handle the case where imageUrl is empty
          print('Failed to upload image: Empty imageUrl');
          // You can show an error message to the user
        }
      } else {
        // Handle the case where pickedFile is null (user canceled the image picking)
        print('No image selected');
        // You can show a message to the user
      }
    } catch (error) {
      // Handle other exceptions
      print('Error occurred: $error');
      // You can show an error message to the user
    }
  }

  // Future<void> _onUploadButtonPressed() async {
  //   final picker = ImagePicker();
  //   // XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     try {
  //       String imageUrl = await uploadImage(XFile(pickedFile.path));
  //       print('Image URL: $imageUrl');

  //       if (imageUrl.isNotEmpty) {
  //         // Add the imageUrl to the capturedImagePaths list
  //         setState(() {
  //           capturedImagePaths.add(imageUrl);
  //         });
  //       } else {
  //         // Handle the case where imageUrl is empty
  //         print('Failed to upload image: Empty imageUrl');
  //         // You can show an error message to the user
  //       }
  //     } catch (error) {
  //       // Handle upload errors or other exceptions
  //       print('Image URL: $pickedFile');
  //       print('Error occurred: $error');
  //       // You can show an error message to the user
  //     }
  //   }
  // }

  // Future<List<Map<String, dynamic>>> fetchDrumTypes() async {
  //   final response =
  //       await http.get(Uri.parse('$baseurl/api/drum_types/'), headers: {
  //     'Authorization': 'Bearer $Newaccesskey',
  //   });

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     final List<Map<String, dynamic>> drumTypes = List.from(data['records']);
  //     return drumTypes;
  //   } else {
  //     throw Exception('Failed to load drum types');
  //   }
  // }

  // Future<List<Map<String, dynamic>>> fetchWasteTypes() async {
  //   final response =
  //       await http.get(Uri.parse('$baseurl/api/waste_types/'), headers: {
  //     'Authorization': 'Bearer $Newaccesskey',
  //   });

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     final List<Map<String, dynamic>> wasteType = List.from(data['records']);
  //     return wasteType;
  //   } else {
  //     throw Exception('Failed to load waste types');
  //   }
  // }

  Future<List<Map<String, dynamic>>?> fetchWasteTypes() async {
    final response = await DatabaseHelper.instance.queryAllRows('waste_types');
    return response;
  }

  Future<List<Map<String, dynamic>>?> fetchDrumTypes() async {
    final response = await DatabaseHelper.instance.queryAllRows('drum_types');
    return response;
  }

  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        for (var pickedFile in pickedFiles) {
          imagepath.add(pickedFile.path);
          imageList.add(ImageModel(
            imageFile: File(pickedFile.path),
            imageName: 'Image ${imageList.length + 1}',
          ));
        }
      });
    }
  }

  @override
  void initState() {
    rf_id.clear();
    super.initState();
    // _drumTypes =
    fetchDrumTypes();
    // _wasteTypes =
    fetchWasteTypes();
  }

  List<String> imagepath = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              if (rf_id.text.isEmpty) {
                // Show a dialog informing the user to enter the RFID first
                ErrorDialog.showError(
                    context, 'Error', 'Please enter RFID first.');
              } else {
                if (_selectedDrumTypeId == null ||
                    _selectedWasteTypeId == null) {
                  ErrorDialog.showError(
                      context, 'Error', 'Please Select  All Required Field ');
                } else {
                  LoadingScreen.showLoading(context);
                  create_bundle(
                      rf_id.text,
                      null, //  widget.Prduct_id,
                      null, //  widget.pullingid,
                      //   null, //  widget.pullingname,
                      'HazMat Waste',
                      null, //  widget.numOfJointsValue,
                      null, //  widget.numOflength,
                      null, //  widget.approxLengthValue,
                      null, //  widget.approxWeightValue,
                      null, //  widget.carneWeightValue,
                      null, //  widget.dimensions,
                      null, //  widget.weight_in_air,
                      false, //  widget.HydrocarbonsValue as bool,
                      false, //  widget.mercuryvalue as bool,
                      false, // widget.normvalue as bool,
                      true, // widget.contaminatedvalue as bool,
                      false, //  widget.remnant_ugvalue as bool,
                      null, // widget.benzenevalue,
                      null, //  widget.vocvalue,
                      null,
                      null,
                      null, //  widget.surfacevalue,
                      null, // widget.hs2_value,
                      null, // widget.lel_value,
                      null, //surfacecontaminaton
                      null,
                      null,
                      null,
                      null,
                      // _selectedADGClass,
                      // _selectedADGClass == '9' ? un_number.text : _selectedUN,
                      // dose_rate.text,
                      // _selectedClassCategory,
                      _selectedDrumTypeId,
                      _selectedWasteTypeId,
                      imagepath,
                      Classification.CONTAMINATED,
                      null,
                      null

                      //uploadedFileUrls,
                      );
                }
              }
            },
            child: SizedBox(
              width: 100.w,
              height: 60.h,
              child: Center(
                child: Text(
                  'Done',
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tag - Hazmat Waste',
                    style: GoogleFonts.mulish(
                      color: Color(0xFF262626),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.44,
                    ),
                  ),
                  // ClipOval(
                  //   child: Material(
                  //     color: Color(0xFFF9F9F9),
                  //     child: IconButton(
                  //       onPressed: () {
                  //         // Implement chat button functionality here
                  //       },
                  //       icon: Icon(Icons.ac_unit),
                  //       iconSize: 30,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
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
                      contentPadding: EdgeInsets.only(top: 10, left: 15)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type of Drum',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),

// ...

                  FutureBuilder(
                    future: fetchDrumTypes(), //_drumTypes,
                    builder: (context, AsyncSnapshot snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Text(
                      //       'Loading...'); // Loading indicator while fetching data
                      // } else
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text(
                            'No drum types available'); // Handle empty data
                      } else {
                        final drumTypes = snapshot.data!;
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F5F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedDrumTypeId,
                            decoration: InputDecoration(
                              // Set decoration to null or customize it as needed
                              border: InputBorder
                                  .none, // Removes the underline border
                              contentPadding: EdgeInsets.symmetric(
                                  // horizontal: 10,
                                  vertical:
                                      3), // Optional: Adjust content padding
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDrumTypeId = newValue;
                              });
                            },
                            items: drumTypes.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> drumType) {
                              return DropdownMenuItem<String>(
                                value: drumType['drum_type_id'],
                                child: Text(drumType['name']),
                              );
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),

                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 12),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFFF4F5F6),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: DropdownButton<String>(
                  //     isExpanded: true,
                  //     value: _selectedDrumType,
                  //     underline: SizedBox(),
                  //     items: <String>['Drum', 'IBC'].map((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(
                  //           value,
                  //           textAlign: TextAlign.left,
                  //           style: GoogleFonts.poppins(
                  //             color: Color(0xFF23262F),
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w400,
                  //             height: 0,
                  //           ),
                  //         ),
                  //       );
                  //     }).toList(),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         _selectedDrumType = newValue;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  Text(
                    'Waste Type',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  FutureBuilder(
                    future: fetchWasteTypes(), //_wasteTypes,
                    builder: (context, AsyncSnapshot snapshot) {
                      //   if (snapshot.connectionState == ConnectionState.waiting) {
                      //     return Text(
                      //         'Loading...'); // Loading indicator while fetching data
                      //   } else
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text(
                            'No Waste types available'); // Handle empty data
                      } else {
                        List<Map<String, dynamic>> wasteTypes = snapshot.data!;
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F5F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedWasteTypeId,
                            decoration: InputDecoration(
                              // Set decoration to null or customize it as needed
                              border: InputBorder
                                  .none, // Removes the underline border
                              contentPadding: EdgeInsets.symmetric(
                                  // horizontal: 10,
                                  vertical:
                                      3), // Optional: Adjust content padding
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedWasteTypeId = newValue;
                              });
                            },
                            items: wasteTypes.map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> wasteType) {
                              return DropdownMenuItem<String>(
                                value: wasteType['waste_type_id'],
                                child: Text(wasteType['name']),
                              );
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                  //   Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 12),
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFFF4F5F6),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: DropdownButton<String>(
                  //       isExpanded: true,
                  //       value: _selectedWasteType,
                  //       underline: SizedBox(),
                  //       items: <String>['Solid', 'Liquid', 'SCO']
                  //           .map((String valuewaste) {
                  //         return DropdownMenuItem<String>(
                  //           value: valuewaste,
                  //           child: Text(
                  //             valuewaste,
                  //             textAlign: TextAlign.left,
                  //             style: GoogleFonts.poppins(
                  //               color: Color(0xFF23262F),
                  //               fontSize: 12,
                  //               fontWeight: FontWeight.w400,
                  //               height: 0,
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           _selectedWasteType = newValue;
                  //         });
                  //       },
                  //     ),
                  //   ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.all(20.0),
                //   child: Text(
                //     'Drum Contamination Details',
                //     style: GoogleFonts.mulish(
                //       color: Color(0xFF262626),
                //       fontSize: 16,
                //       fontWeight: FontWeight.w700,
                //       height: 0,
                //       letterSpacing: -0.32,
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding:
                //       EdgeInsets.only(left: 15.0, right: 20, top: 0, bottom: 0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           margin: EdgeInsets.all(8.0),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 'ADG Class',
                //                 style: GoogleFonts.mulish(
                //                   color: Color(0xFF262626),
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.w700,
                //                   height: 0,
                //                   letterSpacing: -0.28,
                //                 ),
                //               ),
                //               SizedBox(height: 8.0),
                //               Container(
                //                 padding: EdgeInsets.symmetric(horizontal: 12),
                //                 decoration: BoxDecoration(
                //                   color: Colors.grey[200],
                //                   borderRadius: BorderRadius.circular(12),
                //                 ),
                //                 child: DropdownButton<String>(
                //                   isExpanded: true,
                //                   value: _selectedADGClass,
                //                   underline: SizedBox(),
                //                   items:
                //                       <String>['7', '9'].map((String valueAGD) {
                //                     return DropdownMenuItem<String>(
                //                       value: valueAGD,
                //                       child: Text(
                //                         valueAGD,
                //                         textAlign: TextAlign.left,
                //                         style: GoogleFonts.poppins(
                //                           color: Color(0xFF23262F),
                //                           fontSize: 12,
                //                           fontWeight: FontWeight.w400,
                //                           height: 0,
                //                         ),
                //                       ),
                //                     );
                //                   }).toList(),
                //                   onChanged: (String? newValue) {
                //                     setState(() {
                //                       _selectedADGClass = newValue;

                //                       if (_selectedADGClass == '9') {
                //                         setState(() {
                //                           _selectedUN = null;
                //                           // selectedContainerData.un_number = '3369';
                //                           _selectedClassCategory = null;

                //                           dose_rate.clear();
                //                         });
                //                       }
                //                       shouldHideDropdowns = newValue == '9';
                //                     });
                //                   },
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: Container(
                //           margin: EdgeInsets.all(8.0),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 'UN#',
                //                 style: GoogleFonts.mulish(
                //                   color: Color(0xFF262626),
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.w700,
                //                   height: 0,
                //                   letterSpacing: -0.28,
                //                 ),
                //               ),
                //               SizedBox(height: 8.0),
                //               _selectedADGClass == '9'
                //                   ? Container(
                //                       padding:
                //                           EdgeInsets.symmetric(horizontal: 12),
                //                       decoration: BoxDecoration(
                //                         color: Colors.grey[200],
                //                         borderRadius: BorderRadius.circular(12),
                //                       ),
                //                       child: TextFormField(
                //                         controller: un_number,
                //                         decoration: InputDecoration(
                //                           border: InputBorder.none,
                //                           hintText: '',
                //                           hintStyle: GoogleFonts.inter(
                //                             color: Color(0xFFB9B9B9),
                //                             fontSize: 10,
                //                             fontWeight: FontWeight.w700,
                //                             height: 0,
                //                             letterSpacing: 0.40,
                //                           ),
                //                         ),
                //                       ),
                //                     )
                //                   : Container(
                //                       padding:
                //                           EdgeInsets.symmetric(horizontal: 12),
                //                       decoration: BoxDecoration(
                //                         color: Colors.grey[200],
                //                         borderRadius: BorderRadius.circular(12),
                //                       ),
                //                       child: DropdownButton<String>(
                //                         isExpanded: true,
                //                         value: _selectedUN,
                //                         underline: SizedBox(),
                //                         items: <String>[
                //                           '2910',
                //                           '2911',
                //                           '2912',
                //                           '2913',
                //                           '3326'
                //                         ].map((String valueUN) {
                //                           return DropdownMenuItem<String>(
                //                             value: valueUN,
                //                             child: Text(
                //                               valueUN,
                //                               textAlign: TextAlign.left,
                //                               style: GoogleFonts.poppins(
                //                                 color: Color(0xFF23262F),
                //                                 fontSize: 12,
                //                                 fontWeight: FontWeight.w400,
                //                                 height: 0,
                //                               ),
                //                             ),
                //                           );
                //                         }).toList(),
                //                         onChanged: (String? newValue) {
                //                           setState(() {
                //                             _selectedUN = newValue;
                //                           });
                //                         },
                //                       ),
                //                     ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // shouldHideDropdowns
                //     ? SizedBox()
                //     : Padding(
                //         padding: EdgeInsets.only(
                //             left: 15.0, right: 20, top: 0, bottom: 0),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: Container(
                //                 margin: EdgeInsets.all(8.0),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Text(
                //                       'Dose Rate',
                //                       style: GoogleFonts.mulish(
                //                         color: Color(0xFF262626),
                //                         fontSize: 14,
                //                         fontWeight: FontWeight.w700,
                //                         height: 0,
                //                         letterSpacing: -0.28,
                //                       ),
                //                     ),
                //                     SizedBox(height: 8.0),
                //                     Container(
                //                       padding:
                //                           EdgeInsets.symmetric(horizontal: 12),
                //                       decoration: BoxDecoration(
                //                         color: Colors.grey[200],
                //                         borderRadius: BorderRadius.circular(12),
                //                       ),
                //                       child: TextFormField(
                //                         controller: dose_rate,
                //                         decoration: InputDecoration(
                //                           border: InputBorder.none,
                //                           suffix: Text('µSv/h'),
                //                           suffixStyle: GoogleFonts.inter(
                //                             color: Color(0xFFCCCCCC),
                //                             fontSize: 12,
                //                             fontWeight: FontWeight.w500,
                //                             height: 0,
                //                             letterSpacing: -0.24,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //             shouldHideDropdowns
                //                 ? SizedBox()
                //                 : Expanded(
                //                     child: Container(
                //                       margin: EdgeInsets.all(8.0),
                //                       child: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             'Class 7 Category',
                //                             style: GoogleFonts.mulish(
                //                               color: Color(0xFF262626),
                //                               fontSize: 14,
                //                               fontWeight: FontWeight.w700,
                //                               height: 0,
                //                               letterSpacing: -0.28,
                //                             ),
                //                           ),
                //                           SizedBox(height: 8.0),
                //                           Container(
                //                             padding: EdgeInsets.symmetric(
                //                                 horizontal: 12),
                //                             decoration: BoxDecoration(
                //                               color: Colors.grey[200],
                //                               borderRadius:
                //                                   BorderRadius.circular(12),
                //                             ),
                //                             child: DropdownButton<String>(
                //                               isExpanded: true,
                //                               value: _selectedClassCategory,
                //                               underline: SizedBox(),
                //                               items: <String>[
                //                                 'Expected',
                //                                 'I - White',
                //                                 'II - Yellow',
                //                                 'III - Yellow',
                //                               ].map((String valueClassCat) {
                //                                 return DropdownMenuItem<String>(
                //                                   value: valueClassCat,
                //                                   child: Text(
                //                                     valueClassCat,
                //                                     textAlign: TextAlign.left,
                //                                     style: GoogleFonts.poppins(
                //                                       color: Color(0xFF23262F),
                //                                       fontSize: 12,
                //                                       fontWeight:
                //                                           FontWeight.w400,
                //                                       height: 0,
                //                                     ),
                //                                   ),
                //                                 );
                //                               }).toList(),
                //                               onChanged: (String? newValue) {
                //                                 setState(() {
                //                                   _selectedClassCategory =
                //                                       newValue;
                //                                 });
                //                               },
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //           ],
                //         ),
                //       ),
                // SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 20),
                      child: Text(
                        'Upload images',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.mulish(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 20, right: 20),
                      child: Container(
                        width: 380.w,
                        height: 150.h, // Adjust the height as needed
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              color: Color.fromARGB(223, 244, 245, 246),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: imageList.isNotEmpty
                            ? ListView.builder(
                                itemCount: imageList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                              'image.jpg '), // Add your image file name here
                                          Text((index + 1)
                                              .toString()), // Display the count
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            imageList.removeAt(
                                                index); // Remove the image path from the list
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text('No images captured yet.'),
                              ),
                      ),
                    ),
                    // here goes the upload image button
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                      ),
                      child: RoundButton(
                        title: 'Use Camera',
                        icon: SvgPicture.asset('images/svg/camera2.svg'),
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        borderColor: Color(0xFFA80303),
                        onPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                surfaceTintColor: Colors.white,
                                title: Text('Upload image'),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        final pickedFile = await ImagePicker()
                                            .getImage(
                                                source: ImageSource.camera);
                                        if (pickedFile != null) {
                                          setState(() {
                                            imagepath.add(pickedFile.path);
                                            imageList.add(ImageModel(
                                              imageFile: File(pickedFile.path),
                                              imageName:
                                                  'Image ${imageList.length + 1}',
                                            ));
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: SvgPicture.asset(
                                            'images/svg/camera2.svg'),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        pickImages();
                                        // final pickedFile = await ImagePicker()
                                        //     .getImage(
                                        //         source: ImageSource.gallery);
                                        // if (pickedFile != null) {
                                        //   setState(() {
                                        //     imagepath.add(pickedFile.path);
                                        //     imageList.add(ImageModel(
                                        //       imageFile: File(pickedFile.path),
                                        //       imageName:
                                        //           'Image ${imageList.length + 1}',
                                        //     ));
                                        //   });
                                        // }
                                      },
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          child: Image(
                                            color: Color(0xFFA80303),
                                            image: AssetImage(
                                              'images/gallery.png',
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          // // final pickedFile = await ImagePicker()
                          // //     .getImage(source: ImageSource.camera);
                          // if (pickedFile != null) {
                          //   setState(() {
                          //     imagepath.add(pickedFile.path);
                          //     imageList.add(ImageModel(
                          //       imageFile: File(pickedFile.path),
                          //       imageName: 'Image ${imageList.length + 1}',
                          //     ));
                          //   });
                          //  }

                          // _onUploadButtonPressed();
                          // final cameras = await availableCameras();
                          // final firstCamera = cameras.first;

                          // final image = await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         CameraScreen(camera: firstCamera),
                          //   ),
                          // );

                          // if (image != null) {
                          //   setState(() {
                          //     capturedImagePaths.add(image
                          //         .path); // Store the path of the captured image
                          //   });
                          // } else {
                          //   // Handle cancellation (image is null)
                          // }
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 70,
                    //   ),
                    //   child: RoundButton(
                    //     title: 'Use Camera',
                    //     icon: SvgPicture.asset('images/svg/camera2.svg'),
                    //     buttonColor: Colors.white,
                    //     textColor: Colors.black,
                    //     borderColor: Color(0xFFA80303),
                    //     onPress: () async {
                    //       final pickedFile = await ImagePicker()
                    //           .getImage(source: ImageSource.camera);
                    //       if (pickedFile != null) {
                    //         setState(() {
                    //           imagepath.add(pickedFile.path);
                    //           imageList.add(ImageModel(
                    //             imageFile: File(pickedFile.path),
                    //             imageName: 'Image ${imageList.length + 1}',
                    //           ));
                    //         });
                    //       }
                    //       // _onUploadButtonPressed();
                    //       // final cameras = await availableCameras();
                    //       // final firstCamera = cameras.first;

                    //       // final image = await Navigator.of(context).push(
                    //       //   MaterialPageRoute(
                    //       //     builder: (context) =>
                    //       //         CameraScreen(camera: firstCamera),
                    //       //   ),
                    //       // );

                    //       // if (image != null) {
                    //       //   setState(() {
                    //       //     capturedImagePaths.add(image
                    //       //         .path); // Store the path of the captured image
                    //       //   });
                    //       // } else {
                    //       //   // Handle cancellation (image is null)
                    //       // }
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageModel {
  final File imageFile;
  final String imageName;

  ImageModel({required this.imageFile, required this.imageName});
}
