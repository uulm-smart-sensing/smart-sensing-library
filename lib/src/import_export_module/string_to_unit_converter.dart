import '../../smart_sensing_library.dart';

MapEntry<String, Unit> _unitToMapEntry(Unit unit) =>
    MapEntry(unit.toString(), unit);

/// Maps the string representation to a [Unit].
final stringToUnit = Map.fromEntries([
  ...Acceleration.values.map(_unitToMapEntry),
  ...Angle.values.map(_unitToMapEntry),
  ...AngularVelocity.values.map(_unitToMapEntry),
  ...MagneticFluxDensity.values.map(_unitToMapEntry),
  ...Pressure.values.map(_unitToMapEntry),
  ...Temperature.values.map(_unitToMapEntry),
]);

/// Converts the string representation of a [Unit] into a [Unit] object.
///
/// Throws an exception, if the [input] string is not a valid representation of
/// any implemented [Unit].
Unit unitFromString(String input) {
  if (!stringToUnit.containsKey(input)) {
    throw Exception("Could not parse unit type");
  }

  return stringToUnit[input]!;
}
