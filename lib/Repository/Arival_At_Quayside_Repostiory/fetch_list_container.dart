import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';

Future<List<Asset>?>? fetch_voyage_assets(
    String? to_location_id, String? vessel_id, String? from_location_id,
    [String? searchTerm]) async {
  var where = [
    ['to_location_id', '=', to_location_id],
  ];
  if (vessel_id != null) {
    where.add(['vessel_id', '=', vessel_id]);
  }
  ;
  if (from_location_id != null) {
    where.add(['from_location_id', '=', from_location_id]);
  }
  ;

  final voyages = await DatabaseHelper.instance.queryList('voyages', where, {
    // 'searchColumns': ['rf_id', 'product_id'],
    // 'searchValue': searchTerm
  },
   limit: null
  
  );

  if (voyages != null) {
    final voyageJson = voyages.map((json) => Voyage.fromJson(json)).toList();

    var voyageData = {};
    for (var voyage in voyageJson) {
      voyageData[voyage.voyage_id] = voyage;
    }
    ;

    final voyage_ids = voyageJson.map((obj) => obj.voyage_id).toList();

    var voyage_ids_string = '';
    voyage_ids.asMap().forEach((index, id) {
      voyage_ids_string += '"$id"';

      if (index != voyage_ids.length - 1) {
        voyage_ids_string += ', ';
      }
    });

    final voyage_assets =
        await DatabaseHelper.instance.queryList('voyage_assets', [
      ['voyage_id', 'IN', '($voyage_ids_string)'],
    ], 
      
    {}
    ,
     limit: null
    );

    if (voyage_assets != null) {
      final voyageAssetJson =
          voyage_assets.map((json) => VoyageAsset.fromJson(json)).toList();

      var voyageAssetData = {};
      for (var voyage_asset in voyageAssetJson) {
        voyageAssetData[voyage_asset.asset_id] = voyage_asset.voyage_id;
      }
      ;

      final asset_ids = voyageAssetJson.map((obj) => obj.asset_id).toList();

      var asset_ids_string = '';
      asset_ids.asMap().forEach((index, id) {
        asset_ids_string += '"$id"';

        if (index != asset_ids.length - 1) {
          asset_ids_string += ', ';
        }
      });

      final assets = await DatabaseHelper.instance.queryList('assets', [
        ['status', '=', AssetStatus.IN_TRANSIT],
        ['asset_id', 'IN', '($asset_ids_string)'],
      ], {
        'searchColumns': ['rf_id', 'product_id'],
        'searchValue': searchTerm
      }
        , limit: null
      );

      final resp = assets?.map((json) => Asset.fromJson(json)).toList();

      if (resp != null) {
        for (var row in resp) {
          row.vessel = voyageData[voyageAssetData[row.asset_id]].vessel;
          row.voyage_origin =
              voyageData[voyageAssetData[row.asset_id]].from_location;
          row.voyage_destination =
              voyageData[voyageAssetData[row.asset_id]].to_location;
        }
      }
      ;

      return resp;
    } else {
      throw Exception('Failed to load containers');
    }
  } else {
    throw Exception('Failed to load containers');
  }
}

