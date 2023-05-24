import 'dart:collection';

import 'package:sensing_plugin/sensing_plugin.dart';

import 'filter_tools.dart';

/// Extended class of [FilterTools].
///
/// This class is used for multi filtering requests.
/// Uses [FilterTools] as its base and querys the request on all given
/// [SensorId]s. Returns a [Map] with [SensorId] as the key and the queried
/// data as the values.
class MultiFilterTools {
  final Map<SensorId, FilterTools?> _queryMap = HashMap();

  /// Constructor for [MultiFilterTools].
  ///
  /// Adds all values of [queryMap] to internal [_queryMap]
  /// The internal [_queryMap] is used to map all filter options
  /// with the instances.
  MultiFilterTools(Map<SensorId, FilterTools?> queryMap) {
    _queryMap.addAll(queryMap);
  }

  /// Applies [FilterTools.getMax] on every [SensorId]
  /// in given [interval] from [axis].
  void getMax({Duration interval = Duration.zero, int axis = 0}) {
    for (var filter in _queryMap.values) {
      filter?.getMax(interval: interval, axis: axis);
    }
  }

  /// Applies [FilterTools.getMin] on every [SensorId]
  /// in given [interval] from [axis].
  void getMin({Duration interval = Duration.zero, int axis = 0}) {
    for (var filter in _queryMap.values) {
      filter?.getMin(interval: interval, axis: axis);
    }
  }

  /// Applies [FilterTools.getAvg] on every [SensorId].
  void getAvg({Duration interval = Duration.zero}) {
    for (var filter in _queryMap.values) {
      filter?.getAvg(interval: interval);
    }
  }

  /// Applies [FilterTools.getCount] on every [SensorId] and
  /// returns a corresponding [List].
  Map<SensorId, List<int>> getCount({Duration interval = Duration.zero}) {
    var countMap = HashMap<SensorId, List<int>>();
    for (var key in _queryMap.keys) {
      countMap[key] = _queryMap[key]!.getCount(interval: interval);
    }
    return countMap;
  }

  /// Applies [FilterTools.getMedian] on every [SensorId].
  void getMedian({Duration interval = Duration.zero}) {
    for (var filter in _queryMap.values) {
      filter?.getMedian(interval: interval);
    }
  }

  /// Applies [FilterTools.getMode] on every [SensorId]
  /// in given [interval] from [axis].
  void getMode({Duration interval = Duration.zero, int axis = 0}) {
    for (var filter in _queryMap.values) {
      filter?.getMode(interval: interval, axis: axis);
    }
  }

   /// Applies [FilterTools.getRange] on every [SensorId].
  void getRange({Duration interval = Duration.zero}) {
    for (var filter in _queryMap.values) {
      filter?.getRange(interval: interval);
    }
  }

   /// Applies [FilterTools.getSD] on every [SensorId].
  void getSD({Duration interval = Duration.zero}) {
    for (var filter in _queryMap.values) {
      filter?.getSD(interval: interval);
    }
  }

  /// Applies [FilterTools.getSum] on every [SensorId].
  void getSum({Duration interval = Duration.zero}) {
    for (var filter in _queryMap.values) {
      filter?.getSum(interval: interval);
    }
  }

  ///Returns result of query.
  Map<SensorId, List<SensorData>?> result() =>
      _queryMap.map((key, value) => MapEntry(key, value?.result()));
}
