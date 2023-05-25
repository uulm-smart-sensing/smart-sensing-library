import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'sensor_info_tooltip.dart';

/// Wraps up the [SensorInfo] and [SensorConfig] of a certain sensor.
///
/// This data is used by the [SensorInfoTooltip].
class SensorTooltipData {
  final SensorInfo sensorInfo;
  final SensorConfig sensorConfig;

  SensorTooltipData(this.sensorInfo, this.sensorConfig);
}
