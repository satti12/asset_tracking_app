import 'package:asset_tracking/LocalDataBase/db_helper.dart';


Future<List<ContainerType>> fetchContainerTypes() async {
  final List<dynamic>? result =
      await DatabaseHelper.instance.queryAllRows('container_types');

  if (result != null) {
    final records = result
        .where((json) => json != null) // Filter out null values
        .map((json) => ContainerType.fromJson(
            json as Map<String, dynamic>)) // Cast to Map<String, dynamic>
        .toList();
        
    return records;
  } else {
    return [];
  }
}



