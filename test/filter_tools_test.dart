import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/filter_tools.dart';
import 'package:smart_sensing_library/sensor_data.dart';

void main() {
  var randomTestDataset = createRandomTestData();
  var determinedTestDataSet = createDeterminedTestData();

  group("This groups Test that only test if the filters are deterministic.",
      () {
    test("Test getMax in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMax(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMax(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getMin in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMin(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMin(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getAvg in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getAvg(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getAvg(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getCount in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset);
      var count = filter.getCount(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset);
      var testCount = filterTest.getCount(intervall: const Duration(days: 30));

      expect(count, containsAllInOrder(testCount));
    });

    test("Test getMedian in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMedian(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMedian(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getMode in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMode(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMode(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getRange in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getRange(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getRange(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getSum in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getSum(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getSum(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getSD in intervall with Random Data", () {
      var filter = FilterTools(randomTestDataset)
        ..getSD(intervall: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getSD(intervall: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });
  });

  group(
    "This group tests the functionality of "
    "each filter with predetermined inputs",
    () {
      test(
        "Test getMax in single intervall with predetermined data axis 0",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMax();

          expect(filter.result()[0].data, contains(29.1));
        },
      );

      test(
        "Test getMax in single intervall with predetermined data axis 1",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMax(axis: 1);

          expect(filter.result()[0].data, contains(39.2));
        },
      );
      test(
        "Test getMin in single intervall with predetermined data axis 0",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMin();

          expect(filter.result()[0].data, contains(0.1));
        },
      );

      test(
        "Test getMin in single intervall with predetermined data axis 1",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMin(axis: 1);

          expect(filter.result()[0].data, contains(10.2));
        },
      );

      test(
        "Test getAvg in single intervall with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getAvg();

          expect(filter.result()[0].data, contains(14.6));
        },
      );

      test(
        "Test getMedian in single intervall with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMedian();

          expect(filter.result()[0].data, contains(14.6));
        },
      );

      test(
        "Test getSum in single intervall with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getSum();

          expect(filter.result()[0].data, contains(438));
        },
      );

      test(
        "Test getSum in single intervall with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet);

          expect(filter.getCount(), contains(30));
        },
      );

      test(
        "Test getSum in single intervall with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMode();

          // expect(filter.result()[0].data, contains(438));
        },
      );

      test(
        "Test getSum in single intervall with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getRange();

          expect(filter.result()[0].data, contains(29));
        },
      );

      test(
        "Test getSum in single intervall with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getSD();

          expect(filter.result()[0].data, contains(8.7));
        },
      );
    },
  );
}

List<SensorData> createRandomTestData() {
  var testData = <SensorData>[];
  for (var i = 0; i < 30; i++) {
    testData.add(
      SensorData(
        data: [
          Random().nextDouble() * 360,
          Random().nextDouble() * 360,
          Random().nextDouble() * 360,
        ],
        maxPrecision: 1,
        sensorID: SensorId.accelerometer,
        setTime: DateTime(
          2023,
          Random().nextInt(12) + 1,
          Random().nextInt(30) + 1,
          Random().nextInt(60),
        ),
      ),
    );
  }
  testData.sort(
    (a, b) => a.dateTime.compareTo(b.dateTime),
  );
  return testData;
}

List<SensorData> createDeterminedTestData() {
  var testData = <SensorData>[];
  for (var i = 0; i < 30; i++) {
    testData.add(
      SensorData(
        data: [
          i + 0.1,
          i + 10.2,
          i + 100.3,
        ],
        maxPrecision: 1,
        sensorID: SensorId.accelerometer,
        setTime: DateTime(
          2023,
          Random().nextInt(12) + 1,
          Random().nextInt(30) + 1,
          Random().nextInt(60),
        ),
      ),
    );
  }
  testData.sort(
    (a, b) => a.dateTime.compareTo(b.dateTime),
  );
  return testData;
}
