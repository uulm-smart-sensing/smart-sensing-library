import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

/// Unique [Icon] for each [SensorId].
const sensorIdToIcon = {
  SensorId.accelerometer: FontAwesomeIcons.arrowsToDot,
  SensorId.gyroscope: FontAwesomeIcons.groupArrowsRotate,
  SensorId.magnetometer: FontAwesomeIcons.magnet,
  SensorId.orientation: FontAwesomeIcons.compass,
  SensorId.linearAcceleration: FontAwesomeIcons.gaugeHigh,
  SensorId.barometer: FontAwesomeIcons.fireExtinguisher,
  SensorId.thermometer: FontAwesomeIcons.temperatureHalf,
};

const primaryColor = Color.fromARGB(255, 0, 7, 47);
final primaryMaterialColor = MaterialColor(
  primaryColor.value,
  {
    50: primaryColor.withOpacity(.1),
    100: primaryColor.withOpacity(.2),
    200: primaryColor.withOpacity(.3),
    300: primaryColor.withOpacity(.4),
    400: primaryColor.withOpacity(.5),
    500: primaryColor.withOpacity(.6),
    600: primaryColor.withOpacity(.7),
    700: primaryColor.withOpacity(.8),
    800: primaryColor.withOpacity(.9),
    900: primaryColor.withOpacity(1),
  },
);

const secondaryColor = Color.fromARGB(255, 34, 0, 77);
const activeTrackColor = Color.fromARGB(255, 66, 234, 7);
const inactiveTrackColor = Color.fromARGB(255, 144, 149, 142);

/// Theme used for the app-
final theme = ThemeData(
  primarySwatch: primaryMaterialColor,
  scaffoldBackgroundColor: primaryColor,
  dividerColor: Colors.white,
  cardColor: primaryColor,
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
    // Style used for small text in Import/Export page
    bodySmall: TextStyle(
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
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
  sliderTheme: const SliderThemeData(
    thumbColor: Colors.white,
    activeTrackColor: Colors.white,
    inactiveTrackColor: Color.fromARGB(255, 142, 142, 152),
  ),
);
