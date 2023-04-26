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

/// Test data needed for testing
final List<SensorViewData> testData = [
  SensorViewData(
    timestamp: DateTime(2023, 4, 17, 17, 30).millisecondsSinceEpoch.toDouble(),
    x: 3,
    y: 2,
    z: 6,
  ),
  SensorViewData(
    timestamp: DateTime(2023, 4, 17, 17, 31).millisecondsSinceEpoch.toDouble(),
    x: 2,
    y: 1,
    z: 3,
  ),
  SensorViewData(
    timestamp: DateTime(2023, 4, 17, 17, 32).millisecondsSinceEpoch.toDouble(),
    x: 5,
    y: 4,
    z: 6,
  ),
  SensorViewData(
    timestamp: DateTime(2023, 4, 17, 17, 33).millisecondsSinceEpoch.toDouble(),
    x: 2.5,
    y: 1.5,
    z: 3.5,
  ),
  SensorViewData(
    timestamp: DateTime(2023, 4, 17, 17, 34).millisecondsSinceEpoch.toDouble(),
    x: 4,
    y: 2.5,
    z: 4.5,
  ),
];

/// Determines the maximum of a unit in a list and returns the maximum.
double getMaxUnit(List<SensorViewData> value) {
  var maxUnit = value.map((data) => [data.x, data.y ?? 0, data.z ?? 0]).reduce(
        (a, b) => a.reduce((a1, b1) => a1 > b1 ? a1 : b1) >
                b.reduce((a1, b1) => a1 > b1 ? a1 : b1)
            ? a
            : b,
      );
  return maxUnit.reduce((a, b) => a > b ? a : b);
}

/// Determines the maximum of timestamp in a list and returns the maximum.
double getMaxTimeStamp(List<SensorViewData> value) {
  var maxUnit =
      value.map((data) => data.timestamp).reduce((a, b) => a > b ? a : b);
  return maxUnit;
}

/// Determines the minimum of timestamp in a list and returns the maximum.
double getMinTimeStamp(List<SensorViewData> value) {
  var maxUnit =
      value.map((data) => data.timestamp).reduce((a, b) => a < b ? a : b);
  return maxUnit;
}

DateTime convertToDate(double value) =>
    DateTime.fromMillisecondsSinceEpoch(value.toInt());
