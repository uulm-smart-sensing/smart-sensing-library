import 'dart:math';

/// Class that stores Data for historic view page
class SensorViewData {
  final double timestamp;
  final double x;
  final double? y;
  final double? z;

  const SensorViewData({
    required this.timestamp,
    required this.x,
    this.y,
    this.z,
  });

  @override
  String toString() => '$x\n$y\n$z';
}

/// Determines the maximum of a unit in a list and returns the maximum.
double getMaxY(List<SensorViewData> value) => value
    .expand(
      (element) => [
        element.x,
        element.y ?? double.negativeInfinity,
        element.z ?? double.negativeInfinity
      ],
    )
    .reduce(max);

double getMinY(List<SensorViewData> value) {
  var minY = value
      .expand(
        (element) => [
          element.x,
          element.y ?? double.infinity,
          element.z ?? double.infinity
        ],
      )
      .reduce(min);
  return minY > 0 ? 0 : minY;
}

/// Determines the maximum of timestamp in a list and returns the maximum.
double getMaxX(List<SensorViewData> value) =>
    value.map((element) => element.timestamp).reduce(max);

/// Determines the minimum of timestamp in a list and returns the maximum.
double getMinX(List<SensorViewData> value) =>
    value.map((element) => element.timestamp).reduce(min);

DateTime convertToDate(double value) =>
    DateTime.fromMillisecondsSinceEpoch(value.toInt());
