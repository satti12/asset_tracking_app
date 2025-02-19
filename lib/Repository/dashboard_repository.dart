import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/login.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/URL/url.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> fetchDashboard(BuildContext context) async {
  final response = await makeDashboardData();
  if (response == null) {
    // Session expired, show dialog box and logout user
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Expired'),
          content: Text('Your session has expired. Please login again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                SharedPreferencesHelper.removeUserInfo('userInfo');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => NewLoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
  return response;
}

Future makeDashboardData() async {
  final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

  if (userInfo == null) {
    return null;
  }
  final locationId = userInfo['locationId'];
  final name = userInfo['name'];
  final password = userInfo['password'];
  final location = await DatabaseHelper.instance
      .queryUnique('operating_locations', 'operating_location_id', locationId);
  final user =
      await DatabaseHelper.instance.queryUnique('users', 'phone', name);

  if (password != user?[0]['password']) {
    SharedPreferencesHelper.removeUserInfo('userInfo');
    Get.to(NewLoginScreen());
  }

  final permissions = {
    'id_asset_and_tag': false,
    'transport_container_tag': false,
    'vessel': false,
    'arrival_at_quayside': false,
    'receipt_yard': false,
    'tag_rigid_pipes': false,
    'tag_ancillary_batch': false,
    'move_to_yard_storage': false,
    'unbundle_and_tag_flexibles': false,
    'screen_assets': false,
    'clean_and_decontam': false,
    'receival': false,
    'disposal': false,
    'waste_disposal': false,
    'tag_hazmat_waste': false,
    'post_screening': false,
    'clearance': false,
    'disposal_unbundle_and_tag_flexibles': false,
    'release_container': false,
    'container': false
  };

  final profile = {
    'id': user?[0]['user_id'],
    'role': 'admin',
    'name': user?[0]['name'],
    'email': user?[0]['email'],
    'avatar': '$baseurl/assets/images/avatars/placeholder.png',
    'status': user?[0]['status'],
    'about': user?[0]['about'],
    'phone': user?[0]['phone'],
    'twoStep': user?[0]['two_factor_enabled'],
    'email_verified': user?[0]['email_verified'],
    'last_login': user?[0]['last_login'],
  };

  if (location?[0]['type'] == LocationType.FIELD) {
    permissions['id_asset_and_tag'] = true;
    permissions['transport_container_tag'] = true;
    permissions['vessel'] = true;
    permissions['container'] = true;
  } else if (location?[0]['type'] == LocationType.QUAYSIDE) {
    permissions['arrival_at_quayside'] = true;
  } else if (location?[0]['type'] == LocationType.DECONTAM_YARD) {
    permissions['receipt_yard'] = true;
    permissions['tag_rigid_pipes'] = true;
    permissions['tag_ancillary_batch'] = true;
    permissions['unbundle_and_tag_flexibles'] = true;
    permissions['screen_assets'] = true;
    permissions['clean_and_decontam'] = true;
    permissions['disposal'] = true;
    permissions['waste_disposal'] = true;
    permissions['tag_hazmat_waste'] = true;
    permissions['move_to_yard_storage'] = true;
    permissions['post_screening'] = true;
    permissions['clearance'] = true;
    permissions['release_container'] = true;
  } else if (location?[0]['type'] == LocationType.DISPOSAL_YARD) {
    permissions['receival'] = true;
    permissions['disposal'] = true;
    permissions['disposal_unbundle_and_tag_flexibles'] = true;
    permissions['release_container'] = true;
  }

  final response = {
    'profile': profile,
    'permissions': permissions,
    'active_location': locationId,
    'location_name': location?[0]['name'] + ' ' + location?[0]['type']
  };

  return response;
}
