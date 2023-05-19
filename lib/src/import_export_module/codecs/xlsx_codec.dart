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
  var sheet = excel["sensor_data"];

  // get the sensorId of this data
  var sensorIdAsString = sheet.rows.skip(1).first[0]!.value.toString();
  var sensorId =
      SensorId.values.firstWhere((element) => element.name == sensorIdAsString);

  return ImportResult(
    resultStatus: ImportResultStatus.success,
    importedData: SensorDataCollection(
      sensorId,
      sheet.rows.skip(1).map(_decodeXlsxRow).toList(),
    ),
  );
}

SensorData _decodeXlsxRow(List<Data?> xlsxRow) {
  var unitString = xlsxRow[1]!.value.toString();
  var maxPrecisionString = xlsxRow[2]!.value.toString();
  var timestampInMicrosecondsString = xlsxRow[3]!.value.toString();
  var dataString = xlsxRow[4]!.value.toString();

  var unit = unitFromString(unitString);
  var maxPrecision = int.parse(maxPrecisionString);
  var timestampInMicroseconds = int.parse(timestampInMicrosecondsString);
  var data =
      dataString.split(", ").map(double.parse).whereType<double>().toList();

  return SensorData(
    unit: unit,
    maxPrecision: maxPrecision,
    timestamp: DateTime.fromMicrosecondsSinceEpoch(timestampInMicroseconds),
    data: data,
  );
}
