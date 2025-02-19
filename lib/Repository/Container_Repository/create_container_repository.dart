// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:get/get.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:intl/intl.dart';

Future<void> create_Newcontainer(
  String id,
  String containerTypeid,
  String containerType,
  String container_serial_number,
  String container_dimention,
  String tare_weight,
) async {
  final Map<String, dynamic> requestData = {
    "rf_id": id,
    "container_type_id": containerTypeid,
    "container_type": containerType,
    "container_serial_number": container_serial_number,
    "dimension": container_dimention,
    "asset_type": 'Container',
    "approximate_weight": tare_weight,
    // Use the assetIds list directly
  };
  Asset assetsobject = new Asset(
    rf_id: id,
    container_type_id: containerTypeid,
    container_serial_number: container_serial_number,
    dimensions: container_dimention,
    asset_type: AssetType.CONTAINER,
    classification: Classification.NON_CONTAMINATED,
    approximate_weight: double.parse(tare_weight),
  );

  try {
    Asset modifiedAsset =
        await DatabaseHelper.instance.createAsset(assetsobject);

    AssetLog log = new AssetLog();
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.ASSET_CREATED;
    String assetType = assetsobject.asset_type.toString();
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            ?.toString();
    Map<String, String> variables = {
      'container_type': containerType,
      'rf_id': assetsobject.rf_id.toString(),
      'container_serial_number':
          assetsobject.container_serial_number.toString(),
      'current_location': userInfo['location_name'],
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = assetsobject.asset_id.toString();
    log.rf_id = assetsobject.rf_id.toString();
    log.current_transaction = jsonEncode(modifiedAsset.toMap());
    log.container_type_id = containerTypeid.toString();
    log.status = assetsobject.status.toString();
    log.event_type = eventType;
    log.asset_type = assetsobject.asset_type.toString();
    log.event_description = eventDesc;
    log.current_location_id = userInfo['locationId'];
    DatabaseHelper.instance.createAssetLog(log);

    Get.to(NewBottomNavigation());
  } catch (e) {
    Utils.SnackBar('Error', e.toString());
    throw Exception(e.toString());
  }
}

Future<void> loadNewContainer(
  Asset container,
  List<Asset> items,
) async {
  await DatabaseHelper.instance
      .createAsset(container, items: items)
      .whenComplete(() async {
    AssetLog log = new AssetLog();
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.LOADED;
    String assetType = WITH_CONTAINER;
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            ?.toString();
    Map<String, String> variables = {
      'rf_id': container.rf_id.toString(),
      'container_type': container.container_type.toString(),
      'container_rfid': container.rf_id.toString(),
      'current_location': userInfo['location_name'],
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = container.asset_id.toString();
    log.rf_id = container.rf_id.toString();
    log.asset_type = container.asset_type;
    log.current_transaction = jsonEncode(container.toMap());
    log.event_type = eventType;
    log.container_type_id = container.container_type_id;
    log.status = container.status.toString();
    log.event_description = eventDesc;
    log.current_location_id = userInfo['locationId'];
    DatabaseHelper.instance.createAssetLog(log);
  });

  for (var item in items) {
    final result = await DatabaseHelper.instance
        .queryUnique('assets', 'asset_id', item.asset_id);

    final resp = result?.map((json) => Asset.fromJson(json)).toList();
    Asset? res = resp?[0];

    AssetLog log = new AssetLog();
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.LOADED;
    String assetType = INSIDE_CONTAINER;
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            ?.toString();
    Map<String, String> variables = {
      'asset_type': item.asset_type.toString(),
      'rf_id': item.rf_id.toString(),
      'container_type': container.container_type.toString(),
      'container_rfid': container.rf_id.toString(),
      'current_location': userInfo['location_name'],
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = item.asset_id.toString();
    log.rf_id = item.rf_id.toString();
    log.asset_type = res?.asset_type;
    log.current_transaction = jsonEncode(res?.toMap());
    log.event_type = eventType;
    log.container_type_id = item.container_type_id;
    //container.container_type_id
    log.status = res?.status.toString();
    log.event_description = eventDesc;
    log.current_location_id = userInfo['locationId'];
    DatabaseHelper.instance.createAssetLog(log);
  }
  Get.to(NewBottomNavigation());
}

Future<void> loadNoContainer(
  List<Asset> items,
) async {
  for (var item in items) {
    item.status = AssetStatus.LOADED;
    item.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    item.is_sync = 0;
    final assetMap = item.toMap();
    final filteredMap = Map.fromEntries(
        assetMap.entries.where((element) => element.value != null));
    filteredMap.remove('asset_id');
    filteredMap.remove('product');
    filteredMap.remove('product_no');
    filteredMap.remove('pulling_line');
    filteredMap.remove('container_type');
    filteredMap.remove('drum_type');
    filteredMap.remove('waste_type');

    await DatabaseHelper.instance
        .update('assets', 'asset_id', item.asset_id, filteredMap);
    final result = await DatabaseHelper.instance
        .queryUnique('assets', 'asset_id', item.asset_id);

    final resp = result?.map((json) => Asset.fromJson(json)).toList();
    Asset? res = resp?[0];

    AssetLog log = new AssetLog();
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    String eventType = EventType.LOADED;
    String assetType = WITHOUT_CONTAINER;
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            ?.toString();
    Map<String, String> variables = {
      'asset_type': item.asset_type.toString(),
      'rf_id': item.rf_id.toString(),
      'current_location': userInfo['location_name'],
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = item.asset_id.toString();
    log.rf_id = item.rf_id.toString();
    log.event_type = eventType;
    log.asset_type = res?.asset_type;
    log.status = res?.status;
    log.current_transaction = jsonEncode(res?.toMap());
    log.event_description = eventDesc;
    log.current_location_id = userInfo['locationId'];
    DatabaseHelper.instance.createAssetLog(log);

    // final data = await DatabaseHelper.instance.queryList('screenings', [
    //   ['asset_id', '=', item.asset_id],
    //   ['screening_type', '=', ScreeningType.INITIAL_SCREENING],
    // ], {});
    // var screenig_id;
    // if (data != null && data.length > 0) {
    //   final List<AssetScreening> response =
    //       data.map((json) => AssetScreening.fromJson(json)).toList();

    //   // Populate the TextFormFields with user data
    //   screenig_id = response[0].screening_id.toString();

    AssetScreening screening = AssetScreening(
      adg_class: item.adg_class, // Use the adg_class from the current item
      un_number: item.un_number,
      dose_rate: double.tryParse(item.dose_rate.toString()),
      class_7_category: item.class_7_category,
      is_sync: 0,
    );

    final screeningMap = screening.toMap();
    final filteredScreeningMap = Map.fromEntries(
        screeningMap.entries.where((element) => element.value != null));

    await DatabaseHelper.instance.update(
        'asset_screenings', 'asset_id', item.asset_id, filteredScreeningMap);
    // }

    // String screeningId =
    //     await DatabaseHelper.instance.createAssetScreening(screening);
  }
  Get.to(NewBottomNavigation());
}
