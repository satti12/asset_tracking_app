import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:get/get.dart';

RxBool loading = false.obs;

Future<Map<String, dynamic>> Login(String name, String password,
    String locationId, String location_name, String AppVersion) async {
  try {
    final response =
        await DatabaseHelper.instance.queryUnique('users', 'phone', name);

    if (response!.isNotEmpty) {
      final user = response[0];
      final enc_password = user['password'];
      final app_access = user['app_access'];

      if (password != enc_password) {
        throw Exception('Username Password Mismatch');
      }
      if (app_access == 0) {
        throw Exception('User Not Allow to Access the app');
      }
      print(user);
      final userInfo = {
        'user_id': user['user_id'],
        'name': name,
        'user_name': user['name'],
        'password': password,
        'locationId': locationId,
        'location_name': location_name,
        'app_version': AppVersion
      };
      await SharedPreferencesHelper.saveUserInfo(userInfo);
      Get.to(NewBottomNavigation()
          // BottomNavigation()
          );
      //Get.to(Dashboard());
      // print(responseData);
      return userInfo;
    } else {
      throw Exception('Username Password Mismatch');
    }
  } catch (e) {
    print('Error: $e');
    Utils.SnackBar('Warning', '$e');
    loading.value = false;
    throw e; // Rethrow the error to handle it at the calling code if needed
  } finally {
    loading.value =
        false; // Set loading to false when the request completes (whether success or failure)
  }
}
