import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/custom_toast.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Repository/auth_repository.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Save data to SharedPreferences when the app is paused
      _NewLoginScreenState().saveValuesToStorage();
    }
  }
}

class NewLoginScreen extends StatefulWidget with WidgetsBindingObserver {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final passwordcontroller = TextEditingController();
  final namcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  ValueNotifier<bool> _toggle = ValueNotifier<bool>(true);

  String fullPhoneNumber = '';

  GlobalKey<FormState> formKey = new GlobalKey();

  String? _selectedFullName;
  String? _selectedOperatingLocationId;
  List<Map<String, dynamic>> _locations = [];
  String version = 'NA';

  onSetAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    } catch (e) {
      print('Error getting app version: $e');
      version = 'NA';
    }
    setState(() {
      version;
    });
  }

  // Load stored values from SharedPreferences
  void loadStoredValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namcontroller.text = prefs.getString('storedName') ?? '';
      //  passwordcontroller.text = prefs.getString('storedPas') ?? '';
    });
  }

  // Save values to SharedPreferences
  void saveValuesToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('storedName', namcontroller.text);
    //prefs.setString('storedPas', passwordcontroller.text);
  }

  Future<void> _fetchLocations() async {
    // final response =
    //     await DatabaseHelper.instance.queryAllRows('operating_locations');

   final response =
        await DatabaseHelper.instance.queryList('operating_locations', [
      ['type', '<>', LocationType.QUAYSIDE]
    ], {});
    setState(() {
      _locations = (response as List)
          .map((record) => {
                'operating_location_id': record['operating_location_id'],
                'full_name': record['name'] + ' ' + record['type'],
              })
          .toList();

      _locations.sort((a, b) => a['full_name'].compareTo(b['full_name']));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
    loadStoredValues();
    onSetAppVersion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(AppLifecycleObserver());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                top: 480.h,
                left: 100,
                child: Opacity(
                  opacity: 0.1,
                  child: Transform.rotate(
                    angle:
                        -0.3, // Specify the rotation angle in radians (negative for counterclockwise)
                    child: Container(
                      width: 400.w,
                      height: 400.h,
                      child: Image(
                        image: AssetImage('images/background.png'),
                        color: Colors.grey[400],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 35.h,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Center(
                            child: Container(
                              height: 76.h,
                              width: 186,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/logo.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.mulish(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.56,
                              ),
                            )),
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text(
                              ' User ID',
                              style: GoogleFonts.mulish(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.24,
                              ),
                            )),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width / .9,
                            height: 42,
                            // decoration: ShapeDecoration(
                            //   shape: RoundedRectangleBorder(
                            //     side: BorderSide(
                            //         width: 0.50, color: Color(0xFFD9D9D9)),
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: TextFormField(
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (value) {},
                              controller: namcontroller,
                              //  cursorHeight: 4.0,

                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out this field';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.email_rounded,
                                  color: Color(0xFFD9D9D9),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD9D9D9)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                helperStyle: GoogleFonts.mulish(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                  letterSpacing: -0.28,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(top: 8, left: 15),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Text(
                            'Enter Password',
                            style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width / .9,
                            height: 42,
                            // decoration: ShapeDecoration(
                            //   shape: RoundedRectangleBorder(
                            //     side: BorderSide(
                            //         width: 0.50, color: Color(0xFFD9D9D9)),
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: ValueListenableBuilder(
                                valueListenable: _toggle,
                                builder: (context, value, child) {
                                  return TextFormField(
                                    maxLines: 1,
                                    textAlignVertical: TextAlignVertical.top,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please fill out this field';
                                      }
                                      return null;
                                    },
                                    controller: passwordcontroller,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: _toggle.value,
                                    decoration: InputDecoration(
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          _toggle.value = !_toggle.value;
                                        },
                                        child: Icon(
                                            _toggle.value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility,
                                            color: _toggle.value
                                                ? Color(0xFFD9D9D9)
                                                : Colors
                                                    .black // Color when the condition is true (e.g., off state)
                                            ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFFD9D9D9)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      helperStyle: GoogleFonts.mulish(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                        letterSpacing: -0.28,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 8, left: 15),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        //For select location i add this  code in login screen
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Text(
                            'Select Location*',
                            style: GoogleFonts.mulish(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width / .9,
                            height: 42,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 0.50, color: Color(0xFFD9D9D9)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  _fetchLocations();
                                },
                                child: Container(
                                  width: 180.w,
                                  height: 48.h,
                                  child: DropdownButtonFormField<String>(
                                    // hint: Text('Select Location'),
                                    decoration: InputDecoration(
                                        // Set decoration to null or customize it as needed
                                        border: InputBorder
                                            .none, // Removes the underline border
                                        contentPadding:
                                            EdgeInsets.only(bottom: 7)
                                        // horizontal: 10,

                                        // Optional: Adjust content padding
                                        ),
                                    value: _selectedFullName,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedFullName = newValue!;
                                        _selectedOperatingLocationId =
                                            _locations.firstWhere((location) =>
                                                        location['full_name'] ==
                                                        newValue)[
                                                    'operating_location_id']
                                                as String;
                                      });
                                    },
                                    items: _locations
                                        .map((location) =>
                                            DropdownMenuItem<String>(
                                              child:
                                                  Text(location['full_name']),
                                              value: location['full_name']
                                                  as String,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //
                        SizedBox(
                          height: 45.h,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Obx(
                            () => RoundButton(
                              loading: loading.value,
                              title: 'Log In',
                              onPress: () async {
                                //  if (formKey.currentState!.validate()) {
                                onSetAppVersion();
                                loading.value = true;

                                saveValuesToStorage();
                                if (_selectedOperatingLocationId == null) {
                                  Utils.SnackBar(
                                      'Error', 'Please Select Location');
                                  loading.value = false;
                                } else
                                // if ('v$version'.toString() ==
                                //  SetVersion)
                                {
                                  // DatabaseHelper.instance
                                  //     .syncDataFromServer()
                                  //     .then((value) {
                                  //   // Only attempt login if sync is successful
                                  //   Login(
                                  //     namcontroller.text.toString(),
                                  //     DatabaseHelper.instance.hashPassword(
                                  //         passwordcontroller.text.toString()),
                                  //     _selectedOperatingLocationId.toString(),
                                  //     _selectedFullName.toString(),
                                  //     'v$version'.toString(),
                                  //   ).whenComplete(() {
                                  //     // You can put any post-login logic here if needed
                                  //     CustomToast(context).success(
                                  //         'Sync down successful and logged in!');
                                  //   });
                                  // }).catchError((error) {
                                  //   // Handle sync error without attempting to login
                                  //   loading.value = false;
                                  //   CustomToast(context)
                                  //       .error('Sync down failed, $error');
                                  // });

                                  Login(
                                    namcontroller.text.toString(),
                                    DatabaseHelper.instance.hashPassword(
                                        passwordcontroller.text.toString()),
                                    _selectedOperatingLocationId.toString(),
                                    _selectedFullName.toString(),
                                    'v$version'.toString(),
                                  ).whenComplete(() async {
                                    LoadingScreen.showLoading(context,
                                        duration: Duration(seconds: 10));
                                    await DatabaseHelper.instance
                                        .syncDataFromServer()
                                        .then((value) {
                                      ;

                                      CustomToast(context)
                                          .success('Sync down successful!');
                                    }).catchError((error) {
                                      loading.value = false;
                                      CustomToast(context)
                                          .error('Sync down failed!');
                                    });
                                  });
                                }

                                //  else {
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         title: Text('Update Required'),
                                //         content: Text(
                                //             'Your app version is old. Please update the app.'),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             onPressed: () {
                                //               Navigator.of(context)
                                //                   .pop(); // Close the dialog
                                //             },
                                //             child: Text('OK'),
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );
                                //   loading.value = false;
                                // }
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 200.h,
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}
