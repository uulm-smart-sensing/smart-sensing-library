import 'dart:convert';

import '../../filter_options.dart';

/// Class to save preview settings.
class SensorPreviewSetting {
  late Duration timeInterval;
  late final Map<FilterOption, bool> active;
  SensorPreviewSetting({
    this.timeInterval = const Duration(seconds: 5),
    Map<FilterOption, bool>? activeMap,
  }) {
    activeMap ??= _createEmptyMap();
    active = activeMap;
  }

  Map<FilterOption, bool> _createEmptyMap() {
    var map = <FilterOption, bool>{};
    for (var filter in FilterOption.values) {
      map[filter] = false;
    }
    return map;
  }

  SensorPreviewSetting.fromJson(String jsonString) {
    var json = jsonDecode(jsonString);
    timeInterval = Duration(microseconds: json['timeInterval']);
    active = (json['activeMap'] as Map<dynamic,dynamic>).cast<String,bool>().map(
      (key, value) =>
    MapEntry(FilterOption.values[int.parse(key)], value),);
  }

  String toJson() => json.encode({
    'timeInterval': timeInterval.inMicroseconds,
    'activeMap': active.map((key, value) => MapEntry(key.index.toString(), value)),
  });
}
