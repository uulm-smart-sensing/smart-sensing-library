import 'package:excel/excel.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

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
      "timestampInMicroseconds",
      "data",
    ]);

  for (var sensorData in data) {
    var sensorDataRow = [
      sensorId.name,
      sensorData.unit.name,
      sensorData.maxPrecision,
      sensorData.timestampInMicroseconds,
      sensorData.data.join(", "),
    ];
    sheet.appendRow(sensorDataRow);
  }

  // encode excel file as string
  return excel.save()!;
}

/// Decodes binary xlsx data into a list of [SensorData] points.
List<SensorData> decodeXlsx(List<int> rawData) {
  var excel = Excel.decodeBytes(rawData);
  var sheet = excel["sensor_data"];

  return sheet.rows.skip(1).map(_decodeXlsxRow).toList();
}

SensorData _decodeXlsxRow(List<Data?> xlsxRow) {
  var unitString = xlsxRow[1]!.value.toString();
  var maxPrecisionString = xlsxRow[2]!.value.toString();
  var timestampInMicrosecondsString = xlsxRow[3]!.value.toString();
  var dataString = xlsxRow[4]!.value.toString();

  var unit = Unit.values.firstWhere((element) => element.name == unitString);
  var maxPrecision = int.parse(maxPrecisionString);
  var timestampInMicroseconds = int.parse(timestampInMicrosecondsString);
  var data =
      dataString.split(", ").map(double.parse).whereType<double>().toList();

  return SensorData(
    unit: unit,
    maxPrecision: maxPrecision,
    timestampInMicroseconds: timestampInMicroseconds,
    data: data,
  );
}
