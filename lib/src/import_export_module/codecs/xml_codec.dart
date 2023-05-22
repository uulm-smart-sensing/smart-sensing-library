import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:xml/xml.dart';

import '../import_result.dart';
import '../sensor_data_collection.dart';
import '../string_to_unit_converter.dart';
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
        ..element('unit', nest: data.unit.toString())
        ..element('maxPrecision', nest: data.maxPrecision)
        ..element(
          'timestamp',
          nest: data.timestamp.microsecondsSinceEpoch,
        );
    },
  );
}

/// Decodes binary xml data into a list of [SensorData] objects with a
/// corresponding [SensorId].
///
/// Therefor it builds an XML document from the raw data and validates it. If
/// the validation is successful, the sensor data objects will be created and
/// returned. Otherwise it will encode the error in the [ImportResultStatus] and
/// return an [ImportResult] with an empty [SensorDataCollection] field.
ImportResult decodeXml(List<int> rawData) {
  var xmlString = String.fromCharCodes(rawData);

  var xmlDocument = XmlDocument.parse(xmlString);
  var root = xmlDocument.rootElement;

  var sensorDataElements = root.findElements("sensorData");

  if (sensorDataElements.isEmpty) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXMLFormatting);
  }

  // get the sensorId of this data
  var sensorIdAsString = root.getElement("sensorId");

  // check sensorId
  if (!_validateSensorId(sensorIdAsString)) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXMLFormatting);
  }

  var sensorId = SensorId.values
      .firstWhere((element) => element.name == sensorIdAsString!.text);

  var sensorData = sensorDataElements.map(_decodeSensorDataElement).toList();

  if (sensorData.contains(null)) {
    return ImportResult(resultStatus: ImportResultStatus.invalidXMLFormatting);
  }

  return ImportResult(
    resultStatus: ImportResultStatus.success,
    importedData: SensorDataCollection(
      sensorId,
      sensorData.map((e) => e!).toList(),
    ),
  );
}

SensorData? _decodeSensorDataElement(XmlElement sensorDataElement) {
  var datapointElements = sensorDataElement.findAllElements("dataPoint");

  if (!_validateDataPoints(datapointElements)) return null;
  var data = datapointElements
      .map((dataPointElement) => double.parse(dataPointElement.text))
      .toList();

  var unitElement = sensorDataElement.getElement("unit");
  if (!_validateUnit(unitElement)) return null;
  var unitString = unitElement!.text;
  var unit = unitFromString(unitString);

  var precisionElement = sensorDataElement.getElement("maxPrecision");
  if (!_validatePrecision(precisionElement)) return null;
  var maxPrecision = int.parse(precisionElement!.text);

  var timestampElement = sensorDataElement.getElement("timestamp");
  if (!_validateTimestamp(timestampElement)) return null;
  var timestampInMicroseconds = int.parse(
    timestampElement!.text,
  );

  return SensorData(
    data: data,
    unit: unit,
    maxPrecision: maxPrecision,
    timestamp: DateTime.fromMicrosecondsSinceEpoch(timestampInMicroseconds),
  );
}

bool _validateSensorId(XmlElement? sensorId) {
  if (sensorId == null) return false;

  return SensorId.values.map((id) => id.name).toList().contains(sensorId.text);
}

bool _validateUnit(XmlElement? unit) {
  if (unit == null) return false;

  return stringToUnit.containsKey(unit.text);
}

bool _validatePrecision(XmlElement? precision) {
  if (precision == null) return false;

  var precisionAsInt = int.tryParse(precision.text);

  if (precisionAsInt == null) return false;

  return precisionAsInt >= 0 && precisionAsInt <= 9;
}

bool _validateTimestamp(XmlElement? timestamp) {
  if (timestamp == null) return false;

  var timestampAsInt = int.tryParse(timestamp.text);

  if (timestampAsInt == null) return false;

  return timestampAsInt >= 0;
}

bool _validateDataPoints(Iterable<XmlElement> datapoints) {
  if (datapoints.isEmpty) return false;

  for (var datapoint in datapoints) {
    if (double.tryParse(datapoint.text) == null) return false;
  }

  return true;
}
