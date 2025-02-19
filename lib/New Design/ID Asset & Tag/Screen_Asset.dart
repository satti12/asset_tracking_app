// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/New%20Design/Dashboard.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/Preview_Asset.dart';
import 'package:asset_tracking/URL/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Screen_Assets extends StatefulWidget {
  String? rfid_value;
  String? tfmcText;
  String? scText;
  String? startvalue;
  String? lineEndvalue;
  String? numOfJointsValue;
  String? numOflength;
  String? approxLengthValue;
  String? approxWeightValue;
  String? carneWeightValue;
  String? Status;
  String? Productid;
  String? puling_id;
  String? puling_name;
  String? dimensions;
  String? weight_in_air;
  String? CurrentLocation;
  String? Quantity;
  String? IsBatch;

  Screen_Assets({
    this.rfid_value,
    this.tfmcText,
    this.scText,
    this.startvalue,
    this.numOfJointsValue,
    this.numOflength,
    this.approxLengthValue,
    this.approxWeightValue,
    this.carneWeightValue,
    this.lineEndvalue,
    this.Status,
    this.Productid,
    this.puling_id,
    this.puling_name,
    this.dimensions,
    this.weight_in_air,
    this.CurrentLocation,
    this.Quantity,
    this.IsBatch,
  });

  @override
  _Screen_AssetsState createState() => _Screen_AssetsState();
}

class _Screen_AssetsState extends State<Screen_Assets> {
  //bool contamValue = true;
  bool hydrocarbonValuee = false;
  bool mercuryValueee = false;
  bool _radionorm = false;
  bool _radioremnant = false;
  String? hazardText;
  List<String> capturedImagePaths = [];
  List<ImageModel> imageList = [];
  List<String> uploadedFileUrls = [];
  TextEditingController benzenecontroller = TextEditingController();
  TextEditingController voccontroller = TextEditingController();
  TextEditingController surface_ugcontroller = TextEditingController();
  TextEditingController surface_ppmcontroller = TextEditingController();
  TextEditingController normsurfacecontroller = TextEditingController();
  TextEditingController dose_rate_controller = TextEditingController();
  TextEditingController vapoursurface_controller = TextEditingController();
  TextEditingController h2scontroller = TextEditingController();
  TextEditingController lelcontroller = TextEditingController();
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  FocusNode _focusNode6 = FocusNode();
  FocusNode _focusNode7 = FocusNode();
  FocusNode _focusNode8 = FocusNode();
  FocusNode _focusNode9 = FocusNode();
  List<String> imagepath = [];

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

  // void contamenatedValue(bool? value) {
  //   setState(() {
  //     contamValue = value!;
  //     if (contamValue == false) {
  //       hydrocarbonValuee = false;
  //       mercuryValueee = false;
  //       _radionorm = false;
  //       _radioremnant = false;
  //     } else {
  //       hydrocarbonValuee = true;
  //       mercuryValueee = true;
  //       _radionorm = true;
  //       _radioremnant = true;
  //     }
  //   });
  // }

  void hydrocarbonValue(value) {
    setState(() {
      hydrocarbonValuee = value!;
    });
  }

  void mercury(value) {
    setState(() {
      mercuryValueee = value!;
      // if (mercuryValueee == true) {
      //   contamValue = true;
      // } else {
      //   //contamValue = false;
      //   // _radioValueee = false;
      //   // _radionorm = false;
      //   // _radioremnant = false;
      // }
    });
  }

  void _handleRadioValueChangenorm(value) {
    setState(() {
      _radionorm = value!;
    });
  }

  void _handleRadioValueChangeremnant(value) {
    setState(() {
      _radioremnant = value!;
    });
  }

  String determineText() {
    if (mercuryValueee || _radionorm) {
      return Classification.CONTAMINATED.toString();
    } else if (hydrocarbonValuee ||
        (_radioremnant && !mercuryValueee && !_radionorm)) {
      return Classification.HAZARDOUS.toString();
    } else {
      return Classification.NON_CONTAMINATED.toString();
    }
  }
  // String determineText() {
  //   var result;
  //   // if (!contamValue) {
  //   //   result = Classification.NON_CONTAMINATED;
  //   // }
  //   if (hydrocarbonValuee || _radioremnant) {
  //     result = Classification.HAZARDOUS;
  //   }

  //   if (_radionorm || mercuryValueee) {
  //     result = Classification.CONTAMINATED;
  //   } else {
  //     result = Classification.NON_CONTAMINATED;
  //   }
  //   return result;
  // }
  // final pickedFile = await ImagePicker()
  //     .getImage(source: ImageSource.gallery);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(PreviewScreen(
                  tfmcText: widget.tfmcText,
                  scText: widget.scText,
                  scanRfidValue: widget.rfid_value,
                  startvalue: widget.startvalue,
                  pulling_id: widget.puling_id,
                  pulling_name: widget.puling_name,
                  lineEndvalue: widget.lineEndvalue,
                  numOfJointsValue: widget.numOfJointsValue,
                  numOflength: widget.numOflength,
                  approxLengthValue: widget.approxLengthValue,
                  HydrocarbonsValue: hydrocarbonValuee,
                  benzenevalue: benzenecontroller.text,
                  vocvalue: voccontroller.text,
                  mercuryvalue: mercuryValueee,
                  normsurfacevalue: normsurfacecontroller.text,
                  dose_rate: dose_rate_controller.text,
                  surfacevalue_ugvalue: surface_ugcontroller.text,
                  surfacevalue_ppmvalue: surface_ppmcontroller.text,
                  vaporsurfacereading: vapoursurface_controller.text,
                  is_radiation: _radionorm,
                  is_rph: _radioremnant,
                  hs2_value: h2scontroller.text,
                  lel_value: lelcontroller.text,
                  Status: widget.Status,
                  condition: determineText(),
                  Prduct_id: widget.Productid,
                  imageUrls: imageList,
                  approxWeightValue: widget.approxWeightValue,
                  carneWeightValue: widget.carneWeightValue,
                  weight_in_air: widget.weight_in_air,
                  dimensions: widget.dimensions,
                  imagepath: imagepath,
                  Quantity: widget.Quantity,
                  IsBatch: widget.IsBatch,
                ));
              },
              child: SizedBox(
                width: 100.w,
                height: 60.h,
                child: Center(
                  child: Text(
                    'Preview',
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
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Screen - ${widget.Status}',
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
                    widget.CurrentLocation.toString(),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200.w,
                        child: Row(
                          children: [
                            Container(
                              width: 190,
                              //   color: Colors.red,
                              child: Text(
                                'TFMC ID# ${widget.tfmcText}',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                  letterSpacing: 0.56,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(new ClipboardData(
                                    text: '${widget.tfmcText}'));
                              },
                              child: SvgPicture.asset(
                                'images/svg/copy.svg',
                                height: 18,
                                width: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 200.w,
                        //  color: Colors.red,
                        child: Text(
                          '${widget.scText}',
                          style: GoogleFonts.inter(
                            color: Color(0xFF424242),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: 0.48,
                          ),
                        ),
                      ),
//
                      Text(
                        widget.Status == 'Rigid Pipe'
                            ? ''
                            : 'RFID - ${widget.rfid_value}',
                        style: GoogleFonts.inter(
                          color: Color(0xFFB9B9B9),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.40,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 130.w,
                        child: Text(
                          widget.Status == 'Flexibles'
                              ? 'Start End: ${widget.startvalue}'
                              : '',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Container(
                        width: 130.w,
                        child: Text(
                          widget.Status == 'Flexibles'
                              ? 'Line End:  ${widget.lineEndvalue}'
                              : '',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Container(
                        width: 130.w,
                        child: Text(
                          widget.Status == 'Flexibles'
                              ? 'No. of Joints: ${widget.numOfJointsValue}'
                              : widget.Status == 'Rigid Pipe'
                                  ? 'Quantity - ${widget.numOflength}'
                                  : 'Location - ${widget.startvalue}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Container(
                        width: 130.w,
                        child: Text(
                          widget.Status == 'Flexibles'
                              ? 'Approx. Length: ${widget.approxLengthValue} m'
                              : '',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                      Container(
                        width: 140.w,
                        child: Text(
                          widget.Status == 'Flexibles'
                              ? 'Approx. Weight: ${widget.approxWeightValue} MT'
                              : widget.Status == 'Rigid Pipe'
                                  ? 'Container Weight - ${widget.approxWeightValue}'
                                  : 'Dimension - ${widget.dimensions}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.inter(
                            color: Color(0xFF808080),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.only(left: 20, top: 30, bottom: 18),
            //       child: Text(
            //         'Contamination',
            //         textAlign: TextAlign.left,
            //         style: GoogleFonts.mulish(
            //           color: Colors.black,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w700,
            //           height: 0,
            //           letterSpacing: -0.32,
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Radio(
            //             activeColor: Colors.red.shade900,
            //             value: true,
            //             groupValue: contamValue,
            //             onChanged: contamenatedValue,
            //           ),
            //           Text('Contaminated'
            //               // widget.Status == 'Flexible'
            //               //     ? 'Contaminated'
            //               //     : 'Potentially Contaminated',
            //               ),
            //           SizedBox(
            //             width: 17,
            //           ),
            //           Radio(
            //             value: false,
            //             activeColor: Colors.red.shade900,
            //             groupValue: contamValue,
            //             onChanged: contamenatedValue,
            //           ),
            //           Text('Non Contaminated'),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 18, bottom: 18),
                  child: Text(
                    'Hydrocarbons',
                    textAlign: TextAlign.left,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: Colors.red.shade900,
                        value: true,
                        groupValue: hydrocarbonValuee,
                        onChanged: hydrocarbonValue,
                      ),
                      Text(
                        'Yes',
                      ),
                      SizedBox(
                        width: 82,
                      ),
                      Radio(
                        value: false,
                        activeColor: Colors.red.shade900,
                        groupValue: hydrocarbonValuee,
                        onChanged: hydrocarbonValue,
                      ),
                      Text('No'),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 23,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Benzene',
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: Text(
                          'VOC ',
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 170,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: benzenecontroller,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode1,
                            //autofocus: true,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode2);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '0.67',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'ppm',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          width: 170,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: voccontroller,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode2,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode3);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '0.67',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'ppm',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 25, bottom: 18),
                  child: Text(
                    'Mercury',
                    textAlign: TextAlign.left,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: Colors.red.shade900,
                        value: true,
                        groupValue: mercuryValueee,
                        onChanged: mercury,
                      ),
                      Text(
                        'Yes',
                      ),
                      SizedBox(
                        width: 82,
                      ),
                      Radio(
                        value: false,
                        activeColor: Colors.red.shade900,
                        groupValue: mercuryValueee,
                        onChanged: mercury,
                      ),
                      Text('No'),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 23,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Surface Reading',
                            style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 170,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: surface_ugcontroller,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode3,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode4);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '1.35',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'µg/cm2',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          width: 170,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: surface_ppmcontroller,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode4,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode5);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '0.67',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'ppm',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 23,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Vapour',
                            style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: 170,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: vapoursurface_controller,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode5,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode6);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '1.35',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'mg/m3',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 180),
                    ],
                  ),
                ],
              ),
            ),

//next code here

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 25, bottom: 18),
                  child: Text(
                    'NORM/Radiation',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: Colors.red.shade900,
                        value: true,
                        groupValue: _radionorm,
                        onChanged: _handleRadioValueChangenorm,
                      ),
                      Text(
                        'Yes',
                      ),
                      SizedBox(
                        width: 82,
                      ),
                      Radio(
                        value: false,
                        activeColor: Colors.red.shade900,
                        groupValue: _radionorm,
                        onChanged: _handleRadioValueChangenorm,
                      ),
                      Text('No'),
                    ],
                  ),
                ),
              ],
            ),

            //here

            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 23,
                bottom: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Surface Reading',
                            style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Dose Rate ',
                            style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 160.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: normsurfacecontroller,
                          keyboardType: TextInputType.number,
                          focusNode: _focusNode6,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_focusNode7);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // hintText: '1.37',
                            // hintStyle: GoogleFonts.poppins(
                            //   color: Color(0xFF23262F),
                            //   fontSize: 12,
                            //   fontWeight: FontWeight.w400,
                            //   height: 0,
                            // ),
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(top: 13, right: 10),
                              child: Text(
                                'Bq/cm2',
                                style: GoogleFonts.mulish(
                                  color: Color(0xFFCCCCCC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 8, left: 10),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          width: 160.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            onTapOutside: (value) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode7,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode8);
                            },
                            controller: dose_rate_controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '0.67',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'µSv/hr',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //here now

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 25, bottom: 18),
                  child: Text(
                    'Remnant Product Hazard (RPH)',
                    style: GoogleFonts.mulish(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: Colors.red.shade900,
                        value: true,
                        groupValue: _radioremnant,
                        onChanged: _handleRadioValueChangeremnant,
                      ),
                      Text(
                        'Yes',
                      ),
                      SizedBox(
                        width: 82,
                      ),
                      Radio(
                        value: false,
                        activeColor: Colors.red.shade900,
                        groupValue: _radioremnant,
                        onChanged: _handleRadioValueChangeremnant,
                      ),
                      Text('No'),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 20,
                top: 23,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'H2S',
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: Text(
                          'LEL ',
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: h2scontroller,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode8,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode9);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '1.35',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'ppm',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          width: 170,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: lelcontroller,
                            keyboardType: TextInputType.number,
                            focusNode: _focusNode9,
                            onSubmitted: (value) {
                              _focusNode9.unfocus();
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '0.67',
                              // hintStyle: GoogleFonts.poppins(
                              //   color: Color(0xFF23262F),
                              //   fontSize: 12,
                              //   fontWeight: FontWeight.w400,
                              //   height: 0,
                              // ),
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(top: 13, left: 15),
                                child: Text(
                                  '%',
                                  style: GoogleFonts.mulish(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 8, left: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Classification',
                      style: GoogleFonts.mulish(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'The ${widget.Status}\n Categorizes as: ',
                            style: GoogleFonts.mulish(
                              color: Color(0xFF808080),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              determineText(),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.mulish(
                                color:
                                    determineText() == Classification.HAZARDOUS
                                        ? Colors.orange
                                        : determineText() ==
                                                Classification.NON_CONTAMINATED
                                            ? Colors.green
                                            : Colors.red,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    determineText() == Classification.HAZARDOUS
                                        ? Colors.orange
                                        : determineText() ==
                                                Classification.NON_CONTAMINATED
                                            ? Colors.green
                                            : Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: -0.44,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
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
                  padding: const EdgeInsets.only(left: 30, top: 20, right: 20),
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
                              return Card(
                                color: Color(0xFFCCCCCC),
                                child: ListTile(
                                  title: Text(
                                    'image.jpg ${index + 1}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                      size: 11,
                                    ),
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
                            title: Text(
                              'Upload Image',
                              style: GoogleFonts.mulish(
                                //decoration: TextDecoration.underline,

                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: -0.44,
                              ),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    final pickedFile =
                                        await ImagePicker().getImage(
                                      source: ImageSource.camera,
                                      // imageQuality: 60
                                    );
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
                                    //
                                    // final pickedFile = await ImagePicker()
                                    //     .getImage(source: ImageSource.gallery);
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
              ],
            ),

            SizedBox(
              height: 15,
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
