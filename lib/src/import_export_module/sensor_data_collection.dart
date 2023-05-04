import 'package:sensing_plugin/sensing_plugin.dart';

import '../../sensor_data_dto.dart';

/// A collection of [SensorData] of a sensor, which should be exported or was
/// imported.
///
/// This class is only used to encode the sensor data as json or decode a
/// json string into an usable object
class SensorDataCollection {
  /// The [SensorId] of the sensor, whose data is saved in this collection.
  final SensorId sensorId;

  /// The list of sensor data of the sensor, that should be imported or
  /// exported.
  final List<SensorData> sensorData;

  /// Creates a new collection of sensor data.
  SensorDataCollection(this.sensorId, this.sensorData);

  /// Converts this [SensorDataCollection] into the corresponding JSON map
  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['sensorId'] = sensorId.name;
    data['sensorData'] = sensorData.map(_formatSensorDataToJson).toList();

    return data;
  }

  Map<String, dynamic> _formatSensorDataToJson(SensorData sensorData) {
    var data = <String, dynamic>{};
    data['data'] = sensorData.data;
    data['unit'] = sensorData.unit.toString();
    data['maxPrecision'] = sensorData.maxPrecision;
    data['timestamp'] = sensorData.timestamp.microsecondsSinceEpoch;

    return data;
  }

  /// Creates a new [SensorDataCollection] from the passed [json] map.
  factory SensorDataCollection.fromJson(Map<String, dynamic> json) {
    /// TODO: find default, if no valid sensorId is provided
    var sensorId = SensorId.values.firstWhere(
      (id) => id.name == json['sensorId'],
      orElse: () => SensorId.accelerometer,
    );
    var sensorData = <SensorData>[];

    if (json['sensorData'] == null) {
      return SensorDataCollection(sensorId, sensorData);
    }
    for (var sensorDataJson in json['sensorData']) {
      sensorData.add(_formatSensorDataFromJson(sensorDataJson));
    }

    return SensorDataCollection(sensorId, sensorData);
  }

  static SensorData _formatSensorDataFromJson(Map<String, dynamic> json) {
    var data = (json['data'] as List<dynamic>).whereType<double>().toList();
    var unit = SensorDataDTO.unitFromString(json['unit']);
    var maxPrecision = json['maxPrecision'] as int;
    var timestampInMicroseconds = json['timestampInMicroseconds'] as int;

    return SensorData(
      data: data,
      unit: unit,
      maxPrecision: maxPrecision,
      timestamp: DateTime.fromMicrosecondsSinceEpoch(timestampInMicroseconds),
    );
  }
}
