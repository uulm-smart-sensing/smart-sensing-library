import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import 'src/import_export_module/string_to_unit_converter.dart';

///DTO class for SensorData
@Entity()
class SensorDataDTO {
  ///Id for Objectbox generation
  @Id()
  int id;

  ///Datapoints that are saved.
  late String data;

  ///Max precision of the values.
  int maxPrecision;

  ///Id of the sensor.
  int sensorID;

  ///Time the data got saved.
  @Property(type: PropertyType.dateNano)
  DateTime dateTime;

  ///Unit of sensor data.
  String unit;

  ///BaseConstructor
  SensorDataDTO()
      : id = 0,
        maxPrecision = 0,
        sensorID = 0,
        dateTime = DateTime.fromMicrosecondsSinceEpoch(0),
        unit = "";

  ///From Sensordata
  SensorDataDTO.fromSensorData(SensorData sensorData, SensorId senId)
      : id = 0,
        data = jsonEncode({"data": sensorData.data}),
        maxPrecision = sensorData.maxPrecision,
        sensorID = senId.index,
        dateTime = sensorData.timestamp,
        unit = sensorData.unit.toString() {
    _ensureStableEnumValues();
  }

  ///Converts DTO to SensorData
  SensorData toSensorData() {
    _ensureStableEnumValues();

    return SensorData(
      maxPrecision: maxPrecision,
      timestamp: dateTime,
      data: (jsonDecode(data)['data'] as List<dynamic>).cast<double>(),
      unit: unitFromString(unit),
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
