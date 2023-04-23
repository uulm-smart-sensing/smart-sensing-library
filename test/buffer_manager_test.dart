import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/buffer_manager.dart';

void main() {
  var bufferManager = BufferManager();
  var testData = SensorData(
    data: const [1.1, 1.2, 1.3],
    maxPrecision: 1,
    unit: Unit.microTeslas,
    timestamp: DateTime.utc(2023),
  );
  var testList = [
    SensorData(
      data: const [1.2, 1.2, 1.3],
      maxPrecision: 1,
      unit: Unit.microTeslas,
      timestamp: DateTime.utc(2023),
    ),
    SensorData(
      data: const [2.2, 2.2, 3.3],
      maxPrecision: 1,
      unit: Unit.microTeslas,
      timestamp: DateTime.utc(2022),
    ),
    SensorData(
      data: const [3.2, 3.2, 3.3],
      maxPrecision: 1,
      unit: Unit.microTeslas,
      timestamp: DateTime.utc(2021),
    ),
    SensorData(
      data: const [4.2, 4.2, 4.3],
      maxPrecision: 1,
      unit: Unit.microTeslas,
      timestamp: DateTime.utc(2020),
    )
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
        ..addBuffer(SensorId.orientation)
        ..getBuffer(SensorId.orientation).add(testData);
      bufferManager.getBuffer(SensorId.orientation).remove(testData);
      expect(bufferManager.getBuffer(SensorId.orientation).isEmpty, true);
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
        bufferManager.getBuffer(SensorId.magnetometer).last.timestamp.year,
        2023,
      );
      expect(
        bufferManager.getBuffer(SensorId.magnetometer).first.timestamp.year,
        2020,
      );
    });
  });
}
