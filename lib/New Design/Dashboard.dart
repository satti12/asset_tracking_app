import 'dart:async';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/custom_toast.dart';
import 'package:asset_tracking/Component/loading.dart';
import 'package:asset_tracking/Component/loading_Screen_component.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/Clearance/Clearance.dart';
import 'package:asset_tracking/New%20Design/Clean%20&%20Decontam/Clean_Decontam.dart';
import 'package:asset_tracking/New%20Design/Disposal%20Yard/YardDisposal.dart';
import 'package:asset_tracking/New%20Design/NewProfileSceen.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/New_Adding_Asset.dart';
import 'package:asset_tracking/New%20Design/login.dart';
import 'package:asset_tracking/New%20Design/Arrival_At_Quayside/ArrivalAtQuaysaide.dart';
import 'package:asset_tracking/New%20Design/Release%20Container/Release_container.dart';
import 'package:asset_tracking/New%20Design/Tag%20HazMat%20Waste/Tag_Hazmat.dart';
import 'package:asset_tracking/New%20Design/Vessel/Vessel.dart';
import 'package:asset_tracking/New%20Design/Move%20To%20Yard%20Storage/Select_Asset.dart';
import 'package:asset_tracking/Repository/dashboard_repository.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info/package_info.dart';
import 'package:asset_tracking/main.dart';
//import 'package:intl/intl.dart';
import 'DeContamDisposal/DeContamDisposalPage.dart';
import 'Receipt Yard/Receipt_Yard.dart';
import 'Receivel/ReceievelPage.dart';
import 'Screening Assets/Post Screening/ScreenAssets.dart';
import 'Tags Rigids Pipes/Tags_And_Rigids.dart';
import 'Transport Container/Add_Container.dart';
import 'Transport Container/Transport_container.dart';
import 'Unbundle/Unbundling.dart';

var Newaccesskey;

class NewDashboard extends StatefulWidget {
  const NewDashboard({Key? key}) : super(key: key);

  @override
  _NewDashboardState createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard> {
  Future<Map<String, dynamic>>? _dashboardData;

  @override
  void initState() {
    super.initState();
    _dashboardData = fetchDashboard(context);

    // Timer.periodic(Duration(seconds: 5), (timer) async {
    //   await DatabaseHelper.instance.syncUp();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _dashboardData,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error occurred: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          Map<String, dynamic>? data = snapshot.data;
          return ListView(
            children: [
              Column(children: [
                Stack(
                  children: [
                    Container(
                      height: 175.h,
                      decoration: ShapeDecoration(
                        color: Color(0xFF292929),
                        shape: RoundedRectangleBorder(),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(NewProfilePage(
                                          Userid: data?['profile']['id'],
                                        ));
                                      },
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: CircleAvatar(
                                                radius: 40.r,
                                                backgroundImage:
                                                    (data?['profile'] == null ||
                                                            data?['profile'][
                                                                    'avatar'] ==
                                                                null ||
                                                            data?['profile']
                                                                    ['avatar']
                                                                .isEmpty)
                                                        ? AssetImage(
                                                                'logo.jpeg ')
                                                            as ImageProvider<
                                                                Object>
                                                        : NetworkImage(
                                                            data?['profile']
                                                                    ['avatar']
                                                                as String)
                                                //  Provide a local placeholder image
                                                ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              right: 10.r,
                                            ),
                                            width: 20.w,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFA80303),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 20),
                                      child: Container(
                                        // color: Colors.amber,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data?['profile']['name'].isEmpty
                                                  ? 'Loading'
                                                  : data?['profile']['name'],
                                              style: GoogleFonts.mulish(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w800,
                                                height: 0,
                                                letterSpacing: -0.44,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'ID:  ${data?['profile']['id'] == null ? 'Loading' : data?['profile']['id']}',
                                                  style: GoogleFonts.mulish(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                    letterSpacing: -0.24,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                // Icon(
                                                //   Icons.access_time_filled,
                                                //   size: 14,
                                                //   color:
                                                //       Color.fromRGBO(168, 3, 3, 1),
                                                // ),
                                                // Padding(
                                                //   padding:
                                                //       EdgeInsets.only(left: 10),
                                                //   child: Text(
                                                //     DateFormat('MMM d y').format(DateTime
                                                //         .fromMillisecondsSinceEpoch(
                                                //             data['profile'] == null
                                                //                 ? 1223332
                                                //                 : data['profile'][
                                                //                         'last_login'] *
                                                //                     1000)),
                                                //     style: GoogleFonts.mulish(
                                                //       color: Colors.white,
                                                //       fontSize: 12.sp,
                                                //       fontWeight: FontWeight.w400,
                                                //       height: 0,
                                                //       letterSpacing: -0.24,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Color.fromRGBO(168, 3, 3, 1),
                                      ),
                                      Text(
                                        ' ${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                                        style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 30, top: 30),
                                child: Container(
                                  width: 80.w,
                                  height: 125.h,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          LoadingScreen.showLoading(context,
                                              duration: Duration(seconds: 10));
                                          // Loading.showLoading(context);
                                          checkInternetConnection()
                                              .then((result) {
                                            if (result.contains(
                                                'Connected to the internet')) {
                                              DatabaseHelper.instance.syncUp();
                                              SharedPreferencesHelper
                                                  .removeUserInfo('userInfo');
                                              Get.to(NewLoginScreen());
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Internet Connection Status"),
                                                    content: Text(
                                                        "You Device Is Not Connected To Internet"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text("OK"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          });

                                          // await DatabaseHelper.instance
                                          //     .syncUp();
                                          // SharedPreferencesHelper
                                          //     .removeUserInfo('userInfo');
                                          // Get.to(NewLoginScreen());
                                        },
                                        child: Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFA80303),
                                            shape: OvalBorder(
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF292929)),
                                            ),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'images/svg/logout.svg',
                                              height: 20.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 20.h,
                                      // ),
                                      // InkWell(
                                      //   onTap: () async {
                                      //     LoadingScreen.showLoading(context);
                                      //     await DatabaseHelper.instance
                                      //         .syncUp();
                                      //   },
                                      //   child: Container(
                                      //     width: 50.w,
                                      //     height: 50.h,
                                      //     decoration: ShapeDecoration(
                                      //       color: Color(0xFFA80303),
                                      //       shape: OvalBorder(
                                      //         side: BorderSide(
                                      //             width: 1,
                                      //             color: Color(0xFF292929)),
                                      //       ),
                                      //     ),
                                      //     child: Center(
                                      //         child: Icon(
                                      //       Icons.file_upload_outlined,
                                      //       color: Colors.white,
                                      //     )),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   right: 10,
                    //   top: 30,
                    //   child: SvgPicture.asset(
                    //     'images/svg/dotbox.svg',
                    //     height: 150,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'Sync Up',
                    // onPress: () async {
                    //   LoadingScreen.showLoading(context,
                    //       duration: Duration(seconds: 10));
                    //   await DatabaseHelper.instance.syncUp().then((value) {
                    //     CustomToast(context).success('Sync up successful!');
                    //   }).catchError((error) {
                    //     // SharedPreferencesHelper.removeUserInfo('userInfo');
                    //     // Get.to(NewLoginScreen());
                    //     CustomToast(context).error('Sync up failed!');
                    //   });
                    // }
                    onPress: () {
                      // Check internet connection
                      checkInternetConnection().then((result) async {
                        if (result.contains('Connected to the internet')) {
                          try {
                            // Show second loading screen for sync operations
                            LoadingScreen.showLoading(context,
                                duration: Duration(seconds: 10));

                            // Perform sync operations
                            await DatabaseHelper.instance.syncUp();
                            await DatabaseHelper.instance.refreshDatabase();
                            await DatabaseHelper.instance.syncDataFromServer();

                            // Show success toast and wait for 2 seconds
                            CustomToast(context).success('Sync up successful!');
                            await Future.delayed(Duration(seconds: 2));

                            // Show loading screen again for refreshing data
                            // LoadingScreen.showLoading(context,
                            //     duration: Duration(seconds: 5));
                            CustomToast(context).warn('Refreshing your data');
                          } catch (error) {
                            CustomToast(context).error('Sync up failed!');
                          } finally {
                            // Ensure the loading screen is dismissed in the end
                            Loading.hideLoading();
                          }
                        } else {
                          // Show alert dialog if not connected to the internet
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Internet Connection Status"),
                                content: Text(
                                    "Your device is not connected to the internet."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }).catchError((error) {
                        // Handle errors if internet connection check fails
                        Navigator.of(context)
                            .pop(); // Dismiss initial loading screen if error occurs
                        CustomToast(context)
                            .error('Error checking internet connection!');
                      });
                    }

                    // onPress: () {
                    //   Loading.showLoading(context);
                    //   checkInternetConnection().then((result) async {
                    //     if (result.contains('Connected to the internet')) {
                    //       try {
                    //         LoadingScreen.showLoading(context,
                    //             duration: Duration(seconds: 10));
                    //         DatabaseHelper.instance
                    //             .syncUp()
                    //             .then((value) async {
                    //           {
                    //             await DatabaseHelper.instance.refreshDatabase();
                    //           }
                    //         }).whenComplete(() async {
                    //           await DatabaseHelper.instance
                    //               .syncDataFromServer()
                    //               .then((value) {
                    //             // CustomToast(context).success('Sync up successful!');
                    //           }).catchError((error) {
                    //             SharedPreferencesHelper.removeUserInfo(
                    //                 'userInfo');
                    //             Get.to(NewLoginScreen());
                    //             Utils.SnackBar('Error',
                    //                 'Your App Version Is Old Please Update App ');
                    //             // CustomToast(context).error('Sync up failed!');
                    //           });
                    //         });

                    //         CustomToast(context).success('Sync up successful!');
                    //         // Wait for 2 seconds after the success toast
                    //         await Future.delayed(Duration(seconds: 2));

                    //         //  Loading.showLoading(context); // Show loading again
                    //         LoadingScreen.showLoading(context,
                    //             duration: Duration(seconds: 5));
                    //         CustomToast(context).warn('Refreshing your data');
                    //       } catch (error) {
                    //         CustomToast(context).error('Sync up failed!');
                    //       } finally {
                    //         Loading.hideLoading();
                    //       }
                    //     } else {
                    //       showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return AlertDialog(
                    //             title: Text("Internet Connection Status"),
                    //             content: Text("You Device Is Not Connected To"),
                    //             actions: <Widget>[
                    //               TextButton(
                    //                 child: Text("OK"),
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     }
                    //   });
                    // }

                    ),
              ),
              SizedBox(
                height: 10,
              ),

              if (data?['permissions'] != null &&
                  data?['permissions']['id_asset_and_tag'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card1.svg',
                  title: 'ID Asset & Tag',
                  onPress: () {
                    Get.to(NewAssetsAdding(
                      CrunnetLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),

              if (data?['permissions'] != null &&
                  data?['permissions']['transport_container_tag'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card2.svg',
                  title: 'Transport Container',
                  onPress: () {
                    Get.to(TransportContainerPage());
                  },
                ),
              if (data?['permissions'] != null &&
                  data?['permissions']['vessel'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card3.svg',
                  title: 'Vessel',
                  onPress: () {
                    Get.to(VesselsPages(
                      currentlocationid:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                      currentID:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['active_location']}',
                    ));
                  },
                ),

              if (data?['permissions'] != null &&
                  data?['permissions']['container'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card1.svg',
                  title: 'Create Container',
                  onPress: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return SizedBox(
                            child: AddContainer(
                          Screenkey: '123',
                        ));
                      },
                    );
                  },
                ),

              //Quayside

              if (data?['permissions'] != null &&
                  data?['permissions']['arrival_at_quayside'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/qside.svg',
                  title: 'Arrival At Quayside',
                  onPress: () {
                    Get.to(ArrivalAtQuaysidePage(
                      ActiveLocationid:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['active_location']}',
                      CurrentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),
              // Receipt Yard
              if (data?['permissions'] != null &&
                  data?['permissions']['receipt_yard'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card3.svg',
                  title: 'Receipt Yard',
                  onPress: () {
                    Get.to(ReceiptYardPage(
                      ActiveLocationid:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['active_location']}',
                      Location:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),
              // RigidPipes
              if (data?['permissions'] != null &&
                  data?['permissions']['tag_rigid_pipes'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card2.svg',
                  title: 'Tag Rigid Pipes',
                  onPress: () {
                    Get.to(TagsRigidsPipes(
                      currentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),
              if (data?['permissions'] != null &&
                  data?['permissions']['tag_ancillary_batch'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card1.svg',
                  title: 'Tag Ancillary Batch',
                  onPress: () {
                    Get.to(TagsRigidsPipes(
                      title: 'Tag Ancillary Batch',
                      currentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),
              if (data?['permissions'] != null &&
                  data?['permissions']['tag_hazmat_waste'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card3.svg',
                  title: 'Tag HazMat Waste',
                  onPress: () {
                    Get.to(TagHazmatWaste());
                  },
                ),

              if (data?['permissions'] != null &&
                  data?['permissions']['move_to_yard_storage'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card1.svg',
                  title: 'Move to Yard Storage',
                  onPress: () {
                    Get.to(MoveToYardStorage());
                  },
                ),

              if (data?['permissions'] != null &&
                  data?['permissions']['unbundle_and_tag_flexibles'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card3.svg',
                  title: 'Unbundle & Tag Flexibles',
                  onPress: () {
                    Get.to(UnbundlingAndTagFlexiblePage(
                      CurrentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),

              if (data?['permissions'] != null &&
                  data?['permissions']['screen_assets'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card2.svg',
                  title: 'Screen Assets',
                  onPress: () {
                    Get.to(ScreenAssetsPage(
                      Screening_Type: ScreeningType.SCREENING,
                      CurrentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),

              // here goest the DecontaminationPage page
              if (data?['permissions'] != null &&
                  data?['permissions']['clean_and_decontam'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card1.svg',
                  title: 'Clean & Decontam',
                  onPress: () {
                    Get.to(DecontaminationPage(
                      CurrentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),
              // Receival page
              if (data?['permissions'] != null &&
                  data?['permissions']['post_screening'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card2.svg',
                  title: 'Post Screening',
                  onPress: () {
                    Get.to(ScreenAssetsPage(
                        CurrentLocation:
                            '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                        Screening_Type: ScreeningType.POST_SCREENING));
                  },
                ),
              if (data?['permissions'] != null &&
                  data?['permissions']['clearance'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/card2.svg',
                  title: 'Clearance',
                  onPress: () {
                    Get.to(Clearance(
                      CurrentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),
              if (data?['permissions'] != null &&
                  data?['permissions']['receival'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/receviel.svg',
                  title: 'Receival',
                  onPress: () {
                    Get.to(ReceivelPage(
                        CurrentLocation:
                            '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                        ActiveLocationid:
                            '${(data?['profile'] == null) ? 'Loading...' : data?['active_location']}'));
                  },
                ),

              if (data?['permissions'] != null &&
                  data?['permissions']['disposal_unbundle_and_tag_flexibles'] ==
                      true)
                RoundedCard(
                  svgAsset: 'images/svg/card3.svg',
                  title: 'Unbundle & Tag Flexibles',
                  onPress: () {
                    Get.to(UnbundlingAndTagFlexiblePage(
                      CurrentLocation:
                          '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                    ));
                  },
                ),
              if (data?['permissions'] != null &&
                  data?['permissions']['disposal'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/waste.svg',
                  title: 'Disposal',
                  onPress: () {
                    data?['location_name'] == 'Onslow Disposal Yard' ||
                            data?['location_name'] == 'Karratha Disposal Yard'
                        ? Get.to(YardDisposal(
                            CurrentLocation:
                                '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                          ))
                        : Get.to(DisposalPage(
                            CurrentLocation:
                                '${(data?['profile'] == null) ? 'Loading...' : data?['location_name']}',
                          ));
                  },
                ),
              if (data?['permissions'] != null &&
                  data?['permissions']['release_container'] == true)
                RoundedCard(
                  svgAsset: 'images/svg/waste.svg',
                  title: 'Release Container',
                  onPress: () {
                    Get.to(ContainerRelease());
                  },
                ),

              SizedBox(
                height: 160.h,
              )
            ],
          );
        } else {
          return Center(child: Text('Data is null'));
        }
      },
    ));
  }
}

class RoundedCard extends StatelessWidget {
  final String svgAsset;
  final String title;
  final VoidCallback onPress;

  RoundedCard(
      {Key? key,
      required this.svgAsset,
      required this.title,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          width: 350.w,
          height: 143.h,
          decoration: ShapeDecoration(
            color: Color(0xFFF0F0F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 200.w,
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Color(0xFF262626),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.36,
                    ),
                  ),
                ),
              ),
              Container(
                width: 112.17.w,
                height: 107.67.h,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    svgAsset,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
