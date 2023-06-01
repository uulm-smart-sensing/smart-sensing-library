import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

/// Time picker to pick the time interval of a sensor.
///
/// The user can picks a time interval between 0 ms and 59 minutes, 59 seconds
/// and 999 milliseconds (=3599999 ms) (both inclusive).
class TimeIntervalPicker extends CommonPickerModel {
  final int minimumMillisecondsSelection;

  String digits(int value, int length) => '$value'.padLeft(length, "0");

  TimeIntervalPicker({
    required DateTime startTime,
    int minimumTimeIntervalInMilliseconds = 0,
    super.locale,
  }) : minimumMillisecondsSelection = minimumTimeIntervalInMilliseconds < 1000
            ? minimumTimeIntervalInMilliseconds
            : 0 {
    currentTime = startTime;
    setLeftIndex(currentTime.minute);
    setMiddleIndex(currentTime.second);
    setRightIndex(currentTime.millisecond);
  }

  /// Minutes
  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return "${digits(index, 2)} min";
    } else {
      return null;
    }
  }

  /// Seconds
  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return "${digits(index, 2)} s";
    } else {
      return null;
    }
  }

  /// Milliseconds
  @override
  String? rightStringAtIndex(int index) {
    // Configuring the available options is weird
    // Step sizes don't seem to be supported
    if (index >= minimumMillisecondsSelection && index < 1000) {
      return "${digits(index, 3)} ms";
    } else {
      return null;
    }
  }

  @override
  String leftDivider() => ":";

  @override
  String rightDivider() => ":";

  @override
  List<int> layoutProportions() => [2, 2, 3];

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
