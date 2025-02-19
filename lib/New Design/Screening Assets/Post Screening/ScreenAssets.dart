// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Dashboard.dart';
import 'package:asset_tracking/URL/url.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:asset_tracking/main.dart';
import 'Comp_for_RFID_ScrennAssets.dart/Comp_For_Scanned_Assets.dart';
import 'Preview_Screen_Asstes.dart';

class ScreenAssetsPage extends StatefulWidget {
  String? CurrentLocation;
  String? Screening_Type;

  ScreenAssetsPage({this.CurrentLocation, this.Screening_Type});

  @override
  _ScreenAssetsPageState createState() => _ScreenAssetsPageState();
}

class _ScreenAssetsPageState extends State<ScreenAssetsPage> {
  //bool contamValue = true;
  bool hydrocarbonValuee = false;
  bool mercuryValueee = false;
  bool _radionorm = false;
  bool _radioremnant = false;
  List<String> capturedImagePaths = [];
  List<String> uploadedFileUrls = [];
  TextEditingController ctc_number = TextEditingController();
  TextEditingController benzenecontroller = TextEditingController();
  TextEditingController voccontroller = TextEditingController();
  TextEditingController surface_ugcontroller = TextEditingController();
  TextEditingController surface_ppmcontroller = TextEditingController();
  TextEditingController normsurfacecontroller = TextEditingController();
  TextEditingController vapoursurface_controller = TextEditingController();
  TextEditingController h2scontroller = TextEditingController();
  TextEditingController lelcontroller = TextEditingController();
  TextEditingController dose_rate = TextEditingController();
  List<ImageModel> imageList = [];
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
      //   contamValue = false;
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

  // String determineText() {
  //   var result;
  //   if (!contamValue) {
  //     result = Classification.NON_CONTAMINATED;
  //   }
  //   if (hydrocarbonValuee || _radioremnant) {
  //     result = Classification.HAZARDOUS;
  //   }

  //   if (_radionorm || mercuryValueee) {
  //     result = Classification.CONTAMINATED;
  //   }
  //   return result;
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

  Color determineColor() {
    String textResult = determineText();

    if (textResult == Classification.HAZARDOUS) {
      return Colors.orange; // Red
    } else if (textResult == Classification.NON_CONTAMINATED) {
      return Colors.green; // Orange
    } else {
      return Colors.red; // Green
    }
  }

  Asset containerData = new Asset();

  Future<Asset> fetchScreenItem(String rfId) async {
    if (rfId.isNotEmpty) {
      final data = await DatabaseHelper.instance.queryList('assets', [
        ['rf_id', '=', rfId],
      ], {});
      if (widget.Screening_Type == 'Screening') {
        if (data != null && data.isNotEmpty) {
          final String assetType = data[0]['asset_type'];
          final String status = data[0]['status'];
          final String location = data[0]['operating_location_id'];

          bool isValidAsset = false;

          if (assetType == AssetType.ANCILLARY_EQUIPMENT &&
              (status == AssetStatus.ARRIVED_AT_YARD ||
                  status == AssetStatus.TAGGED ||
                  status == AssetStatus.MOVED_TO_YARD_STORAGE)) {
            isValidAsset = true;
          } else if (assetType == AssetType.SUBSEA_STRUCTURE &&
                  status == AssetStatus.ARRIVED_AT_YARD ||
              status == AssetStatus.MOVED_TO_YARD_STORAGE) {
            isValidAsset = true;
          } else if (assetType == AssetType.FLEXIBLES &&
              status == AssetStatus.TAGGED &&
              location != 'GQGGSOA18I') {
            isValidAsset = true;
          } else if (assetType == AssetType.RIGID_PIPE &&
              status == AssetStatus.MOVED_TO_YARD_STORAGE) {
            isValidAsset = true;
          }

          if (isValidAsset) {
            final List<Asset> response =
                data.map((json) => Asset.fromJson(json)).toList();
            setState(() {
              containerData = response[0];
            });
            return response[0];
          } else {
            Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
            throw Exception('Cannot Find Asset with this RFID');
          }
        } else {
          Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
          throw Exception('Cannot Find Asset with this RFID');
        }
      } else {
        if (data != null && data.length > 0) {
          if ((data[0]['classification'] == Classification.CONTAMINATED ||
                  data[0]['classification'] == Classification.HAZARDOUS) &&
              data[0]['status'] == AssetStatus.IN_CLEARANCE) {
            final List<Asset> response =
                data.map((json) => Asset.fromJson(json)).toList();
            setState(() {
              containerData = response[0];
            });

            return response[0];
          } else {
            Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
            throw Exception('Cannot Find Asset with this RFID');
          }
        } else {
          Utils.SnackBar('Error', 'Cannot Find Asset with this RFID');
          throw Exception('Cannot Find Asset with this RFID');
        }
      }
    } else {
      return Utils.SnackBar('Error', 'Please Enter RFID');
    }
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   rf_id.clear();
  //   super.dispose();
  // }
  @override
  void initState() {
    rf_id.clear();
    super.initState();
  }

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  FocusNode _focusNode6 = FocusNode();
  FocusNode _focusNode7 = FocusNode();
  FocusNode _focusNode8 = FocusNode();
  FocusNode _focusNode9 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            containerData.rf_id == null
                ? SizedBox()
                : TextButton(
                    onPressed: () {
                      Get.to(PreviewScreening(
                        tfmcText: containerData.product_no,
                        scText: containerData.product_no,
                        scanRfidValue: containerData.rf_id,
                        // contaminatedvalue: contamValue,
                        ctc_number: ctc_number.text,
                        HydrocarbonsValue: hydrocarbonValuee,
                        benzenevalue: benzenecontroller.text,
                        vocvalue: voccontroller.text,
                        mercuryvalue: mercuryValueee,
                        normsurfacevalue: normsurfacecontroller.text,
                        surfacevalue_ugvalue: surface_ugcontroller.text,
                        surfacevalue_ppmvalue: surface_ppmcontroller.text,
                        vaporsurfacereading: vapoursurface_controller.text,
                        normvalue: _radionorm,
                        remnant_ugvalue: _radioremnant,
                        hs2_value: h2scontroller.text,
                        lel_value: lelcontroller.text,
                        dose_rate: dose_rate.text,
                        condition: determineText(),
                        Prduct_id: containerData.product.toString(),
                        vaporsurfacereadingthis: '',
                        object: containerData,
                        imagepath: imagepath,
                        imageUrls: imageList,
                        ScreeningType: widget.Screening_Type.toString(),
                      ));
                    },
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
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // here goes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.Screening_Type == ScreeningType.POST_SCREENING
                      ? Text(
                          'Screening-Post',
                          style: GoogleFonts.inter(
                            color: Color(0xFF262626),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.48,
                          ),
                        )
                      : Text(
                          'Screening - Initial',
                          style: GoogleFonts.inter(
                            color: Color(0xFF262626),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.48,
                          ),
                        ),

                  // Text(
                  //   'Screening - Initial',
                  //   style: GoogleFonts.inter(
                  //     color: Color(0xFF262626),
                  //     fontSize: 24.sp,
                  //     fontWeight: FontWeight.w700,
                  //     letterSpacing: -0.48,
                  //   ),
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     // Add your functionality here
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
              Row(
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

              SizedBox(height: 15.h),

              Container(
                width: MediaQuery.sizeOf(context).width / 1,
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
                    fetchScreenItem(rf_id.text);
                  },
                  decoration: InputDecoration(
                      hintText: 'Scan  RFID',
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
                                  fetchScreenItem(rf_id.text);
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
                      contentPadding: EdgeInsets.only(top: 8, left: 15)),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),
              // here come the Card that containes all containers info Scanned from RFID
              ContainerForScreenAssets(
                color: containerData.classification == Classification.HAZARDOUS
                    ? Colors.orange
                    : containerData.classification ==
                            Classification.NON_CONTAMINATED
                        ? Colors.green
                        : Colors.red,

                structureType:
                    '${(containerData.product == null && containerData.asset_type == 'Container') ? containerData.container_type : (containerData.product != null ? containerData.product : containerData.asset_type) ?? ''}',
                // '${containerData.product ?? ' '}',
                rfid: 'RFID#    ${containerData.rf_id ?? ' '}',
                bundle: containerData.bundle_no == null &&
                        containerData.batch_no == null
                    ? '' // both are null, return empty string
                    : containerData.bundle_no == null
                        ? 'Batch#       ${containerData.batch_no ?? ' '}' // bundle_no is null, use batch_no
                        : 'Bundle#       ${containerData.bundle_no ?? ' '}', // bundle_no is not null, use it

                // containerData.bundle_no == null
                //     ? 'Batch#       ${containerData.batch_no ?? ' '}'
                //     : 'Bundle#       ${containerData.bundle_no ?? ' '}',
                TFMC: '${containerData.product_no ?? ' '}',
                ContamClassOfshore: '${containerData.classification ?? ''}',
              ),
              SizedBox(
                height: 15.h,
              ),
              // Text(
              //   'Contamination',
              //   textAlign: TextAlign.left,
              //   style: GoogleFonts.mulish(
              //     color: Colors.black,
              //     fontSize: 16,
              //     fontWeight: FontWeight.w700,
              //     height: 0,
              //     letterSpacing: -0.32,
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Radio(
              //       activeColor: Colors.red.shade900,
              //       value: true,
              //       groupValue: contamValue,
              //       onChanged: contamenatedValue,
              //     ),
              //     Text(
              //       'Contaminated',
              //     ),
              //     SizedBox(
              //       width: 17.w,
              //     ),
              //     Radio(
              //       value: false,
              //       activeColor: Colors.red.shade900,
              //       groupValue: contamValue,
              //       onChanged: contamenatedValue,
              //     ),
              //     Text('Non Contaminated'),
              //   ],
              // ),
              if (widget.Screening_Type == 'Screening' &&
                  (containerData.asset_type == AssetType.FLEXIBLES ||
                      containerData.asset_type == AssetType.RIGID_PIPE))
                Container(
                  width: MediaQuery.sizeOf(context).width / 1,
                  height: 50,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextFormField(
                    controller: ctc_number,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter CTC No',
                        suffixIcon: Container(
                          width: 91.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (ctc_number.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    ctc_number.clear();
                                  },
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
                        contentPadding: EdgeInsets.only(top: 8, left: 15)),
                  ),
                ),
              if (widget.Screening_Type == 'Screening' &&
                  (containerData.asset_type == AssetType.FLEXIBLES ||
                      containerData.asset_type == AssetType.RIGID_PIPE))
                SizedBox(height: 20.h),
              Text(
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
              Row(
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
                    width: 75.w,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              SizedBox(height: 20.h),
              Row(
                children: [
                  Container(
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
                      focusNode: _focusNode1,
                      onSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focusNode2);
                      },
                      controller: benzenecontroller,
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
                  SizedBox(width: 20),
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
                        focusNode: _focusNode2,
                        onSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_focusNode3);
                        },
                        controller: voccontroller,
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

              SizedBox(
                height: 15.h,
              ),

              Text(
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
              Row(
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
                    width: 82.w,
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Surface Reading',
                        style: GoogleFonts.mulish(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Container(
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
                          focusNode: _focusNode3,
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_focusNode4);
                          },
                          controller: surface_ugcontroller,
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
                      SizedBox(width: 20),
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
                            focusNode: _focusNode4,
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(_focusNode5);
                            },
                            controller: surface_ppmcontroller,
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
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Vapour',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 0,
                  letterSpacing: -0.28,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
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
                  focusNode: _focusNode5,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_focusNode6);
                  },
                  controller: vapoursurface_controller,
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
              SizedBox(width: 180.w),

              //next code here
              SizedBox(
                height: 15.h,
              ),
              Text(
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
              Row(
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

              //here

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  Container(
                    width: 160.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: normsurfacecontroller,
                      focusNode: _focusNode6,
                      onSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_focusNode7);
                      },
                      keyboardType: TextInputType.number,
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
                          padding: const EdgeInsets.only(top: 13, right: 10),
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
                  SizedBox(width: 20),
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
                        controller: dose_rate,
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

              //here now
              SizedBox(
                height: 15.h,
              ),
              Text(
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
              Row(
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
                    width: 82.w,
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Container(
                        width: 160.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: h2scontroller,
                          focusNode: _focusNode8,
                          onSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_focusNode9);
                          },
                          keyboardType: TextInputType.number,
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
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          width: 160.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: lelcontroller,
                            focusNode: _focusNode9,
                            onSubmitted: (value) {
                              _focusNode9.unfocus();
                            },
                            keyboardType: TextInputType.number,
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
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Classification',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.40,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'The bundle \n Categorizes as: ',
                    style: GoogleFonts.mulish(
                      color: Color(0xFF808080),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.24,
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Text(
                      determineText(),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.mulish(
                        color: determineColor(),
                        decoration: TextDecoration.underline,
                        decorationColor: determineColor(),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.44,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h),
              Text(
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
              SizedBox(
                height: 15.h,
              ),

              Container(
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
                                    capturedImagePaths.removeAt(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  final pickedFile = await ImagePicker()
                                      .getImage(source: ImageSource.camera);
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
              SizedBox(
                height: 15,
              ),
            ],
          ),
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
