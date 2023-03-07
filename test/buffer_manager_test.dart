import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library/buffer_manager.dart';
import 'package:smart_sensing_library/sensor_data.dart';

void main() {
  var bufferManager = BufferManager();
  var testData =
      SensorData(data: [1.1, 1.2, 1.3], maxPrecision: 1, sensorID: 1);
  group("Basic testing of BufferManager", () {
    test("Add and Get Buffer from Buffermanager", () {
      bufferManager.addBuffer(1);
      expect(bufferManager.getBuffer(1).isEmpty, true);
    });

    test("Add buffer twice", () {
      expect(() => bufferManager.addBuffer(1), throwsException);
    });

    test("Add Data to Buffer", () {
      bufferManager.getBuffer(1).add(testData);
      expect(bufferManager.getBuffer(1)[0], testData);
    });
    test("Remove Data from Buffer", () {
      bufferManager.getBuffer(1).remove(testData);
      expect(bufferManager.getBuffer(1).isEmpty, true);
    });
    test("Remove buffer from buffer manager.", () {
      bufferManager.removeBuffer(1);
      expect(() => bufferManager.getBuffer(1), throwsException);
    });
  });
}
