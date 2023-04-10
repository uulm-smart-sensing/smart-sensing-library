import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/filter_tools.dart';

void main() {
  var randomTestDataset = createRandomTestData();
  var determinedTestDataSet = createDeterminedTestData();
  var splittingTestDataSet = createDataForSplitting();

  group("This group tests, that all filter (functions) work deterministic.",
      () {
    test("Test getMax in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMax(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMax(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getMin in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMin(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMin(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getAvg in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getAvg(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getAvg(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getCount in interval with random data", () {
      var filter = FilterTools(randomTestDataset);
      var count = filter.getCount(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset);
      var testCount = filterTest.getCount(interval: const Duration(days: 30));

      expect(count, containsAllInOrder(testCount));
    });

    test("Test getMedian in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMedian(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMedian(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getMode in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getMode(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getMode(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getRange in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getRange(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getRange(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getSum in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getSum(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getSum(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });

    test("Test getSD in interval with random data", () {
      var filter = FilterTools(randomTestDataset)
        ..getSD(interval: const Duration(days: 30));

      var filterTest = FilterTools(randomTestDataset)
        ..getSD(interval: const Duration(days: 30));

      expect(filter.result(), containsAllInOrder(filterTest.result()));
    });
  });

  group(
    "This group tests the functionality of "
    "each filter with predetermined inputs",
    () {
      test(
        "Test getMax in single interval with predetermined data axis 0",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMax();

          expect(filter.result()[0].data, contains(29.1));
        },
      );

      test(
        "Test getMax in single interval with predetermined data axis 1",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMax(axis: 1);

          expect(filter.result()[0].data, contains(39.2));
        },
      );
      test(
        "Test getMin in single interval with predetermined data axis 0",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMin();

          expect(filter.result()[0].data, contains(0.1));
        },
      );

      test(
        "Test getMin in single interval with predetermined data axis 1",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMin(axis: 1);

          expect(filter.result()[0].data, contains(10.2));
        },
      );

      test(
        "Test getAvg in single interval with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getAvg();

          expect(filter.result()[0].data, contains(14.1));
        },
      );

      test(
        "Test getMedian in single interval with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMedian();

          expect(filter.result()[0].data, contains(14.1));
        },
      );

      test(
        "Test getSum in single interval with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getSum();

          expect(filter.result()[0].data, contains(438.1));
        },
      );

      test(
        "Test getCount in single interval with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet);

          expect(filter.getCount(), contains(31));
        },
      );

      test(
        "Test getMode in single interval with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getMode();

          expect(filter.result()[0].data, contains(0.1));
        },
      );

      test(
        "Test getRange in single interval with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getRange();

          expect(filter.result()[0].data, contains(29));
        },
      );

      test(
        "Test getSD in single interval with predetermined data",
        () {
          var filter = FilterTools(determinedTestDataSet)..getSD();

          expect(filter.result()[0].data, contains(8.9));
        },
      );
    },
  );

  group(
      "This group tests the splitting algorithm"
      "(depending on the time intervals)", () {
    test(
      "Test for splitting in months",
      () {
        var filter = FilterTools(splittingTestDataSet)
          ..getMax(interval: const Duration(days: 31));

        expect(filter.result().length, 12);
      },
    );

    test(
      "Test for splitting in days",
      () {
        var filter = FilterTools(splittingTestDataSet)
          ..getMax(interval: const Duration(days: 1));

        expect(filter.result().length, 365);
      },
    );

    test(
      "Test for splitting in hours",
      () {
        var filter = FilterTools(splittingTestDataSet)
          ..getMax(interval: const Duration(hours: 1));
        expect(filter.result().length, 8760);
      },
    );

    test(
      "Test for splitting in minutes",
      () {
        var filter = FilterTools(splittingTestDataSet)
          ..getMax(interval: const Duration(minutes: 1));
        expect(filter.result().length, 525600);
      },
    );
  });
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
        timestampInMicroseconds: DateTime.utc(
          2023,
          Random().nextInt(12) + 1,
          Random().nextInt(30) + 1,
          Random().nextInt(60),
        ).microsecondsSinceEpoch,
        unit: Unit.bar,
      ),
    );
  }
  testData.sort(
    (a, b) => DateTime.fromMicrosecondsSinceEpoch(a.timestampInMicroseconds)
        .compareTo(
            DateTime.fromMicrosecondsSinceEpoch(b.timestampInMicroseconds)),
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
        unit: Unit.bar,
        timestampInMicroseconds: DateTime.utc(
          2023,
          Random().nextInt(12) + 1,
          Random().nextInt(30) + 1,
          Random().nextInt(60),
        ).microsecondsSinceEpoch,
      ),
    );
  }
  testData
    ..add(
      SensorData(
        data: const [
          0.1,
          10.2,
          100.3,
        ],
        maxPrecision: 1,
        unit: Unit.bar,
        timestampInMicroseconds: DateTime.utc(
          2023,
          Random().nextInt(12) + 1,
          Random().nextInt(30) + 1,
          Random().nextInt(60),
        ).microsecondsSinceEpoch,
      ),
    )
    ..sort(
      (a, b) => DateTime.fromMicrosecondsSinceEpoch(a.timestampInMicroseconds)
          .compareTo(
              DateTime.fromMicrosecondsSinceEpoch(b.timestampInMicroseconds)),
    );
  return testData;
}

List<SensorData> createDataForSplitting() {
  var testData = <SensorData>[];
  for (var month = 1; month < 13; month++) {
    for (var day = 1; day < 32; day++) {
      for (var hour = 0; hour < 24; hour++) {
        for (var minute = 0; minute < 60; minute++) {
          if (month == 2 && day > 28) {
            continue;
          }
          if ([4, 6, 9, 11].contains(month) && day > 30) {
            continue;
          }
          testData.add(
            SensorData(
              data: [
                month.toDouble(),
                day.toDouble(),
                hour.toDouble(),
              ],
              maxPrecision: 1,
              unit: Unit.celsius,
              timestampInMicroseconds: DateTime.utc(
                2023,
                month,
                day,
                hour,
                minute,
              ).microsecondsSinceEpoch,
            ),
          );
        }
      }
    }
  }
  testData.sort(
    (a, b) => DateTime.fromMicrosecondsSinceEpoch(a.timestampInMicroseconds)
        .compareTo(
            DateTime.fromMicrosecondsSinceEpoch(b.timestampInMicroseconds)),
  );

  return testData;
}
