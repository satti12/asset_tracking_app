import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Repository/CreateShipment_Repository/Voyages_Repository/fetch_voyage_containerList_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'HistoryTabContainer.dart/HistoryTabContainer_com.dart';

class VoyageHistoryTab extends StatefulWidget {
  const VoyageHistoryTab({Key? key});

  @override
  State<VoyageHistoryTab> createState() => _VoyageHistoryTabState();
}

class _VoyageHistoryTabState extends State<VoyageHistoryTab> {
  Future<List<Asset>?>? fetch_voyage(
    String? vessel_id,
    String? from_location_id,
    // String searchTerm,
  ) async {
    final voyages = await DatabaseHelper.instance.queryList('voyages', [
      ['vessel_id', '=', vessel_id],
      ['from_location_id', '=', from_location_id],
    ], {
      // 'searchColumns': ['rf_id', 'product_id'],
      // 'searchValue': searchTerm
    });

    if (voyages != null) {
      final voyageJson = voyages.map((json) => Voyage.fromJson(json)).toList();

      var voyageData = {};
      for (var voyage in voyageJson) {
        voyageData[voyage.voyage_id] = voyage;
      }
      ;

      final voyage_ids = voyageJson.map((obj) => obj.voyage_id).toList();

      var voyage_ids_string = '';
      voyage_ids.asMap().forEach((index, id) {
        voyage_ids_string += '"$id"';

        if (index != voyage_ids.length - 1) {
          voyage_ids_string += ', ';
        }
      });

      final voyage_assets =
          await DatabaseHelper.instance.queryList('voyage_assets', [
        ['voyage_id', 'IN', '($voyage_ids_string)'],
      ], {});

      if (voyage_assets != null) {
        final voyageAssetJson =
            voyage_assets.map((json) => VoyageAsset.fromJson(json)).toList();

        var voyageAssetData = {};
        for (var voyage_asset in voyageAssetJson) {
          voyageAssetData[voyage_asset.asset_id] = voyage_asset.voyage_id;
        }
        ;

        final asset_ids = voyageAssetJson.map((obj) => obj.asset_id).toList();

        var asset_ids_string = '';
        asset_ids.asMap().forEach((index, id) {
          asset_ids_string += '"$id"';

          if (index != asset_ids.length - 1) {
            asset_ids_string += ', ';
          }
        });

        final assets = await DatabaseHelper.instance.queryList('assets', [
          //['status', '=', AssetStatus.IN_TRANSIT],
          ['asset_id', 'IN', '($asset_ids_string)'],
        ], {
          //  'searchColumns': ['rf_id', 'product_id'],
          //  'searchValue': searchTerm
        });

        final resp = assets?.map((json) => Asset.fromJson(json)).toList();

        if (resp != null) {
          for (var row in resp) {
            row.vessel = voyageData[voyageAssetData[row.asset_id]].vessel;
            row.voyage_origin =
                voyageData[voyageAssetData[row.asset_id]].from_location;
            row.voyage_destination =
                voyageData[voyageAssetData[row.asset_id]].to_location;
          }
        }
        ;

        print(resp);

        return resp;
      } else {
        throw Exception('Failed to load containers');
      }
    } else {
      throw Exception('Failed to load containers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 350.w,
              height: 48,
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
                    SvgPicture.asset('images/svg/filter.svg'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            FutureBuilder<List<Asset>?>(
              future: fetch_voyage('', ''),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No containers available');
                } else {
                  return Column(
                    children: snapshot.data!.asMap().entries.map((entry) {
                      // final index = entry.key;
                      final markquayside = entry.value;

                      return FutureBuilder<List<Asset>?>(
                          future: fetchAssetItemInVessel(markquayside),
                          builder: (context, itemSnapshot) {
                            if (itemSnapshot.hasError) {
                              return Text('Error: ${itemSnapshot.error}');
                            } else {
                              //   final index = entry.key;
                              var items = itemSnapshot.data;
                              List<String>? productNos;
                              List<String>? productName;
                              List<String>? bundle;
                              List<String>? batch;
                              List<String>? drum_no;
                              List<String>? no_of_joint;
                              List<String>? no_of_length;

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

                                no_of_joint = items
                                    .where((obj) => obj.no_of_joints != null)
                                    .map((obj) => obj.no_of_joints.toString())
                                    .toList();

                                no_of_length = items
                                    .where((obj) => obj.no_of_lengths != null)
                                    .map((obj) => obj.no_of_lengths.toString())
                                    .toList();
                              }

                              String getTFMCID() {
                                if (markquayside.asset_type.toString() ==
                                    'Container') {
                                  var result;

                                  result = productNos != null &&
                                          productNos.length > 0
                                      ? '${productNos.map((item) => 'TFMC ID# $item').join('\n')}'
                                      : 'Drum # ${drum_no?.map((item) => 'Drum# $item').join('\n')}';

                                  //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                  return result;
                                } else {
                                  return 'TFMC ID # ${markquayside.product_no}';
                                }
                              }

                              String getProduct() {
                                if (markquayside.asset_type.toString() ==
                                    'Container') {
                                  var result;

                                  result = productName != null &&
                                          productName.length > 0
                                      ? '${productName.map((item) => '$item').join('\n')}'
                                      : 'Drum # ${productName?.map((item) => '$item').join('\n')}';

                                  //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                  return result;
                                } else {
                                  return '${markquayside.product}';
                                }
                              }

                              String getbndle() {
                                if (markquayside.asset_type.toString() ==
                                    'Container') {
                                  var result;

                                  result = bundle != null && bundle.length > 0
                                      ? '${bundle.map((item) => 'Bundle# $item').join('\n')}'
                                      : '';

                                  result += batch != null && batch.length > 0
                                      ? '\n${batch.map((item) => 'Batch # $item').join('\n')}'
                                      : '';

                                  //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                  return result;
                                } else {
                                  return '';
                                }
                              }

                              String getlength() {
                                if (markquayside.asset_type.toString() ==
                                    'Container') {
                                  var result;

                                  result = no_of_joint != null &&
                                          no_of_joint.length > 0
                                      ? '${no_of_joint.map((item) => 'No of joint$item').join('\n')}'
                                      : ' ${no_of_length?.map((item) => 'No of Length $item').join('\n')}';

                                  //        '${productNos != null ? '' : productNos!.map((item) => '$item').join('\n')}';

                                  return result;
                                } else {
                                  return '${markquayside.product}';
                                }
                              }

                              String convertUnixTimestamp(int unixTimestamp) {
                                // Convert Unix timestamp to milliseconds (Dart uses milliseconds, not seconds)
                                DateTime dateTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        unixTimestamp * 1000,
                                        isUtc: true);

                                // Format the DateTime object as '(Mon DD, YYYY HH:mm UTC)'
                                String formattedTime =
                                    DateFormat("MMM dd, yyyy HH:mm 'UTC'")
                                        .format(dateTime);

                                return '($formattedTime)';
                              }

                              String formattedTime = convertUnixTimestamp(
                                  markquayside.date_added!.toInt());

                              String deliveredTime = convertUnixTimestamp(
                                  markquayside.date_updated!.toInt());
                              List<Widget> buildDialogContent(markquayside) {
                                List<Widget> content = [];

                                content.add(
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('${getProduct()}'),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (markquayside.asset_type
                                                    .toString() ==
                                                'Container')
                                              Text('${getlength()}'),
                                            if (markquayside.asset_type
                                                    .toString() ==
                                                'Container')
                                              Text('${getlength()}'),
                                            // Add more details based on your requirements
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                                return content;
                              }

                              return GestureDetector(
                                onTap: () {
                                  // Show dialog here and print the selected index
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        width: 500,
                                        child: AlertDialog(
                                          title: Text('Details'),
                                          content: Container(
                                            height: 400,
                                            // Adjust the height as needed
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: buildDialogContent(
                                                  markquayside),
                                              //   children: [
                                              //     Container(
                                              //       height: 200,
                                              //       color: Colors.red,
                                              //       child: Row(children: [
                                              //         Container(
                                              //           width: 150,
                                              //           color: Colors.yellow,
                                              //           child: Column(
                                              //             children: [
                                              //               // Text('${getTFMCID()}'),
                                              //               Text(
                                              //                   '${getProduct()}'),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //         Column(
                                              //           children: [
                                              //             Text('${getlength()}'),
                                              //             // Text('${getbndle()}'),
                                              //             // Text('${getlength()}'),
                                              //           ],
                                              //         )
                                              //       ]),
                                              //     )

                                              //     // Add more details based on your requirements
                                              //   ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: HistorytabContainer(
                                  voyageNumber: '',
                                  // getTFMCID(),
                                  deliveryStatus:
                                      markquayside.status.toString(),
                                  personName: markquayside.vessel.toString(),
                                  // asset_type ==
                                  //         'Container'
                                  //     ? markquayside.container_type.toString()
                                  //     : markquayside.asset_type.toString(),
                                  location1:
                                      markquayside.voyage_origin.toString(),
                                  location2: markquayside.voyage_destination
                                      .toString(),
                                  dispatched1: 'Dispatched',
                                  dispatched2: 'Delivered',
                                  dateTime1: '$formattedTime',
                                  dateTime2: '$deliveredTime',
                                ),
                              );
                            }
                          });
                    }).toList(),
                  );
                }
              },
            ),
            // HistorytabContainer(
            //   voyageNumber: 'RPA0001',
            //   deliveryStatus: 'Delivered',
            //   personName: 'Miss Nora Barge',
            //   location1: 'Enfield',
            //   location2: 'Dampier Quayside',
            //   dispatched1: 'Dispatched',
            //   dispatched2: 'Dispatched',
            //   dateTime1: '03 Sep 23  8:14 UTC',
            //   dateTime2: '03 Sep 23  8:14 UTC',
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            // HistorytabContainer(
            //   voyageNumber: 'RPA0001',
            //   deliveryStatus: 'Delivered',
            //   personName: 'Miss Nora Barge',
            //   location1: 'Enfield',
            //   location2: 'Dampier Quayside',
            //   dispatched1: 'Dispatched',
            //   dispatched2: 'Dispatched',
            //   dateTime1: '03 Sep 23  8:14 UTC',
            //   dateTime2: '03 Sep 23  8:14 UTC',
            // ),
          ],
        ),
      ),
    );
  }
}
