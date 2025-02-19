// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable

import 'dart:convert';

import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<List<Asset>?> create_bundle(
  String? rf_id,
  String? product_id,
  String? pulling_line_id,
  String? asset_type,
  String? no_of_joints,
  String? no_of_lengths,
  String? approximate_length,
  String? approximate_weight,
  String? crane_weight,
  String? dimensions,
  String? weight_in_air,
  bool? is_contaminated,
  bool? is_hydrocarbon,
  bool? is_mercury,
  bool? is_radiation,
  bool? is_rph,
  String? benzene,
  String? voc,
  String? surface_reading_gm,
  String? surface_reading_ppm,
  String? vapour,
  String? h2s,
  String? lel,
  String? surface_contamination,
  String? adg_class,
  String? un_number,
  String? dose_rate,
  String? class_7_category,
  String? drum_type_id,
  String? waste_type_id,
  List<String>? images,
  String? classification,
  String? description,
  String? quantity,

  //Strig? status
) async {
  final requestData = {
    "rf_id": rf_id,
    "product_id": product_id,
    "pulling_line_id": pulling_line_id,
    'asset_type': asset_type,
    'no_of_joints': no_of_joints,
    'approximate_length': approximate_length,
    'no_of_lengths': no_of_lengths,
    'approximate_weight': approximate_weight,
    'crane_weight ': crane_weight,
    'dimensions': dimensions,
    'weight_in_air': weight_in_air,
    "is_contaminated": is_contaminated,
    'is_hydrocarbon': is_hydrocarbon,
    'is_mercury': is_mercury,
    'is_radiation': is_radiation,
    'is_rph': is_rph,
    'benzene': benzene,
    'voc': voc,
    'surface_reading_gm': surface_reading_gm,
    'surface_reading_ppm': surface_reading_ppm,
    'vapour': vapour,
    'h2s': h2s,
    'lel': lel,
    'drum_type_id': drum_type_id,
    'waste_type_id': waste_type_id,
    'surface_contamination': surface_contamination,
    'adg_class': adg_class,
    'un_number': un_number,
    'dose_rate': dose_rate,
    'class_7_category': class_7_category,
    'classification': classification,
    'description': description,
    'quantity': quantity,
    // 'status':status,
  };

  Asset assetsobject = new Asset(
    rf_id: rf_id,
    product_id: product_id,
    pulling_line_id: pulling_line_id,
    asset_type: asset_type,
    no_of_joints: double.tryParse(no_of_joints.toString()),
    approximate_length: double.tryParse(approximate_length.toString()),
    no_of_lengths: double.tryParse(no_of_lengths.toString()) ?? 0.0,
    approximate_weight: double.tryParse(approximate_weight.toString()),
    crane_weight: double.tryParse(crane_weight.toString()),
    dimensions: dimensions,
    weight_in_air: double.tryParse(weight_in_air.toString()),
    is_hydrocarbon: is_hydrocarbon == true ? 1 : 0,
    is_radiation: is_radiation == true ? 1 : 0,
    is_rph: is_rph == true ? 1 : 0,
    is_contaminated: is_contaminated == true ? 1 : 0,
    is_mercury: is_mercury == true ? 1 : 0,
    benzene: double.tryParse(benzene.toString()) ?? 0.0,
    voc: double.tryParse(voc.toString()) ?? 0.0,
    surface_reading_gm: double.tryParse(surface_reading_gm.toString()),
    surface_reading_ppm: double.tryParse(surface_reading_ppm.toString()),
    vapour: double.tryParse(vapour.toString()),
    h2s: double.tryParse(h2s.toString()),
    lel: double.tryParse(lel.toString()),
    drum_type_id: drum_type_id,
    waste_type_id: waste_type_id,
    surface_contamination: double.tryParse(surface_contamination.toString()),
    adg_class: adg_class,
    un_number: un_number,
    dose_rate: double.tryParse(dose_rate.toString()),
    class_7_category: class_7_category,
    classification: classification,
    description: description,
    quantity: double.tryParse(quantity.toString()),
    is_sync: 0,
  );

  Asset modifiedAsset = await DatabaseHelper.instance.createAsset(assetsobject);
  var product_number = '';
  var drum_type = '';
  var waste_type = '';
  if (assetsobject.product_id != null) {
    final product_no = await DatabaseHelper.instance
        .queryUnique('products', 'product_id', assetsobject.product_id);
    product_number = product_no?[0]['product_no'];
  }
  if (assetsobject.drum_type_id != null) {
    final drum = await DatabaseHelper.instance
        .queryUnique('drum_types', 'drum_type_id', assetsobject.drum_type_id);
    drum_type = drum?[0]['name'];
  }
  if (assetsobject.waste_type_id != null) {
    final waste = await DatabaseHelper.instance.queryUnique(
        'waste_types', 'waste_type_id', assetsobject.waste_type_id);
    waste_type = waste?[0]['name'];
  }
  AssetLog log = new AssetLog();
  final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
  String eventType = EventType.ASSET_CREATED;
  String assetType = assetsobject.asset_type.toString();
  var eventDesc;
  var template =
      (eventDefinition[eventType] as Map<Object, dynamic>?)?[assetType]
          ?.toString();
  Map<String, String> variables = {
    'asset_type': assetType,
    'rf_id': assetsobject.rf_id.toString(),
    'product_no': product_number,
    'batch_no': assetsobject.batch_no.toString(),
    'drum_type': drum_type,
    'waste_type': waste_type,
    'current_location': userInfo['location_name'],
    'user': userInfo['user_name'],
    'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
  };
  eventDesc = replaceVariables(template!, variables);
  log.asset_id = assetsobject.asset_id.toString();
  log.asset_type = assetsobject.asset_type.toString();
  log.current_transaction = jsonEncode(modifiedAsset.toMap());
  log.rf_id = assetsobject.rf_id.toString();
  log.event_type = eventType;
  log.status = assetsobject.status.toString();
  log.product_id = assetsobject.product_id;
  log.event_description = eventDesc;
  log.current_location_id = userInfo['locationId'];
  DatabaseHelper.instance.createAssetLog(log);

  final get_rf_id = await DatabaseHelper.instance
      .queryUnique('assets', 'rf_id', assetsobject.rf_id);
  if (get_rf_id != null && get_rf_id.length > 0) {
    try {
      final assetId = get_rf_id[0]['asset_id'];
      AssetScreening screening = new AssetScreening(
        asset_id: assetId,
        screening_type: ScreeningType.INITIAL_SCREENING,
        is_hydrocarbon: is_hydrocarbon == true ? 1 : 0,
        is_radiation: is_radiation == true ? 1 : 0,
        is_rph: is_rph == true ? 1 : 0,
        is_contaminated: is_contaminated == true ? 1 : 0,
        is_mercury: is_mercury == true ? 1 : 0,
        benzene: double.tryParse(benzene.toString()) ?? 0.0,
        voc: double.tryParse(voc.toString()) ?? 0.0,
        surface_reading_gm:
            double.tryParse(surface_reading_gm.toString()) ?? 0.0,
        surface_reading_ppm:
            double.tryParse(surface_reading_ppm.toString()) ?? 0.0,
        vapour: double.tryParse(vapour.toString()) ?? 0.0,
        h2s: double.tryParse(h2s.toString()) ?? 0.0,
        lel: double.tryParse(lel.toString()) ?? 0.0,
        surface_contamination:
            double.tryParse(surface_contamination.toString()) ?? 0.0,
        adg_class: adg_class,
        un_number: un_number,
        dose_rate: double.tryParse(dose_rate.toString()) ?? 0.0,
        class_7_category: class_7_category,
        classification: classification,
        description: description,
        is_sync: 0,
      );

      String screeningId =
          await DatabaseHelper.instance.createAssetScreening(screening);
      if (assetsobject.asset_type.toString() != AssetType.HAZMAT_WASTE) {
        AssetLog screeninglog = new AssetLog();
        String ScreeningEventType = EventType.SCREENING;
        String ScreeningAssetType = ScreeningType.INITIAL_SCREENING;
        var eventDesc;
        var template = (eventDefinition[ScreeningEventType]
                as Map<Object, dynamic>?)?[ScreeningAssetType]
            ?.toString();
        Map<String, String> variables = {
          'asset_type': assetsobject.asset_type.toString(),
          'rf_id': assetsobject.rf_id.toString(),
          'product_no': product_number,
          'current_location': userInfo['location_name'],
          'user': userInfo['user_name'],
          'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
        };
        eventDesc = replaceVariables(template!, variables);
        screeninglog.asset_id = assetsobject.asset_id.toString();
        screeninglog.current_transaction = jsonEncode(modifiedAsset.toMap());
        screeninglog.rf_id = assetsobject.rf_id.toString();
        screeninglog.event_type = 'Offshore Screening';
        screeninglog.asset_type = assetsobject.asset_type.toString();
        screeninglog.product_id = assetsobject.product_id;
        screeninglog.status = assetsobject.status.toString();
        screeninglog.event_description = eventDesc;
        screeninglog.current_location_id = userInfo['locationId'];
        DatabaseHelper.instance.createAssetLog(screeninglog);
      }
      if (images != null && images.length > 0) {
        for (var image in images) {
          Asset_Image asset_image = new Asset_Image();
          asset_image.screening_id = screeningId;
          asset_image.image_path = image;
          await DatabaseHelper.instance.createImage(asset_image);
        }
      }
    } catch (e) {
      Utils.SnackBar('Error', e.toString());
      throw Exception(e.toString());
    }
  }

  Get.to(NewBottomNavigation());
}
