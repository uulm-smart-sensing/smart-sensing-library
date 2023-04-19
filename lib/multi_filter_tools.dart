import 'dart:collection';

import 'package:sensing_plugin/sensing_plugin.dart';

import 'filter_tools.dart';

///Extended class of [FilterTools].
///
///This class is used for multi filtering requests.
///Uses [FilterTools] as its base and querys the request on all given
///[SensorId]s. Returns a [Map] with [SensorId] as the key and the queried
///data as the values.
class MultiFilterTools {
  final Map<SensorId, FilterTools> _querryMap = HashMap();

  ///Constructor for [MultiFilterTools].
  ///
  ///All [List]s in [querryMap] get converted to a [FilterTools] instance.
  ///The internal [_querryMap] is used to map all filter options
  ///with the instances.
  MultiFilterTools(Map<SensorId, List<SensorData>> querryMap) {
    var newMap = querryMap.map((key, value) {
      var filterTools = FilterTools(value);
      return MapEntry(key, filterTools);
    });
    _querryMap.addAll(newMap);
  }

  ///Maps maximum of each [List] in given [interval] from [axis].
  void getMax({Duration interval = Duration.zero, int axis = 0}) {
    for (var filter in _querryMap.values) {
      filter.getMax(interval: interval, axis: axis);
    }
  }

  ///Maps minimum of each [List] in given [interval] from [axis].
  void getMin({Duration interval = Duration.zero, int axis = 0}) {
    for (var filter in _querryMap.values) {
      filter.getMin(interval: interval, axis: axis);
    }
  }

  ///Maps average of each [List] in given [interval].
  void getAvg({Duration interval = Duration.zero}) {
    for (var filter in _querryMap.values) {
      filter.getAvg(interval: interval);
    }
  }

  ///Maps amount of entries in each [List] in given [interval].
  Map<SensorId, List<int>> getCount({Duration interval = Duration.zero}) {
    var countMap = HashMap<SensorId, List<int>>();
    for (var key in _querryMap.keys) {
      countMap[key] = _querryMap[key]!.getCount(interval: interval);
    }
    return countMap;
  }

  ///Maps amount of entries in each [List] in given [interval].
  void getMedian({Duration interval = Duration.zero}) {
    for (var filter in _querryMap.values) {
      filter.getMedian(interval: interval);
    }
  }

  ///Maps amount of entries in [List] in given [interval].
  void getMode({Duration interval = Duration.zero, int axis = 0}) {
    for (var filter in _querryMap.values) {
      filter.getMode(interval: interval, axis: axis);
    }
  }

  ///Maps the difference between the highest and lowest value in each [List]
  ///in given [interval].
  void getRange({Duration interval = Duration.zero}) {
    for (var filter in _querryMap.values) {
      filter.getRange(interval: interval);
    }
  }

  ///Maps the standard deviation of each [List] in given [interval].
  void getSD({Duration interval = Duration.zero}) {
    for (var filter in _querryMap.values) {
      filter.getSD(interval: interval);
    }
  }

  ///Maps sum of each [List] in given [interval].
  void getSum({Duration interval = Duration.zero}) {
    for (var filter in _querryMap.values) {
      filter.getSum(interval: interval);
    }
  }

  ///Returns result of querry.
  Map<SensorId, List<SensorData>> result() =>
      _querryMap.map((key, value) => MapEntry(key, value.result()));
}
