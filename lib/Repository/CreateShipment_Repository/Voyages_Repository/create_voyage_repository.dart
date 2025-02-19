import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VoyageController {
  static Future<void> create_voyage(
      String fromId,
      List<Asset> items,
      String whereId,
      String vesselId,
      String vesselName,
      String fromLocation,
      String toLocation) async {
    Voyage voyage = new Voyage(
      vessel_id: vesselId,
      from_location_id: fromId,
      to_location_id: whereId,
    );
    try {
      await DatabaseHelper.instance.createVoyage(voyage, items);
      for (var item in items) {
        AssetLog log = new AssetLog();
        final result = await DatabaseHelper.instance
            .queryUnique('assets', 'asset_id', item.asset_id);

        final resp = result?.map((json) => Asset.fromJson(json)).toList();
        Asset? res = resp?[0];
        final userInfo =
            await SharedPreferencesHelper.retrieveUserInfo('userInfo');
        String eventType = EventType.IN_TRANSIT;
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
          'vessel': vesselName.toString(),
          'from_location': fromLocation,
          'to_location': toLocation,
          // 'current_location': userInfo['location_name'],
          'user': userInfo['user_name'],

          'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
        };
        eventDesc = replaceVariables(template!, variables);
        log.asset_id = item.asset_id.toString();
        log.rf_id = item.rf_id.toString();
        log.asset_type = item.asset_type;
        log.current_transaction = jsonEncode(res?.toMap());
        log.event_type = eventType;
        log.container_type_id = item.container_type_id;
        log.vessel_id = vesselId;
        log.from_location_id = fromId;
        log.to_location_id = whereId;
        log.status = res?.status;
        log.event_description = eventDesc;
        DatabaseHelper.instance.createAssetLog(log);

        var child_assets = [];
        final List<dynamic>? groups = await DatabaseHelper.instance.queryList(
            'asset_groups',
            [
              ['group_id', '=', item.asset_id],
            ],
            {},
            limit: null);
        if (groups != null && groups.length > 0) {
          for (var group in groups) {
            child_assets.add(group['asset_id']);
          }
        }

        if (child_assets.length > 0) {
          final childAssetIdsString = makeIdsForIN(child_assets);

          final child_items = await DatabaseHelper.instance.queryList(
              'assets',
              [
                ['asset_id', 'IN', '($childAssetIdsString)'],
              ],
              {},
              limit: null);

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
                'vessel': vesselName.toString(),
                'from_location': fromLocation,
                'to_location': toLocation,
                'user': userInfo['user_name'],
                'time':
                    DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
              };
              eventDesc = replaceVariables(template!, variables);
              childLog.asset_id = child_item['asset_id'].toString();
              childLog.rf_id = child_item['rf_id'].toString();
              childLog.asset_type = child_item['asset_type'].toString();
              childLog.current_transaction = jsonEncode(res?.toMap());
              childLog.event_type = eventType;
              childLog.vessel_id = vesselId;
              childLog.from_location_id = fromId;
              childLog.status = res?.status;
              childLog.to_location_id = whereId;
              childLog.event_description = eventDesc;
              DatabaseHelper.instance.createAssetLog(childLog);
            }
          }
        }
      }
    } catch (e) {
      Utils.SnackBar('Error', e.toString());
      throw Exception(e);
    }
    Get.to(NewBottomNavigation());
  }
}
