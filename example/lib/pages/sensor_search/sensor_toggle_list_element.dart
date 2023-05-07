import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../sensor_unit_handler/sensor_default_target_unit.dart';
import '../../theme/theme.dart';
import 'sensor_toggle_element.dart';

class SensorToggleListElement extends SensorToggleElement {
  /// Creates a [SensorToggleListElement] for the passed [sensorId].
  ///
  /// If [isTogglingDisabled] is true, the [SensorToggleListElement] is also
  /// disabled, the colors for the disabled state are replaced with the colors
  /// for the inactive state of the switch.
  /// This has the reason that the [SensorToggleListElement] can be shown
  /// without knowing whether the sensor for the passed [sensorId] is actually
  /// available in which case the [SensorToggleListElement] would be disabled.
  SensorToggleListElement({
    required super.sensorId,
    required bool isDisabled,
    required super.isToggledOn,
    bool isTogglingDisabled = false,
    super.key,
  }) : super(
          color: isDisabled
              ? HSLColor.fromColor(sensorIdToColor[sensorId]!.withAlpha(128))
                  .withSaturation(0.5)
                  .toColor()
              : sensorIdToColor[sensorId]!,
          activeColor: const Color.fromARGB(255, 217, 217, 217),
          activeTrackColor: const Color.fromARGB(255, 66, 234, 7),
          inactiveColor: const Color.fromARGB(255, 217, 217, 217),
          inactiveTrackColor: const Color.fromARGB(255, 144, 149, 142),
          isDisabled: isDisabled || isTogglingDisabled,
          disabledColor: const Color.fromARGB(255, 158, 162, 157),
          disabledTrackColor: const Color.fromARGB(255, 144, 149, 142),
          textColor: Colors.black,
          onChanged: (isToggledOn) async {
            if (isTogglingDisabled) {
              return;
            }

            if (isToggledOn) {
              var result = await IOManager().addSensor(
                id: sensorId,
                config: SensorConfig(
                  targetUnit: sensorIdToDefaultTargetUnit[sensorId]!,
                  targetPrecision: 2,
                  timeInterval: const Duration(milliseconds: 100),
                ),
              );
              log("Started sensor ${sensorId.name} with result ${result.name}");
            } else {
              var result = await IOManager().removeSensor(sensorId);
              log("Stopped sensor ${sensorId.name} with result ${result.name}");
            }
          },
        );
}
