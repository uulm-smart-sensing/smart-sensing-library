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
