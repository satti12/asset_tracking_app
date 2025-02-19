import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/New%20Design/Boarding%20Screen/Splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'SharedPrefrence/SharedPrefrence.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/services.dart';

TextEditingController rf_id = TextEditingController();
const MethodChannel _channel = MethodChannel('utfCode');

Future<void> sendActionToNative(String action) async {
  try {
    await _channel.invokeMethod('sendActionToNative', {'action': action});
  } catch (e) {
    print('Error: $e');
  }
}

// Future<void> _handleMethod(MethodCall call, TextEditingController rf_id) async {
//   if (call.method == 'receiveData') {
//     String? receivedData = call.arguments;
//     String cleanedData =
//         receivedData?.replaceAll(RegExp(r'[\sEPC:]+'), '') ?? '';
//     rf_id.text = cleanedData;
//     //   rf_id.text = receivedData ?? '';
//     print('Clean Data: $cleanedData');

//     print('Received Data: $receivedData');
//     // Do something with the received data in your Flutter app
//   }
// }

Future<void> _handleMethod(MethodCall call, TextEditingController rf_id) async {
  if (call.method == 'receiveData') {
    String? receivedData = call.arguments;
    // Remove only spaces and the "EPC:" prefix
    String cleanedData =
        receivedData?.replaceAll('EPC:', '').replaceAll(' ', '') ?? '';
    rf_id.text = cleanedData;
    print('Clean Data: $cleanedData');
    print('Received Data: $receivedData');
    // Do something with the received data in your Flutter app
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;
  await DefaultCacheManager().emptyCache();
  // Check if access token exists in SharedPreferences

  final hasUserInfo = await SharedPreferencesHelper.hasUserInfo();

  // MethodChannel initialization
  const MethodChannel channel = MethodChannel('utfCode');
  channel.setMethodCallHandler((call) => _handleMethod(call, rf_id));

  runApp(MyApp(hasUserInfo: hasUserInfo, textEditingController: rf_id));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool hasUserInfo;

  final TextEditingController textEditingController;

  MyApp({required this.hasUserInfo, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Asset Tracking',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.white, brightness: Brightness.light),
              useMaterial3: true,
            ),
            home:
                //MYLocal()
                hasUserInfo
                    ? NewBottomNavigation()
                    // BottomNavigation()
                    : SplashScreen(),
          );
        });
  }
}
