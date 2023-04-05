import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

const sensorIdToColor = {
  SensorId.accelerometer: Color.fromARGB(255, 162, 255, 105),
  SensorId.gyroscope: Color.fromARGB(255, 107, 252, 182),
  SensorId.magnetometer: Color.fromARGB(255, 91, 168, 255),
  SensorId.orientation: Color.fromARGB(255, 74, 244, 255),
  SensorId.linearAcceleration: Color.fromARGB(255, 252, 220, 107),
  SensorId.barometer: Color.fromARGB(255, 252, 107, 168),
  SensorId.thermometer: Color.fromARGB(255, 252, 168, 107),
};

// TODO: add theme here as constant
