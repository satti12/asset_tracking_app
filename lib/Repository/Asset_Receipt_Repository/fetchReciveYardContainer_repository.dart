import 'dart:async';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';

// List<Asset>? countItems = [];

// Future<List<Asset>> fetchReciveYardAssets() async {
//   final List<dynamic>? response =
//       await DatabaseHelper.instance.queryList('assets', [
//     ['status', '=', AssetStatus.ARRIVED_AT_YARD],
//   ], {});

//   if (response != null) {
//     final resp = response.map((json) => Asset.fromJson(json)).toList();
//     var child_assets = [];
//     for (var res in resp) {
//       final List<dynamic>? groups =
//           await DatabaseHelper.instance.queryList('asset_groups', [
//         ['group_id', '=', res.asset_id],
//       ], {});
//       if (groups != null && groups.length > 0) {
//         for (var group in groups) {
//           child_assets.add(group['asset_id']);
//         }
//       }
//     }

//     List<Asset> final_resp = [];
//     for (var rep in resp) {
//       if (!child_assets.contains(rep.asset_id)) {
//         final_resp.add(rep);
//       }
//     }
//     countItems = final_resp;
//     return final_resp;
//   } else {
//     return [];
//   }
// }
