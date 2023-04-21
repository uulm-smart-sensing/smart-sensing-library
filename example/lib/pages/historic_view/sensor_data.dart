class SData {
  final double timestamp;
  final double x;
  final double? y;
  final double? z;

  const SData({
    required this.timestamp,
    required this.x,
    this.y,
    this.z,
  });

  @override
  String toString() => '$x\n$y\n$z';
}

final List<SData> threeAxes = [
  SData(
    timestamp: DateTime(2023, 4, 17, 17, 30).millisecondsSinceEpoch.toDouble(),
    x: 3,
    y: 2,
    z: 6,
  ),
  SData(
    timestamp: DateTime(2023, 4, 17, 17, 31).millisecondsSinceEpoch.toDouble(),
    x: 2,
    y: 1,
    z: 3,
  ),
  SData(
    timestamp: DateTime(2023, 4, 17, 17, 32).millisecondsSinceEpoch.toDouble(),
    x: 5,
    y: 4,
    z: 6,
  ),
  SData(
    timestamp: DateTime(2023, 4, 17, 17, 33).millisecondsSinceEpoch.toDouble(),
    x: 2.5,
    y: 1.5,
    z: 3.5,
  ),
  SData(
    timestamp: DateTime(2023, 4, 17, 17, 34).millisecondsSinceEpoch.toDouble(),
    x: 4,
    y: 2.5,
    z: 4.5,
  ),
];

double getMaxUnit(List<SData> value) {
  var maxUnit = value.map((data) => [data.x, data.y ?? 0, data.z ?? 0]).reduce(
        (a, b) => a.reduce((a1, b1) => a1 > b1 ? a1 : b1) >
                b.reduce((a1, b1) => a1 > b1 ? a1 : b1)
            ? a
            : b,
      );
  return maxUnit.reduce((a, b) => a > b ? a : b);
}

double getMaxTimeStamp(List<SData> value) {
  var maxUnit =
      value.map((data) => data.timestamp).reduce((a, b) => a > b ? a : b);
  return maxUnit;
}

double getMinTimeStamp(List<SData> value) {
  var maxUnit =
      value.map((data) => data.timestamp).reduce((a, b) => a < b ? a : b);
  return maxUnit;
}

DateTime convertToDate(double value) =>
    DateTime.fromMillisecondsSinceEpoch(value.toInt());
