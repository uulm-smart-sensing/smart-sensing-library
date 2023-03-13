import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/buffer_manager.dart';
import 'package:smart_sensing_library/sensor_data.dart';

void main() {
  var bufferManager = BufferManager();
  var testData = SensorData(
    data: [1.1, 1.2, 1.3],
    maxPrecision: 1,
    sensorID: SensorId.accelerometer,
  );
  var testList = [
    SensorData(
      data: [1.2, 1.2, 1.3],
      maxPrecision: 1,
      sensorID: SensorId.accelerometer,
    )..dateTime = DateTime(2023),
    SensorData(
      data: [2.2, 2.2, 3.3],
      maxPrecision: 1,
      sensorID: SensorId.accelerometer,
    )..dateTime = DateTime(2022),
    SensorData(
      data: [3.2, 3.2, 3.3],
      maxPrecision: 1,
      sensorID: SensorId.accelerometer,
    )..dateTime = DateTime(2021),
    SensorData(
      data: [4.2, 4.2, 4.3],
      maxPrecision: 1,
      sensorID: SensorId.accelerometer,
    )..dateTime = DateTime(2020)
  ];

  group("Basic testing of BufferManager", () {
    test("Add and Get Buffer from Buffermanager", () {
      bufferManager.addBuffer(SensorId.accelerometer);
      expect(bufferManager.getBuffer(SensorId.accelerometer).isEmpty, true);
    });

    test("Add buffer twice", () {
      bufferManager.addBuffer(SensorId.barometer);
      expect(
        () => bufferManager.addBuffer(SensorId.barometer),
        throwsException,
      );
    });

    test("Add Data to Buffer", () {
      bufferManager.addBuffer(SensorId.gyroscope);
      bufferManager.getBuffer(SensorId.gyroscope).add(testData);
      expect(bufferManager.getBuffer(SensorId.gyroscope)[0], testData);
    });
    test("Remove Data from Buffer", () {
      bufferManager
        ..addBuffer(SensorId.heading)
        ..getBuffer(SensorId.heading).add(testData);
      bufferManager.getBuffer(SensorId.heading).remove(testData);
      expect(bufferManager.getBuffer(SensorId.heading).isEmpty, true);
    });
    test("Remove buffer from buffer manager.", () {
      bufferManager
        ..addBuffer(SensorId.linearAcceleration)
        ..removeBuffer(SensorId.linearAcceleration);
      expect(
        () => bufferManager.getBuffer(SensorId.linearAcceleration),
        throwsException,
      );
    });
    test("Test buffer sorting algorithm.", () {
      bufferManager
        ..addBuffer(SensorId.magnetometer)
        ..getBuffer(SensorId.magnetometer).addAll(testList);
      expect(
        bufferManager.getBuffer(SensorId.magnetometer).last.dateTime.year,
        2023,
      );
      expect(
        bufferManager.getBuffer(SensorId.magnetometer).first.dateTime.year,
        2020,
      );
    });
  });
}
