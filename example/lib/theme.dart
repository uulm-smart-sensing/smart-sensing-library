import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

/// Unique [Color] for each [SensorId].
const sensorIdToColor = {
  SensorId.accelerometer: Color.fromARGB(255, 162, 255, 105),
  SensorId.gyroscope: Color.fromARGB(255, 107, 252, 182),
  SensorId.magnetometer: Color.fromARGB(255, 91, 168, 255),
  SensorId.orientation: Color.fromARGB(255, 74, 244, 255),
  SensorId.linearAcceleration: Color.fromARGB(255, 252, 220, 107),
  SensorId.barometer: Color.fromARGB(255, 252, 107, 168),
  SensorId.thermometer: Color.fromARGB(255, 252, 168, 107),
};

const primaryColorHex = 0xFF00072F;
const primaryColor = MaterialColor(
  primaryColorHex,
  {
    50: Color.fromRGBO(0, 7, 47, .1),
    100: Color.fromRGBO(0, 7, 47, .2),
    200: Color.fromRGBO(0, 7, 47, .3),
    300: Color.fromRGBO(0, 7, 47, .4),
    400: Color.fromRGBO(0, 7, 47, .5),
    500: Color.fromRGBO(0, 7, 47, .6),
    600: Color.fromRGBO(0, 7, 47, .7),
    700: Color.fromRGBO(0, 7, 47, .8),
    800: Color.fromRGBO(0, 7, 47, .9),
    900: Color.fromRGBO(0, 7, 47, 1),
  },
);

/// Theme used for the app-
var theme = ThemeData(
  primarySwatch: primaryColor,
  scaffoldBackgroundColor: const Color(primaryColorHex),
  dividerColor: Colors.white,
  cardColor: const Color.fromARGB(255, 34, 0, 77),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  textTheme: const TextTheme(
    // Style used for Text widget
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
    // Style used for DropdownButton text
    titleMedium: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.zero,
      textStyle: const TextStyle(
        fontSize: 18,
      ),
    ),
  ),
);
