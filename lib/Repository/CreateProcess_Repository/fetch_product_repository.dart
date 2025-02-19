import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';

Future<List<Product>> fetchProductsList(
    String category, String searchTerm, String? filter, String is_batch) async {
  final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
  List<dynamic>? result;
  // print(filter);
  // print(is_batch);
  if (filter != null) {
    var wheres = [
      ['product_type_id', '=', filter],
      ['is_batch', '=', is_batch],
      ['operating_location_id', '=', userInfo['locationId']],
      ['status', '<>', ProductStatus.COMPLETED]
    ];

    // if ((category == 'Subsea Structure' || category == 'Ancillary Equipment') &&
    //     is_batch == '0') {
    //   wheres.add(['status', '=', 'Pending']);
    // }

    result = await DatabaseHelper.instance.queryList('products', wheres, {
      'searchColumns': ['product_name', 'product_no'],
      'searchValue': searchTerm
    });
   
  } else {
    final categoryObj = await DatabaseHelper.instance
        .queryUnique('categories', 'name', category);

    if (categoryObj != null && categoryObj.length > 0) {
      final categoryId = categoryObj[0]['category_id'];

      final product_types =
          await DatabaseHelper.instance.queryList('product_types', [
        ['category_id', '=', categoryId]
      ], {});

      if (product_types != null && product_types.length > 0) {
        final productTypeJson =
            product_types.map((json) => ProductType.fromJson(json)).toList();
        final product_type_ids =
            productTypeJson.map((obj) => obj.product_type_id).toList();

        var product_type_ids_string = '';
        product_type_ids.asMap().forEach((index, id) {
          product_type_ids_string += '"$id"';

          if (index != product_type_ids.length - 1) {
            product_type_ids_string += ', ';
          }
        });

        var wheres = [
          ['product_type_id', 'IN', '($product_type_ids_string)'],
          ['operating_location_id', '=', userInfo['locationId']],
          ['is_batch', '=', is_batch],
          ['status', '<>', ProductStatus.COMPLETED]
        ];

        // if ((category == 'Subsea Structure' ||
        //         category == 'Ancillary Equipment') &&
        //     is_batch == '0') {
        //   wheres.add(['status', '=', 'Pending']);
        // }

        result = await DatabaseHelper.instance.queryList('products', wheres, {
          'searchColumns': ['product_name', 'product_no'],
          'searchValue': searchTerm
        });
      
      }
    }
  }

  if (result != null) {
    final resp = result.map((json) => Product.fromJson(json)).toList();

    return resp;
  } else {
    return [];
  }
}

// For Swap New RFID
Future<List<Asset>> fetchAssetsList(
  String category,
  String searchTerm,
) async {
  final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
  List<dynamic>? result;
  if (category != null) {
    var wheres = [
      ['asset_type', '=', category],
    ];

    result = await DatabaseHelper.instance.queryList('assets', wheres, {
      'searchColumns': [
        'rf_id',
      ],
      'searchValue': searchTerm
    });
  } else {}

  if (result != null) {
    final resp = result.map((json) => Asset.fromJson(json)).toList();

    return resp;
  } else {
    return [];
  }
}
