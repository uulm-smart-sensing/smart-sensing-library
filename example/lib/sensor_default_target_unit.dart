import 'package:smart_sensing_library/smart_sensing_library.dart';

/// A default [Unit] assigned for each [SensorId].
const sensorIdToDefaultTargetUnit = <SensorId, Unit>{
  SensorId.accelerometer: Acceleration.meterPerSecondSquared,
  SensorId.gyroscope: AngularVelocity.degreesPerSecond,
  SensorId.magnetometer: MagneticFluxDensity.microTesla,
  SensorId.orientation: Angle.degrees,
  SensorId.linearAcceleration: Acceleration.meterPerSecondSquared,
  SensorId.barometer: Pressure.hectoPascal,
  SensorId.thermometer: Temperature.celsius,
};

/// A list of all valid [Unit]s for a given [SensorId].
const sensorIdToUnitCategory = <SensorId, List<Unit>>{
  SensorId.accelerometer: Acceleration.values,
  SensorId.gyroscope: AngularVelocity.values,
  SensorId.magnetometer: MagneticFluxDensity.values,
  SensorId.orientation: Angle.values,
  SensorId.linearAcceleration: Acceleration.values,
  SensorId.barometer: Pressure.values,
  SensorId.thermometer: Temperature.values
};
