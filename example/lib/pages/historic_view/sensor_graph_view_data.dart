import 'dart:math';

/// Represents a data point for a sensor view. Each SensorViewData object
/// contains the timestamp, x-coordinate value, and optional y- and
/// z-coordinate values. This data is used in the GraphView widget to plot the
/// sensor readings on the chart.
class SensorGraphViewData {
  final double timestamp;
  final double x;
  final double? y;
  final double? z;

  const SensorGraphViewData({
    required this.timestamp,
    required this.x,
    this.y,
    this.z,
  });

  @override
  String toString() => '$x\n$y\n$z';
}

/// The getMaxY function calculates the maximum y-coordinate value from a list
///  of SensorViewData objects. It considers both the y and z values,
/// if available, and returns the maximum value. If the maximum value is
/// negative, it is adjusted to 0.
double getMaxY(List<SensorGraphViewData> value) {
  var maxY = value
      .expand(
        (element) => [
          element.x,
          element.y ?? double.negativeInfinity,
          element.z ?? double.negativeInfinity
        ],
      )
      .reduce(max);
  return maxY < 0 ? 0 : maxY;
}

/// The getMinY function calculates the minimum y-coordinate value from a
/// list of SensorViewData objects. It considers both the y and z values,
/// if available, and returns the minimum value. If the minimum value is
///  positive, it is adjusted to 0.
double getMinY(List<SensorGraphViewData> value) {
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

/// The getMaxX function calculates the maximum x-coordinate value from a
/// list of SensorViewData objects by extracting the timestamp values and
/// finding the maximum.
double getMaxX(List<SensorGraphViewData> value) =>
    value.map((element) => element.timestamp).reduce(max);

/// The getMinX function calculates the minimum x-coordinate value from a list
/// of SensorViewData objects by extracting the timestamp values and finding
/// the minimum.
double getMinX(List<SensorGraphViewData> value) =>
    value.map((element) => element.timestamp).reduce(min);

/// The convertToDate function converts a double value representing a
/// timestamp to a DateTime object.
DateTime convertToDate(double value) =>
    DateTime.fromMillisecondsSinceEpoch(value.toInt());
