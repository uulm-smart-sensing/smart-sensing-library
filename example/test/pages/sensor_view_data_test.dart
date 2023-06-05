import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library_example/pages/historic_view/sensor_graph_view_data.dart';

void main() {
  var sensorDataList = [
    const SensorGraphViewData(timestamp: 1, x: 1, y: 2, z: 3),
    const SensorGraphViewData(timestamp: 2, x: 4, y: 1, z: 7),
    const SensorGraphViewData(timestamp: 3, x: 7, y: 8, z: 1),
  ];

  group('Checks the maximum X in the SensorViewData list', () {
    test('If it is the maximum in SensorviewData it returns true.', () {
      var maxX = getMaxX(sensorDataList);
      expect(maxX, equals(3));
    });

    test('If it is the not maximum in SensorviewData it returns false.', () {
      var maxX = getMaxX(sensorDataList);
      expect(maxX, isNot(1));
    });
  });

  group('Checks the minimum X in the SensorViewData list', () {
    test('If it is the minimum X in SensorviewData it returns true', () {
      var minX = getMinX(sensorDataList);
      expect(minX, equals(1));
    });
    test('If it is not the minimum X in SensorviewData it returns false', () {
      var minX = getMinX(sensorDataList);
      expect(minX, isNot(2));
    });
  });

  group("Checks the maximum Y in the SensorViewData list", () {
    test('If it is the maximum in SensorviewData it returns true. ', () {
      var expectedmaxY = getMaxY(sensorDataList);

      expect(expectedmaxY, equals(8));
    });

    test('If it is not the maximum in SensorviewData it returns false. ', () {
      var expectedmaxY = getMaxY(sensorDataList);

      expect(expectedmaxY, isNot(2));
    });
  });

  group('Checks the minimum Y in the SensorViewData list', () {
    test('If it is the minimum in SensorviewData it returns true. ', () {
      var expectedminY = getMinY(sensorDataList);

      expect(expectedminY, equals(0));
    });

    test('If it is not the minimum in SensorviewData it returns false. ', () {
      var expectedminY = getMinY(sensorDataList);

      expect(expectedminY, isNot(3));
    });
  });

  test('converts a timestamp into a DateTime object.', () {
    var timestamp = 12345.67;
    var date = convertToDate(timestamp);

    expect(
      date,
      equals(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt())),
    );
  });

  test('When toString() is called, then the x, y, z values are returned', () {
    var sensorViewData =
        const SensorGraphViewData(timestamp: 1, x: 2, y: 3, z: 4);

    expect(sensorViewData.toString(), equals('2.0\n3.0\n4.0'));
  });
}
