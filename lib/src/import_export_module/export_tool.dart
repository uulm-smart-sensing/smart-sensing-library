import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:xml/xml.dart';

import 'sensor_data_collection.dart';
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
    /// TODO: check for a better way to handle the case, nothing exists for the
    /// export
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

/// Formats a list of sensor data (points) into the corresponding json string
/// following the format described in [SupportedFileFormat.json].
List<int> formatDataIntoJson(SensorId sensorId, List<SensorData> data) {
  var sensorDataCollection = SensorDataCollection(sensorId, data);

  // use indentation for make it look prettier
  var encoder = const JsonEncoder.withIndent("  ");

  return encoder.convert(sensorDataCollection).codeUnits;
}

/// Formats a list of sensor data (points) into the corresponding csv string
/// following the format described in [SupportedFileFormat.csv].
///
/// Therefor a [ListToCsvConverter] is used to enforce the RFC conforming
/// format.
List<int> formatDataIntoCSV(SensorId sensorId, List<SensorData> data) {
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

  return const ListToCsvConverter().convert(csvData).codeUnits;
}

/// Formats a list of sensor data (points) into the corresponding xlsx string
/// following the format described in [SupportedFileFormat.xlsx].
List<int> formatDataIntoXLSX(SensorId sensorId, List<SensorData> data) {
  var excel = Excel.createExcel();
  excel.rename(excel.getDefaultSheet().toString(), "sensor_data");

  var sheet = excel["sensor_data"]
    ..appendRow([
      "sensorId",
      "unit",
      "maxPrecision",
      "timestampInMicroseconds",
      "data",
    ]);

  for (var sensorData in data) {
    var sensorDataRow = [
      sensorId.name,
      sensorData.unit.name,
      sensorData.maxPrecision,
      sensorData.timestampInMicroseconds,
      sensorData.data.map((e) => e.toString()).toList().join(", "),
    ];
    sheet.appendRow(sensorDataRow);
  }

  // encode excel file as string
  return excel.save()!;
}

/// Formats a list of sensor data (points) into the corresponding xml string
/// following the format described in [SupportedFileFormat.xml].
List<int> formatDataIntoXML(SensorId sensorId, List<SensorData> data) {
  // create and define builder for xml document
  var builder = XmlBuilder();
  builder
    ..processing("xml", "version=\"1.0\" encoding=\"UTF-8\"")
    ..element(
      'root',
      nest: () {
        builder.element('sensorId', nest: sensorId.name);
        for (var sensorData in data) {
          _buildSensorData(builder, sensorData);
        }
      },
    );

  // build xml document
  var xmlDocument = builder.buildDocument();

  return xmlDocument.toXmlString(pretty: true, indent: "\t").codeUnits;
}

void _buildSensorData(XmlBuilder builder, SensorData data) {
  builder.element(
    'sensorData',
    nest: () {
      builder
        ..element(
          'data',
          nest: () {
            for (var datapoint in data.data) {
              builder.element('dataPoint', nest: datapoint);
            }
          },
        )
        ..element('unit', nest: data.unit.name)
        ..element('maxPrecision', nest: data.maxPrecision)
        ..element(
          'timestampInMicroseconds',
          nest: data.timestampInMicroseconds,
        );
    },
  );
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
  var status = await Permission.storage.status;
  if (status != PermissionStatus.granted) {
    status = await Permission.storage.request();
  }
  if (status.isGranted) {
    File("$filepath.${format.name}").writeAsBytesSync(formattedData);
  }
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
