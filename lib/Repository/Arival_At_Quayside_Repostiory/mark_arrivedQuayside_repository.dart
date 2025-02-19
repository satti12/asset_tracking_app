import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> mark_arrived_at_yard(
  List<Asset> assets,
) async {
  // try {
  await DatabaseHelper.instance.markMultipleArrivedAtYard(
    assets,
  );
  for (var item in assets) {
    final data = await DatabaseHelper.instance.queryList('asset_track_logs', [
      ['asset_id', '=', item.asset_id],
    ], {});

    var fromLocationId = null;
    var fromLocation = '';
    if (data != null && data.length > 0) {
      fromLocationId = data[0]['from_location'];
      final location = await DatabaseHelper.instance.queryUnique(
          'operating_locations', 'operating_location_id', fromLocationId);

      fromLocation = location?[0]['name'] + ' ' + location?[0]['type'] ?? '';
    }
    final voyage = await DatabaseHelper.instance
        .queryUnique('voyage_assets', 'asset_id', item.asset_id);
    var voyageID = voyage?[0]['voyage_id'];
    final vessel = await DatabaseHelper.instance
        .queryUnique('voyages', 'voyage_id', voyageID);
    var vesselId = vessel?[0]['vessel_id'];
    final result = await DatabaseHelper.instance
        .queryUnique('assets', 'asset_id', item.asset_id);

    final resp = result?.map((json) => Asset.fromJson(json)).toList();
    Asset? res = resp?[0];

    AssetLog log = new AssetLog();
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    String eventType = EventType.ARRIVED_AT_YARD;
    String assetType = item.asset_type == AssetType.CONTAINER
        ? WITH_CONTAINER
        : WITHOUT_CONTAINER;
    var eventDesc;
    var template =
        (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
            ?.toString();
    Map<String, String> variables = {
      'asset_type': item.asset_type.toString() == AssetType.CONTAINER
          ? item.container_type.toString()
          : item.asset_type.toString(),
      'container_type': item.container_type.toString(),
      'rf_id': item.rf_id.toString(),
      'from_location': fromLocation,
      'current_location': userInfo['location_name'],
      'user': userInfo['user_name'],
      'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
    };
    eventDesc = replaceVariables(template!, variables);
    log.asset_id = item.asset_id.toString();
    log.rf_id = item.rf_id.toString();
    log.asset_type = item.asset_type;
    log.current_transaction = jsonEncode(res?.toMap());
    log.event_type = eventType;
    log.vessel_id = vesselId;
    log.container_type_id =
        item.asset_type == 'null' ? null : item.container_type_id;
    log.from_location_id = fromLocationId;
    log.status = res?.status;
    log.container_type_id = item.container_type_id;
    log.current_location_id = userInfo['locationId'];
    log.event_description = eventDesc;
    DatabaseHelper.instance.createAssetLog(log);

    var child_assets = [];
    final List<dynamic>? groups =
        await DatabaseHelper.instance.queryList('asset_groups', [
      ['group_id', '=', item.asset_id],
    ], {});
    if (groups != null && groups.length > 0) {
      for (var group in groups) {
        child_assets.add(group['asset_id']);
      }
    }

    if (child_assets.length > 0) {
      final childAssetIdsString = makeIdsForIN(child_assets);

      final child_items =
          await await DatabaseHelper.instance.queryList('assets', [
        ['asset_id', 'IN', '($childAssetIdsString)'],
      ], {});

      if (child_items != null) {
        for (var child_item in child_items) {
          AssetLog childLog = new AssetLog();

          final result = await DatabaseHelper.instance
              .queryUnique('assets', 'asset_id', child_item['asset_id']);

          final resp = result?.map((json) => Asset.fromJson(json)).toList();
          Asset? res = resp?[0];

          var eventDesc;
          var template = (eventDefinition[eventType]
                  as Map<Object, dynamic>?)?[INSIDE_CONTAINER]
              ?.toString();
          Map<String, String> variables = {
            'asset_type': child_item['asset_type'].toString(),
            'container_type': item.container_type.toString(),
            'container_rfid': item.rf_id.toString(),
            'rf_id': child_item['rf_id'].toString(),
            'from_location': fromLocation,
            'current_location': userInfo['location_name'],
            'user': userInfo['user_name'],
            'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
          };
          eventDesc = replaceVariables(template!, variables);
          childLog.asset_id = child_item['asset_id'].toString();
          childLog.rf_id = child_item['rf_id'].toString();
          childLog.asset_type = child_item['asset_type'].toString();
          log.current_transaction = jsonEncode(res?.toMap());
          childLog.event_type = eventType;
          childLog.vessel_id = vesselId;
          childLog.status = res?.status;
          childLog.from_location_id = fromLocationId;
          childLog.current_location_id = userInfo['locationId'];
          childLog.event_description = eventDesc;
          DatabaseHelper.instance.createAssetLog(childLog);
        }
      }
    }
  }
  Get.to(NewBottomNavigation());
  // } catch (e) {
  //   Utils.SnackBar('Error', e.toString());
  //   throw Exception(e);
  // }
}
