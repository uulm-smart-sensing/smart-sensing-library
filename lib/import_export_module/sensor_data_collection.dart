import 'package:sensing_plugin/sensing_plugin.dart';

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
    data['unit'] = sensorData.unit.name;
    data['maxPrecision'] = sensorData.maxPrecision;
    data['timestampInMicroseconds'] = sensorData.timestampInMicroseconds;

    return data;
  }
}