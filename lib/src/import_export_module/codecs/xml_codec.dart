import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:xml/xml.dart';

import '../supported_file_format.dart';

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
