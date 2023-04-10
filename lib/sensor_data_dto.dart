import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
///DTO class for SensorData
@Entity()
class SensorDataDTO {
  ///Id for Objectbox generation
  @Id()
  late int id;

  ///Datapoints that are saved.
  late String data;

  ///Max precision of the values.
  late int maxPrecision;

  ///Id of the sensor.
  late int sensorID;

  ///Time the data got saved.
  late DateTime dateTime;

  ///Unit of sensor data.
  late Unit unit;

  ///BaseConstructor
  SensorDataDTO();

  ///From Sensordata
  SensorDataDTO.fromSensorData(SensorData sensorData, SensorId senId) {
    _ensureStableEnumValues();
    id = 0;
    maxPrecision = sensorData.maxPrecision;
    sensorID = senId.index;
    dateTime = DateTime.
    fromMicrosecondsSinceEpoch(sensorData.timestampInMicroseconds, isUtc:true);
    data = jsonEncode({"data": sensorData.data});
    unit = sensorData.unit;
  }

  ///Converts DTO to internalSensorData
  SensorData toSensorData() {
    _ensureStableEnumValues();
    return SensorData(
      maxPrecision: maxPrecision,
      timestampInMicroseconds: dateTime.microsecondsSinceEpoch,
      data: (jsonDecode(data)['data'] as List<dynamic>).cast<double>(),
      unit: unit,
    );
  }

  void _ensureStableEnumValues() {
    assert(SensorId.accelerometer.index == 0, "Test if enum still stable");
    assert(SensorId.gyroscope.index == 1, "Test if enum still stable");
    assert(SensorId.magnetometer.index == 2, "Test if enum still stable");
    assert(SensorId.orientation.index == 3, "Test if enum still stable");
    assert(SensorId.linearAcceleration.index == 4, "Test if enum still stable");
    assert(SensorId.barometer.index == 5, "Test if enum still stable");
    assert(SensorId.thermometer.index == 6, "Test if enum still stable");
  }
}
