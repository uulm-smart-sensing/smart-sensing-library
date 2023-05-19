import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import '../import_result.dart';
import '../sensor_data_collection.dart';
import '../string_to_unit_converter.dart';
import '../supported_file_format.dart';

/// Formats a list of sensor data (points) into the corresponding csv string
/// following the format described in [SupportedFileFormat.csv].
///
/// Therefor a [ListToCsvConverter] is used to enforce the RFC conforming
/// format.
List<int> formatDataIntoCSV(SensorId sensorId, List<SensorData> data) {
  // create first row
  var headerRow = ["sensorId", "unit", "maxPrecision", "timestamp", "data"];

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

/// Decodes binary csv data into a list of [SensorData] objects with a
/// correspondig [SensorId] using the [CsvToListConverter].
///
/// Therefor it reads the raw data and validate it. If the
/// validation is successful, the sensor data objects will be created and
/// returned. Otherwise it will encode the error in the [ImportResultStatus] and
/// return an [ImportResult] with an empty [SensorDataCollection] field.
ImportResult decodeCsv(List<int> rawData) {
  var csvString = String.fromCharCodes(rawData);
  var lines = const CsvToListConverter().convert(csvString);

  // check if first line is correct
  if (lines.isNotEmpty &&
      !lines[0]
          .equals(["sensorId", "unit", "maxPrecision", "timestamp", "data"])) {
    return ImportResult(resultStatus: ImportResultStatus.invalidCSVFormatting);
  }

  // check, if the csv file contains data
  if (lines.length <= 1) {
    return ImportResult(resultStatus: ImportResultStatus.invalidCSVFormatting);
  }

  // get the sensorId of this data
  var sensorIdAsString = lines.skip(1).first[0];
  // check, that sensor id exists and is correct
  var sensorId = SensorId.values
      .firstWhereOrNull((element) => element.name == sensorIdAsString);

  if (sensorId == null) {
    return ImportResult(resultStatus: ImportResultStatus.invalidCSVFormatting);
  }

  var sensorData = lines.skip(1).map(_decodeCsvLine).toList();

  if (sensorData.contains(null)) {
    return ImportResult(resultStatus: ImportResultStatus.invalidCSVFormatting);
  }

  return ImportResult(
    resultStatus: ImportResultStatus.success,
    importedData: SensorDataCollection(
      sensorId,
      sensorData.map((e) => e!).toList(),
    ),
  );
}

SensorData? _decodeCsvLine(List<dynamic> line) {
  // check, that enough data is given in this line
  if (line.length != 5) return null;

  // check, that unit is valid and if so, decode it
  if (!stringToUnit.containsKey(line[1])) return null;
  var unit = unitFromString(line[1]);

  var maxPrecision = line[2];
  // check, that precision is valid and if so, decode it
  if (maxPrecision is! int || maxPrecision < 0 || maxPrecision > 9) return null;

  var timestamp = line[3];
  // check, that precision is valid and if so, decode it
  if (timestamp is! int || timestamp < 0) return null;

  if (line[4] is! String || !_validateData(line[4])) return null;

  var data = line[4].split(", ").map(double.parse).whereType<double>().toList();

  return SensorData(
    unit: unit,
    maxPrecision: maxPrecision,
    timestamp: DateTime.fromMicrosecondsSinceEpoch(timestamp),
    data: data,
  );
}

bool _validateData(String datapoints) {
  var points = datapoints.toString().split(", ");

  if (points.isEmpty) return false;
  for (var datapoint in points) {
    var parsedDatapoint = double.tryParse(datapoint);

    if (parsedDatapoint == null) return false;
  }

  return true;
}
