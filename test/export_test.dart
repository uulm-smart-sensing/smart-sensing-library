import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library/src/import_export_module/export_tool.dart';
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

  // create dummy sensorData
  var exampleData = [
    SensorData(
      data: [1.4, 0, 9.81],
      maxPrecision: 5,
      unit: Unit.metersPerSecondSquared,
      timestampInMicroseconds: 1681561948,
    ),
    SensorData(
      data: [0.2, 0, 1],
      maxPrecision: 5,
      unit: Unit.gravitationalForce,
      timestampInMicroseconds: 1681562008,
    ),
  ];

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
  group("Test of the export feature of the smart sensing library.", () {
    test("Export only work with valid directory.", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        "./dummy_dir",
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful, isFalse);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        ".",
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
          "./accelerometer_${DateFormat('yyyy-MM-dd_hh-mm').format(DateTime.fromMicrosecondsSinceEpoch(0))}_${DateFormat('yyyy-MM-dd_hh-mm').format(DateTime.now())}.json",
        ).exists(),
        isTrue,
      );
    });
  });

  group("Test the SensorDataCollection object.", () {
    test("SensorDataCollection object converted to json.", () async {
      var sensorDataCollection =
          SensorDataCollection(SensorId.linearAcceleration, exampleData);

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
        equals("gravitationalForce"),
      );
    });
  });

  group("Test export in different file formats.", () {
    test(
      "Data will be correctly formatted depending on selected format.",
      () async {
        expect(
          formatDataIntoJson(SensorId.accelerometer, exampleData),
          formatData(
            SensorId.accelerometer,
            exampleData,
            SupportedFileFormat.json,
          ),
        );
        expect(
          formatDataIntoCSV(SensorId.accelerometer, exampleData),
          formatData(
            SensorId.accelerometer,
            exampleData,
            SupportedFileFormat.csv,
          ),
        );
        expect(
          formatDataIntoXLSX(SensorId.accelerometer, exampleData),
          formatData(
            SensorId.accelerometer,
            exampleData,
            SupportedFileFormat.xlsx,
          ),
        );
        expect(
          formatDataIntoXML(SensorId.accelerometer, exampleData),
          formatData(
            SensorId.accelerometer,
            exampleData,
            SupportedFileFormat.xml,
          ),
        );
      },
    );
    test(
      "JSON formatting complies with requirements.",
      () async {
        var formattedData = Uint8List.fromList(
          formatDataIntoJson(SensorId.linearAcceleration, exampleData),
        );

        var expectedData = File(
          "lib/src/import_export_module/example_import_files/exampleSensorData.json",
        ).readAsBytesSync();

        expect(formattedData, expectedData);
      },
    );

    test(
      "CSV formatting complies with requirements.",
      () async {
        // filter out all bytes with value 13 (in ASCII CR, because git seems
        // to convert CRLF to LF)
        var formattedData = Uint8List.fromList(
          formatDataIntoCSV(SensorId.linearAcceleration, exampleData),
        ).where((element) => element != 13);

        var expectedData = File(
          "lib/src/import_export_module/example_import_files/exampleSensorData.csv",
        ).readAsBytesSync().where((element) => element != 13);

        expect(formattedData, expectedData);
      },
    );

    test(
      "XLSX formatting complies with requirements.",
      () async {
        await writeFormattedData(
          "exampleSensorData",
          SupportedFileFormat.xlsx,
          formatDataIntoXLSX(SensorId.linearAcceleration, exampleData),
        );

        var expectedData = Excel.decodeBytes(
          File(
            "lib/src/import_export_module/example_import_files/exampleSensorData.xlsx",
          ).readAsBytesSync(),
        );

        expect(
          expectedData.tables["sensor_data"]!
              .row(0)
              .map((e) => e!.value)
              .toList()
              .toString(),
          "[sensorId, unit, maxPrecision, timestampInMicroseconds, data]",
        );
        expect(
          expectedData.tables["sensor_data"]!
              .row(1)
              .map((e) => e!.value)
              .toList()
              .toString(),
          "[linearAcceleration, metersPerSecondSquared, 5, "
          "1681561948, 1.4, 0.0, 9.81]",
        );
        expect(
          expectedData.tables["sensor_data"]!
              .row(2)
              .map((e) => e!.value)
              .toList()
              .toString(),
          "[linearAcceleration, gravitationalForce, 5, "
          "1681562008, 0.2, 0.0, 1.0]",
        );
      },
    );

    test(
      "XML formatting complies with requirements.",
      () async {
        var formattedData = Uint8List.fromList(
          formatDataIntoXML(SensorId.linearAcceleration, exampleData),
        );

        var expectedData = File(
          "lib/src/import_export_module/example_import_files/exampleSensorData.xml",
        ).readAsBytesSync();

        expect(formattedData, expectedData);
      },
    );
  });
}
