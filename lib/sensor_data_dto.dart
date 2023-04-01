import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import 'sensor_data_mock.dart';

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

  ///BaseConstructor
  SensorDataDTO();

  ///From Sensordata
  SensorDataDTO.fromSensorData(SensorDataMock sensorData) {
    _ensureStableEnumValues();
    id = 0;
    maxPrecision = sensorData.maxPrecision;
    sensorID = sensorData.sensorID.index;
    dateTime = sensorData.dateTime;
    data = jsonEncode({"data": sensorData.data});
  }

  ///Converts DTO to internalSensorData
  SensorDataMock toSensorData() {
    _ensureStableEnumValues();
    return SensorDataMock(
      maxPrecision: maxPrecision,
      setTime: dateTime,
      sensorID: SensorId.values[sensorID],
      data: (jsonDecode(data)['data'] as List<dynamic>).cast<double>(),
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
