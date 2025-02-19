class LocationType {
  static final FIELD = 'Field';
  static final QUAYSIDE = 'Quayside';
  static final DECONTAM_YARD = 'Decontam Yard';
  static final DISPOSAL_YARD = 'Disposal Yard';
}

class ForiegnTables {
  static final PRODUCT = ['operating_locations', 'product_types'];
}

class AssetType {
  static final FLEXIBLES = 'Flexibles';
  static final BUNDLE = 'Bundle';
  static final CONTAINER = 'Container';
  static final SUBSEA_STRUCTURE = 'Subsea Structure';
  static final ANCILLARY_EQUIPMENT = 'Ancillary Equipment';
  static final ANCILLARY_BATCH = 'Ancillary Batch';
  static final RIGID_PIPE = 'Rigid Pipe';
  static final BATCH = 'Batch';
  static final HAZMAT_WASTE = 'HazMat Waste';
  static final INDIVIDUAL_ASSET = 'Individual Asset';
  static final DRUM = 'Drum';
}

class AssetStatus {
  static final READY_TO_LOAD = 'Packed / Ready To Load';
  static final LOADED = 'Loaded / To Be Shipped';
  static final IN_TRANSIT = 'Shipped / In Transit';
  static final ARRIVED_AT_QUAYSIDE = 'Arrived at Quayside';
  static final ARRIVED_AT_YARD = 'Arrived at Yard';
  static final ASSET_RECEIPT_AND_OFFLOADED = 'Asset Receipt And Offloaded';
  static final CONTAINER_RELEASED = 'Container Released';
  static final UNBUNDLED = 'Unbundled';
  static final TAGGED = 'Tagged';
  static final IN_CLEANING = 'In Cleaning';
  static final IN_CLEARANCE = 'In Clearance';
  static final READY_FOR_DISPOSAL = 'Ready For Disposal';
  // static final READY_FOR_DISPOSAL = 'Cleared Decontamination';
  static final IN_DISPOSAL = 'In Disposal';
  // static final IN_DISPOSAL = 'Accepted for Disposal';
  static final ARRIVED_AT_DISPOSAL_YARD = 'Arrived at Disposal Yard';
  static final DISPOSED = 'Disposed';
  static final MOVED_TO_YARD_STORAGE = 'Moved To Yard Storage';
}

class StorageArea {
  static final YARD_STORAGE = 'Yard_Storage';
  static final ANCILLARY_STORAGE_AREA = 'Ancillary_Holding_Area';
  static final SUBSEA_STORAGE_AREA = 'Subsea_Holding_Area';
}

class Classification {
  static final NON_CONTAMINATED = 'Non-Contaminated';
  static final CONTAMINATED = 'Contaminated';
  static final HAZARDOUS = 'Hazardous';
}

class ScreeningType {
  static final INITIAL_SCREENING = 'Initial Screening';
  static final SCREENING = 'Screening';
  static final POST_SCREENING = 'Post Screening';
}

class EventType {
  static final ASSET_CREATED = 'Asset Created';
  static final LOADED = 'Loaded / To Be Shipped';
  static final IN_TRANSIT = 'Shipped / In Transit';
  static final ARRIVED_AT_QUAYSIDE = 'Arrived at Quayside';
  static final ARRIVED_AT_YARD = 'Arrived at Yard';
  static final CONTAINER_RELEASED = 'Container Released';
  static final UNBUNDLED = 'Unbundled';
  static final IN_CLEANING = 'In Cleaning';
  static final SCREENING = 'Screening';
  static final IN_CLEARANCE = 'In Clearance';
  static final READY_FOR_DISPOSAL = 'Ready For Disposal';
  static final IN_DISPOSAL = 'In Disposal';
  static final ARRIVED_AT_DISPOSAL_YARD = 'Arrived at Disposal Yard';
  static final DISPOSED = 'Disposed';
  static final TAG_NUMBER_SWAPPED = 'Tag Number Swapped';
  static final MOVED_TO_YARD_STORAGE = 'Moved To Yard Storage';
}

class ProductStatus {
  static final COMPLETED = 'Completed';
  static final PENDING = 'Pending';
  static final IN_PROGRESS = 'In Progress';
}
