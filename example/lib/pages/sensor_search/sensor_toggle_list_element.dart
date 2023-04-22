import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../theme.dart';
import 'sensor_toggle_element.dart';

class SensorToggleListElement extends SensorToggleElement {
  /// Creates a [SensorToggleListElement] for the passed [sensorId].
  ///
  /// If [disableToggling] is true, the [SensorToggleListElement] is also
  /// disabled, the colors for the disabeld state are replaced with the colors
  /// for the inactive state of the switch.
  /// This has the reason that the [SensorToggleListElement] can be shown
  /// without knowing whether the sensor for the passed [sensorId] is actually
  /// available in which case the [SensorToggleListElement] would be disabled.
  SensorToggleListElement({
    required super.sensorId,
    required bool isDisabled,
    required super.isToggledOn,
    bool disableToggling = false,
  }) : super(
          key: UniqueKey(),
          color: sensorIdToColor[sensorId] ?? Colors.white,
          activeColor: const Color.fromARGB(255, 217, 217, 217),
          activeTrackColor: const Color.fromARGB(255, 66, 234, 7),
          inactiveColor: const Color.fromARGB(255, 217, 217, 217),
          inactiveTrackColor: const Color.fromARGB(255, 144, 149, 142),
          isDisabled: isDisabled || disableToggling,
          disabledColor: disableToggling
              ? const Color.fromARGB(255, 217, 217, 217)
              : const Color.fromARGB(255, 158, 162, 157),
          disabledTrackColor: disableToggling
              ? const Color.fromARGB(255, 144, 149, 142)
              : const Color.fromARGB(255, 144, 149, 142),
          textColor: Colors.black,
          onChanged: (isToggledOn) async {
            if (disableToggling) {
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

// TODO: Replace with `sensor_default_target_unit.dart`
const sensorIdToDefaultTargetUnit = {
  SensorId.accelerometer: Unit.metersPerSecondSquared,
  SensorId.gyroscope: Unit.degreesPerSecond,
  SensorId.magnetometer: Unit.microTeslas,
  SensorId.orientation: Unit.degrees,
  SensorId.linearAcceleration: Unit.metersPerSecondSquared,
  SensorId.barometer: Unit.hectoPascal,
  SensorId.thermometer: Unit.celsius,
};
