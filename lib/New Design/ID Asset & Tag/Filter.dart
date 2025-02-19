// ignore_for_file: must_be_immutable

import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/ID%20Asset%20&%20Tag/Tag%20_Assets.dart';
import 'package:flutter/material.dart';

class NewFilterCustomSnackbar extends StatefulWidget {
  String type;
  String? isbatch;
  String? CurrentLocation;

  NewFilterCustomSnackbar(
      {super.key, required this.type, this.isbatch, this.CurrentLocation});

  @override
  _NewFilterCustomSnackbarState createState() =>
      _NewFilterCustomSnackbarState();
}

class _NewFilterCustomSnackbarState extends State<NewFilterCustomSnackbar> {
  // FilterList? apiData;
  var apiData;
  // // Store API response data
  String? selectedFilter; // Store the selected filter
  String? filterid;
  @override
  void initState() {
    super.initState();
    selectedFilter = null; // Initially, no filter is selected
    fetchData(widget.type);
  }

  Future<void> fetchData(String type) async {
    try {
      final List<ProductType?>? response =
          await DatabaseHelper.instance.queryProductTypes(type);

      setState(() {
        apiData = response;
      });
    } catch (error) {
      // Handle network error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Your existing widget code
      child: Column(
        children: [
          // Add radio buttons here

          Expanded(
            child: ListView.builder(
              itemCount: apiData.length ?? 0,
              itemBuilder: (context, index) {
                final item = apiData?[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          filterid = item?.product_type_id;
                          fetchData(
                            widget.type,
                          );
                          //     Navigator.pop(context, filterid);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) {
                                // Return the widget that represents the screen you want to navigate to
                                return Tag_Flexibles(
                                  Status: widget.type,
                                  filter: filterid,
                                  IsBatch: widget.isbatch,
                                  Location: widget.CurrentLocation,
                                );
                              },
                            ),
                          );
                        });

                        // Navigator.pop(context);
                      },
                      title: Text(item?.name ?? ''),
                      //subtitle: Text(item?.productTypeId ?? ''),
                      // Customize the appearance of other data as needed
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
