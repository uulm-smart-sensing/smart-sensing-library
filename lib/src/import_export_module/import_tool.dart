import 'package:sensing_plugin/sensing_plugin.dart';

import 'codecs/csv_codec.dart';
import 'codecs/json_codec.dart';
import 'codecs/xlsx_codec.dart';
import 'codecs/xml_codec.dart';
import 'supported_file_format.dart';

/// Decodes a list of raw data into a list of [SensorData] objects.
List<SensorData> decodeSensorData({
  required List<int> rawData,
  required SupportedFileFormat format,
}) {
  switch (format) {
    case SupportedFileFormat.json:
      return decodeJson(rawData);
    case SupportedFileFormat.csv:
      return decodeCsv(rawData);
    case SupportedFileFormat.xlsx:
      return decodeXlsx(rawData);
    case SupportedFileFormat.xml:
      return decodeXml(rawData);
  }
}
