import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/multi_filter_tools.dart';

import 'filter_tools_test.dart';

void main() {
  var randomMultiTestDataset = createRandomMultiTestData();
  var determinedMultiTestDataSet = createDeterminedMultiTestData();
  var splittingMultiTestDataSet = createMultiDataForSplitting();

  group("This group tests, that all filter (functions) work deterministic.",
      () {
    test("Test getMax in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getMax(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getMax(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });

    test("Test getMin in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getMin(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getMin(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });
    test("Test getAvg in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getAvg(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getAvg(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });
    test("Test getCount in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getCount(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getCount(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });
    test("Test getMedian in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getMedian(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getMedian(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });
    test("Test getMode in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getMode(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getMode(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });
    test("Test getRange in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getRange(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getRange(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });
    test("Test getSD in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getSD(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getSD(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });

    test("Test getSum in interval with random data", () {
      var filter = MultiFilterTools(randomMultiTestDataset)
        ..getSum(interval: const Duration(days: 30));

      var filterTest = MultiFilterTools(randomMultiTestDataset)
        ..getSum(interval: const Duration(days: 30));

      for (var element in filter.result().keys) {
        expect(
          filter.result()[element],
          SensorDataMatcher(filterTest.result()[element]!),
        );
      }
    });
  });

  group(
    "This group tests the functionality of "
    "each filter with predetermined inputs",
    () {
      test(
        "Test getMax in single interval with predetermined data axis 0",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)..getMax();
          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(29.1),
            );
          }
        },
      );

      test(
        "Test getMax in single interval with predetermined data axis 1",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)
          ..getMax(axis: 1);

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(39.2),
            );
          }
        },
      );
      test(
        "Test getMin in single interval with predetermined data axis 0",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)..getMin();

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(0.1),
            );
          }
        },
      );

      test(
        "Test getMin in single interval with predetermined data axis 1",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)
          ..getMin(axis: 1);

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(10.2),
            );
          }
        },
      );

      test(
        "Test getAvg in single interval with predetermined data",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)..getAvg();

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(14.1),
            );
          }
        },
      );

      test(
        "Test getMedian in single interval with predetermined data",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)
          ..getMedian();

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(14.1),
            );
          }
        },
      );

      test(
        "Test getSum in single interval with predetermined data",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)..getSum();

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(438.1),
            );
          }
        },
      );

      test(
        "Test getCount in single interval with predetermined data",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet);

          for (var element in filter.result().keys) {
            expect(
              filter.getCount()[element],
              contains(31),
            );
          }
        },
      );

      test(
        "Test getMode in single interval with predetermined data",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)..getMode();
          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(0.1),
            );
          }
        },
      );

      test(
        "Test getRange in single interval with predetermined data",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)..getRange();

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(29),
            );
          }
        },
      );

      test(
        "Test getSD in single interval with predetermined data",
        () {
          var filter = MultiFilterTools(determinedMultiTestDataSet)..getSD();

          for (var element in filter.result().keys) {
            expect(
              filter.result()[element]![0].data,
              contains(8.9),
            );
          }
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
        var filter = MultiFilterTools(splittingMultiTestDataSet)
          ..getMax(interval: const Duration(days: 31));

        for (var element in filter.result().keys) {
            expect(
              filter.result()[element]!.length,
              12,
            );
          }
      },
    );

    test(
      "Test for splitting in days",
      () {
        var filter = MultiFilterTools(splittingMultiTestDataSet)
          ..getMax(interval: const Duration(days: 1));
        for (var element in filter.result().keys) {
            expect(
              filter.result()[element]!.length,
              365,
            );
          }
      },
    );

    test(
      "Test for splitting in hours",
      () {
        var filter = MultiFilterTools(splittingMultiTestDataSet)
          ..getMax(interval: const Duration(hours: 1));
        for (var element in filter.result().keys) {
            expect(
              filter.result()[element]!.length,
              8760,
            );
          }
      },
    );

    test(
      "Test for splitting in minutes",
      () {
        var filter = MultiFilterTools(splittingMultiTestDataSet)
          ..getMax(interval: const Duration(minutes: 1));
        for (var element in filter.result().keys) {
            expect(
              filter.result()[element]!.length,
              525600,
            );
          }
      },
    );
  });
}

Map<SensorId, List<SensorData>> createRandomMultiTestData() {
  var testMap = HashMap<SensorId, List<SensorData>>();
  testMap[SensorId.accelerometer] = createRandomTestData();
  testMap[SensorId.barometer] = createRandomTestData();
  testMap[SensorId.gyroscope] = createRandomTestData();
  return testMap;
}

Map<SensorId, List<SensorData>> createDeterminedMultiTestData() {
  var testMap = HashMap<SensorId, List<SensorData>>();
  testMap[SensorId.accelerometer] = createDeterminedTestData();
  testMap[SensorId.barometer] = createDeterminedTestData();
  testMap[SensorId.gyroscope] = createDeterminedTestData();
  return testMap;
}

Map<SensorId, List<SensorData>> createMultiDataForSplitting() {
  var testMap = HashMap<SensorId, List<SensorData>>();
  testMap[SensorId.accelerometer] = createDataForSplitting();
  testMap[SensorId.barometer] = createDataForSplitting();
  testMap[SensorId.gyroscope] = createDataForSplitting();
  return testMap;
}
