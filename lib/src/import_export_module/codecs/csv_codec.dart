import 'package:csv/csv.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import '../../../sensor_data_dto.dart';
import '../sensor_data_collection.dart';
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
              sensorData.unit.toString(),
              sensorData.maxPrecision,
              sensorData.timestamp.microsecondsSinceEpoch,
              sensorData.data.join(", "),
            ],
          )
          .toList();

  return const ListToCsvConverter().convert(csvData).codeUnits;
}

/// Decodes binary csv data into a list of [SensorData] points.
SensorDataCollection decodeCsv(List<int> rawData) {
  var csvString = String.fromCharCodes(rawData);
  var lines = const CsvToListConverter().convert(csvString);

  // get the sensorId of this data
  var sensorIdAsString = lines.skip(1).first[0];
  var sensorId =
      SensorId.values.firstWhere((element) => element.name == sensorIdAsString);

  return SensorDataCollection(
    sensorId,
    lines.skip(1).map(_decodeCsvLine).toList(),
  );
}

SensorData _decodeCsvLine(List<dynamic> line) {
  var unitString = line[1];
  var maxPrecision = line[2];
  var timestampInMicroseconds = line[3];
  var dataString = line[4];

  var unit = SensorDataDTO.unitFromString(unitString);
  var data =
      dataString.split(", ").map(double.parse).whereType<double>().toList();

  return SensorData(
    unit: unit,
    maxPrecision: maxPrecision,
    timestamp: DateTime.fromMicrosecondsSinceEpoch(timestampInMicroseconds),
    data: data,
  );
}
