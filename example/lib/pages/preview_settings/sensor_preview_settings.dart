import '../../filter_options.dart';

/// Class to save preview settings.
class SensorPreviewSetting {
  Duration timeInterval;
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
}