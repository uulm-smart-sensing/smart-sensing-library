import 'package:smart_sensing_library/smart_sensing_library.dart';

// TODO: Remove as new unit type system is implemented
List<Unit> getUnitsFromSensorId(SensorId sensorId) {
  switch (sensorId) {
    case SensorId.accelerometer:
    case SensorId.linearAcceleration:
      return [
        Unit.gravitationalForce,
        Unit.metersPerSecondSquared,
      ];
    case SensorId.gyroscope:
      return [
        Unit.degreesPerSecond,
        Unit.radiansPerSecond,
      ];
    case SensorId.magnetometer:
      return [
        Unit.microTeslas,
      ];
    case SensorId.orientation:
      return [
        Unit.degrees,
        Unit.radians,
      ];
    case SensorId.barometer:
      return [
        Unit.bar,
        Unit.hectoPascal,
        Unit.kiloPascal,
      ];
    case SensorId.thermometer:
      return [
        Unit.celsius,
        Unit.fahrenheit,
        Unit.kelvin,
      ];
  }
}
