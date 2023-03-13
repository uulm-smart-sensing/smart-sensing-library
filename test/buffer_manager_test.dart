import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library/buffer_manager.dart';
import 'package:smart_sensing_library/sensor_data.dart';

void main() {
  var bufferManager = BufferManager();
  var testData =
      SensorData(data: [1.1, 1.2, 1.3], maxPrecision: 1, sensorID: 1);
  var testList = [
    SensorData(data: [1.2, 1.2, 1.3], maxPrecision: 1, sensorID: 1)
      ..dateTime = DateTime(2023),
    SensorData(data: [2.2, 2.2, 3.3], maxPrecision: 1, sensorID: 1)
      ..dateTime = DateTime(2022),
    SensorData(data: [3.2, 3.2, 3.3], maxPrecision: 1, sensorID: 1)
      ..dateTime = DateTime(2021),
    SensorData(data: [4.2, 4.2, 4.3], maxPrecision: 1, sensorID: 1)
      ..dateTime = DateTime(2020)
  ];

  group("Basic testing of BufferManager", () {
    test("Add and Get Buffer from Buffermanager", () {
      bufferManager.addBuffer(1);
      expect(bufferManager.getBuffer(1).isEmpty, true);
    });

    test("Add buffer twice", () {
      bufferManager.addBuffer(2);
      expect(() => bufferManager.addBuffer(2), throwsException);
    });

    test("Add Data to Buffer", () {
      bufferManager.addBuffer(3);
      bufferManager.getBuffer(3).add(testData);
      expect(bufferManager.getBuffer(3)[0], testData);
    });
    test("Remove Data from Buffer", () {
      bufferManager
        ..addBuffer(4)
        ..getBuffer(4).add(testData);
      bufferManager.getBuffer(4).remove(testData);
      expect(bufferManager.getBuffer(4).isEmpty, true);
    });
    test("Remove buffer from buffer manager.", () {
      bufferManager
        ..addBuffer(5)
        ..removeBuffer(5);
      expect(() => bufferManager.getBuffer(5), throwsException);
    });
    test("Test buffer sorting algorithm.", () {
      bufferManager
        ..addBuffer(6)
        ..getBuffer(6).addAll(testList);
      expect(bufferManager.getBuffer(6).last.dateTime.year, 2023);
      expect(bufferManager.getBuffer(6).first.dateTime.year, 2020);
    });
  });
}
