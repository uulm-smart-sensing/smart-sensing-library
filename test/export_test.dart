import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library/src/import_export_module/sensor_data_collection.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel(
    'plugins.flutter.io/path_provider',
  ).setMockMethodCallHandler((methodCall) async => ".");
  var ioManager = IOManager.testManager();

  if (!await ioManager.openDatabase()) {
    throw Exception("Database connection failed!");
  }

  setUp(() async {
    await ioManager.removeData(SensorId.accelerometer);
    await ioManager.removeSensor(SensorId.accelerometer);

    // add sensor data to the database
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: const SensorConfig(
        targetUnit: Unit.metersPerSecondSquared,
        targetPrecision: 2,
        timeInterval: Duration(milliseconds: 1000),
      ),
    );
    await Future.delayed(const Duration(seconds: 15));
  });
  group("Test of the export feature of the smart sensing libary.", () {
    test("Export only work with valid directory.", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        "./dummy_dir",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful, isFalse);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful2, isTrue);
    });

    test("Export only work with at least one sensor (id)", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [],
      );
      expect(wasExportSuccessful, isFalse);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful2, isTrue);
    });

    test("Export only works, if sensor data really exist.", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [SensorId.gyroscope, SensorId.accelerometer],
      );
      expect(wasExportSuccessful, isFalse);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful2, isTrue);
    });

    test(
        "Export only works, if sensor data really exist"
        "(in time interval).", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
        DateTime.fromMicrosecondsSinceEpoch(0),
        DateTime.now().add(const Duration(seconds: -20)),
      );
      expect(wasExportSuccessful, isFalse);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
        DateTime.now().add(const Duration(seconds: -10)),
      );
      expect(wasExportSuccessful2, isTrue);
    });

    test(
        "Export method creates the correct file in the correct"
        "directory", () async {
      await ioManager.exportSensorDataToFile(
        "./",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );

      expect(
        await File(
          "./accelerometer_${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.fromMicrosecondsSinceEpoch(0))}_${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}.json",
        ).exists(),
        isTrue,
      );
    });
  });

  group("Test the SensorDataCollection object.", () {
    test("SensorDataCollection object converted to json.", () async {
      // create dummy sensorData
      var sensorData = [
        SensorData(
          data: [0.4],
          maxPrecision: 2,
          unit: Unit.bar,
          timestampInMicroseconds: 1,
        ),
        SensorData(
          data: [0.4, 0.9],
          maxPrecision: 3,
          unit: Unit.unitless,
          timestampInMicroseconds: 2,
        ),
      ];

      var sensorDataCollection =
          SensorDataCollection(SensorId.linearAcceleration, sensorData);

      expect(sensorDataCollection.toJson(), isNotEmpty);
      expect(
        sensorDataCollection.toJson()["sensorId"],
        equals("linearAcceleration"),
      );
      expect(
        sensorDataCollection.toJson()["sensorData"].length,
        2,
      );
      expect(
        sensorDataCollection.toJson()["sensorData"][1]["unit"],
        equals("unitless"),
      );
    });
  });
}
