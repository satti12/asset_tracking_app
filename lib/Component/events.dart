import 'package:asset_tracking/Component/constants.dart';

const WITH_CONTAINER = 'With Container';
const WITHOUT_CONTAINER = 'Without Container';
const INSIDE_CONTAINER = 'Inside Container';

final eventDefinition = {
  EventType.ASSET_CREATED: {
    AssetType.FLEXIBLES:
        '{asset_type} is created with RFID: {rf_id} from {parent_asset_type}, RFID: {parent_rfid} on {current_location} by {user} at {time}',
    AssetType.RIGID_PIPE:
        '{asset_type} is created with RFID: RFID: {rf_id} from {parent_asset_type}, Batch No: {parent_batch_no} on {current_location} by {user} at {time}',
    AssetType.CONTAINER:
        '{container_type} is created with RFID: {rf_id} & Serial Number: {container_serial_number} on {current_location} by {user} at {time}',
    AssetType.BATCH:
        '{asset_type} is created with Batch No: {batch_no} on {current_location} by {user} at {time}',
    AssetType.ANCILLARY_BATCH:
        '{asset_type} is created with Batch No: {batch_no} on {current_location} by {user} at {time}',
    AssetType.BUNDLE:
        '{asset_type} is created of {product_no} with RFID: {rf_id} on {current_location} by {user} at {time}',
    AssetType.SUBSEA_STRUCTURE:
        '{asset_type} is created of {product_no} with RFID: {rf_id} on {current_location} by {user} at {time}',
    AssetType.ANCILLARY_EQUIPMENT:
        '{asset_type} is created of {product_no} with RFID: {rf_id} on {current_location} by {user} at {time}',
    AssetType.HAZMAT_WASTE:
        '{asset_type} is created with RFID: {rf_id} of Drum Type: {drum_type} & Waste Type: {waste_type} on {current_location} by {user} at {time}',
  },
  EventType.LOADED: {
    WITH_CONTAINER:
        '{container_type} with RFID: {rf_id} is loaded on {current_location} by {user} at {time}',
    INSIDE_CONTAINER:
        '{asset_type} with RFID: {rf_id} is loaded on {container_type} - {container_rfid} on {current_location} by {user} at {time}',
    WITHOUT_CONTAINER:
        '{asset_type} with RFID: {rf_id} is loaded without container on {current_location} by {user} at {time}'
  },
  EventType.IN_TRANSIT: {
    WITH_CONTAINER:
        '{container_type} with RFID: {rf_id} is shipped on {vessel} form {from_location} to {to_location} by {user} at {time}',
    WITHOUT_CONTAINER:
        '{asset_type} with RFID: {rf_id} is shipped on {vessel} form {from_location} to {to_location} by {user} at {time}',
    INSIDE_CONTAINER:
        '{asset_type} with RFID: {rf_id} is shipped on {container_type} - {container_rfid} on {vessel} form {from_location} to {to_location} by {user} at {time}',
  },
  EventType.ARRIVED_AT_QUAYSIDE: {
    WITH_CONTAINER:
        '{container_type} with RFID: {rf_id} is mark arrived at {current_location} form {from_location} by {user} at {time}',
    WITHOUT_CONTAINER:
        '{asset_type} with RFID: {rf_id} is mark arrived at {current_location} form {from_location} by {user} at {time}',
    INSIDE_CONTAINER:
        '{asset_type} with RFID: {rf_id} is mark arrived at {current_location} form {from_location} within {container_type} - {container_rfid} by {user} at {time}'
  },
  EventType.ARRIVED_AT_YARD: {
    WITH_CONTAINER:
        '{container_type} with RFID: {rf_id} is mark arrived at {current_location} form {from_location} by {user} at {time}',
    WITHOUT_CONTAINER:
        '{asset_type} with RFID: {rf_id} is mark arrived at {current_location} form {from_location} by {user} at {time}',
    INSIDE_CONTAINER:
        '{asset_type} with RFID: {rf_id} is mark arrived at {current_location} form {from_location} within {container_type} - {container_rfid} by {user} at {time}'
  },
  EventType.MOVED_TO_YARD_STORAGE:
      '{asset_type} with RFID: {rf_id} is Moved To Yard Storage at {rack} on {current_location} by {user} at {time}',
  EventType.CONTAINER_RELEASED:
      '{container_type} with RFID: {rf_id} is released at {current_location} by {user} at {time}',
  EventType.UNBUNDLED: {
    AssetType.BUNDLE:
        '{asset_type} with RFID: {rf_id} is tagged at {current_location} by {user} at {time}',
    AssetType.BATCH:
        '{asset_type} with Batch No: {batch_no} is tagged at {current_location} by {user} at {time}',
    AssetType.ANCILLARY_BATCH:
        '{asset_type} with Batch No: {batch_no} is tagged at {current_location} by {user} at {time}',
  },
  EventType.SCREENING: {
    ScreeningType.INITIAL_SCREENING:
        'Offshore Screening of {asset_type} of {product_no} with RFID: {rf_id} is completed at {current_location} by {user} at {time}',
    ScreeningType.SCREENING:
        'Initial Yard Screening of {asset_type} of {product_no} with RFID: {rf_id} is completed at {current_location} by {user} at {time}',
    ScreeningType.POST_SCREENING:
        'Post De-Contam Screening of {asset_type} of {product_no}  with RFID: {rf_id} is completed at {current_location} by {user} at {time}',
  },
  // EventType.IN_CLEANING:
  //     '{asset_type} with RFID: {rf_id} is in cleaning at {current_location} by {user} at {time}',
  EventType.IN_CLEARANCE:
      '{asset_type} of {product_no} with RFID: {rf_id} is in clearance at {current_location} by {user} at {time}',
  EventType.READY_FOR_DISPOSAL:
      '{asset_type} of {product_no} with RFID: {rf_id} is Ready For Disposal at {current_location} by {user} at {time}',
  EventType.IN_DISPOSAL:
      '{asset_type} {of product_no} with RFID: {rf_id} is sent to {current_location} by {user} at {time}',
  EventType.ARRIVED_AT_DISPOSAL_YARD:
      '{asset_type}  with RFID: {rf_id} is arrived at {current_location} form {from_location} by {user} at {time}',
  // '{asset_type} of {of product_no}  with RFID: {rf_id} is arrived at {current_location} form {from_location} by {user} at {time}',

  EventType.DISPOSED:
      '{asset_type} of {of product_no} with RFID: {rf_id} is marked Disposed at {current_location} by {user} at {time}',
  EventType.TAG_NUMBER_SWAPPED:
      'Tag Number is Swapped of {asset_type} from: {old_rfid} to: {new_rfid} by {user} at {time}'
};

String replaceVariables(String template, Map<String, String> variables) {
  final description = template.replaceAllMapped(RegExp(r'{(.*?)}'),
      (Match match) => variables[match.group(1)] ?? match.group(0)!);
  return description;
}
