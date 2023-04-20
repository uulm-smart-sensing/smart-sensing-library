import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

/// Time picker to pick the time interval of a sensor.
///
/// The user can picks a time interval between 10 ms and 59 minutes, 59 seconds
/// and 999 milliseconds (=3599999 ms) (both inclusive).
///
/// Note: A minimum of 10 ms was chosen because that's what is used in the
/// sensing plugin as part of the sensor property validator. On Android the
/// values 0-3 are reserved for preset time intervals e.g.
/// [SENSOR_DELAY_FASTEST](https://developer.android.com/reference/kotlin/android/hardware/SensorManager#sensor_delay_fastest). It is highly unlikely that a sensor can
/// deliver sensor data in an interval less than 10 ms.
class TimeIntervalPicker extends CommonPickerModel {
  String digits(int value, int length) => '$value'.padLeft(length, "0");

  TimeIntervalPicker({required DateTime startTime, super.locale}) {
    currentTime = startTime;
    setLeftIndex(currentTime.minute);
    setMiddleIndex(currentTime.second);
    setRightIndex(currentTime.millisecond);
  }

  /// Minutes
  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  /// Seconds
  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  /// Milliseconds
  @override
  String? rightStringAtIndex(int index) {
    // Configuring the available options is weird
    // Step sizes don't seem to be supported
    if (index >= 10 && index < 1000) {
      return digits(index, 3);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() => ":";

  @override
  String rightDivider() => ":";

  @override
  List<int> layoutProportions() => [1, 1, 2];

  @override
  DateTime finalTime() => currentTime.isUtc
      ? DateTime.utc(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          0, // hours
          currentLeftIndex(), // minutes
          currentMiddleIndex(), // seconds
          currentRightIndex(), // milliseconds
          0, // microseconds
        )
      : DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          0, // hours
          currentLeftIndex(), // minutes
          currentMiddleIndex(), // seconds
          currentRightIndex(), // milliseconds
          0, // microseconds
        );
}
