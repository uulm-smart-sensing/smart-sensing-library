import 'dart:convert';

import 'package:sensing_plugin/sensing_plugin.dart';

import '../sensor_data_collection.dart';
import '../supported_file_format.dart';

/// Formats a list of sensor data (points) into the corresponding json string
/// following the format described in [SupportedFileFormat.json].
List<int> formatDataIntoJson(SensorId sensorId, List<SensorData> data) {
  var sensorDataCollection = SensorDataCollection(sensorId, data);

  // use indentation for make it look prettier
  var encoder = const JsonEncoder.withIndent("  ");

  return encoder.convert(sensorDataCollection).codeUnits;
}
