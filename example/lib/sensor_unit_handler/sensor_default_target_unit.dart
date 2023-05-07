import 'package:smart_sensing_library/smart_sensing_library.dart';

/// A [Unit] assigned for each [SensorId].
const sensorIdToDefaultTargetUnit = {
  SensorId.accelerometer: Unit.metersPerSecondSquared,
  SensorId.gyroscope: Unit.degreesPerSecond,
  SensorId.magnetometer: Unit.microTeslas,
  SensorId.orientation: Unit.degrees,
  SensorId.linearAcceleration: Unit.metersPerSecondSquared,
  SensorId.barometer: Unit.hectoPascal,
  SensorId.thermometer: Unit.celsius,
};
