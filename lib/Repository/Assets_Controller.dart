import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';

Future<List<Asset>?> fetchAssets(
  bool isNoContainerSelected,
  String searchTerm,
) async {
  final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

  var filter = [
    ['status', '=', 'Packed / Ready To Load'],
    ['asset_type', '<>', AssetType.CONTAINER],
    ['asset_type', '<>', AssetType.RIGID_PIPE],
    ['asset_type', '<>', AssetType.FLEXIBLES],
    // ['operating_location_id', '=', userInfo['locationId']],
  ];
  if (isNoContainerSelected) {
    filter.add(
      ['asset_type', '<>', AssetType.BUNDLE],
    );
    filter.add(
      ['asset_type', '<>', AssetType.BATCH],
    );
    filter.add(
      ['asset_type', '<>', AssetType.ANCILLARY_BATCH],
    );
  }
  final result = await DatabaseHelper.instance.queryList(
      'assets',
      filter,
      {
        'searchColumns': ['rf_id', 'product_id'],
        'searchValue': searchTerm
      },
      limit: null);
  if (result != null) {
    final resp = result.map((json) => Asset.fromJson(json)).toList();
    return resp;
  } else {
    return null;
  }
}
