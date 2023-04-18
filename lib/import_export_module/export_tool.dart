import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import '../constants/supported_file_formats_import_export.dart';
import 'sensor_data_collection.dart';

/// Formats a list of sensor data (points) into the given [format].
///
/// Therefor the appropiate specific formatter is called.
String formatData(
  SensorId sensorId,
  List<SensorData> data,
  SupportedFileFormat format,
) {
  if (data.isEmpty) {
    /// TODO: check for a better way to handle the case, nothing exists for the
    /// export
    return "";
  }

  switch (format) {
    case SupportedFileFormat.json:
      return formatDataIntoJson(sensorId, data);
    case SupportedFileFormat.csv:
      return formatDataIntoCSV(sensorId, data);
    case SupportedFileFormat.xlsx:
      return "";
    case SupportedFileFormat.xml:
      return "";
  }
}

/// Formats a list of sensor data (points) into the corresponding json string
/// following the format described in [SupportedFileFormat].
String formatDataIntoJson(SensorId sensorId, List<SensorData> data) {
  var sensorDataCollection = SensorDataCollection(sensorId, data);

  // use indentation for make it look prettier
  var encoder = const JsonEncoder.withIndent("  ");

  return encoder.convert(sensorDataCollection);
}

/// Formats a list of sensor data (points) into the corresponding csv string
/// following the format described in [SupportedFileFormat].
///
/// Therefor a [ListToCsvConverter] is used to enforce the RFC conforming
/// format.
String formatDataIntoCSV(SensorId sensorId, List<SensorData> data) {
  // create first row
  var headerRow = [
    "sensorId",
    "unit",
    "maxPrecision",
    "timestampInMicroseconds",
    "data"
  ];

  var csvData = <List<dynamic>>[headerRow];

  // create sensor data rows
  for (var sensorData in data) {
    var sensorDataRow = [
      sensorId.name,
      sensorData.unit.name,
      sensorData.maxPrecision,
      sensorData.timestampInMicroseconds,
      sensorData.data.map((e) => e.toString()).toList().join(", "),
    ];
    csvData.add(sensorDataRow);
  }

  return const ListToCsvConverter().convert(csvData);
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
