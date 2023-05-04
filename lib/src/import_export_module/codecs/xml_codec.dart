import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:xml/xml.dart';

import '../sensor_data_collection.dart';
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

/// Decodes binary xml data into a list of [SensorData] points.
SensorDataCollection decodeXml(List<int> rawData) {
  var xmlString = String.fromCharCodes(rawData);

  var xmlDocument = XmlDocument.parse(xmlString);
  var root = xmlDocument.rootElement;

  var sensorDataElements = root.findElements("sensorData");

  // get the sensorId of this data
  var sensorIdAsString = root.getElement("sensorId")!.text;
  var sensorId =
      SensorId.values.firstWhere((element) => element.name == sensorIdAsString);

  return SensorDataCollection(
    sensorId,
    sensorDataElements.map(_decodeSensorDataElement).toList(),
  );
}

SensorData _decodeSensorDataElement(XmlElement sensorDataElement) {
  var data = sensorDataElement
      .findAllElements("dataPoint")
      .map((dataPointElement) => double.parse(dataPointElement.text))
      .toList();

  var unitString = sensorDataElement.getElement("unit")!.text;
  var unit = Unit.values.firstWhere((element) => element.name == unitString);

  var maxPrecision =
      int.parse(sensorDataElement.getElement("maxPrecision")!.text);

  var timestampInMicroseconds = int.parse(
    sensorDataElement.getElement("timestampInMicroseconds")!.text,
  );

  return SensorData(
    data: data,
    unit: unit,
    maxPrecision: maxPrecision,
    timestampInMicroseconds: timestampInMicroseconds,
  );
}
