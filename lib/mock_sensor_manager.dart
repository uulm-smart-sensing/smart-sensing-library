import 'dart:collection';

import 'package:sensing_plugin/sensing_plugin.dart';
import 'sensor_data.dart';

///A SensorManager for testing purposes
class MockSensorManager{

  MockSensorManager._constructor();
  static final MockSensorManager _instance = MockSensorManager._constructor();
  final HashMap _streamMap =
  HashMap<SensorId, Stream<SensorData>?>();

  ///Instance for MockSensorManager
  factory MockSensorManager() => _instance;

 ///Creates a Stream for testingPurposes
  Stream<SensorData> addSensor(SensorId id) {
    var stream =  Stream<SensorData>.periodic(
          const Duration(seconds: 1), (x) => _createTestData(x, id),);
    _streamMap[id] = stream;
    return stream;
  }

  ///Creates a Stream for testingPurposes
  void removeSensor(SensorId id) {
    _streamMap[id] = null;
  }

  SensorData _createTestData(int i, SensorId id) => SensorData(
        data: [i + 0.1, i + 0.2, i + 0.3],
        maxPrecision: 2,
        sensorID: id,
      );

}