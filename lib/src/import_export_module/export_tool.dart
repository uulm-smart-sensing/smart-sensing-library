import 'dart:io';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import 'codecs/csv_codec.dart';
import 'codecs/json_codec.dart';
import 'codecs/xlsx_codec.dart';
import 'codecs/xml_codec.dart';
import 'supported_file_format.dart';

/// Formats a list of sensor data (points) into the given [format].
///
/// Therefor the appropriate specific formatter is called and the sensor data
/// encoded as byte array is returned, which can be used to write the data
/// into a file.
List<int> formatData(
  SensorId sensorId,
  List<SensorData> data,
  SupportedFileFormat format,
) {
  if (data.isEmpty) {
    return "".codeUnits;
  }

  switch (format) {
    case SupportedFileFormat.json:
      return formatDataIntoJson(sensorId, data);
    case SupportedFileFormat.csv:
      return formatDataIntoCSV(sensorId, data);
    case SupportedFileFormat.xlsx:
      return formatDataIntoXLSX(sensorId, data);
    case SupportedFileFormat.xml:
      return formatDataIntoXML(sensorId, data);
  }
}

/// Creates a new file at [filepath] and writes the formatted data
/// (= [formattedData]) into this file and saves it.
///
/// The [filepath] can be relative or absolute.
Future<void> writeFormattedData(
  String filepath,
  SupportedFileFormat format,
  List<int> formattedData,
) async {
  if (Platform.isAndroid &&
      !(await Permission.manageExternalStorage.request().isGranted)) {
    /// TODO: provide a visual hint to the user, that the app dont have the
    /// permission
    return;
  }
  File("$filepath.${format.name}").writeAsBytesSync(formattedData);
}

/// Creates the filename for the export of the sensor data for the sensor
/// with the given [sensorId] in the time interval [startTime] - [endTime].
///
/// The filename have the format:
/// _<sensorId>\_<startTime>\_<endTime>_
/// The start and endTime is formatted as 'yyyy-MM-dd_hh-mm'
String createFileName(
  SensorId sensorId,
  DateTime startTime,
  DateTime endTime,
) {
  var dateFormat = DateFormat('yyyy-MM-dd_hh-mm');

  return "${sensorId.name}_${dateFormat.format(startTime)}_"
      "${dateFormat.format(endTime)}";
}
