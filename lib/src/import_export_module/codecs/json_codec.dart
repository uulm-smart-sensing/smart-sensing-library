import 'dart:convert';
import 'dart:io';
import 'package:json_schema2/json_schema2.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import '../import_result.dart';
import '../sensor_data_collection.dart';
import '../supported_file_format.dart';

/// The path the JSON validation schema.
const String filePathSchema =
    "./lib/src/import_export_module/validation_schemas/jsonFileFormatSchema.json";

/// Formats a list of sensor data (points) into the corresponding json string
/// following the format described in [SupportedFileFormat.json].
List<int> formatDataIntoJson(SensorId sensorId, List<SensorData> data) {
  var sensorDataCollection = SensorDataCollection(sensorId, data);

  // use indentation for make it look prettier
  var encoder = const JsonEncoder.withIndent("  ");

  return encoder.convert(sensorDataCollection).codeUnits;
}

/// Decodes binary json data into a list of [SensorData] objects with a
/// corresponding [SensorId].
///
/// Therefor it validates the json string against a schema and if the validation
/// is successful, it will build the sensor data from the string and return it.
/// Otherwise it will encode the error in the [ImportResultStatus] and return
/// an [ImportResult] with an empty [SensorDataCollection] field.
Future<ImportResult> decodeJson(List<int> rawData) async {
  var jsonString = String.fromCharCodes(rawData);

  var validationResult = await _validateJsonFile(jsonString);
  if (!validationResult) {
    return ImportResult(resultStatus: ImportResultStatus.invalidJsonFormatting);
  }

  var jsonData = const JsonDecoder().convert(jsonString);

  var sensorDataCollection = SensorDataCollection.fromJson(jsonData);

  return ImportResult(
    resultStatus: ImportResultStatus.success,
    importedData: sensorDataCollection,
  );
}

Future<bool> _validateJsonFile(String jsonString) async {
  // read schema file
  var schemaString = await File(filePathSchema).readAsString();

  var schema = JsonSchema.createSchema(schemaString);
  return schema.validate(json.decode(jsonString));
}
