import 'dart:io';
import 'dart:convert';
import 'package:asset_tracking/Component/constants.dart';
import 'package:asset_tracking/Component/events.dart';
import 'package:asset_tracking/New%20Design/BottomNavigation.dart';
import 'package:asset_tracking/New%20Design/login.dart';
import 'package:asset_tracking/SharedPrefrence/SharedPrefrence.dart';
import 'package:asset_tracking/URL/url.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Import your DatabaseHelper class
import 'package:image/image.dart' as img;
import 'dart:typed_data'; // Import this line
import 'package:connectivity_plus/connectivity_plus.dart';

class Role {
  String? roleId;
  String? roleName;
  int? manageUsers;
  int? createProcess;
  int? loadContainer;
  int? dispatchVoyage;
  int? quaysideArrival;
  int? assetReceipt;
  int? individualAssetForm;
  int? cleaning;
  int? clearanceForm;
  int? wastePackage;
  int? disposalAndTransportForm;
  int? wasteTransform;
  int? disposed;
  int? isActive;
  int? date_added;
  int? date_updated;
  int? is_sync;

  Role({
    required this.roleId,
    required this.roleName,
    required this.manageUsers,
    required this.createProcess,
    required this.loadContainer,
    required this.dispatchVoyage,
    required this.quaysideArrival,
    required this.assetReceipt,
    required this.individualAssetForm,
    required this.cleaning,
    required this.clearanceForm,
    required this.wastePackage,
    required this.disposalAndTransportForm,
    required this.wasteTransform,
    required this.disposed,
    required this.isActive,
    required this.date_added,
    required this.date_updated,
    required this.is_sync,
  });

  Map<String, dynamic> toMap() {
    return {
      'role_id': roleId,
      'role_name': roleName,
      'manage_users': manageUsers,
      'create_process': createProcess,
      'load_container': loadContainer,
      'dispatch_voyage': dispatchVoyage,
      'quayside_arrival': quaysideArrival,
      'asset_receipt': assetReceipt,
      'individual_asset_form': individualAssetForm,
      'cleaning': cleaning,
      'clearance_form': clearanceForm,
      'waste_package': wastePackage,
      'disposal_and_transport_form': disposalAndTransportForm,
      'waste_transform': wasteTransform,
      'disposed': disposed,
      'is_active': isActive,
      'date_added': date_added,
      'date_updated': date_updated,
      'is_sync': is_sync,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'role_name': roleName,
      'manage_users': manageUsers,
      'create_process': createProcess,
      'load_container': loadContainer,
      'dispatch_voyage': dispatchVoyage,
      'quayside_arrival': quaysideArrival,
      'asset_receipt': assetReceipt,
      'individual_asset_form': individualAssetForm,
      'cleaning': cleaning,
      'clearance_form': clearanceForm,
      'waste_package': wastePackage,
      'disposal_and_transport_form': disposalAndTransportForm,
      'waste_transform': wasteTransform,
      'disposed': disposed,
      'is_active': isActive,
      'date_added': date_added,
      'date_updated': date_updated,
      'is_sync': is_sync,
    };
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      roleId: json['role_id'],
      roleName: json['role_name'],
      manageUsers: json['manage_users'],
      createProcess: json['create_process'],
      loadContainer: json['load_container'],
      dispatchVoyage: json['dispatch_voyage'],
      quaysideArrival: json['quayside_arrival'],
      assetReceipt: json['asset_receipt'],
      individualAssetForm: json['individual_asset_form'],
      cleaning: json['cleaning'],
      clearanceForm: json['clearance_form'],
      wastePackage: json['waste_package'],
      disposalAndTransportForm: json['disposal_and_transport_form'],
      wasteTransform: json['waste_transform'],
      disposed: json['disposed'],
      isActive: json['is_active'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
      is_sync: json['is_sync'],
    );
  }
}

class User {
  final String userId;
  final String? roleId;
  final String? email;
  final String? phone;
  final String? password;
  final String? name;
  final String? address;
  final String? avatar;
  final String? status;
  final String? about;
  final String? city;
  final String? zip;
  final int? googleUser;
  final int? emailVerified;
  final int? customVerified;
  final int? twoFactorEnabled;
  final String? otpSecret;
  final int? askPasswordChange;
  final int? isActive;
  final int? is_sync;
  final int? app_access;
  final String? registeredAtIp;
  final String? lastUsedIp;
  final int? date_added;
  final int? date_updated;

  User({
    required this.userId,
    this.roleId,
    this.email,
    this.phone,
    this.password,
    this.name,
    this.address,
    this.avatar,
    this.status,
    this.about,
    this.city,
    this.zip,
    required this.googleUser,
    required this.emailVerified,
    required this.customVerified,
    required this.twoFactorEnabled,
    this.otpSecret,
    required this.askPasswordChange,
    required this.isActive,
    required this.is_sync,
    required this.app_access,
    this.registeredAtIp,
    this.lastUsedIp,
    this.date_added,
    this.date_updated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      roleId: json['role_id'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      name: json['name'],
      address: json['address'],
      avatar: json['avatar'],
      status: json['status'],
      about: json['about'],
      city: json['city'],
      zip: json['zip'],
      googleUser: json['google_user'],
      emailVerified: json['email_verified'],
      customVerified: json['custom_verified'],
      twoFactorEnabled: json['two_factor_enabled'],
      otpSecret: json['otp_secret'],
      askPasswordChange: json['ask_password_change'],
      isActive: json['is_active'],
      is_sync: json['is_sync'],
      app_access: json['app_access'],
      registeredAtIp: json['registered_at_ip'],
      lastUsedIp: json['last_used_ip'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role_id': roleId,
      'email': email,
      'phone': phone,
      'password': password,
      'name': name,
      'address': address,
      'avatar': avatar,
      'status': status,
      'about': about,
      'city': city,
      'zip': zip,
      'google_user': googleUser,
      'email_verified': emailVerified,
      'custom_verified': customVerified,
      'two_factor_enabled': twoFactorEnabled,
      'otp_secret': otpSecret,
      'ask_password_change': askPasswordChange,
      'is_active': isActive,
      'is_sync': is_sync,
      'app_access': app_access,
      'registered_at_ip': registeredAtIp,
      'last_used_ip': lastUsedIp,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'role_id': roleId,
      'email': email,
      'phone': phone,
      'password': password,
      'name': name,
      'address': address,
      'avatar': avatar,
      'status': status,
      'about': about,
      'city': city,
      'zip': zip,
      'google_user': googleUser,
      'email_verified': emailVerified,
      'custom_verified': customVerified,
      'two_factor_enabled': twoFactorEnabled,
      'otp_secret': otpSecret,
      'ask_password_change': askPasswordChange,
      'is_active': isActive,
      'is_sync': is_sync,
      'app_access': app_access,
      'registered_at_ip': registeredAtIp,
      'last_used_ip': lastUsedIp,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class OperatingLocation {
  final String? operatingLocationId;
  final String? name;
  final String? type;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  OperatingLocation({
    required this.operatingLocationId,
    required this.name,
    required this.type,
    required this.is_sync,
    required this.date_added,
    required this.date_updated,
  });
  factory OperatingLocation.fromJson(Map<String, dynamic> json) {
    return OperatingLocation(
      operatingLocationId: json['operating_location_id'],
      name: json['name'],
      type: json['type'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'operating_location_id': operatingLocationId,
      'name': name,
      'type': type,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'operating_location_id': operatingLocationId,
      'name': name,
      'type': type,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class Location {
  final String? location_id;
  final String? name;
  final String? code;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  Location({
    required this.location_id,
    required this.name,
    required this.code,
    required this.is_sync,
    required this.date_added,
    required this.date_updated,
  });
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      location_id: json['location_id'],
      name: json['name'],
      code: json['code'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }
  Map<String, dynamic> toJson() {
    return {
      'location_id': location_id,
      'name': name,
      'code': code,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'location_id': location_id,
      'name': name,
      'code': code,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class Category {
  final String? category_id;
  final String? name;
  final String? air_weight_unit;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  Category({
    required this.category_id,
    required this.name,
    required this.air_weight_unit,
    required this.is_sync,
    required this.date_added,
    required this.date_updated,
  });
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_id: json['category_id'],
      name: json['name'],
      air_weight_unit: json['air_weight_unit'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'category_id': category_id,
      'name': name,
      'air_weight_unit': air_weight_unit,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': category_id,
      'name': name,
      'air_weight_unit': air_weight_unit,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class ProductType {
  final String? product_type_id;
  final String? name;
  final String? category_id;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  ProductType({
    required this.product_type_id,
    required this.name,
    required this.category_id,
    required this.is_sync,
    required this.date_added,
    required this.date_updated,
  });
  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      product_type_id: json['product_type_id'],
      name: json['name'],
      category_id: json['category_id'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'product_type_id': product_type_id,
      'name': name,
      'category_id': category_id,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'product_type_id': product_type_id,
      'name': name,
      'category_id': category_id,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class Product {
  final String? product_id;
  final String? operating_location_id;
  final String? operating_location;
  final String? product_type_id;
  final int? is_batch;
  final String? product_type;
  final String? sector_name;
  final String? product_name;
  final String? product_no;
  final String? status;
  final String? id_inch;
  final String? identification_no;
  final String? length_m;
  final String? quantity;
  final String? dimensions;
  final String? structure_id;
  final double? used;
  final String? air_weight;
  final String? line_end_1;
  final String? line_end_2;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;
  final String? line_end_1_name;
  final String? line_end_2_name;

  Product({
    this.product_id,
    this.operating_location_id,
    this.operating_location,
    this.product_type_id,
    this.is_batch,
    this.product_type,
    this.sector_name,
    this.product_name,
    this.product_no,
    this.status,
    this.id_inch,
    this.identification_no,
    this.length_m,
    this.quantity,
    this.dimensions,
    this.structure_id,
    this.used,
    this.air_weight,
    this.line_end_1,
    this.line_end_2,
    this.is_sync,
    this.date_added,
    this.date_updated,
    this.line_end_1_name,
    this.line_end_2_name,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'],
      operating_location_id: json['operating_location_id'],
      operating_location: json['operating_location'],
      product_type_id: json['product_type_id'],
      is_batch: json['is_batch'],
      product_type: json['product_type'],
      sector_name: json['sector_name'],
      product_name: json['product_name'],
      product_no: json['product_no'],
      status: json['status'],
      id_inch: json['id_inch'],
      identification_no: json['ide ntification_no'],
      length_m: json['length_m'],
      quantity: json['quantity'],
      dimensions: json['dimensions'],
      structure_id: json['structure_id'],
      used: json['used'],
      air_weight: json['air_weight'],
      line_end_1: json['line_end_1'],
      line_end_2: json['line_end_2'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
      line_end_1_name: json['line_end_1_name'],
      line_end_2_name: json['line_end_2_name'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'operating_location_id': operating_location_id,
      'operating_location': operating_location,
      'product_type_id': product_type_id,
      'is_batch': is_batch,
      'product_type': product_type,
      'sector_name': sector_name,
      'product_name': product_name,
      'product_no': product_no,
      'status': status,
      'id_inch': id_inch,
      'identification_no': identification_no,
      'length_m': length_m,
      'quantity': quantity,
      'dimensions': dimensions,
      'structure_id': structure_id,
      'used': used,
      'air_weight': air_weight,
      'line_end_1': line_end_1,
      'line_end_2': line_end_2,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
      'line_end_1_name': line_end_1_name,
      'line_end_2_name': line_end_2_name,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': product_id,
      'operating_location_id': operating_location_id,
      'operating_location': operating_location,
      'product_type_id': product_type_id,
      'is_batch': is_batch,
      'product_type': product_type,
      'sector_name': sector_name,
      'product_name': product_name,
      'product_no': product_no,
      'status': status,
      'id_inch': id_inch,
      'identification_no': identification_no,
      'length_m': length_m,
      'quantity': quantity,
      'dimensions': dimensions,
      'structure_id': structure_id,
      'used': used,
      'air_weight': air_weight,
      'line_end_1': line_end_1,
      'line_end_2': line_end_2,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
      'line_end_1_name': line_end_1_name,
      'line_end_2_name': line_end_2_name,
    };
  }
}

class ContainerType {
  final String? container_type_id;
  final String? name;
  final double? length_m;
  final double? width_m;
  final double? height_m;
  final double? total_weight_kg;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  ContainerType({
    this.container_type_id,
    this.name,
    this.length_m,
    this.width_m,
    this.height_m,
    this.total_weight_kg,
    this.is_sync,
    this.date_added,
    this.date_updated,
  });
  factory ContainerType.fromJson(Map<String, dynamic> json) {
    return ContainerType(
      container_type_id: json['container_type_id'],
      name: json['name'],
      length_m: json['length_m'],
      width_m: json['width_m'],
      height_m: json['height_m'],
      total_weight_kg: json['total_weight_kg'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'container_type_id': container_type_id,
      'name': name,
      'length_m': length_m,
      'width_m': width_m,
      'height_m': height_m,
      'total_weight_kg': total_weight_kg,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'container_type_id': container_type_id,
      'name': name,
      'length_m': length_m,
      'width_m': width_m,
      'height_m': height_m,
      'total_weight_kg': total_weight_kg,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class DrumType {
  final String? drum_type_id;
  final String? name;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  DrumType({
    this.drum_type_id,
    this.name,
    this.is_sync,
    this.date_added,
    this.date_updated,
  });
  factory DrumType.fromJson(Map<String, dynamic> json) {
    return DrumType(
      drum_type_id: json['drum_type_id'],
      name: json['name'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'drum_type_id': drum_type_id,
      'name': name,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'drum_type_id': drum_type_id,
      'name': name,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class WasteType {
  final String? waste_type_id;
  final String? name;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  WasteType({
    this.waste_type_id,
    this.name,
    this.is_sync,
    this.date_added,
    this.date_updated,
  });
  factory WasteType.fromJson(Map<String, dynamic> json) {
    return WasteType(
      waste_type_id: json['waste_type_id'],
      name: json['name'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name: map['name'],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'waste_type_id': waste_type_id,
      'name': name,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'waste_type_id': waste_type_id,
      'name': name,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class Asset {
  String? asset_id;
  String? rf_id;
  String? starting_point;
  String? operating_location_id;
  String? yard_location_id;
  String? product_id;
  String? product;
  String? product_no;
  String? pulling_line_id;
  String? pulling_line;
  String? asset_type;
  int? bundle_no;
  String? batch_no;
  String? drum_no;
  String? ctc_number;
  String? container_type_id;
  String? container_type;
  String? drum_type_id;
  String? drum_type;
  String? waste_type_id;
  String? waste_type;
  double? quantity;
  double? no_of_joints;
  double? no_of_lengths;
  double? approximate_length;
  double? approximate_weight;
  double? crane_weight;
  String? dimensions;
  double? weight_in_air;
  int? is_hydrocarbon;
  int? is_mercury;
  int? is_radiation;
  int? is_rph;
  int? is_contaminated;
  double? benzene;
  double? voc;
  double? surface_reading_gm;
  double? surface_reading_ppm;
  double? vapour;
  double? h2s;
  double? lel;
  double? surface_contamination;
  String? adg_class;
  String? un_number;
  double? dose_rate;
  String? class_7_category;
  String? container_serial_number;
  String? classification;
  String? status;
  String? description;
  String? storage_area;
  String? storage_rack;
  String? added_by_id;
  int? is_sync;
  int? date_added;
  int? date_updated;
  int? disposal_date;

  // For Getting Voyage Information
  String? vessel;
  String? voyage_origin;
  String? voyage_destination;

  Asset({
    this.asset_id,
    this.rf_id,
    this.starting_point,
    this.operating_location_id,
    this.yard_location_id,
    this.product_id,
    this.product,
    this.product_no,
    this.pulling_line_id,
    this.pulling_line,
    this.asset_type,
    this.bundle_no,
    this.batch_no,
    this.ctc_number,
    this.drum_no,
    this.container_type_id,
    this.container_type,
    this.drum_type_id,
    this.drum_type,
    this.waste_type_id,
    this.waste_type,
    this.quantity,
    this.no_of_joints,
    this.no_of_lengths,
    this.approximate_length,
    this.approximate_weight,
    this.crane_weight,
    this.dimensions,
    this.weight_in_air,
    this.is_hydrocarbon,
    this.is_mercury,
    this.is_radiation,
    this.is_rph,
    this.is_contaminated,
    this.benzene,
    this.voc,
    this.surface_reading_gm,
    this.surface_reading_ppm,
    this.vapour,
    this.h2s,
    this.lel,
    this.surface_contamination,
    this.adg_class,
    this.un_number,
    this.dose_rate,
    this.class_7_category,
    this.container_serial_number,
    this.classification,
    this.status,
    this.description,
    this.storage_area,
    this.storage_rack,
    this.added_by_id,
    this.is_sync,
    this.date_added,
    this.date_updated,
    this.vessel,
    this.voyage_origin,
    this.voyage_destination,
    this.disposal_date,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      asset_id: json['asset_id'],
      rf_id: json['rf_id'],
      starting_point: json['starting_point'],
      operating_location_id: json['operating_location_id'],
      yard_location_id: json['yard_location_id'],
      product_id: json['product_id'],
      product: json['product'],
      product_no: json['product_no'],
      pulling_line_id: json['pulling_line_id'],
      pulling_line: json['pulling_line'],
      asset_type: json['asset_type'],
      bundle_no: json['bundle_no'],
      batch_no: json['batch_no'],
      ctc_number: json['ctc_number'],
      drum_no: json['drum_no'],
      container_type_id: json['container_type_id'],
      container_type: json['container_type'],
      drum_type_id: json['drum_type_id'],
      drum_type: json['drum_type'],
      waste_type_id: json['waste_type_id'],
      waste_type: json['waste_type'],
      quantity: json['quantity'],
      no_of_joints: json['no_of_joints'],
      no_of_lengths: json['no_of_lengths'],
      approximate_length: json['approximate_length'],
      approximate_weight: json['approximate_weight'],
      crane_weight: json['crane_weight'],
      dimensions: json['dimensions'],
      weight_in_air: json['weight_in_air'],
      is_hydrocarbon: json['is_hydrocarbon'],
      is_mercury: json['is_mercury'],
      is_radiation: json['is_radiation'],
      is_rph: json['is_rph'],
      is_contaminated: json['is_contaminated'],
      benzene: json['benzene'],
      voc: json['voc'],
      surface_reading_gm: json['surface_reading_gm'],
      surface_reading_ppm: json['surface_reading_ppm'],
      vapour: json['vapour'],
      h2s: json['h2s'],
      lel: json['lel'],
      surface_contamination: json['surface_contamination'],
      adg_class: json['adg_class'],
      un_number: json['un_number'],
      dose_rate: json['dose_rate'],
      class_7_category: json['class_7_category'],
      container_serial_number: json['container_serial_number'],
      classification: json['classification'],
      status: json['status'],
      description: json['description'],
      storage_area: json['storage_area'],
      storage_rack: json['storage_rack'],
      added_by_id: json['added_by_id'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
      vessel: json['vessel'],
      voyage_origin: json['voyage_origin'],
      voyage_destination: json['voyage_destination'],
      disposal_date: json['disposal_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_id': asset_id,
      'rf_id': rf_id,
      'starting_point': starting_point,
      'operating_location_id': operating_location_id,
      'yard_location_id': yard_location_id,
      'product_id': product_id,
      'product': product,
      'product_no': product_no,
      'pulling_line_id': pulling_line_id,
      'pulling_line': pulling_line,
      'asset_type': asset_type,
      'bundle_no': bundle_no,
      'batch_no': batch_no,
      'ctc_number': ctc_number,
      'drum_no': drum_no,
      'container_type_id': container_type_id,
      'container_type': container_type,
      'drum_type_id': drum_type_id,
      'drum_type': drum_type,
      'waste_type_id': waste_type_id,
      'waste_type': waste_type,
      'quantity': quantity,
      'no_of_joints': no_of_joints,
      'no_of_lengths': no_of_lengths,
      'approximate_length': approximate_length,
      'approximate_weight': approximate_weight,
      'crane_weight': crane_weight,
      'dimensions': dimensions,
      'weight_in_air': weight_in_air,
      'is_hydrocarbon': is_hydrocarbon,
      'is_mercury': is_mercury,
      'is_radiation': is_radiation,
      'is_rph': is_rph,
      'is_contaminated': is_contaminated,
      'benzene': benzene,
      'voc': voc,
      'surface_reading_gm': surface_reading_gm,
      'surface_reading_ppm': surface_reading_ppm,
      'vapour': vapour,
      'h2s': h2s,
      'lel': lel,
      'surface_contamination': surface_contamination,
      'adg_class': adg_class,
      'un_number': un_number,
      'dose_rate': dose_rate,
      'class_7_category': class_7_category,
      'container_serial_number': container_serial_number,
      'classification': classification,
      'status': status,
      'description': description,
      'storage_area': storage_area,
      'storage_rack': storage_rack,
      'added_by_id': added_by_id,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
      'vessel': vessel,
      'voyage_origin': voyage_origin,
      'voyage_destination': voyage_destination,
      'disposal_date': disposal_date,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'asset_id': asset_id,
      'rf_id': rf_id,
      'starting_point': starting_point,
      'operating_location_id': operating_location_id,
      ' yard_location_id': yard_location_id,
      'product_id': product_id,
      'product': product,
      'product_no': product_no,
      'pulling_line_id': pulling_line_id,
      'pulling_line': pulling_line,
      'asset_type': asset_type,
      'bundle_no': bundle_no,
      'batch_no': batch_no,
      'drum_no': drum_no,
      'ctc_number': ctc_number,
      'container_type_id': container_type_id,
      'container_type': container_type,
      'drum_type_id': drum_type_id,
      'drum_type': drum_type,
      'quantity': quantity,
      'waste_type_id': waste_type_id,
      'waste_type': waste_type,
      'no_of_joints': no_of_joints,
      'no_of_lengths': no_of_lengths,
      'approximate_length': approximate_length,
      'approximate_weight': approximate_weight,
      'crane_weight': crane_weight,
      'dimensions': dimensions,
      'weight_in_air': weight_in_air,
      'is_hydrocarbon': is_hydrocarbon,
      'is_mercury': is_mercury,
      'is_radiation': is_radiation,
      'is_rph': is_rph,
      'is_contaminated': is_contaminated,
      'benzene': benzene,
      'voc': voc,
      'surface_reading_gm': surface_reading_gm,
      'surface_reading_ppm': surface_reading_ppm,
      'vapour': vapour,
      'h2s': h2s,
      'lel': lel,
      'surface_contamination': surface_contamination,
      'adg_class': adg_class,
      'un_number': un_number,
      'dose_rate': dose_rate,
      'class_7_category': class_7_category,
      'container_serial_number': container_serial_number,
      'classification': classification,
      'status': status,
      'description': description,
      'storage_area': storage_area,
      'storage_rack': storage_rack,
      'added_by_id': added_by_id,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
      'vessel': vessel,
      'voyage_origin': voyage_origin,
      'voyage_destination': voyage_destination,
      'disposal_date': disposal_date
    };
  }
}

class AssetScreening {
  String? screening_id;
  String? asset_id;
  String? screening_type;
  int? is_hydrocarbon;
  int? is_mercury;
  int? is_radiation;
  int? is_rph;
  int? is_contaminated;
  double? benzene;
  double? voc;
  double? surface_reading_gm;
  double? surface_reading_ppm;
  double? vapour;
  double? h2s;
  double? lel;
  double? surface_contamination;
  String? adg_class;
  String? un_number;
  double? dose_rate;
  String? class_7_category;
  String? container_serial_number;
  String? classification;
  String? description;
  String? added_by_id;
  int? is_sync;
  int? date_added;
  int? date_updated;

  AssetScreening({
    this.screening_id,
    this.asset_id,
    this.screening_type,
    this.is_hydrocarbon,
    this.is_mercury,
    this.is_radiation,
    this.is_rph,
    this.is_contaminated,
    this.benzene,
    this.voc,
    this.surface_reading_gm,
    this.surface_reading_ppm,
    this.vapour,
    this.h2s,
    this.lel,
    this.surface_contamination,
    this.adg_class,
    this.un_number,
    this.dose_rate,
    this.class_7_category,
    this.container_serial_number,
    this.classification,
    this.description,
    this.added_by_id,
    this.is_sync,
    this.date_added,
    this.date_updated,
  });

  factory AssetScreening.fromJson(Map<String, dynamic> json) {
    return AssetScreening(
      screening_id: json['screening_id'],
      asset_id: json['asset_id'],
      screening_type: json['screening_type'],
      is_hydrocarbon: json['is_hydrocarbon'],
      is_mercury: json['is_mercury'],
      is_radiation: json['is_radiation'],
      is_rph: json['is_rph'],
      is_contaminated: json['is_contaminated'],
      benzene: json['benzene'],
      voc: json['voc'],
      surface_reading_gm: json['surface_reading_gm'],
      surface_reading_ppm: json['surface_reading_ppm'],
      vapour: json['vapour'],
      h2s: json['h2s'],
      lel: json['lel'],
      surface_contamination: json['surface_contamination'],
      adg_class: json['adg_class'],
      un_number: json['un_number'],
      dose_rate: json['dose_rate'],
      class_7_category: json['class_7_category'],
      container_serial_number: json['container_serial_number'],
      classification: json['classification'],
      description: json['description'],
      added_by_id: json['added_by_id'],
      is_sync: json['is_sync'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screening_id': screening_id,
      'asset_id': asset_id,
      'screening_type': screening_type,
      'is_hydrocarbon': is_hydrocarbon,
      'is_mercury': is_mercury,
      'is_radiation': is_radiation,
      'is_rph': is_rph,
      'is_contaminated': is_contaminated,
      'benzene': benzene,
      'voc': voc,
      'surface_reading_gm': surface_reading_gm,
      'surface_reading_ppm': surface_reading_ppm,
      'vapour': vapour,
      'h2s': h2s,
      'lel': lel,
      'surface_contamination': surface_contamination,
      'adg_class': adg_class,
      'un_number': un_number,
      'dose_rate': dose_rate,
      'class_7_category': class_7_category,
      'container_serial_number': container_serial_number,
      'classification': classification,
      'description': description,
      'added_by_id': added_by_id,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'screening_id': screening_id,
      'asset_id': asset_id,
      'screening_type': screening_type,
      'is_hydrocarbon': is_hydrocarbon,
      'is_mercury': is_mercury,
      'is_radiation': is_radiation,
      'is_rph': is_rph,
      'is_contaminated': is_contaminated,
      'benzene': benzene,
      'voc': voc,
      'surface_reading_gm': surface_reading_gm,
      'surface_reading_ppm': surface_reading_ppm,
      'vapour': vapour,
      'h2s': h2s,
      'lel': lel,
      'surface_contamination': surface_contamination,
      'adg_class': adg_class,
      'un_number': un_number,
      'dose_rate': dose_rate,
      'class_7_category': class_7_category,
      'container_serial_number': container_serial_number,
      'classification': classification,
      'description': description,
      'added_by_id': added_by_id,
      'is_sync': is_sync,
      'date_added': date_added,
      'date_updated': date_updated,
    };
  }
}

class Asset_Image {
  String? image_id;
  String? asset_id;
  String? screening_id;
  String? image_path;
  int? is_sync;

  Asset_Image({
    this.image_id,
    this.asset_id,
    this.screening_id,
    this.image_path,
    this.is_sync,
  });
  factory Asset_Image.fromJson(Map<String, dynamic> json) {
    return Asset_Image(
      image_id: json['image_id'],
      asset_id: json['asset_id '],
      screening_id: json['screening_id '],
      image_path: json['image_path'],
      is_sync: json['is_sync'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_id': image_id,
      'asset_id': asset_id,
      'screening_id': screening_id,
      'image_path': image_path,
      'is_sync': is_sync,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'image_id': image_id,
      'asset_id': asset_id,
      'screening_id': screening_id,
      'image_path': image_path,
      'is_sync': is_sync,
    };
  }
}

class AssetGroup {
  final String? asset_group_id;
  final String? asset_id;
  final String? group_id;
  final int? is_cleared;
  final int? is_sync;

  AssetGroup({
    required this.asset_group_id,
    required this.asset_id,
    required this.group_id,
    required this.is_cleared,
    required this.is_sync,
  });
  factory AssetGroup.fromJson(Map<String, dynamic> json) {
    return AssetGroup(
      asset_group_id: json['asset_group_id'],
      asset_id: json['asset_id'],
      group_id: json['group_id'],
      is_cleared: json['is_cleared'],
      is_sync: json['is_sync'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     asset_id : map['asset_id '],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }
  Map<String, dynamic> toJson() {
    return {
      'asset_group_id': asset_group_id,
      'asset_id': asset_id,
      'group_id': group_id,
      'is_cleared': is_cleared,
      'is_sync': is_sync,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'asset_group_id': asset_group_id,
      'asset_id ': asset_id,
      'group_id': group_id,
      'is_cleared': is_cleared,
      'is_sync': is_sync,
    };
  }
}

class AssetTrackLog {
  final String? asset_track_log_id;
  final String? asset_id;
  final String? from_location;
  final String? to_location;
  final String? previous_status;
  final String? current_status;
  final String? added_by_id;
  final int? date_added;
  final int? is_sync;

  AssetTrackLog({
    required this.asset_track_log_id,
    required this.asset_id,
    required this.from_location,
    required this.to_location,
    required this.previous_status,
    required this.current_status,
    required this.added_by_id,
    required this.date_added,
    required this.is_sync,
  });
  factory AssetTrackLog.fromJson(Map<String, dynamic> json) {
    return AssetTrackLog(
      asset_track_log_id: json['asset_track_log_id'],
      asset_id: json['asset_id'],
      from_location: json['from_location'],
      to_location: json['to_location'],
      previous_status: json['previous_status'],
      current_status: json['current_status'],
      added_by_id: json['added_by_id'],
      date_added: json['date_added'],
      is_sync: json['is_sync'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_track_log_id': asset_track_log_id,
      'asset_id': asset_id,
      'from_location': from_location,
      'to_location': to_location,
      'previous_status': previous_status,
      'current_status': current_status,
      'added_by_id': added_by_id,
      'date_added': date_added,
      'is_sync': is_sync,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'asset_track_log_id': asset_track_log_id,
      'asset_id': asset_id,
      'from_location': from_location,
      'to_location': to_location,
      'previous_status': previous_status,
      'current_status': current_status,
      'added_by_id': added_by_id,
      'date_added': date_added,
      'is_sync': is_sync,
    };
  }
}

class Vessel {
  final String? vessel_id;
  final String? name;
  final String? vendor_name;
  final String? current_location_id;
  final int? is_sync;
  final int? date_added;
  final int? date_updated;

  Vessel({
    required this.vessel_id,
    required this.name,
    required this.vendor_name,
    required this.current_location_id,
    required this.is_sync,
    required this.date_added,
    required this.date_updated,
  });
  factory Vessel.fromJson(Map<String, dynamic> json) {
    return Vessel(
      vessel_id: json['vessel_id'],
      name: json['name'],
      vendor_name: json['vendor_name'],
      current_location_id: json['current_location_id'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
      is_sync: json['is_sync'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vessel_id': vessel_id,
      'name': name,
      'vendor_name': vendor_name,
      'current_location_id': current_location_id,
      'date_added': date_added,
      'date_updated': date_updated,
      'is_sync': is_sync,
    };
  }
  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     name  : map['name  '],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'vessel_id': vessel_id,
      'name': name,
      'vendor_name': vendor_name,
      'current_location_id': current_location_id,
      'date_added': date_added,
      'date_updated': date_updated,
      'is_sync': is_sync,
    };
  }
}

class Voyage {
  String? voyage_id;
  String? vessel_id;
  String? vessel;
  String? from_location_id;
  String? from_location;
  String? to_location_id;
  String? to_location;
  String? added_by_id;
  int? is_sync;
  int? date_added;
  int? date_updated;

  Voyage({
    this.voyage_id,
    this.vessel_id,
    this.vessel,
    this.from_location_id,
    this.from_location,
    this.to_location_id,
    this.to_location,
    this.added_by_id,
    this.is_sync,
    this.date_added,
    this.date_updated,
  });
  factory Voyage.fromJson(Map<String, dynamic> json) {
    return Voyage(
      voyage_id: json['voyage_id'],
      vessel_id: json['vessel_id'],
      vessel: json['vessel'],
      from_location_id: json['from_location_id'],
      from_location: json['from_location'],
      to_location_id: json['to_location_id'],
      to_location: json['to_location'],
      added_by_id: json['added_by_id'],
      date_added: json['date_added'],
      date_updated: json['date_updated'],
      is_sync: json['is_sync'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voyage_id': voyage_id,
      'vessel_id': vessel_id,
      'vessel': vessel,
      'from_location_id': from_location_id,
      'from_location': from_location,
      'to_location_id': to_location_id,
      'to_location': to_location,
      'added_by_id': added_by_id,
      'date_added': date_added,
      'date_updated': date_updated,
      'is_sync': is_sync,
    };
  }
  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     from_location_id  : map['from_location_id  '],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'voyage_id': voyage_id,
      'vessel_id': vessel_id,
      'vessel': vessel,
      'from_location_id': from_location_id,
      'from_location': from_location,
      'to_location_id': to_location_id,
      'to_location': to_location,
      'added_by_id': added_by_id,
      'date_added': date_added,
      'date_updated': date_updated,
      'is_sync': is_sync,
    };
  }
}

class VoyageAsset {
  final String? voyage_asset_id;
  final String? voyage_id;
  final String? asset_id;
  final int? is_sync;

  VoyageAsset({
    required this.voyage_asset_id,
    required this.voyage_id,
    required this.asset_id,
    required this.is_sync,
  });
  factory VoyageAsset.fromJson(Map<String, dynamic> json) {
    return VoyageAsset(
      voyage_asset_id: json['voyage_asset_id'],
      voyage_id: json['voyage_id'],
      asset_id: json['asset_id'],
      is_sync: json['is_sync'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voyage_asset_id': voyage_asset_id,
      'voyage_id': voyage_id,
      'asset_id': asset_id,
      'is_sync': is_sync,
    };
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     asset_id  : map['asset_id  '],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'voyage_asset_id': voyage_asset_id,
      'voyage_id': voyage_id,
      'asset_id': asset_id,
      'is_sync': is_sync,
    };
  }
}

class AssetColumnHistory {
  String? history_id;
  String? asset_id;
  String? column_name;
  String? old_value;
  String? new_value;
  String? comments;
  int? date_added;
  String? added_by_id;

  int? is_sync;

  AssetColumnHistory({
    this.history_id,
    this.asset_id,
    this.column_name,
    this.old_value,
    this.new_value,
    this.comments,
    this.date_added,
    this.added_by_id,
    this.is_sync,
  });
  factory AssetColumnHistory.fromJson(Map<String, dynamic> json) {
    return AssetColumnHistory(
      history_id: json['history_id'],
      asset_id: json['asset_id'],
      column_name: json['column_name'],
      old_value: json['old_value'],
      new_value: json['new_value'],
      comments: json['comments'],
      date_added: json['date_added'],
      added_by_id: json['added_by_id'],
      is_sync: json['is_sync'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'history_id': history_id,
      'asset_id': asset_id,
      'column_name': column_name,
      'old_value': old_value,
      'new_value': new_value,
      'comments': comments,
      'date_added': date_added,
      'added_by_id': added_by_id,
      'is_sync': is_sync,
    };
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     asset_id  : map['asset_id  '],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'history_id': history_id,
      'asset_id': asset_id,
      'column_name': column_name,
      'old_value': old_value,
      'new_value': new_value,
      'comments': comments,
      'date_added': date_added,
      'added_by_id': added_by_id,
      'is_sync': is_sync,
    };
  }
}

class AssetNotes {
  String? note_id;
  String? asset_id;
  String? description;
  int? date_added;
  String? added_by_id;
  String? operating_location_id;
  String? status;
  int? is_sync;

  AssetNotes({
    this.note_id,
    this.asset_id,
    this.description,
    this.date_added,
    this.added_by_id,
    this.operating_location_id,
    this.status,
    this.is_sync,
  });
  factory AssetNotes.fromJson(Map<String, dynamic> json) {
    return AssetNotes(
      note_id: json['note_id'],
      asset_id: json['asset_id'],
      description: json['description'],
      date_added: json['date_added'],
      added_by_id: json['added_by_id'],
      operating_location_id: json['operating_location_id'],
      status: json['status'],
      is_sync: json['is_sync'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note_id': note_id,
      'asset_id': asset_id,
      'description': description,
      'date_added': date_added,
      'added_by_id': added_by_id,
      'operating_location_id': operating_location_id,
      'status': status,
      'is_sync': is_sync,
    };
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     asset_id  : map['asset_id  '],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'note_id': note_id,
      'asset_id': asset_id,
      'description': description,
      'date_added': date_added,
      'added_by_id': added_by_id,
      'operating_location_id': operating_location_id,
      'status': status,
      'is_sync': is_sync,
    };
  }
}

class AssetLog {
  String? asset_log_id;
  String? asset_id;
  String? current_transaction;
  String? event_type;
  String? event_description;
  String? rf_id;
  String? asset_type;
  String? current_location_id;
  String? from_location_id;
  String? to_location_id;
  String? container_type_id;
  String? vessel_id;
  String? vessel;
  String? product_id;
  String? drum_type_id;
  String? waste_type_id;
  String? status;
  String? added_by_id;
  int? date_added;
  int? is_sync;

  AssetLog({
    this.asset_log_id,
    this.asset_id,
    this.current_transaction,
    this.event_type,
    this.event_description,
    this.rf_id,
    this.asset_type,
    this.current_location_id,
    this.from_location_id,
    this.to_location_id,
    this.container_type_id,
    this.vessel_id,
    this.vessel,
    this.product_id,
    this.drum_type_id,
    this.waste_type_id,
    this.status,
    this.added_by_id,
    this.date_added,
    this.is_sync,
  });
  factory AssetLog.fromJson(Map<String, dynamic> json) {
    return AssetLog(
      asset_log_id: json['asset_log_id'],
      asset_id: json['asset_id'],
      current_transaction: json['current_transaction'],
      event_type: json['event_type'],
      event_description: json['event_description'],
      rf_id: json['rf_id'],
      asset_type: json['asset_type'],
      current_location_id: json['current_location_id'],
      from_location_id: json['from_location_id'],
      to_location_id: json['to_location_id'],
      container_type_id: json['container_type_id'],
      vessel_id: json['vessel_id'],
      vessel: json['vessel'],
      product_id: json['product_id'],
      drum_type_id: json['drum_type_id'],
      waste_type_id: json['waste_type_id'],
      status: json['status'],
      added_by_id: json['added_by_id'],
      date_added: json['date_added'],
      is_sync: json['is_sync'],
    );
  }

  // factory OperatingLocation.fromMap(Map<String, dynamic> map) {
  //   return OperatingLocation(
  //     operatingLocationId: map['operating_location_id'],
  //     asset_id  : map['asset_id  '],
  //     type: map['type'],
  //     is_sync: map['is_sync'],
  //     date_added: map['date_added'],
  //     date_updated: map['date_updated'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'asset_log_id': asset_log_id,
      'asset_id': asset_id,
      'current_transaction': current_transaction,
      'event_type': event_type,
      'event_description': event_description,
      'rf_id': rf_id,
      'asset_type': asset_type,
      'current_location_id': current_location_id,
      'from_location_id': from_location_id,
      'to_location_id': to_location_id,
      'container_type_id': container_type_id,
      'vessel_id': vessel_id,
      'vessel': vessel,
      'product_id': product_id,
      'drum_type_id': drum_type_id,
      'waste_type_id': waste_type_id,
      'status': status,
      'added_by_id': added_by_id,
      'date_added': date_added,
      'is_sync': is_sync,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'asset_log_id': asset_log_id,
      'asset_id': asset_id,
      'current_transaction': current_transaction,
      'event_type': event_type,
      'event_description': event_description,
      'rf_id': rf_id,
      'asset_type': asset_type,
      'current_location_id': current_location_id,
      'from_location_id': from_location_id,
      'to_location_id': to_location_id,
      'container_type_id': container_type_id,
      'vessel_id': vessel_id,
      'vessel': vessel,
      'product_id': product_id,
      'drum_type_id': drum_type_id,
      'waste_type_id': waste_type_id,
      'status': status,
      'added_by_id': added_by_id,
      'date_added': date_added,
      'is_sync': is_sync,
    };
  }
}

var SetVersion;

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'track.db');
    return await openDatabase(path, version: 1, onCreate: createTable);
  }

  hashPassword(String password) {
    var bytes = utf8.encode(password); // Encode the password as bytes
    var enc_pass = md5.convert(bytes);
    return enc_pass.toString();
    // Convert the hash to a hexadecimal string
  }

  Future<void> createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE roles (
        role_id VARCHAR(32) PRIMARY KEY,
        role_name VARCHAR(50) NOT NULL,
        manage_users TINYINT(1) NOT NULL DEFAULT '1',
        create_process TINYINT(1) NOT NULL DEFAULT '1',
        load_container TINYINT(1) NOT NULL DEFAULT '1',
        dispatch_voyage TINYINT(1) NOT NULL DEFAULT '1',
        quayside_arrival TINYINT(1) NOT NULL DEFAULT '1',
        asset_receipt TINYINT(1) NOT NULL DEFAULT '1',
        individual_asset_form TINYINT(1) NOT NULL DEFAULT '1',
        cleaning TINYINT(1) NOT NULL DEFAULT '1',
        clearance_form TINYINT(1) NOT NULL DEFAULT '1',
        waste_package TINYINT(1) NOT NULL DEFAULT '1',
        disposal_and_transport_form TINYINT(1) NOT NULL DEFAULT '1',
        waste_transform TINYINT(1) NOT NULL DEFAULT '1',
        disposed TINYINT(1) NOT NULL DEFAULT '1',
        is_active TINYINT(1) NOT NULL DEFAULT '1',
        is_sync  TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        user_id VARCHAR(32) PRIMARY KEY,
        role_id VARCHAR(32),
        email VARCHAR(100) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        password VARCHAR(32) NOT NULL,
        name VARCHAR(128),
        address VARCHAR(1024),
        avatar VARCHAR(1024),
        status VARCHAR(1024),
        about VARCHAR(1024),
        city VARCHAR(1024),
        zip VARCHAR(1024),
        google_user TINYINT(1) NOT NULL DEFAULT '0',
        email_verified TINYINT(1) NOT NULL DEFAULT '0',
        custom_verified TINYINT(1) NOT NULL DEFAULT '0',
        two_factor_enabled TINYINT(1) NOT NULL DEFAULT '0',
        otp_secret VARCHAR(32),
        ask_password_change TINYINT(1) NOT NULL DEFAULT '0',
        is_active TINYINT(1) NOT NULL DEFAULT '1',
        is_sync TINYINT(1) NOT NULL,
        app_access TINYINT(1) NOT NULL,
        registered_at_ip VARCHAR(32),
        last_used_ip VARCHAR(32),
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE operating_locations(
        operating_location_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        type VARCHAR(256),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE locations(
        location_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        code VARCHAR(256),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories(
        category_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        air_weight_unit VARCHAR(256),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE product_types(
        product_type_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        category_id VARCHAR(32),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        product_id VARCHAR(32) PRIMARY KEY,
        operating_location_id VARCHAR(32),
        product_type_id VARCHAR(32),
        is_batch TINYINT(1) NOT NULL,
        sector_name VARCHAR(256),
        product_name VARCHAR(256),
        product_no VARCHAR(256),
        status VARCHAR(256) NOT NULL DEFAULT 'Pending',
        id_inch VARCHAR(256),
        identification_no VARCHAR(256),
        length_m VARCHAR(256),
        quantity VARCHAR(256),
        dimensions VARCHAR(256),
        structure_id VARCHAR(256),
        used FLOAT,
        air_weight VARCHAR(256),
        line_end_1 VARCHAR(32),
        line_end_2 VARCHAR(32),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE container_types(
        container_type_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        length_m FLOAT,
        width_m FLOAT,
        height_m FLOAT,
        total_weight_kg FLOAT,
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE drum_types(
        drum_type_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE waste_types(
        waste_type_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE assets(
        asset_id VARCHAR(32) PRIMARY KEY,
        rf_id VARCHAR(64) UNIQUE NOT NULL,
        starting_point VARCHAR(256) NULL,
        operating_location_id VARCHAR(32),
        yard_location_id VARCHAR(32),
        product_id VARCHAR(32),
        pulling_line_id VARCHAR(32),
        asset_type VARCHAR(256),
        bundle_no INT,
        batch_no VARCHAR(256),
        ctc_number VARCHAR(256),
        drum_no VARCHAR(256),
        container_type_id VARCHAR(32),
        drum_type_id VARCHAR(32),
        waste_type_id VARCHAR(32),
        quantity FLOAT,
        no_of_joints FLOAT,
        no_of_lengths FLOAT,
        approximate_length FLOAT,
        approximate_weight FLOAT,
        crane_weight FLOAT,
        dimensions VARCHAR(128),
        weight_in_air FLOAT,
        is_hydrocarbon TINYINT(1) NOT NULL DEFAULT '0',
        is_mercury TINYINT(1) NOT NULL DEFAULT '0',
        is_radiation TINYINT(1) NOT NULL DEFAULT '0',
        is_rph TINYINT(1) NOT NULL DEFAULT '0',
        is_contaminated TINYINT(1) NOT NULL DEFAULT '0',
        benzene FLOAT,
        voc FLOAT,
        surface_reading_gm FLOAT,
        surface_reading_ppm FLOAT,
        vapour FLOAT,
        h2s FLOAT,
        lel FLOAT,
        surface_contamination FLOAT,
        adg_class VARCHAR(64),
        un_number VARCHAR(64),
        dose_rate FLOAT,
        class_7_category VARCHAR(64),
        container_serial_number VARCHAR(256),
        classification VARCHAR(256),
        status VARCHAR(256),
        storage_area VARCHAR(256),
        storage_rack VARCHAR(256),
        description VARCHAR(1024),
        added_by_id VARCHAR(256),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT,
        disposal_date BIGINT

      )
    ''');

    await db.execute('''
      CREATE TABLE asset_screenings(
        screening_id VARCHAR(32) PRIMARY KEY,
        asset_id VARCHAR(32),
        screening_type VARCHAR(64),
        is_hydrocarbon TINYINT(1) NOT NULL DEFAULT '0',
        is_mercury TINYINT(1) NOT NULL DEFAULT '0',
        is_radiation TINYINT(1) NOT NULL DEFAULT '0',
        is_rph TINYINT(1) NOT NULL DEFAULT '0',
        is_contaminated TINYINT(1) NOT NULL DEFAULT '0',
        benzene FLOAT,
        voc FLOAT,
        surface_reading_gm FLOAT,
        surface_reading_ppm FLOAT,
        vapour FLOAT,
        h2s FLOAT,
        lel FLOAT,
        surface_contamination FLOAT,
        adg_class VARCHAR(64),
        un_number VARCHAR(64),
        dose_rate FLOAT,
        class_7_category VARCHAR(64),
        container_serial_number VARCHAR(256),
        classification VARCHAR(256),
        description VARCHAR(1024),
        added_by_id VARCHAR(256),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT

      )
    ''');

    await db.execute('''
      CREATE TABLE asset_images(
        image_id VARCHAR(32) PRIMARY KEY,
        asset_id VARCHAR(32),
        screening_id VARCHAR(32),
        image_path VARCHAR(1024),
        is_sync TINYINT(1) NOT NULL,
        date_added BIGINT,
        date_updated BIGINT
      )
    ''');

    await db.execute('''
      CREATE TABLE asset_groups(
        asset_group_id VARCHAR(32) PRIMARY KEY,
        asset_id VARCHAR(32),
        group_id VARCHAR(32),
        is_cleared TINYINT(1) NOT NULL DEFAULT '0',
        is_sync TINYINT(1) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE asset_track_logs(
        asset_track_log_id VARCHAR(32) PRIMARY KEY,
        asset_id VARCHAR(32),
        from_location VARCHAR(32),
        to_location VARCHAR(32),
        previous_status VARCHAR(256),
        current_status VARCHAR(256),
        added_by_id VARCHAR(32),
        date_added BIGINT,
        is_sync TINYINT(1) NOT NULL

      )
    ''');

    await db.execute('''
      CREATE TABLE vessels(
        vessel_id VARCHAR(32) PRIMARY KEY,
        name VARCHAR(256),
        vendor_name VARCHAR(256),
        current_location_id VARCHAR(32),
        is_sync TINYINT(1) NOT NULL,
         date_added BIGINT,
        date_updated BIGINT

      )
    ''');

    await db.execute('''
      CREATE TABLE voyages(
        voyage_id VARCHAR(32) PRIMARY KEY,
        vessel_id VARCHAR(32),
        from_location_id VARCHAR(32),
        to_location_id VARCHAR(32),
        added_by_id VARCHAR(32),
        is_sync TINYINT(1) NOT NULL,
         date_added BIGINT,
        date_updated BIGINT

      )
    ''');

    await db.execute('''
      CREATE TABLE voyage_assets(
        voyage_asset_id VARCHAR(32) PRIMARY KEY,
        voyage_id VARCHAR(32),
        asset_id VARCHAR(32),
        is_sync TINYINT(1) NOT NULL

      )
    ''');

    await db.execute('''
      CREATE TABLE asset_column_history(
        history_id VARCHAR(32) PRIMARY KEY,
        asset_id VARCHAR(32),
        column_name VARCHAR(256),
        old_value VARCHAR(256),
        new_value VARCHAR(256),
        comments VARCHAR(1024),
        date_added BIGINT,
        added_by_id VARCHAR(32),
        is_sync TINYINT(1) NOT NULL

      )
    ''');

    await db.execute('''
      CREATE TABLE asset_notes(
        note_id VARCHAR(32) PRIMARY KEY,
        asset_id VARCHAR(32),
        description VARCHAR(1024),
        date_added BIGINT,
        added_by_id VARCHAR(32),
        operating_location_id VARCHAR(32),
        status VARCHAR(256),
        is_sync TINYINT(1) NOT NULL

      )
    ''');

    await db.execute('''
      CREATE TABLE asset_logs(
        asset_log_id VARCHAR(32) PRIMARY KEY,
        asset_id VARCHAR(32),
        current_transaction TEXT,
        event_type VARCHAR(256),
        event_description TEXT,
        rf_id VARCHAR(64),
        asset_type VARCHAR(256),
        current_location_id VARCHAR(32),
        from_location_id VARCHAR(32),
        to_location_id VARCHAR(32),
        container_type_id VARCHAR(32),
        vessel_id VARCHAR(32),
        product_id VARCHAR(32),
        drum_type_id VARCHAR(32),
        waste_type_id VARCHAR(32),
        status VARCHAR(256),
        added_by_id VARCHAR(32),
        date_added BIGINT,
        is_sync TINYINT(1) NOT NULL

      )
    ''');
  }

  Future<void> insertRole(Role role) async {
    Database? database = await instance.database;

    final roleMap = role.toMap();
    final filteredMap =
        Map.fromEntries(roleMap.entries.where((entry) => entry.value != null));

    await database?.insert('roles', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertUser(User user) async {
    Database? database = await instance.database;
    final userMap = user.toMap();
    final filteredMap =
        Map.fromEntries(userMap.entries.where((entry) => entry.value != null));

    await database?.insert('users', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertOperatingLocation(OperatingLocation location) async {
    Database? database = await instance.database;

    final locationMap = location.toMap();
    final filteredMap = Map.fromEntries(
        locationMap.entries.where((entry) => entry.value != null));

    await database?.insert('operating_locations', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertLoction(Location location) async {
    Database? database = await instance.database;

    final locationMap = location.toMap();
    final filteredMap = Map.fromEntries(
        locationMap.entries.where((entry) => entry.value != null));

    await database?.insert('locations', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCategories(Category category) async {
    Database? database = await instance.database;
    final categoryMap = category.toMap();
    final filteredMap = Map.fromEntries(
        categoryMap.entries.where((entry) => entry.value != null));

    await database?.insert('categories', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertProductTypes(ProductType productType) async {
    Database? database = await instance.database;
    final productTypeMap = productType.toMap();
    final filteredMap = Map.fromEntries(
        productTypeMap.entries.where((entry) => entry.value != null));

    await database?.insert('product_types', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertProduct(Product product) async {
    Database? database = await instance.database;
    final productMap = product.toMap();
    final filteredMap = Map.fromEntries(
        productMap.entries.where((entry) => entry.value != null));

    await database?.insert('products', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertContainerType(ContainerType containerType) async {
    Database? database = await instance.database;
    final containerTypeMap = containerType.toMap();
    final filteredMap = Map.fromEntries(
        containerTypeMap.entries.where((entry) => entry.value != null));

    await database?.insert('container_types', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertDrumType(DrumType drumType) async {
    Database? database = await instance.database;
    final drumTypeMap = drumType.toMap();
    final filteredMap = Map.fromEntries(
        drumTypeMap.entries.where((entry) => entry.value != null));

    await database?.insert('drum_types', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertWasteType(WasteType wasteType) async {
    Database? database = await instance.database;
    final wasteTypeMap = wasteType.toMap();
    final filteredMap = Map.fromEntries(
        wasteTypeMap.entries.where((entry) => entry.value != null));

    await database?.insert('waste_types', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAsset(Asset asset) async {
    Database? database = await instance.database;
    final assetMap = asset.toMap();
    final filteredMap =
        Map.fromEntries(assetMap.entries.where((entry) => entry.value != null));

    await database?.insert('assets', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertScreeningAsset(AssetScreening asset_screenings) async {
    Database? database = await instance.database;
    final assetMap = asset_screenings.toMap();
    final filteredMap =
        Map.fromEntries(assetMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_screenings', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAssetImage(Asset_Image asset_image) async {
    Database? database = await instance.database;
    final asset_imageMap = asset_image.toMap();
    final filteredMap = Map.fromEntries(
        asset_imageMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_images', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAssetGroup(AssetGroup assetGroup) async {
    Database? database = await instance.database;
    final assetGroupMap = assetGroup.toMap();
    final filteredMap = Map.fromEntries(
        assetGroupMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_groups', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAssetTrackLog(AssetTrackLog assetTrackLog) async {
    Database? database = await instance.database;

    final assetTrackLogMap = assetTrackLog.toMap();
    final filteredMap = Map.fromEntries(
        assetTrackLogMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_track_logs', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertVessel(Vessel vessel) async {
    Database? database = await instance.database;
    final vesselMap = vessel.toMap();
    final filteredMap = Map.fromEntries(
        vesselMap.entries.where((entry) => entry.value != null));

    await database?.insert('vessels', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertVoyage(Voyage voyage) async {
    Database? database = await instance.database;
    final voyageMap = voyage.toMap();
    final filteredMap = Map.fromEntries(
        voyageMap.entries.where((entry) => entry.value != null));

    await database?.insert('voyages', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertVoyageAsset(VoyageAsset voyageAsset) async {
    Database? database = await instance.database;
    final voyageAssetMap = voyageAsset.toMap();
    final filteredMap = Map.fromEntries(
        voyageAssetMap.entries.where((entry) => entry.value != null));

    await database?.insert('voyage_assets', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAssetColumnHistory(
      AssetColumnHistory assetColumnHistory) async {
    Database? database = await instance.database;
    final AssetColumnHistoryMap = assetColumnHistory.toMap();
    final filteredMap = Map.fromEntries(
        AssetColumnHistoryMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_column_history', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertNotes(AssetNotes assetNotes) async {
    Database? database = await instance.database;
    final AssetNotesMap = assetNotes.toMap();
    final filteredMap = Map.fromEntries(
        AssetNotesMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_notes', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAssetLog(AssetLog assetLog) async {
    Database? database = await instance.database;
    final AssetLogMap = assetLog.toMap();
    final filteredMap = Map.fromEntries(
        AssetLogMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_logs', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String> createAssetScreening(AssetScreening screening) async {
    Database? database = await instance.database;
    final screening_id = await timedId();

    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    screening.screening_id = screening_id;
    screening.added_by_id = userInfo['user_id'];
    screening.date_added = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    screening.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    screening.is_sync = 0;

    final assetImageMap = screening.toMap();
    final filteredMap = Map.fromEntries(
        assetImageMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_screenings', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return screening_id;
  }

  Future updateAssetScreening(AssetScreening screening) async {
    Database? database = await instance.database;

    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    screening.added_by_id = userInfo['user_id'];
    screening.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    screening.is_sync = 0;

    final assetScreeningMap = screening.toMap();
    final filteredMap = Map.fromEntries(
      assetScreeningMap.entries.where((entry) => entry.value != null),
    );

    return await database?.update(
      'asset_screenings',
      filteredMap,
      where: 'asset_id = ?',
      whereArgs: [screening.asset_id],
    );
  }

  Future<void> createImage(Asset_Image image) async {
    Database? database = await instance.database;
    image.image_id = await timedId();
    image.is_sync = 0;

    final assetImageMap = image.toMap();
    final filteredMap = Map.fromEntries(
        assetImageMap.entries.where((entry) => entry.value != null));
    await database?.insert('asset_images', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return;
  }

  Future<Asset> createAsset(Asset asset, {List<Asset>? items}) async {
    Database? database = await instance.database;
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    asset.added_by_id = userInfo['user_id'];
    asset.operating_location_id = userInfo['locationId'];

    if (asset.asset_type == AssetType.CONTAINER) {
      // Container Creation
      final container = await queryUnique('assets', 'rf_id', asset.rf_id);

      if (container != null && container.length > 0) {
        if (items == null || items.length == 0) {
          throw Exception(
              'Container with this RFID already exists. Kindly Add Items in container');
        }
        final asset_id = container[0]['asset_id'];
        // Update Container & Add Items In Container

        asset.status = AssetStatus.LOADED;
        asset.is_contaminated = 0;
        asset.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
        asset.classification = Classification.NON_CONTAMINATED;
        asset.is_sync = 0;

        for (var item in items) {
          if (item.is_contaminated == 1) {
            asset.is_contaminated = 1;
            break;
          }
        }

        for (var item in items) {
          if (item.classification == Classification.HAZARDOUS) {
            asset.classification = Classification.HAZARDOUS;
            break;
          }

          if (item.classification == Classification.CONTAMINATED) {
            asset.classification = Classification.CONTAMINATED;
          }
        }

        final assetMap = asset.toMap();
        final filteredMap = Map.fromEntries(
            assetMap.entries.where((entry) => entry.value != null));

        filteredMap.remove('asset_id');
        filteredMap.remove('product');
        filteredMap.remove('product_no');
        filteredMap.remove('pulling_line');
        filteredMap.remove('container_type');
        filteredMap.remove('drum_type');
        filteredMap.remove('waste_type');

        await update('assets', 'asset_id', asset.asset_id, filteredMap);

        final asset_groups = await queryList('asset_groups', [
          ['group_id', '=', asset_id]
        ], {});

        var group_asset_ids = [];
        if (asset_groups != null && group_asset_ids.length > 0) {
          final assetGroupJson =
              asset_groups.map((json) => AssetGroup.fromJson(json)).toList();
          group_asset_ids = assetGroupJson.map((obj) => obj.asset_id).toList();
        }

        for (var item in items) {
          if (group_asset_ids.contains(item.asset_id)) {
            continue;
          }

          await update('assets', 'asset_id', item.asset_id,
              {'status': AssetStatus.LOADED, 'is_sync': 0});

          final logData = {
            'asset_track_log_id': await timedId(),
            'asset_id': item.asset_id,
            'from_location': item.operating_location_id,
            'to_location': item.operating_location_id,
            'previous_status': AssetStatus.READY_TO_LOAD,
            'current_status': AssetStatus.LOADED,
            'added_by_id': userInfo['user_id'],
            'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
            'is_sync': 0
          };

          await database?.insert('asset_track_logs', logData,
              conflictAlgorithm: ConflictAlgorithm.replace);

          final existingGroups = await queryList('asset_groups', [
            ['group_id', '=', asset_id]
          ], {});

          final groupJson =
              existingGroups?.map((json) => AssetGroup.fromJson(json)).toList();
          final groupIds = groupJson?.map((obj) => obj.asset_id).toList();

          if (groupIds != null &&
              groupIds.length > 0 &&
              groupIds.contains(asset.asset_id)) {
          } else {
            final groupData = {
              'asset_group_id': await timedId(),
              'group_id': asset_id,
              'asset_id': item.asset_id,
              'is_sync': 0
            };

            await database?.insert('asset_groups', groupData,
                conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      } else {
        // Create Container
        asset.asset_id = await timedId();
        asset.status = AssetStatus.READY_TO_LOAD;
        asset.date_added = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
        asset.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
        asset.is_sync = 0;

        final op_lc = await queryUnique('operating_locations',
            'operating_location_id', userInfo['locationId']);
        asset.starting_point = op_lc?[0]['name'] + ' ' + op_lc?[0]['type'];

        final assetMap = asset.toMap();
        final filteredMap = Map.fromEntries(
            assetMap.entries.where((entry) => entry.value != null));

        final rfIdExists = await queryUnique('assets', 'rf_id', asset.rf_id);
        if (rfIdExists?.length != 0) {
          throw Exception('RFID already exists.');
        }

        await database?.insert('assets', filteredMap,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } else {
      // Asset Creation (Bundle, Batch, HazMat Waste, Ancillary, Subsea Structure)
      final op_lc = await queryUnique('operating_locations',
          'operating_location_id', userInfo['locationId']);

      Database? db = await instance.database;
      if (asset.asset_type == AssetType.FLEXIBLES) {
        asset.asset_type = AssetType.BUNDLE;

        final prevoious_bundle = await db?.rawQuery(
            'SELECT bundle_no FROM assets WHERE starting_point = "${userInfo['location_name']}" ORDER BY bundle_no DESC LIMIT 1');

        if (prevoious_bundle != null && prevoious_bundle.length > 0) {
          final previous_bundle_no = prevoious_bundle[0]['bundle_no'];
          asset.bundle_no =
              previous_bundle_no != null ? (previous_bundle_no as int) + 1 : 1;
        } else {
          asset.bundle_no = 1;
        }
      } else if (asset.asset_type == AssetType.RIGID_PIPE) {
        asset.asset_type = AssetType.BATCH;
        final rigid_rf = await timedId();
        asset.rf_id = 'Rigid-$rigid_rf';

        final prevoious_batch = await db?.rawQuery(
            'SELECT batch_no FROM assets WHERE starting_point = "${userInfo['location_name']}" AND batch_no LIKE "RGP%" ORDER BY batch_no DESC LIMIT 1');

        if (prevoious_batch != null && prevoious_batch.length > 0) {
          final prevoious_batch_no = prevoious_batch[0]['batch_no'];

          if (prevoious_batch_no != null) {
            final batch_no_list = prevoious_batch_no.toString().split('-');
            var previousNumber =
                int.parse(batch_no_list[batch_no_list.length - 1]);
            previousNumber = previousNumber + 1;
            asset.batch_no =
                generateCustomNo('RGP', op_lc?[0]['name'], previousNumber);
          } else {
            asset.batch_no = generateCustomNo('RGP', op_lc?[0]['name'], 1);
          }
        } else {
          asset.batch_no = generateCustomNo('RGP', op_lc?[0]['name'], 1);
        }
      } else if (asset.asset_type == AssetType.HAZMAT_WASTE) {
        final prevoious_drum = await db?.rawQuery(
            'SELECT drum_no FROM assets WHERE starting_point = "${userInfo['location_name']}" ORDER BY drum_no DESC LIMIT 1');

        if (prevoious_drum != null && prevoious_drum.length > 0) {
          final prevoious_drum_no = prevoious_drum[0]['drum_no'];

          if (prevoious_drum_no != null) {
            final drum_no_list = prevoious_drum_no.toString().split('-');
            final previousNumber =
                int.parse(drum_no_list[drum_no_list.length - 1]);

            asset.drum_no =
                generateCustomNo('OW', op_lc?[0]['name'], previousNumber);
          } else {
            asset.drum_no = generateCustomNo('OW', op_lc?[0]['name'], 1);
          }
        } else {
          asset.drum_no = generateCustomNo('OW', op_lc?[0]['name'], 1);
        }
      } else if (asset.asset_type == AssetType.ANCILLARY_BATCH) {
        final rigid_rf = await timedId();
        asset.rf_id = 'Ancillary-$rigid_rf';

        final prevoious_anc_batch = await db?.rawQuery(
            'SELECT batch_no FROM assets WHERE starting_point = "${userInfo['location_name']}" AND batch_no LIKE "ANC%" ORDER BY batch_no DESC LIMIT 1');

        if (prevoious_anc_batch != null && prevoious_anc_batch.length > 0) {
          final prevoious_anc_batch_no = prevoious_anc_batch[0]['batch_no'];

          if (prevoious_anc_batch_no != null) {
            final batch_no_list = prevoious_anc_batch_no.toString().split('-');
            var previousNumber =
                int.parse(batch_no_list[batch_no_list.length - 1]);
            previousNumber = previousNumber + 1;
            asset.batch_no =
                generateCustomNo('ANC', op_lc?[0]['name'], previousNumber);
          } else {
            asset.batch_no = generateCustomNo('ANC', op_lc?[0]['name'], 1);
          }
        } else {
          asset.batch_no = generateCustomNo('ANC', op_lc?[0]['name'], 1);
        }
      }

      asset.status = AssetStatus.READY_TO_LOAD;

      if (op_lc?[0]['type'] == LocationType.DECONTAM_YARD) {
        asset.status = AssetStatus.TAGGED;
      }

      asset.asset_id = await timedId();
      asset.starting_point = op_lc?[0]['name'] + ' ' + op_lc?[0]['type'];
      asset.date_added = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
      asset.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
      asset.is_sync = 0;

      final assetMap = asset.toMap();
      final filteredMap = Map.fromEntries(
          assetMap.entries.where((entry) => entry.value != null));

      final rfIdExists = await queryUnique('assets', 'rf_id', asset.rf_id);

      if (rfIdExists?.length != 0) {
        Utils.SnackBar('Error', 'RFID already exists.');
        throw Exception('RFID already exists.');
      }

      await database?.insert('assets', filteredMap,
          conflictAlgorithm: ConflictAlgorithm.replace);

      if (asset.product_id != null) {
        await updateProduct(asset);
      }
    }

    return asset;
  }

  Future<void> updateProduct(Asset asset) async {
    if ([
      AssetType.ANCILLARY_EQUIPMENT,
      AssetType.ANCILLARY_BATCH,
      AssetType.SUBSEA_STRUCTURE
    ].contains(asset.asset_type)) {
      var product =
          await queryUnique('products', 'product_id', asset.product_id);

      var quantity = product?[0]['quantity'] ?? 0.0;
      var oldUsed = product?[0]['used'] ?? 0.0;
      var used = oldUsed + asset.quantity;
      var status = (used >= double.parse(quantity))
          ? ProductStatus.COMPLETED
          : ProductStatus.IN_PROGRESS;
      await update('products', 'product_id', asset.product_id, {
        'status': status,
        'used': used,
        'is_sync': 0,
        'date_updated': (DateTime.now().millisecondsSinceEpoch) ~/ 1000
      });
    } else {
      await update('products', 'product_id', asset.product_id, {
        'status': 'In Progress',
        'is_sync': 0,
        'date_updated': (DateTime.now().millisecondsSinceEpoch) ~/ 1000
      });
    }
  }

  Future<void> createVoyage(Voyage voyage, List<Asset> items) async {
    if (items.length == 0) {
      throw Exception('Kindly Add Items For Voyage.');
    }

    Database? database = await instance.database;
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    voyage.voyage_id = await timedId();
    voyage.added_by_id = userInfo['user_id'];
    voyage.date_added = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    voyage.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    voyage.is_sync = 0;

    final assetMap = voyage.toMap();
    final filteredMap =
        Map.fromEntries(assetMap.entries.where((entry) => entry.value != null));

    await database?.insert('voyages', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);

    for (var item in items) {
      await update('assets', 'asset_id', item.asset_id, {
        'status': AssetStatus.IN_TRANSIT,
        'yard_location_id': voyage.to_location_id,
        'is_sync': 0
      });
      print('item');
      print(item.asset_id);
      final logData = {
        'asset_track_log_id': await timedId(),
        'asset_id': item.asset_id,
        'from_location': voyage.from_location_id,
        'to_location': voyage.to_location_id,
        'previous_status': AssetStatus.LOADED,
        'current_status': AssetStatus.IN_TRANSIT,
        'added_by_id': userInfo['user_id'],
        'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
        'is_sync': 0
      };

      await database?.insert('asset_track_logs', logData,
          conflictAlgorithm: ConflictAlgorithm.replace);

      final groupData = {
        'voyage_asset_id': await timedId(),
        'voyage_id': voyage.voyage_id,
        'asset_id': item.asset_id,
        'is_sync': 0
      };

      await database?.insert('voyage_assets', groupData,
          conflictAlgorithm: ConflictAlgorithm.replace);

      final assetIds = items.map((obj) => obj.asset_id).toList();
      final assetIdsString = makeIdsForIN(assetIds);

      final groups = await queryList('asset_groups', [
        ['group_id', 'IN', '($assetIdsString)']
      ], {});

      if (groups != null && groups.length > 0) {
        final groupsJson =
            groups.map((json) => AssetGroup.fromJson(json)).toList();

        final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
        final childAssetIdsString = makeIdsForIN(childAssetIds);

        final childAssets = await queryList('assets', [
          ['asset_id', 'IN', '($childAssetIdsString)']
        ], {});

        var previousLocations = {};
        if (childAssets != null && childAssets.length > 0) {
          for (var childAsset in childAssets) {
            previousLocations[childAsset['asset_id']] =
                childAsset['operating_location_id'];
          }
        }

        for (var group in groups) {
          await update('assets', 'asset_id', group['asset_id'], {
            'status': AssetStatus.IN_TRANSIT,
            'yard_location_id': voyage.to_location_id,
            'is_sync': 0
          });

          final logData = {
            'asset_track_log_id': await timedId(),
            'asset_id': group['asset_id'],
            'from_location': voyage.from_location_id,
            'to_location': voyage.to_location_id,
            'previous_status': AssetStatus.LOADED,
            'current_status': AssetStatus.IN_TRANSIT,
            'added_by_id': userInfo['user_id'],
            'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
            'is_sync': 0
          };

          await database?.insert('asset_track_logs', logData,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
  }

  Future<void> markMultipleArrivedAtYard(List<Asset> items) async {
    if (items.length == 0) {
      throw Exception('Kindly Add Items That Arrived On Quayside');
    }

    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    final currentLocationId = userInfo['locationId'];

    Database? database = await instance.database;

    for (var item in items) {
      await update('assets', 'asset_id', item.asset_id, {
        'status': AssetStatus.ARRIVED_AT_YARD,
        'operating_location_id': currentLocationId,
        'is_sync': 0
      }).whenComplete(() {
        if (item.asset_type == AssetType.ANCILLARY_EQUIPMENT ||
            item.asset_type == AssetType.SUBSEA_STRUCTURE)
          assignStorage(
              [item],
              item.asset_type == AssetType.ANCILLARY_EQUIPMENT
                  ? 'Ancillary Equipment Area'
                  : 'Subsea Structures Area');
      });

      final logData = {
        'asset_track_log_id': await timedId(),
        'asset_id': item.asset_id,
        'from_location': item.operating_location_id,
        'to_location': currentLocationId,
        'previous_status': AssetStatus.IN_TRANSIT,
        'current_status': AssetStatus.ARRIVED_AT_YARD,
        'added_by_id': userInfo['user_id'],
        'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
        'is_sync': 0
      };

      await database?.insert('asset_track_logs', logData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    final assetIds = items.map((obj) => obj.asset_id).toList();
    final assetIdsString = makeIdsForIN(assetIds);

    final groups = await queryList('asset_groups', [
      ['group_id', 'IN', '($assetIdsString)']
    ], {});

    if (groups != null && groups.length > 0) {
      final groupsJson =
          groups.map((json) => AssetGroup.fromJson(json)).toList();

      final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
      final childAssetIdsString = makeIdsForIN(childAssetIds);

      final childAssets = await queryList('assets', [
        ['asset_id', 'IN', '($childAssetIdsString)']
      ], {});

      var previousLocations = {};
      if (childAssets != null && childAssets.length > 0) {
        for (var childAsset in childAssets) {
          previousLocations[childAsset['asset_id']] =
              childAsset['operating_location_id'];
        }
      }

      for (var group in groups) {
        await update('assets', 'asset_id', group['asset_id'], {
          'status': AssetStatus.ARRIVED_AT_YARD,
          'operating_location_id': currentLocationId,
          'is_sync': 0
        });

        final logData = {
          'asset_track_log_id': await timedId(),
          'asset_id': group['asset_id'],
          'from_location': previousLocations[group['asset_id']] ?? null,
          'to_location': currentLocationId,
          'previous_status': AssetStatus.IN_TRANSIT,
          'current_status': AssetStatus.ARRIVED_AT_YARD,
          'added_by_id': userInfo['user_id'],
          'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
          'is_sync': 0
        };

        await database?.insert('asset_track_logs', logData,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> InsertTrackLog(logData) async {
    Database? database = await instance.database;
    await database?.insert('asset_track_logs', logData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> markArrivedAtYard(Asset asset) async {
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    final currentLocationId = userInfo['locationId'];

    Database? database = await instance.database;

    await update('assets', 'asset_id', asset.asset_id, {
      'status': AssetStatus.ARRIVED_AT_YARD,
      'operating_location_id': currentLocationId,
      'is_sync': 0
    }).whenComplete(() {
      if (asset.asset_type == AssetType.ANCILLARY_EQUIPMENT ||
          asset.asset_type == AssetType.SUBSEA_STRUCTURE)
        assignStorage(
            [asset],
            asset.asset_type == AssetType.ANCILLARY_EQUIPMENT
                ? 'Ancillary Equipment Area'
                : 'Subsea Structures Area');
    });

    final logData = {
      'asset_track_log_id': await timedId(),
      'asset_id': asset.asset_id,
      'from_location': asset.operating_location_id,
      'to_location': currentLocationId,
      'previous_status': AssetStatus.IN_TRANSIT,
      'current_status': AssetStatus.ARRIVED_AT_YARD,
      'added_by_id': userInfo['user_id'],
      'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
      'is_sync': 0
    };

    await database?.insert('asset_track_logs', logData,
        conflictAlgorithm: ConflictAlgorithm.replace);

    final groups = await queryList('asset_groups', [
      ['group_id', '=', '${asset.asset_id}']
    ], {});

    if (groups != null && groups.length > 0) {
      final groupsJson =
          groups.map((json) => AssetGroup.fromJson(json)).toList();

      final childAssetIds = groupsJson.map((obj) => obj.asset_id).toList();
      final childAssetIdsString = makeIdsForIN(childAssetIds);

      final childAssets = await queryList('assets', [
        ['asset_id', 'IN', '($childAssetIdsString)']
      ], {});

      var previousLocations = {};
      if (childAssets != null && childAssets.length > 0) {
        for (var childAsset in childAssets) {
          previousLocations[childAsset['asset_id']] =
              childAsset['operating_location_id'];
        }
      }

      for (var group in groups) {
        await update('assets', 'asset_id', group['asset_id'], {
          'status': AssetStatus.ARRIVED_AT_YARD,
          'operating_location_id': currentLocationId,
          'is_sync': 0
        });

        final logData = {
          'asset_track_log_id': await timedId(),
          'asset_id': group['asset_id'],
          'from_location': previousLocations[group['asset_id']] ?? null,
          'to_location': currentLocationId,
          'previous_status': AssetStatus.IN_TRANSIT,
          'current_status': AssetStatus.ARRIVED_AT_YARD,
          'added_by_id': userInfo['user_id'],
          'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
          'is_sync': 0
        };

        await database?.insert('asset_track_logs', logData,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  void assignStorage(List<Asset> assets, String rack) async {
    for (final asset in assets) {
      asset.storage_area = StorageArea.YARD_STORAGE;
      asset.storage_rack = rack;
      asset.status = AssetStatus.MOVED_TO_YARD_STORAGE;

      await DatabaseHelper.instance.update(
        'asset_groups',
        'asset_id',
        asset.asset_id,
        {'is_cleared': 1, 'is_sync': 0},
      );
      await DatabaseHelper.instance
          .update('assets', 'asset_id', asset.asset_id, {
        'storage_area': StorageArea.YARD_STORAGE,
        'storage_rack': rack,
        'status': AssetStatus.MOVED_TO_YARD_STORAGE,
        'is_sync': 0
      });
      final userInfo =
          await SharedPreferencesHelper.retrieveUserInfo('userInfo');

      final oldAsset =
          await DatabaseHelper.instance.queryList('asset_track_logs', [
        ['asset_id', '=', asset.asset_id],
        ['current_status', '=', AssetStatus.ARRIVED_AT_YARD],
      ], {});
      final logData = {
        'asset_track_log_id': await timedId(),
        'asset_id': asset.asset_id,
        'from_location': oldAsset?[0]['to_location'],
        'to_location': oldAsset?[0]['to_location'],
        'previous_status': oldAsset?[0]['current_status'],
        'current_status': asset.status,
        'added_by_id': userInfo['user_id'],
        'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
        'is_sync': 0
      };

      Database? db = await instance.database;
      await db?.insert('asset_track_logs', logData,
          conflictAlgorithm: ConflictAlgorithm.replace);

      AssetLog log = new AssetLog();

      String eventType = EventType.MOVED_TO_YARD_STORAGE;
      var template = eventDefinition[eventType].toString();
      Map<String, String> variables = {
        'asset_type': asset.asset_type.toString(),
        'rf_id': asset.rf_id.toString(),
        'rack': rack,
        'current_location': userInfo['location_name'],
        'user': userInfo['user_name'],
        'time': DateFormat('hh:mm a MMM dd yyyy').format(DateTime.now()),
      };
      var eventDesc = replaceVariables(template, variables);

      log.asset_id = asset.asset_id.toString();
      log.rf_id = asset.rf_id.toString();
      log.event_type = eventType;
      log.asset_type = asset.asset_type.toString();
      log.current_transaction = jsonEncode(asset.toMap());
      log.event_description = eventDesc;
      log.status = asset.status.toString();
      log.current_location_id = userInfo['locationId'];
      DatabaseHelper.instance.createAssetLog(log);
    }

    Get.to(NewBottomNavigation());
  }

  Future<Asset> createIndividualAsset(Asset parentAsset, rfId) async {
    final rfIdExists = await queryUnique('assets', 'rf_id', rfId);
    if (rfIdExists?.length != 0) {
      throw Exception('RFID already exists.');
    }

    Database? database = await instance.database;
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    var assetType;
    if (parentAsset.asset_type == AssetType.BUNDLE) {
      assetType = AssetType.FLEXIBLES;
    } else if (parentAsset.asset_type == AssetType.BATCH) {
      assetType = AssetType.RIGID_PIPE;
    } else if (parentAsset.asset_type == AssetType.ANCILLARY_BATCH) {
      assetType = AssetType.ANCILLARY_EQUIPMENT;
    }

    final now = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    final op_lc = await queryUnique(
        'operating_locations', 'operating_location_id', userInfo['locationId']);

    final asset = new Asset(
      asset_id: await timedId(),
      rf_id: rfId,
      starting_point: op_lc?[0]['name'] + ' ' + op_lc?[0]['type'],
      operating_location_id: userInfo['locationId'],
      product_id: parentAsset.product_id,
      // pulling_line_id: parentAsset.pulling_line_id,
      asset_type: assetType,
      bundle_no: parentAsset.bundle_no,
      batch_no: parentAsset.batch_no,
      drum_no: parentAsset.drum_no,
      drum_type_id: parentAsset.drum_type_id,
      waste_type_id: parentAsset.waste_type_id,
      // no_of_joints: parentAsset.no_of_joints,
      // no_of_lengths: parentAsset.no_of_lengths,
      // no_of_lengths: parentAsset.no_of_lengths,
      // approximate_weight: parentAsset.approximate_weight,
      // crane_weight: parentAsset.crane_weight,
      // dimensions: parentAsset.dimensions,
      weight_in_air: parentAsset.weight_in_air,
      is_hydrocarbon: parentAsset.is_hydrocarbon,
      is_mercury: parentAsset.is_mercury,
      is_radiation: parentAsset.is_radiation,
      is_rph: parentAsset.is_rph,
      is_contaminated: parentAsset.is_contaminated,
      benzene: parentAsset.benzene,
      voc: parentAsset.voc,
      surface_reading_gm: parentAsset.surface_reading_gm,
      surface_reading_ppm: parentAsset.surface_reading_ppm,
      vapour: parentAsset.vapour,
      h2s: parentAsset.h2s,
      lel: parentAsset.lel,
      surface_contamination: parentAsset.surface_contamination,
      adg_class: parentAsset.adg_class,
      un_number: parentAsset.un_number,
      class_7_category: parentAsset.class_7_category,
      classification: parentAsset.classification,
      status: AssetStatus.TAGGED,
      description: parentAsset.description,
      added_by_id: userInfo['user_id'],
      is_sync: 0,
      date_added: now,
      date_updated: now,
    );

    final assetMap = asset.toMap();
    final filteredMap =
        Map.fromEntries(assetMap.entries.where((entry) => entry.value != null));

    await database?.insert('assets', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);

    final existingGroups = await queryList('asset_groups', [
      ['group_id', '=', parentAsset.asset_id]
    ], {});

    final groupJson =
        existingGroups?.map((json) => AssetGroup.fromJson(json)).toList();
    final groupIds = groupJson?.map((obj) => obj.asset_id).toList();

    if (groupIds != null &&
        groupIds.length > 0 &&
        groupIds.contains(asset.asset_id)) {
    } else {
      final groupData = {
        'asset_group_id': await timedId(),
        'group_id': parentAsset.asset_id,
        'asset_id': asset.asset_id,
        'is_sync': 0
      };

      await database?.insert('asset_groups', groupData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Create screening for the new asset
    AssetScreening screening = AssetScreening(
      asset_id: asset.asset_id,
      screening_type: ScreeningType.INITIAL_SCREENING,
      is_hydrocarbon: asset.is_hydrocarbon == 1 ? 1 : 0,
      is_radiation: asset.is_radiation == 1 ? 1 : 0,
      is_rph: asset.is_rph == 1 ? 1 : 0,
      is_contaminated: asset.is_contaminated == 1 ? 1 : 0,
      is_mercury: asset.is_mercury == 1 ? 1 : 0,
      benzene: double.tryParse(asset.benzene.toString()) ?? 0.0,
      voc: double.tryParse(asset.voc.toString()) ?? 0.0,
      surface_reading_gm:
          double.tryParse(asset.surface_reading_gm.toString()) ?? 0.0,
      surface_reading_ppm:
          double.tryParse(asset.surface_reading_ppm.toString()) ?? 0.0,
      vapour: double.tryParse(asset.vapour.toString()) ?? 0.0,
      h2s: double.tryParse(asset.h2s.toString()) ?? 0.0,
      lel: double.tryParse(asset.lel.toString()) ?? 0.0,
      surface_contamination:
          double.tryParse(asset.surface_contamination.toString()) ?? 0.0,
      adg_class: asset.adg_class,
      un_number: asset.un_number,
      dose_rate: double.tryParse(asset.dose_rate.toString()) ?? 0.0,
      class_7_category: asset.class_7_category,
      classification: asset.classification,
      description: asset.description,
      is_sync: 0,
    );

    final Parentscreening =
        await queryUnique('asset_screenings', 'asset_id', parentAsset.asset_id);
    final screening_id = Parentscreening?[0]['screening_id'];
    screening.screening_id = screening_id;
    screening.added_by_id = parentAsset.added_by_id;
    screening.date_added = parentAsset.date_added;
    screening.date_updated = parentAsset.date_updated;
    screening.is_sync = 0;

    final assetImageMap = screening.toMap();
    final filteredScreeningMap = Map.fromEntries(
        assetImageMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_screenings', filteredScreeningMap,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return asset;
  }

  Future<Asset> updateAsset(Asset asset, {String? selectedId}) async {
    final oldAsset = await queryUnique('assets', 'asset_id', asset.asset_id);
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    asset.operating_location_id =
        selectedId == null ? userInfo['locationId'] : selectedId;
    asset.is_sync = 0;

    asset.date_updated = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    final assetMap = asset.toMap();
    final filteredMap =
        Map.fromEntries(assetMap.entries.where((entry) => entry.value != null));

    filteredMap.remove('asset_id');
    filteredMap.remove('product');
    filteredMap.remove('product_no');
    filteredMap.remove('pulling_line');
    filteredMap.remove('container_type');
    filteredMap.remove('drum_type');
    filteredMap.remove('waste_type');

    await update('assets', 'asset_id', asset.asset_id, filteredMap);

    final logData = {
      'asset_track_log_id': await timedId(),
      'asset_id': asset.asset_id,
      'from_location': oldAsset?[0]['operating_location_id'],
      'to_location': asset.operating_location_id,
      'previous_status': oldAsset?[0]['status'],
      'current_status': asset.status,
      'added_by_id': userInfo['user_id'],
      'date_added': (DateTime.now().millisecondsSinceEpoch) ~/ 1000,
      'is_sync': 0
    };

    Database? db = await instance.database;
    await db?.insert('asset_track_logs', logData,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return asset;
  }

  Future<int?> update(table, column, columnValue, data) async {
    Database? db = await instance.database;
    return await db
        ?.update(table, data, where: '$column = ?', whereArgs: [columnValue]);
  }

  Future<void> createAssetColumnHistory(
      AssetColumnHistory assetColumnHistory) async {
    Database? db = await instance.database;
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    assetColumnHistory.history_id = await timedId();
    assetColumnHistory.date_added =
        (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    assetColumnHistory.added_by_id = userInfo['user_id'];
    final assetHistoryMap = assetColumnHistory.toMap();
    final filteredMap = Map.fromEntries(
        assetHistoryMap.entries.where((entry) => entry.value != null));

    await db?.insert('asset_column_history', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createAssetNotes(AssetNotes assetNotes) async {
    Database? db = await instance.database;
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    assetNotes.note_id = await timedId();
    assetNotes.date_added = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    assetNotes.added_by_id = userInfo['user_id'];
    assetNotes.operating_location_id = userInfo['locationId'];
    final assetNoteMap = assetNotes.toMap();
    final filteredMap = Map.fromEntries(
        assetNoteMap.entries.where((entry) => entry.value != null));

    await db?.insert('asset_notes', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createAssetLog(AssetLog log) async {
    Database? database = await instance.database;
    final asset_log_id = await timedId();

    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    log.asset_log_id = asset_log_id;
    log.added_by_id = userInfo['user_id'];
    log.date_added = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    log.is_sync = 0;

    final logMap = log.toMap();
    final filteredMap =
        Map.fromEntries(logMap.entries.where((entry) => entry.value != null));

    await database?.insert('asset_logs', filteredMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>?> queryAllRows(table) async {
    Database? db = await instance.database;
    return await db?.query(table);
  }

  Future<List<ProductType>?>? queryProductTypes(String category) async {
    Database? db = await instance.database;

    final result = await db?.rawQuery(
        'SELECT product_types.product_type_id, product_types.name, product_types.category_id, product_types.date_added, product_types.date_updated, product_types.is_sync FROM product_types INNER JOIN categories ON product_types.category_id = categories.category_id WHERE categories.name = "$category"');
    final resp = result?.map((json) => ProductType.fromJson(json)).toList();
    return resp;
  }

  Future<List<Map<String, dynamic>>?> queryUnique(
      table, columnName, value) async {
    Database? db = await instance.database;
    return await db?.query(table, where: "$columnName = '$value'");
  }

  // [status, In Progress]
  Future<List<dynamic>?>? queryList(
      String table, List<List?>? filters, dynamic search,
      {bool attachFks = true, int? limit = 30, bool debug = false}) async {
    Database? db = await instance.database;
    var where = null;
    filters?.forEach((filter) {
      if (filter?[2] != null && filter?[2].isNotEmpty) {
        final value = filter?[1] != 'IN' ? '"${filter?[2]}"' : filter?[2];

        if (where == null) {
          where = '${filter?[0]} ${filter?[1]} $value';
        } else {
          where += ' AND ${filter?[0]} ${filter?[1]} $value';
        }
      }
    });

    if (search != null) {
      final searchColumns = search['searchColumns'];
      final searchValue = search['searchValue'];

      if (searchValue != null && searchValue.toString().isNotEmpty) {
        searchColumns?.asMap().forEach((index, columnName) {
          if (index == 0 && where != null) {
            where += ' AND ($columnName LIKE "%$searchValue%"';
          } else if (index == 0 && where == null) {
            where = '($columnName LIKE "%$searchValue%"';
          } else if (index == searchColumns.length - 1) {
            where += ' OR $columnName LIKE "%$searchValue%")';
          } else {
            where += ' OR $columnName LIKE "%$searchValue%"';
          }

          if (searchColumns?.length == 1) {
            where += ')';
          }
        });
      }
    }
    if (debug) {
      print('where');
      print(where);
      print('where');
    }
    final results = await db?.query(table, where: where, limit: limit);
    var finalResult = [];
    if (results != null && results.length > 0) {
      for (var result in results) {
        var new_result = {...result};

        if (attachFks) {
          if (result.containsKey('operating_location_id') &&
              result['operating_location_id'] != null) {
            var op_lc = await queryUnique('operating_locations',
                'operating_location_id', result['operating_location_id']);

            new_result['operating_location'] =
                op_lc?[0]['name'] + ' ' + op_lc?[0]['type'] ?? null;
          }

          if (result.containsKey('product_type_id') &&
              result['product_type_id'] != null) {
            var op_lc = await queryUnique(
                'product_types', 'product_type_id', result['product_type_id']);

            new_result['product_type'] = op_lc?[0]['name'] ?? null;
          }

          if (result.containsKey('product_id') &&
              result['product_id'] != null) {
            var op_lc = await queryUnique(
                'products', 'product_id', result['product_id']);

            new_result['product'] = op_lc?[0]['product_name'] ?? null;
            new_result['product_no'] = op_lc?[0]['product_no'] ?? null;
          }

          if (result.containsKey('container_type_id') &&
              result['container_type_id'] != null) {
            var op_lc = await queryUnique('container_types',
                'container_type_id', result['container_type_id']);

            new_result['container_type'] = op_lc?[0]['name'] ?? null;
          }

          if (result.containsKey('drum_type_id') &&
              result['drum_type_id'] != null &&
              result['drum_type_id'].toString().isNotEmpty) {
            var op_lc = await queryUnique(
                'drum_types', 'drum_type_id', result['drum_type_id']);

            new_result['drum_type'] = op_lc?[0]['name'] ?? null;
          }

          if (result.containsKey('waste_type_id') &&
              result['waste_type_id'] != null &&
              result['waste_type_id'].toString().isNotEmpty) {
            var op_lc = await queryUnique(
                'waste_types', 'waste_type_id', result['waste_type_id']);

            new_result['waste_type'] = op_lc?[0]['name'] ?? null;
          }

          if (result.containsKey('pulling_line_id') &&
              result['pulling_line_id'] != null) {
            var op_lc = await queryUnique(
                'locations', 'location_id', result['pulling_line_id']);

            new_result['pulling_line'] = op_lc?[0]['name'] ?? null;
          }

          if (result.containsKey('line_end_1') &&
              result['line_end_1'] != null) {
            var op_lc = await queryUnique(
                'locations', 'location_id', result['line_end_1']);

            new_result['line_end_1_name'] = op_lc?[0]['name'] ?? null;
          }

          if (result.containsKey('line_end_2') &&
              result['line_end_2'] != null) {
            var op_lc = await queryUnique(
                'locations', 'location_id', result['line_end_2']);

            new_result['line_end_2_name'] = op_lc?[0]['name'] ?? null;
          }

          if (result.containsKey('from_location_id') &&
              result['from_location_id'] != null) {
            var op_lc = await queryUnique('operating_locations',
                'operating_location_id', result['from_location_id']);

            new_result['from_location'] =
                op_lc?[0]['name'] + ' ' + op_lc?[0]['type'] ?? null;
          }

          if (result.containsKey('to_location_id') &&
              result['to_location_id'] != null) {
            var op_lc = await queryUnique('operating_locations',
                'operating_location_id', result['to_location_id']);

            new_result['to_location'] =
                op_lc?[0]['name'] + ' ' + op_lc?[0]['type'] ?? null;
          }

          if (result.containsKey('vessel_id') && result['vessel_id'] != null) {
            var op_lc =
                await queryUnique('vessels', 'vessel_id', result['vessel_id']);

            new_result['vessel'] = op_lc?[0]['name'] ?? null;
          }
        }

        finalResult.add(new_result);
      }
    }

    return finalResult;
  }

  Future<void> syncDataFromApi() async {
    Map<String, String> headers = {
      'App-Key': 'us@ma-@pp-k3y',
    };

    final response = await http.get(Uri.parse('$baseurl/api/sync/sync_user'),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);

      if (data != null) {
        SetVersion = data['app_version'];
        print(data['app_version']);
        List<Role> roles =
            (data['roles'] as List).map((role) => Role.fromJson(role)).toList();

        List<User> users =
            (data['users'] as List).map((user) => User.fromJson(user)).toList();

        List<OperatingLocation> operatingLocations =
            (data['operating_locations'] as List)
                .map((operatingLocation) =>
                    OperatingLocation.fromJson(operatingLocation))
                .toList();

        // Ensure the roles, users, and locations lists are not null
        ///  if (roles.isNotEmpty && users.isNotEmpty) {
        //   roles.forEach((role) => insertRole(role));
        // users.forEach((user) => insertUser(user));
        // operatingLocations.forEach((operatingLocation) =>
        //     await insertOperatingLocation(operatingLocation));

        for (var role in roles) {
          await insertRole(role);
        }
        for (var user in users) {
          await insertUser(user);
        }

        for (var operatingLocation in operatingLocations) {
          await insertOperatingLocation(operatingLocation);
        }
      } else {
        throw Exception('Invalid data format from API');
      }
      // } else {
      //   throw Exception('Invalid data format from API');
      // }
    } else {
      print(
          'API Error: ${response.statusCode} - ${response.body}'); // Add this line for debug purposes
      throw Exception('Failed to load data from API');
    }
  }

  // Future<void> syncDataFromServer() async {
  //   final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

  //   Map<String, String> headers = {
  //     'App-Key': 'us@ma-@pp-k3y',
  //   };

  //   final response = await http.get(
  //       Uri.parse(
  //           '$baseurl/api/sync/sync_data?app_version=${userInfo['app_version']}'),
  //       headers: headers);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic>? data = json.decode(response.body);

  //     if (data != null) {
  //       List<Location> locations = (data['locations'] as List)
  //           .map((location) => Location.fromJson(location))
  //           .toList();
  //       List<Category> categories = (data['categories'] as List)
  //           .map((categorie) => Category.fromJson(categorie))
  //           .toList();
  //       List<ProductType> product_types = (data['product_types'] as List)
  //           .map((product_type) => ProductType.fromJson(product_type))
  //           .toList();
  //       List<Product> products = (data['products'] as List)
  //           .map((product) => Product.fromJson(product))
  //           .toList();
  //       List<ContainerType> container_types = (data['container_types'] as List)
  //           .map((container_type) => ContainerType.fromJson(container_type))
  //           .toList();
  //       List<DrumType> drum_types = (data['drum_types'] as List)
  //           .map((drum_type) => DrumType.fromJson(drum_type))
  //           .toList();
  //       List<WasteType> waste_types = (data['waste_types'] as List)
  //           .map((waste_type) => WasteType.fromJson(waste_type))
  //           .toList();
  //       List<Asset> assets = (data['assets'] as List)
  //           .map((asset) => Asset.fromJson(asset))
  //           .toList();
  //       // List<AssetScreening> asset_screenings = (data['asset_screenings']
  //       //         as List)
  //       //     .map(
  //       //         (asset_screenings) => AssetScreening.fromJson(asset_screenings))
  //       //     .toList();

  //       // List<Asset_Image> asset_images = (data['asset_images'] as List)
  //       //     .map((asset_image) => Asset_Image.fromJson(asset_image))
  //       //     .toList();
  //       List<AssetGroup> asset_groups = (data['asset_groups'] as List)
  //           .map((asset_group) => AssetGroup.fromJson(asset_group))
  //           .toList();
  //       List<AssetTrackLog> asset_track_logs = (data['asset_track_logs']
  //               as List)
  //           .map((asset_track_log) => AssetTrackLog.fromJson(asset_track_log))
  //           .toList();
  //       List<Vessel> vessels = (data['vessels'] as List)
  //           .map((vessel) => Vessel.fromJson(vessel))
  //           .toList();
  //       List<Voyage> voyages = (data['voyages'] as List)
  //           .map((voyage) => Voyage.fromJson(voyage))
  //           .toList();
  //       List<VoyageAsset> voyage_assets = (data['voyage_assets'] as List)
  //           .map((voyage_asset) => VoyageAsset.fromJson(voyage_asset))
  //           .toList();

  //       // Ensure the roles, users, and locations lists are not null
  //       if (locations.isNotEmpty) {
  //         locations.forEach((location) => insertLoction(location));
  //         categories.forEach((category) => insertCategories(category));
  //         product_types
  //             .forEach((productType) => insertProductTypes(productType));
  //         products.forEach((product) => insertProduct(product));
  //         container_types
  //             .forEach((container_type) => insertContainerType(container_type));
  //         drum_types.forEach((drum_type) => insertDrumType(drum_type));
  //         waste_types.forEach((waste_type) => insertWasteType(waste_type));
  //         assets.forEach((asset) => insertAsset(asset));
  //         // asset_screenings.forEach(
  //         //     (asset_screenings) => insertScreeningAsset(asset_screenings));
  //         // asset_images.forEach((asset_image) => insertAssetImage(asset_image));
  //         asset_groups.forEach((asset_group) => insertAssetGroup(asset_group));
  //         asset_track_logs.forEach(
  //             (asset_track_log) => insertAssetTrackLog(asset_track_log));
  //         vessels.forEach((vessel) => insertVessel(vessel));
  //         voyages.forEach((voyage) => insertVoyage(voyage));
  //         voyage_assets
  //             .forEach((voyage_asset) => insertVoyageAsset(voyage_asset));
  //       } else {
  //         throw Exception('Invalid data format from API');
  //       }
  //     } else {
  //       throw Exception('Invalid data format from API');
  //     }
  //   } else {
  //     print('API Error: ${response.statusCode} - ${response.body}');

  //     try {
  //       // Try parsing the response body as JSON
  //       final Map<String, dynamic> errorJson = json.decode(response.body);
  //       final errorMessage = errorJson['message'] as String;

  //       Utils.SnackBar('Error', errorMessage);
  //     } catch (e) {
  //       // If parsing fails, display the entire response body as the error message
  //       Utils.SnackBar('Error', '${response.body}',
  //           duration: Duration(seconds: 5));
  //     }

  //     throw Exception('Failed to load data from API');
  //   }
  // }

  ///======
  // Future<void> syncDataFromServer() async {
  //   final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

  //   Map<String, String> headers = {
  //     'App-Key': 'us@ma-@pp-k3y',
  //   };

  //   final response = await http.get(
  //       Uri.parse(
  //           '$baseurl/api/sync/sync_data?app_version=${userInfo['app_version']}'),
  //       headers: headers);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic>? data = json.decode(response.body);

  //     if (data != null) {
  //       List<Location> locations = (data['locations'] as List)
  //           .map((location) => Location.fromJson(location))
  //           .toList();
  //       List<Category> categories = (data['categories'] as List)
  //           .map((categorie) => Category.fromJson(categorie))
  //           .toList();

  //       List<ProductType> product_types = (data['product_types'] as List)
  //           .map((product_type) => ProductType.fromJson(product_type))
  //           .toList();
  //       List<Product> products = (data['products'] as List)
  //           .map((product) => Product.fromJson(product))
  //           .toList();
  //       List<ContainerType> container_types = (data['container_types'] as List)
  //           .map((container_type) => ContainerType.fromJson(container_type))
  //           .toList();
  //       List<DrumType> drum_types = (data['drum_types'] as List)
  //           .map((drum_type) => DrumType.fromJson(drum_type))
  //           .toList();
  //       List<WasteType> waste_types = (data['waste_types'] as List)
  //           .map((waste_type) => WasteType.fromJson(waste_type))
  //           .toList();
  //       List<Asset> assets = (data['assets'] as List)
  //           .map((asset) => Asset.fromJson(asset))
  //           .toList();
  //       List<AssetGroup> asset_groups = (data['asset_groups'] as List)
  //           .map((asset_group) => AssetGroup.fromJson(asset_group))
  //           .toList();
  //       List<AssetTrackLog> asset_track_logs = (data['asset_track_logs']
  //               as List)
  //           .map((asset_track_log) => AssetTrackLog.fromJson(asset_track_log))
  //           .toList();
  //       List<Vessel> vessels = (data['vessels'] as List)
  //           .map((vessel) => Vessel.fromJson(vessel))
  //           .toList();
  //       List<Voyage> voyages = (data['voyages'] as List)
  //           .map((voyage) => Voyage.fromJson(voyage))
  //           .toList();
  //       List<VoyageAsset> voyage_assets = (data['voyage_assets'] as List)
  //           .map((voyage_asset) => VoyageAsset.fromJson(voyage_asset))
  //           .toList();

  //       // Ensure the roles, users, and locations lists are not null
  //       if (locations.isNotEmpty) {
  //         Database? db = await instance.database;

  //         await db?.transaction((txn) async {
  //           var batch = txn.batch();

  //           // Future<void> insertFiltered(
  //           //     String tableName, List<Map<String, dynamic>> items) async {
  //           //   // Get the column names from the database schema
  //           //   List<Map<String, dynamic>> columnInfo =
  //           //       await txn.rawQuery('PRAGMA table_info($tableName)');
  //           //   List<String> columnNames =
  //           //       columnInfo.map((column) => column['name'] as String).toList();

  //           //   for (var item in items) {
  //           //     // Filter the item map to only include columns that exist in the table schema
  //           //     final filteredMap = Map.fromEntries(item.entries
  //           //         .where((entry) => columnNames.contains(entry.key)));
  //           //     batch.insert(tableName, filteredMap,
  //           //         conflictAlgorithm: ConflictAlgorithm.replace);
  //           //   }
  //           // }

  //           Future<void> insertFiltered(
  //               String tableName, List<Map<String, dynamic>> items) async {
  //             // Get the column names from the database schema
  //             List<Map<String, dynamic>> columnInfo =
  //                 await txn.rawQuery('PRAGMA table_info($tableName)');
  //             List<String> columnNames =
  //                 columnInfo.map((column) => column['name'] as String).toList();

  //             for (var item in items) {
  //               // Filter the item map to only include columns that exist in the table schema
  //               final filteredMap = Map.fromEntries(item.entries.where(
  //                   (entry) =>
  //                       columnNames.contains(entry.key) &&
  //                       entry.value != null));
  //               batch.insert(tableName, filteredMap,
  //                   conflictAlgorithm: ConflictAlgorithm.replace);
  //             }
  //           }

  //           await insertFiltered(
  //               'locations', locations.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'categories', categories.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'product_types', product_types.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'products', products.map((e) => e.toMap()).toList());
  //           await insertFiltered('container_types',
  //               container_types.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'drum_types', drum_types.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'waste_types', waste_types.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'assets', assets.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'asset_groups', asset_groups.map((e) => e.toMap()).toList());
  //           await insertFiltered('asset_track_logs',
  //               asset_track_logs.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'vessels', vessels.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'voyages', voyages.map((e) => e.toMap()).toList());
  //           await insertFiltered(
  //               'voyage_assets', voyage_assets.map((e) => e.toMap()).toList());

  //           await batch.commit(noResult: true);
  //         });
  //       } else {
  //         throw Exception('Invalid data format from API');
  //       }
  //     } else {
  //       throw Exception('Invalid data format from API');
  //     }
  //   } else {
  //     print('API Error: ${response.statusCode} - ${response.body}');

  //     try {
  //       // Try parsing the response body as JSON
  //       final Map<String, dynamic> errorJson = json.decode(response.body);
  //       final errorMessage = errorJson['message'] as String;

  //       Utils.SnackBar('Error', errorMessage);
  //     } catch (e) {
  //       // If parsing fails, display the entire response body as the error message
  //       Utils.SnackBar('Error', '${response.body}',
  //           duration: Duration(seconds: 5));
  //     }

  //     throw Exception('Failed to load data from API');
  //   }
  // }

  Future<void> syncDataFromServer() async {
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');

    Map<String, String> headers = {
      'App-Key': 'us@ma-@pp-k3y',
    };

    final response = await http.get(
        Uri.parse(
            '$baseurl/api/sync/sync_data?app_version=${userInfo['app_version']}'),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);

      if (data != null) {
        // Parse the data into respective lists
        List<Location> locations = (data['locations'] as List)
            .map((location) => Location.fromJson(location))
            .toList();
        List<Category> categories = (data['categories'] as List)
            .map((category) => Category.fromJson(category))
            .toList();
        List<ProductType> productTypes = (data['product_types'] as List)
            .map((productType) => ProductType.fromJson(productType))
            .toList();
        List<Product> products = (data['products'] as List)
            .map((product) => Product.fromJson(product))
            .toList();
        List<ContainerType> containerTypes = (data['container_types'] as List)
            .map((containerType) => ContainerType.fromJson(containerType))
            .toList();
        List<DrumType> drumTypes = (data['drum_types'] as List)
            .map((drumType) => DrumType.fromJson(drumType))
            .toList();
        List<WasteType> wasteTypes = (data['waste_types'] as List)
            .map((wasteType) => WasteType.fromJson(wasteType))
            .toList();
        List<Asset> assets = (data['assets'] as List)
            .map((asset) => Asset.fromJson(asset))
            .toList();
        List<AssetGroup> assetGroups = (data['asset_groups'] as List)
            .map((assetGroup) => AssetGroup.fromJson(assetGroup))
            .toList();
        List<AssetTrackLog> assetTrackLogs = (data['asset_track_logs'] as List)
            .map((assetTrackLog) => AssetTrackLog.fromJson(assetTrackLog))
            .toList();
        List<Vessel> vessels = (data['vessels'] as List)
            .map((vessel) => Vessel.fromJson(vessel))
            .toList();
        List<Voyage> voyages = (data['voyages'] as List)
            .map((voyage) => Voyage.fromJson(voyage))
            .toList();
        List<VoyageAsset> voyageAssets = (data['voyage_assets'] as List)
            .map((voyageAsset) => VoyageAsset.fromJson(voyageAsset))
            .toList();

        List<AssetScreening> asset_screenings = (data['asset_screenings']
                as List)
            .map(
                (asset_screenings) => AssetScreening.fromJson(asset_screenings))
            .toList();

        List<AssetNotes> assetNotes = (data['asset_notes'] as List)
            .map((assetNotes) => AssetNotes.fromJson(assetNotes))
            .toList();

        // Create a batch for batch operations
        final db = await DatabaseHelper.instance.database;
        var batch = db?.batch();

        Map<String, dynamic> filterMap(
            Map<String, dynamic> map, List<String> keysToRemove) {
          Map<String, dynamic> filteredMap = Map.from(map);
          keysToRemove.forEach((key) => filteredMap.remove(key));
          return filteredMap;
        }

        // Add each item to the batch
        locations.forEach((location) {
          batch?.insert('locations', location.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        categories.forEach((category) {
          batch?.insert('categories', category.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        asset_screenings.forEach((asset_screenings) {
          batch?.insert('asset_screenings', asset_screenings.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        productTypes.forEach((productType) {
          batch?.insert('product_types', productType.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        products.forEach((product) {
          batch?.insert(
              'products',
              filterMap(product.toJson(), [
                'operating_location',
                'product_type',
                'line_end_1_name',
                'line_end_2_name'
              ]),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        containerTypes.forEach((containerType) {
          batch?.insert('container_types', containerType.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        drumTypes.forEach((drumType) {
          batch?.insert('drum_types', drumType.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        wasteTypes.forEach((wasteType) {
          batch?.insert('waste_types', wasteType.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        assets.forEach((asset) {
          batch?.insert(
              'assets',
              filterMap(asset.toJson(), [
                'product',
                'product_no',
                'pulling_line',
                'container_type',
                'drum_type',
                'waste_type',
                'vessel',
                'voyage_origin',
                'voyage_destination',
              ]),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        assetGroups.forEach((assetGroup) {
          batch?.insert('asset_groups', assetGroup.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        assetTrackLogs.forEach((assetTrackLog) {
          batch?.insert('asset_track_logs', assetTrackLog.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        vessels.forEach((vessel) {
          batch?.insert('vessels', vessel.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        voyages.forEach((voyage) {
          batch?.insert(
              'voyages',
              filterMap(voyage.toJson(), [
                'vessel',
                'from_location',
                'to_location',
              ]),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        voyageAssets.forEach((voyageAsset) {
          batch?.insert('voyage_assets', voyageAsset.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        assetNotes.forEach((assetNotes) {
          batch?.insert('asset_notes', assetNotes.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });

        // Commit the batch
        await batch?.commit(noResult: true);

        print('Data successfully synchronized and inserted into the database.');
      } else {
        throw Exception('Invalid data format from API');
      }
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');

      try {
        // Try parsing the response body as JSON
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'] as String;

        Utils.SnackBar('Error', errorMessage);
      } catch (e) {
        // If parsing fails, display the entire response body as the error message
        Utils.SnackBar('Error', '${response.body}',
            duration: Duration(seconds: 5));
      }

      throw Exception('Failed to load data from API');
    }
  }

  Future<void> syncUp() async {
    final userInfo = await SharedPreferencesHelper.retrieveUserInfo('userInfo');
    final products = await queryList(
        'products',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final assets = await queryList(
        'assets',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final asset_screenings = await queryList(
        'asset_screenings',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final asset_groups = await queryList(
        'asset_groups',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final asset_track_logs = await queryList(
        'asset_track_logs',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final vessels = await queryList(
        'vessels',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final voyages = await queryList(
        'voyages',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final voyage_assets = await queryList(
        'voyage_assets',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final asset_colunm_history = await queryList(
        'asset_column_history',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final asset_notes = await queryList(
        'asset_notes',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final asset_logs = await queryList(
        'asset_logs',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null,
        attachFks: false);

    final upData = {
      'voyage_assets': voyage_assets,
      'voyages': voyages,
      'vessels': vessels,
      'asset_logs': asset_logs,
      'asset_screenings': asset_screenings,
      'asset_groups': asset_groups,
      'asset_track_logs': asset_track_logs,
      'asset_column_history': asset_colunm_history,
      'asset_notes': asset_notes,
      'assets': assets,
      'products': products,
      'app_version': userInfo['app_version'],
      'user_id': userInfo['user_id'],
    };
    print('asset_groups');
    print(asset_groups);
    Map<String, String> headers = {
      'App-Key': 'us@ma-@pp-k3y',
    };
    print('products ${products?.length}');
    print('assets ${assets?.length}');
    print('asset_screenings ${asset_screenings?.length}');
    print('asset_groups ${asset_groups?.length}');
    print('asset_track_logs ${asset_track_logs?.length}');
    print('vessels ${vessels?.length}');
    print('voyages ${voyages?.length}');
    print('voyage_assets ${voyage_assets?.length}');
    print('asset_colunm_history ${asset_colunm_history?.length}');
    print('asset_notes ${asset_notes?.length}');
    print('asset_logs ${asset_logs?.length}');

    final response = await http.post(Uri.parse('$baseurl/api/sync/sync_up'),
        headers: headers, body: jsonEncode(upData));
    print('respone $response');

    if (response.statusCode == 200) {
      if (products != null && products.length != 0) {
        final productJson =
            products.map((json) => Product.fromJson(json)).toList();
        final productIds = productJson.map((obj) => obj.product_id).toList();
        markSync(productIds, 'products', 'product_id');
      }

      if (assets != null && assets.length != 0) {
        final assetJson = assets.map((json) => Asset.fromJson(json)).toList();
        final assetIds = assetJson.map((obj) => obj.asset_id).toList();
        markSync(assetIds, 'assets', 'asset_id');
      }

      if (asset_screenings != null && asset_screenings.length != 0) {
        final assetScreeningJson = asset_screenings
            .map((json) => AssetScreening.fromJson(json))
            .toList();
        final assetScreeningIds =
            assetScreeningJson.map((obj) => obj.screening_id).toList();
        markSync(assetScreeningIds, 'asset_screenings', 'screening_id');
      }

      if (asset_groups != null && asset_groups.length != 0) {
        final assetGroupJson =
            asset_groups.map((json) => AssetGroup.fromJson(json)).toList();
        final assetGroupIds =
            assetGroupJson.map((obj) => obj.asset_group_id).toList();
        markSync(assetGroupIds, 'asset_groups', 'asset_group_id');
      }

      if (asset_track_logs != null && asset_track_logs.length != 0) {
        final assetTrackLogJson = asset_track_logs
            .map((json) => AssetTrackLog.fromJson(json))
            .toList();
        final assetTrackLogIds =
            assetTrackLogJson.map((obj) => obj.asset_track_log_id).toList();
        markSync(assetTrackLogIds, 'asset_track_logs', 'asset_track_log_id');
      }

      if (asset_colunm_history != null && asset_colunm_history.length != 0) {
        final assetColunmHistoryJson = asset_colunm_history
            .map((json) => AssetColumnHistory.fromJson(json))
            .toList();
        final assetColumnHistoryIds =
            assetColunmHistoryJson.map((obj) => obj.history_id).toList();
        markSync(assetColumnHistoryIds, 'asset_column_history', 'history_id');
      }

      if (asset_notes != null && asset_notes.length != 0) {
        final assetNotesJson =
            asset_notes.map((json) => AssetNotes.fromJson(json)).toList();
        final assetNotesIds = assetNotesJson.map((obj) => obj.note_id).toList();
        markSync(assetNotesIds, 'asset_notes', 'note_id');
      }

      if (asset_logs != null && asset_logs.length != 0) {
        final assetLogJson =
            asset_logs.map((json) => AssetLog.fromJson(json)).toList();
        final assetLogIds =
            assetLogJson.map((obj) => obj.asset_log_id).toList();
        markSync(assetLogIds, 'asset_logs', 'asset_log_id');
      }

      if (vessels != null && vessels.length != 0) {
        final vesselJson =
            vessels.map((json) => Vessel.fromJson(json)).toList();
        final vesselIds = vesselJson.map((obj) => obj.vessel_id).toList();
        markSync(vesselIds, 'vessels', 'vessel_id');
      }

      if (voyages != null && voyages.length != 0) {
        final voyageJson =
            voyages.map((json) => Voyage.fromJson(json)).toList();
        final voyageIds = voyageJson.map((obj) => obj.voyage_id).toList();
        markSync(voyageIds, 'voyages', 'voyage_id');
      }

      if (voyage_assets != null && voyage_assets.length != 0) {
        final voyageAssetJson =
            voyage_assets.map((json) => VoyageAsset.fromJson(json)).toList();
        final voyageAssetIds =
            voyageAssetJson.map((obj) => obj.voyage_asset_id).toList();
        markSync(voyageAssetIds, 'voyages', 'voyage_id');
      }
      await uploadImages().catchError((error) {
        SharedPreferencesHelper.removeUserInfo('userInfo');
        Get.to(NewLoginScreen());
        Utils.SnackBar('Error', 'Your App Version Is Old Please Update App ');
        // CustomToast(context).error('Sync up failed!');
      });
      // .then((value) async {
      //   if (value == 200) {
      //     await refreshDatabase();
      //   }
      // }).whenComplete(() async {
      //   await syncDataFromServer().then((value) {
      //     // CustomToast(context).success('Sync up successful!');
      //   })
      //   .catchError((error) {
      //     SharedPreferencesHelper.removeUserInfo('userInfo');
      //     Get.to(NewLoginScreen());
      //     Utils.SnackBar('Error', 'Your App Version Is Old Please Update App ');
      //     // CustomToast(context).error('Sync up failed!');
      //   });
      // });
    }
    // else{

    //   Utils.SnackBar('Error', 'Sync up failed!');
    // }
  }

  refreshDatabase() async {
    Database? db = await instance.database;
    await db!.execute('''
          delete from voyage_assets;
          ''');
    await db.execute('''
          delete from voyages;
          ''');
    await db.execute('''
          delete from vessels;
          ''');
    await db.execute('''
          delete from asset_logs;
          ''');
    await db.execute('''
          delete from asset_screenings;
          ''');
    await db.execute('''
          delete from asset_groups;
          ''');
    await db.execute('''
          delete from asset_track_logs;
          ''');
    await db.execute('''
          delete from asset_column_history;
          ''');
    await db.execute('''
          delete from asset_notes;
          ''');
    await db.execute('''
          delete from assets;
          ''');
    await db.execute('''
          delete from products;
          ''');
  }

  Future<void> markSync(List<String?> ids, String table, String pk) async {
    Database? database = await instance.database;

    final ids_string = makeIdsForIN(ids);
    if (ids_string.toString().isNotEmpty) {
      await database?.execute(
          'UPDATE $table SET is_sync = "1" WHERE $pk IN ($ids_string)');
    }
  }

  Future<int> uploadImages() async {
    final asset_images = await queryList(
        'asset_images',
        [
          ['is_sync', '=', '0']
        ],
        {},
        limit: null);

    print(asset_images?.length.toString());
    print('asset_images');
    if (asset_images != null && asset_images.length > 0) {
      for (var assetImage in asset_images) {
        print('Image No ${assetImage.length}');
        var filePath = assetImage['image_path'];
        final file_name = assetImage['screening_id'] == null
            ? "${assetImage['asset_id']}-asset"
            : "${assetImage['screening_id']}-screening";
        print(filePath);

        // Load the image
        List<int> imageBytes = await File(filePath).readAsBytes();
        img.Image? loadedImage =
            img.decodeImage(Uint8List.fromList(imageBytes));

        // Check if the image is not null
        if (loadedImage != null) {
          // Resize the image (optional, adjust as needed)
          loadedImage = img.copyResize(loadedImage, width: 800);

          // Compress the image to reduce quality (adjust quality as needed)
          List<int> compressedBytes = img.encodeJpg(loadedImage, quality: 70);

          // Create the request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('$baseurl/api/sync/upload_image'),
          );

          // Attach the image bytes as a file in the request
          request.files.add(http.MultipartFile.fromBytes(
            'UserFile',
            compressedBytes,
            filename: file_name,
          ));

          request.headers['App-Key'] = 'us@ma-@pp-k3y';

          // Send the request
          var response = await request.send();
          print('Image response.statusCode');
          print(response.statusCode);
          if (response.statusCode == 200) {
            final assetImageJson =
                asset_images.map((json) => Asset_Image.fromJson(json)).toList();
            final assetImagesIds =
                assetImageJson.map((obj) => obj.image_id).toList();
            markSync(assetImagesIds, 'asset_images', 'image_id');
          }
        }
      }
      return 200; // All images processed successfully
    }
    return 0; // No images to process or an issue occurred
  }

  // Future<int> uploadImages() async {
  //   final asset_images = await queryList(
  //       'asset_images',
  //       [
  //         ['is_sync', '=', '0']
  //       ],
  //       {},
  //       limit: null);

  //   print(asset_images?.length.toString());
  //   print('asset_images');
  //   if (asset_images != null && asset_images.length > 0) {
  //     for (var assetImage in asset_images) {
  //       print('loop call');
  //       var filePath = assetImage['image_path'];
  //       final file_name = assetImage['screening_id'] == null
  //           ? "${assetImage['asset_id']}-asset"
  //           : "${assetImage['screening_id']}-screening";
  //       print(filePath);
  //       // Load the image
  //       List<int> imageBytes = await File(filePath).readAsBytes();
  //       img.Image? loadedImage =
  //           img.decodeImage(Uint8List.fromList(imageBytes));

  //       // Check if the image is not null
  //       if (loadedImage != null) {
  //         // Resize the image (optional, adjust as needed)
  //         loadedImage = img.copyResize(loadedImage, width: 800);

  //         // Compress the image to reduce quality (adjust quality as needed)
  //         List<int> compressedBytes = img.encodeJpg(loadedImage, quality: 70);

  //         // Create the request
  //         var request = http.MultipartRequest(
  //           'POST',
  //           Uri.parse('$baseurl/api/sync/upload_image'),
  //         );

  //         // Attach the image bytes as a file in the request
  //         request.files.add(http.MultipartFile.fromBytes(
  //           'UserFile',
  //           compressedBytes,
  //           filename: file_name,
  //         ));

  //         request.headers['App-Key'] = 'us@ma-@pp-k3y';

  //         // Send the request
  //         var response = await request.send();
  //         print('Image response.statusCode');
  //         print(response.statusCode);
  //         if (response.statusCode == 200) {
  //           final assetImageJson =
  //               asset_images.map((json) => Asset_Image.fromJson(json)).toList();
  //           final assetImagesIds =
  //               assetImageJson.map((obj) => obj.image_id).toList();
  //           markSync(assetImagesIds, 'asset_images', 'image_id');

  //           return response.statusCode;
  //         }
  //       }
  //     }
  //   }
  //   return asset_images != null && asset_images.length > 0 ? 0 : 200;
  // }

  // Future<void> uploadImages() async {
  //   final asset_images = await queryList('asset_images', [
  //     ['is_sync', '=', '0']
  //   ], {});

  //   if (asset_images != null && asset_images.length > 0) {
  //     for (var image in asset_images) {
  //       var filePath = image['image_path'];
  //       XFile xFile = XFile(filePath,

  //       );
  //       var stream = http.ByteStream(Stream.castFrom(xFile.openRead()));
  //       var length = await xFile.length();
  //       var request = http.MultipartRequest(
  //         'Post',
  //         Uri.parse('$baseurl/api/sync/upload_image'),
  //       );

  //       var pic = await http.MultipartFile('UserFile', stream, length,
  //           filename: image['asset_id']);
  //       request.files.add(pic);

  //       request.headers['App-Key'] = 'us@ma-@pp-k3y';

  //       var response = await request.send();
  //       print(filePath);
  //       print('response.statusCode');
  //       print(response.statusCode);
  //       if (response.statusCode == 200) {
  //         // final assetImageJson =
  //         //     asset_images.map((json) => Asset_Image.fromJson(json)).toList();
  //         // final assetImagesIds =
  //         //     assetImageJson.map((obj) => obj.image_id).toList();
  //         // markSync(assetImagesIds, 'asset_images', 'image_id');
  //       }
  //     }
  //   }
  // }
}

timedId() async {
  const BASE36_ALPHABETS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  sleep(const Duration(milliseconds: 1));
  String base36 = '';
  int number = DateTime.now().millisecondsSinceEpoch * 1000;
  var i = 0;
  while (number != 0) {
    number = number ~/ 36;
    i = number % 36;
    base36 = BASE36_ALPHABETS[i] + base36;
  }
  return base36;
}

makeIdsForIN(ids) {
  var ids_string = '';
  ids.asMap().forEach((index, id) {
    ids_string += '"$id"';

    if (index != ids.length - 1) {
      ids_string += ', ';
    }
  });

  return ids_string;
}

String generateCustomNo(
    String firstString, String inputString, int incrementalNumber) {
  String firstTwoLetters = inputString.length >= 2
      ? inputString.toString().toUpperCase().substring(0, 2)
      : inputString;

  String formattedIncrementalNumber =
      incrementalNumber.toString().padLeft(4, '0');

  String result = '$firstString-$firstTwoLetters-$formattedIncrementalNumber';

  return result;
}

Future<bool> isConnectedToInternet() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    // If connected to mobile data or wifi, check if it has internet access
    return await _hasInternetAccess();
  }
  return false;
}

Future<bool> _hasInternetAccess() async {
  try {
    // Try to connect to a well-known website
    final result = await InternetAddress.lookup('example.com');
    print('result');
    print(result);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } catch (e) {
    // Handle the error
  }
  return false;
}

Future<double> testDownloadSpeed() async {
  final url = Uri.parse(
      'http://ipv4.download.thinkbroadband.com/10MB.zip'); // Replace with a reliable file URL
  final startTime = DateTime.now();
  final response = await http.get(url);
  final endTime = DateTime.now();

  if (response.statusCode == 200) {
    final bytes = response.contentLength ?? 0;
    final duration = endTime.difference(startTime).inMilliseconds;
    final speed = bytes / duration * 1000 / (1024 * 1024); // Speed in Mbps
    return speed;
  } else {
    throw Exception('Failed to download file');
  }
}

Future<String> checkInternetConnection() async {
  bool isConnected = await isConnectedToInternet();
  if (isConnected) {
    return 'Connected to the internet';
  } else {
    return 'No internet connection';
  }
}




// Future<bool> isConnectedToInternet() async {
//   var connectivityResult = await Connectivity().checkConnectivity();
//   if (connectivityResult == ConnectivityResult.mobile ||
//       connectivityResult == ConnectivityResult.wifi) {
//     // If connected to mobile data or wifi, check if it has internet access
//     return await _hasInternetAccess();
//   }
//   return false;
// }

// Future<bool> _hasInternetAccess() async {
//   try {
//     // Try to connect to a well-known website
//     final result = await InternetAddress.lookup('example.com');
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       return true;
//     }
//   } catch (e) {
//     // Handle the error
//   }
//   return false;
// }


// Future<double> testDownloadSpeed() async {
//   final url = Uri.parse(
//       'http://ipv4.download.thinkbroadband.com/10MB.zip'); // Replace with a reliable file URL
//   final startTime = DateTime.now();
//   final response = await http.get(url);
//   final endTime = DateTime.now();

//   // Print status code
//   print('Status code: ${response.statusCode}');

//   // Print headers
//   print('Headers: ${response.headers}');

//   // Print body
//   print(
//       'Body: ${response.body.length} bytes'); // Printing the length of the body instead of full content

//   if (response.statusCode == 200) {
//     final bytes = response.contentLength ?? 0;
//     final duration = endTime.difference(startTime).inMilliseconds;
//     final speed = bytes / duration * 1000 / (1024 * 1024); // Speed in Mbps
//     print('Download speed: $speed Mbps');
//     return speed;
//   } else {
//     throw Exception('Failed to download file');
//   }
// }


// void showLoadingDialog(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return WillPopScope(
//         onWillPop: () async => false,
//         child: AlertDialog(
//           content: Row(
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(width: 20),
//               Expanded(child: Text(message)),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// void checkInternetConnection(BuildContext context) async {
//   showLoadingDialog(context, "Please wait, your data is syncing up");

//   bool isConnected = await isConnectedToInternet();
//   Navigator.of(context).pop(); // Dismiss the loading dialog

//   String message;
//   if (isConnected) {
//     message = "Connected to the internet";
//     try {
//       double speed = await testDownloadSpeed();
//       message += '\nDownload speed: $speed Mbps';
//       if (speed < 1.0) {
//         message += '\nThe internet speed is weak';
//       } else {
//         message += '\nThe internet speed is good';
//       }
//     } catch (e) {
//       message = 'Error: $e';
//     }
//   } else {
//     message = "No internet connection";
//   }

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("Internet Connection Status"),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: Text("OK"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
