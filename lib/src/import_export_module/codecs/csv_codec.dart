import 'package:csv/csv.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import '../supported_file_format.dart';

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

  var csvData = <List<dynamic>>[headerRow] +
      data
          .map(
            (sensorData) => [
              sensorId.name,
              sensorData.unit.name,
              sensorData.maxPrecision,
              sensorData.timestampInMicroseconds,
              sensorData.data.join(", "),
            ],
          )
          .toList();

  return const ListToCsvConverter().convert(csvData).codeUnits;
}

/// Decodes binary csv data into a list of [SensorData] points.
List<SensorData> decodeCsv(List<int> rawData) {
  var csvString = String.fromCharCodes(rawData);
  var lines = const CsvToListConverter().convert(csvString);

  // TODO: Check whether header line is valid

  return lines.skip(1).map(_decodeCsvLine).toList();
}

SensorData _decodeCsvLine(List<dynamic> line) {
  var unitString = line[1];
  var maxPrecision = line[2];
  var timestampInMicroseconds = line[3];
  var dataString = line[4];

  var unit = Unit.values.firstWhere((element) => element.name == unitString);
  var data =
      dataString.split(", ").map(double.parse).whereType<double>().toList();

  return SensorData(
    unit: unit,
    maxPrecision: maxPrecision,
    timestampInMicroseconds: timestampInMicroseconds,
    data: data,
  );
}