import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';

Future<List<Asset>> fetchvogeContainers() async {
  final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

  final List<dynamic>? result = await DatabaseHelper.instance.queryList(
      'assets',
      [
        ['status', '=', AssetStatus.LOADED],
        ['asset_type', '<>', AssetType.BUNDLE],
        // ['asset_type', '<>', AssetType.BATCH],
        // ['asset_type', '<>', AssetType.HAZMAT_WASTE],
        // ['asset_type', '<>', AssetType.ANCILLARY_EQUIPMENT],
        ['operating_location_id', '=', userInfo['locationId']],
      ],
      {},
      limit: null);

  if (result != null) {
    final resp = result.map((json) => Asset.fromJson(json)).toList();
    var child_assets = [];
    for (var res in resp) {
      final List<dynamic>? groups =
          await DatabaseHelper.instance.queryList('asset_groups', [
        ['group_id', '=', res.asset_id],
      ], {});
      if (groups != null && groups.length > 0) {
        for (var group in groups) {
          child_assets.add(group['asset_id']);
        }
      }
    }
    List<Asset> final_resp = [];
    for (var rep in resp) {
      if (!child_assets.contains(rep.asset_id)) {
        final_resp.add(rep);
      }
    }
    return final_resp;
  } else {
    return [];
  }
}

Future<List<Asset>?>? fetchAssetItemInVessel(Asset asset) async {
  final groups = await DatabaseHelper.instance.queryList(
      'asset_groups',
      [
        ['group_id', '=', '${asset.asset_id}']
      ],
      {},
      limit: null);
  if (groups != null && groups.length > 0) {
    final groupsJson = groups.map((json) => AssetGroup.fromJson(json)).toList();

    final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
    final childAssetIdsString = makeIdsForIN(childAssetIds);

    final items = await await DatabaseHelper.instance.queryList('assets', [
      ['asset_id', 'IN', '($childAssetIdsString)'],
    ], {});

    if (items != null && items.length > 0) {
      final List<Asset> response =
          items.map((json) => Asset.fromJson(json)).toList();
      return response;
    }
  }
  return null;
}
