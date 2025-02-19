import 'package:asset_tracking/Component/error_dailog.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Repository/Container_Repository/create_container_repository.dart';
import 'package:asset_tracking/Repository/Container_Repository/fetch_containerType_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asset_tracking/main.dart';

class AddContainer extends StatefulWidget {
  String? Screenkey;
  AddContainer({Key? key, this.Screenkey}) : super(key: key);

  @override
  _AddContainerState createState() => _AddContainerState();
}

class _AddContainerState extends State<AddContainer> {
  final List<String> item = ['Container', 'Bundle', 'Flexible Pipe'];
  String selectedItem = 'Container';
  String? selectContainerType;
  //TextEditingController rf_id = TextEditingController();
  TextEditingController serialnum = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Call your API function inside initState
    rf_id.clear();
    fetchContainerTypes().then((types) {
      setState(() {
        containerTypes = types;
      });
    }).catchError((error) {
      // Handle error if necessary
      print('Error: $error');
    });
  }

  String? selectedContainerTypeId;
  String? selectedContainerType;
  String? selectedContainerDimention;
  List<ContainerType> containerTypes = [];
  var tare_weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add A New Container',
                style: GoogleFonts.mulish(
                  color: Color(0xFF262626),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.44,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width / .9,
                height: 50.h,
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
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Container Serial#',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.28,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 350.w,
                height: 48.h,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TextFormField(
                    controller: serialnum,
                    decoration: InputDecoration(
                        // hintText: 'Scan RFID',
                        helperStyle: GoogleFonts.mulish(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.w)),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Select Container Type',
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.28,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                width: 350.w,
                height: 48.h,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFFF4F5F6)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedContainerType,
                        decoration: InputDecoration(
                          // Set decoration to null or customize it as needed
                          border:
                              InputBorder.none, // Removes the underline border
                          contentPadding: EdgeInsets.symmetric(
                              // horizontal: 10,
                              vertical: 3), // Optional: Adjust content padding
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedContainerType = newValue;
                            var len = containerTypes
                                .firstWhere((containerType) =>
                                    containerType.container_type_id == newValue)
                                .length_m;

                            var width = containerTypes
                                .firstWhere((containerType) =>
                                    containerType.container_type_id == newValue)
                                .width_m;
                            var height = containerTypes
                                .firstWhere((containerType) =>
                                    containerType.container_type_id == newValue)
                                .height_m;
                            selectContainerType = containerTypes
                                .firstWhere((containerType) =>
                                    containerType.container_type_id == newValue)
                                .name;
                            tare_weight = containerTypes
                                .firstWhere((containerType) =>
                                    containerType.container_type_id == newValue)
                                .total_weight_kg;
                            selectedContainerDimention =
                                '$len x $width x $height';
                          });
                        },
                        items:
                            containerTypes.map((ContainerType containerType) {
                          return DropdownMenuItem<String>(
                            value: containerType
                                .container_type_id, // assuming 'name' is the property in ContainerType
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(containerType.name.toString()),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 108.w,
                      height: 40.h,
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
                      width: 108,
                      height: 40,
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
                          if (rf_id.text.isEmpty ||
                              selectedContainerType == null) {
                            ErrorDialog.showError(
                                context, 'Error', 'Please Fill All field');
                          } else {
                            LoadingScreen.showLoading(context);
                            if (widget.Screenkey == null) {
                              create_Newcontainer(
                                  rf_id.text,
                                  selectedContainerType.toString(),
                                  selectContainerType.toString(),
                                  serialnum.text,
                                  selectedContainerDimention.toString(),
                                  tare_weight.toString());
                            } else {
                              create_Newcontainer(
                                      rf_id.text,
                                      selectedContainerType.toString(),
                                      selectContainerType.toString(),
                                      serialnum.text,
                                      selectedContainerDimention.toString(),
                                      tare_weight.toString())
                                  .whenComplete(() => Navigator.pop(context));
                            }
                          }
                        },
                        title: 'Create',
                        // buttonColor: Color(0xFFA80303),
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
