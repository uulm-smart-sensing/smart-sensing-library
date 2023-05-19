import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import '../import_result.dart';
import '../sensor_data_collection.dart';
import '../string_to_unit_converter.dart';
import '../supported_file_format.dart';

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
      "timestamp",
      "data",
    ]);

  for (var sensorData in data) {
    var sensorDataRow = [
      sensorId.name,
      sensorData.unit.toString(),
      sensorData.maxPrecision,
      sensorData.timestamp.microsecondsSinceEpoch,
      sensorData.data.join(", "),
    ];
    sheet.appendRow(sensorDataRow);
  }

  // encode excel file as string
  return excel.save()!;
}

/// Decodes binary csv data into a list of [SensorData] objects with a
/// correspondig [SensorId] using the [Excel] package.
///
/// Therefor it reads the raw data and validate it. If the
/// validation is successful, the sensor data objects will be created and
/// returned. Otherwise it will encode the error in the [ImportResultStatus] and
/// return an [ImportResult] with an empty [SensorDataCollection] field.
ImportResult decodeXlsx(List<int> rawData) {
  var excel = Excel.decodeBytes(rawData);
  if (!excel.sheets.containsKey("sensor_data")) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXLSXFormatting);
  }

  var sheet = excel["sensor_data"];

  var firstLine = sheet.rows[0].map((e) => e!.value.toString()).toList();

  // check if first line is correct
  if (sheet.rows.isNotEmpty &&
      !firstLine
          .equals(["sensorId", "unit", "maxPrecision", "timestamp", "data"])) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXLSXFormatting);
  }

  // check, if the csv file contains data
  if (sheet.rows.length <= 1) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXLSXFormatting);
  }

  // get the sensorId of this data
  var sensorIdAsString = sheet.rows.skip(1).first[0]!.value.toString();
  var sensorId = SensorId.values
      .firstWhereOrNull((element) => element.name == sensorIdAsString);

  if (sensorId == null) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXLSXFormatting);
  }

  var sensorData = sheet.rows.skip(1).map(_decodeXlsxRow).toList();

  if (sensorData.contains(null)) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXLSXFormatting);
  }

  return ImportResult(
    resultStatus: ImportResultStatus.success,
    importedData: SensorDataCollection(
      sensorId,
      sensorData.map((e) => e!).toList(),
    ),
  );
}

SensorData? _decodeXlsxRow(List<Data?> xlsxRow) {
  if (xlsxRow.length < 5) return null;

  var unitString = xlsxRow[1]!.value.toString();
  var maxPrecisionString = xlsxRow[2]!.value.toString();
  var timestampString = xlsxRow[3]!.value.toString();
  var dataString = xlsxRow[4]!.value.toString();

  // check, that unit is valid and if so, decode it
  if (!stringToUnit.containsKey(unitString)) return null;
  var unit = unitFromString(unitString);

  var maxPrecision = int.tryParse(maxPrecisionString);
  // check, that precision is valid and if so, decode it
  if (maxPrecision == null || maxPrecision < 0 || maxPrecision > 9) return null;

  var timestamp = int.tryParse(timestampString);
  // check, that precision is valid and if so, decode it
  if (timestamp == null || timestamp < 0) return null;

  if (!_validateData(dataString)) return null;

  var data =
      dataString.split(", ").map(double.parse).whereType<double>().toList();

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
