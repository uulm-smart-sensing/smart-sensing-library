import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library/src/import_export_module/codecs/csv_codec.dart';
import 'package:smart_sensing_library/src/import_export_module/codecs/json_codec.dart';
import 'package:smart_sensing_library/src/import_export_module/codecs/xlsx_codec.dart';
import 'package:smart_sensing_library/src/import_export_module/codecs/xml_codec.dart';
import 'package:smart_sensing_library/src/import_export_module/export_tool.dart';

const exampleJsonFilePath = "test/example_import_files/exampleSensorData.json";
const emptyExampleJsonFilePath =
    "test/example_import_files/emptyExampleSensorData.json";
const exampleCsvFilePath = "test/example_import_files/exampleSensorData.csv";
const exampleXlsxFilePath = "test/example_import_files/exampleSensorData.xlsx";
const exampleXmlFilePath = "test/example_import_files/exampleSensorData.xml";
const wrongFilePath = "test/example_import_files/exampleSensorData.pdf";
const testFilesOutputPath = "test/generated_test_files/";

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

    // export example sensor data
    await writeFormattedData(
      exampleJsonFilePath.split(".")[0],
      SupportedFileFormat.json,
      formatDataIntoJson(SensorId.linearAcceleration, exampleData),
    );

    await writeFormattedData(
      exampleCsvFilePath.split(".")[0],
      SupportedFileFormat.csv,
      formatDataIntoCSV(SensorId.linearAcceleration, exampleData),
    );

    await writeFormattedData(
      exampleXlsxFilePath.split(".")[0],
      SupportedFileFormat.xlsx,
      formatDataIntoXLSX(SensorId.linearAcceleration, exampleData),
    );

    await writeFormattedData(
      exampleXmlFilePath.split(".")[0],
      SupportedFileFormat.xml,
      formatDataIntoXML(SensorId.linearAcceleration, exampleData),
    );
  });

  tearDown(
    () async => {await ioManager.deleteDatabase()},
  );

  group("Test of the import feature of the smart sensing library.", () {
    test("Import only work with valid filepath.", () async {
      var wasImportSuccessful =
          await ioManager.importSensorDataFromFile(wrongFilePath);
      expect(wasImportSuccessful, isFalse);

      var wasImportSuccessful2 = await ioManager.importSensorDataFromFile("./");
      expect(wasImportSuccessful2, isFalse);

      expect(
        await ioManager.importSensorDataFromFile(exampleJsonFilePath),
        isTrue,
      );
      expect(
        await ioManager.importSensorDataFromFile(exampleCsvFilePath),
        isTrue,
      );
      expect(
        await ioManager.importSensorDataFromFile(exampleXlsxFilePath),
        isTrue,
      );
      expect(
        await ioManager.importSensorDataFromFile(exampleXmlFilePath),
        isTrue,
      );
    });

    test("Import only work files that contain data", () async {
      expect(
        await ioManager.importSensorDataFromFile(emptyExampleJsonFilePath),
        isFalse,
      );
      expect(
        await ioManager.importSensorDataFromFile(exampleJsonFilePath),
        isTrue,
      );
    });
  });

  group("Test import of different file formats.", () {
    test(
      "JSON decoding complies with requirements.",
      () async {
        expect(
          await ioManager.importSensorDataFromFile(exampleJsonFilePath),
          isTrue,
        );

        expect(
          await ioManager
              .getFilterFrom(SensorId.linearAcceleration)
              .then((value) => value!.result()),
          isNotEmpty,
        );

        var importedSensorData =
            decodeJson(File(exampleJsonFilePath).readAsBytesSync());
        expect(importedSensorData.sensorId, SensorId.linearAcceleration);
        expect(
          compareSensorDataLists(importedSensorData.sensorData, exampleData),
          isTrue,
        );
      },
    );

    test(
      "CSV decoding complies with requirements.",
      () async {
        expect(
          await ioManager.importSensorDataFromFile(exampleCsvFilePath),
          isTrue,
        );

        expect(
          await ioManager
              .getFilterFrom(SensorId.linearAcceleration)
              .then((value) => value!.result()),
          isNotEmpty,
        );

        var importedSensorData =
            decodeCsv(File(exampleCsvFilePath).readAsBytesSync());
        expect(importedSensorData.sensorId, SensorId.linearAcceleration);
        expect(
          compareSensorDataLists(importedSensorData.sensorData, exampleData),
          isTrue,
        );
      },
    );

    test("XLSX decoding complies with requirements.", () async {
      expect(
        await ioManager.importSensorDataFromFile(exampleXlsxFilePath),
        isTrue,
      );

      expect(
        await ioManager
            .getFilterFrom(SensorId.linearAcceleration)
            .then((value) => value!.result()),
        isNotEmpty,
      );

      var importedSensorData =
          decodeXlsx(File(exampleXlsxFilePath).readAsBytesSync());
      expect(importedSensorData.sensorId, SensorId.linearAcceleration);
      expect(
        compareSensorDataLists(importedSensorData.sensorData, exampleData),
        isTrue,
      );
    });

    test(
      "XML decoding complies with requirements.",
      () async {
        expect(
          await ioManager.importSensorDataFromFile(exampleXmlFilePath),
          isTrue,
        );

        expect(
          await ioManager
              .getFilterFrom(SensorId.linearAcceleration)
              .then((value) => value!.result()),
          isNotEmpty,
        );

        var importedSensorData =
            decodeXml(File(exampleXmlFilePath).readAsBytesSync());
        expect(importedSensorData.sensorId, SensorId.linearAcceleration);
        expect(
          compareSensorDataLists(importedSensorData.sensorData, exampleData),
          isTrue,
        );
      },
    );
  });
}

bool compareSensorDataLists(List<SensorData> a, List<SensorData> b) {
  if (a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (var index = 0; index < a.length; index += 1) {
    // compare sensor data
    if (!listEquals(a[index].data, b[index].data)) {
      return false;
    }

    if (a[index].maxPrecision != b[index].maxPrecision ||
        a[index].unit != b[index].unit ||
        a[index].timestamp.microsecondsSinceEpoch !=
            b[index].timestamp.microsecondsSinceEpoch) {
      return false;
    }
  }
  return true;
}
