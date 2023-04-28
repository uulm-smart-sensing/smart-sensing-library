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
