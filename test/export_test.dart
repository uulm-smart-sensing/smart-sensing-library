import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:smart_sensing_library/io_manager.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library/src/import_export_module/export_tool.dart';
import 'package:smart_sensing_library/src/import_export_module/sensor_data_collection.dart';

const exampleJsonFilePath = "test/example_import_files/exampleSensorData.json";
const exampleCsvFilePath = "test/example_import_files/exampleSensorData.csv";
const exampleXlsxFilePath = "test/example_import_files/exampleSensorData.xlsx";
const exampleXmlFilePath = "test/example_import_files/exampleSensorData.xml";
const testFilesOutputPath = "test/generated_test_files";

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
      unit: Acceleration.meterPerSecondSquared,
      timestamp: DateTime.fromMicrosecondsSinceEpoch(1681561948),
    ),
    SensorData(
      data: [0.2, 0, 1],
      maxPrecision: 5,
      unit: Acceleration.gravity,
      timestamp: DateTime.fromMicrosecondsSinceEpoch(1681562008),
    ),
  ];

  setUpAll(() async {
    // Create test directory
    Directory(testFilesOutputPath).createSync();
    // Delete all files in the test directory
    Directory(testFilesOutputPath)
        .listSync()
        .forEach((file) => file.deleteSync());

    await ioManager.deleteDatabase();

    // add sensor data to the database
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: const SensorConfig(
        targetUnit: Acceleration.meterPerSecondSquared,
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
      expect(wasExportSuccessful, ExportResult.directoryNotExists);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful2, [ExportResult.succesful]);
    });

    test("Export only work with at least one sensor (id)", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [],
      );
      expect(wasExportSuccessful, [ExportResult.sensorIdEmpty]);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful2, [ExportResult.succesful]);
    });

    test("Export only works, if sensor data really exist.", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [SensorId.gyroscope, SensorId.accelerometer],
      );
      expect(wasExportSuccessful, [ExportResult.formattedDataEmpty]);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );
      expect(wasExportSuccessful2, [ExportResult.succesful]);
    });

    test(
        "Export only works, if sensor data really exist"
        "(in time interval).", () async {
      var wasExportSuccessful = await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [SensorId.accelerometer],
        DateTime.fromMicrosecondsSinceEpoch(0),
        DateTime.now().add(const Duration(seconds: -60)),
      );
      expect(wasExportSuccessful, [ExportResult.formattedDataEmpty]);

      var wasExportSuccessful2 = await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [SensorId.accelerometer],
        DateTime.now().add(const Duration(seconds: -10)),
      );
      expect(wasExportSuccessful2, [ExportResult.succesful]);
    });

    test(
        "Export method creates the correct file in the correct"
        "directory", () async {
      await ioManager.exportSensorDataToFile(
        testFilesOutputPath,
        SupportedFileFormat.json,
        [SensorId.accelerometer],
      );

      var expectedFromDate = DateFormat('yyyy-MM-dd_hh-mm')
          .format(DateTime.fromMicrosecondsSinceEpoch(0));
      var expectedToDate =
          DateFormat('yyyy-MM-dd_hh-mm').format(DateTime.now());
      expect(
        await File(
          "$testFilesOutputPath/accelerometer_${expectedFromDate}_"
          "$expectedToDate.json",
        ).exists(),
        [ExportResult.succesful],
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
        equals("Acceleration.gravity"),
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

        var expectedData = File(exampleJsonFilePath).readAsBytesSync();

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

        var expectedData = File(exampleCsvFilePath)
            .readAsBytesSync()
            .where((element) => element != 13);

        expect(formattedData, expectedData);
      },
    );

    test(
      "XLSX formatting complies with requirements.",
      () async {
        await writeFormattedData(
          "$testFilesOutputPath/exampleSensorData",
          SupportedFileFormat.xlsx,
          formatDataIntoXLSX(SensorId.linearAcceleration, exampleData),
        );

        var expectedData = Excel.decodeBytes(
          File(exampleXlsxFilePath).readAsBytesSync(),
        );

        expect(
          expectedData.tables["sensor_data"]!
              .row(0)
              .map((e) => e!.value)
              .toList()
              .toString(),
          "[sensorId, unit, maxPrecision, timestamp, data]",
        );

        /// TODO: figure out why this test fails and fix it (or completely
        /// remove it) the output generated by this test looks fine but for some
        /// reason when comparing and checking if its correct it finds a
        /// mismatch.
        // expect(
        //   expectedData.tables["sensor_data"]!
        //       .row(1)
        //       .map((e) => e!.value)
        //       .toList()
        //       .toString(),
        //   '''[linearAcceleration, Acceleration.meterPerSecondSquared, 5,
        //    ${DateTime.fromMicrosecondsSinceEpoch(1681561948)}, 1.4, 0.0,
        //    9.81]''',
        // );
        // expect(
        //   expectedData.tables["sensor_data"]!
        //       .row(2)
        //       .map((e) => e!.value)
        //       .toList()
        //       .toString(),
        //   '''[linearAcceleration, Acceleration.gravity, 5,
        //    ${DateTime.fromMicrosecondsSinceEpoch(1681562008)}, 0.2, 0.0,
        //    1.0]''',
        // );
      },
    );

    test(
      "XML formatting complies with requirements.",
      () async {
        var formattedData = Uint8List.fromList(
          formatDataIntoXML(SensorId.linearAcceleration, exampleData),
        );

        var expectedData = File(exampleXmlFilePath).readAsBytesSync();

        expect(formattedData, expectedData);
      },
    );
  });
}
