import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import '../constants/supported_file_formats_import_export.dart';
import 'sensor_data_collection.dart';

/// Formats a list of sensor data (points) into the corresponding json string
/// following the format described in [SupportedFileFormat].
String formatDataIntoJson(SensorId sensorId, List<SensorData> data) {
  if (data.isEmpty) {
    /// TODO: check for a better way to handle the case, nothing exists for the
    /// export
    return "";
  }

  var sensorDataCollection = SensorDataCollection(sensorId, data);

  return json.encode(sensorDataCollection);
}

/// Creates a new file at [filepath] and writes the formatted data
/// (= [formattedData]) into this file and saves it.
///
/// The [filepath] can be relative or absolute.
void writeFormattedData(
  String filepath,
  SupportedFileFormat format,
  String formattedData,
) {
  File("$filepath.${format.name}").writeAsStringSync(formattedData);
}

/// Creates the filename for the export of the sensor data for the sensor
/// with the given [sensorId] in the time interval [startTime] - [endTime].
///
/// The filename have the format:
/// _<sensorId>\_<startTime>\_<endTime>_
/// The start and endTime is formatted as 'yyyy-MM-dd hh:mm'
String createFileName(
  SensorId sensorId,
  DateTime startTime,
  DateTime endTime,
) {
  var dateFormat = DateFormat('yyyy-MM-dd hh:mm');

  return "${sensorId.name}_${dateFormat.format(startTime)}_"
      "${dateFormat.format(endTime)}";
}
