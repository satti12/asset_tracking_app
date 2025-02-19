import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // static Future<void> saveAccessToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('accessToken', token);
  // }

  // static Future<String?> retrieve(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(key);
  // }

  // static Future<void> remove(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove(key);
  // }

  // static Future<bool> hasAccessToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final accessToken = prefs.getString('accessToken');
  //   return accessToken != null;
  // }

  static Future<void> saveUserInfo(info) async {
    String userJson = jsonEncode(info);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', userJson);
  }

  static Future retrieveUserInfo(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? info = prefs.getString(key);
    if (info != null) {
      Map<String, dynamic> userMap = jsonDecode(info);
      return {
        'user_id': userMap['user_id'],
        'name': userMap['name'],
        'user_name': userMap['user_name'],
        'password': userMap['password'],
        'locationId': userMap['locationId'],
        'location_name': userMap['location_name'],
        'app_version': userMap['app_version'],
      };
    }
    return null;
  }

  static Future<void> removeUserInfo(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<bool> hasUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfo = prefs.getString('userInfo');
    return userInfo != null;
  }
}
