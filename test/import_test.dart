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
import 'package:smart_sensing_library/src/import_export_module/import_result.dart';

const exampleJsonFilePath = "test/example_import_files/exampleSensorData.json";
const emptyExampleCSVFilePath =
    "test/example_import_files/emptyExampleSensorData.csv";
const exampleFilePathWrongFormatted =
    "test/example_import_files/wrong_formatted_files/";
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
    await ioManager.openDatabase();

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
      expect(wasImportSuccessful, ImportResultStatus.fileDoNotExist);

      var wasImportSuccessful2 = await ioManager.importSensorDataFromFile("./");
      expect(wasImportSuccessful2, ImportResultStatus.fileDoNotExist);

      expect(
        await ioManager.importSensorDataFromFile(exampleJsonFilePath),
        ImportResultStatus.success,
      );
      expect(
        await ioManager.importSensorDataFromFile(exampleCsvFilePath),
        ImportResultStatus.success,
      );
      expect(
        await ioManager.importSensorDataFromFile(exampleXlsxFilePath),
        ImportResultStatus.success,
      );
      expect(
        await ioManager.importSensorDataFromFile(exampleXmlFilePath),
        ImportResultStatus.success,
      );
    });

    test("Import only work files that contain data", () async {
      /// TODO: fix this
      /*expect(
        await ioManager.importSensorDataFromFile(emptyExampleCSVFilePath),
        ImportResultStatus.noSensorDataExisting,
      );*/
      expect(
        await ioManager.importSensorDataFromFile(exampleJsonFilePath),
        ImportResultStatus.success,
      );
    });
  });

  group("Test import of different file formats.", () {
    test(
      "JSON decoding complies with requirements.",
      () async {
        expect(
          await ioManager.importSensorDataFromFile(exampleJsonFilePath),
          ImportResultStatus.success,
        );

        expect(
          await ioManager
              .getFilterFrom(SensorId.linearAcceleration)
              .then((value) => value!.result()),
          isNotEmpty,
        );

        var importedSensorData =
            await decodeJson(File(exampleJsonFilePath).readAsBytesSync());
        expect(
          importedSensorData.importedData!.sensorId,
          SensorId.linearAcceleration,
        );
        expect(
          compareSensorDataLists(
            importedSensorData.importedData!.sensorData,
            exampleData,
          ),
          isTrue,
        );
      },
    );

    test(
      "Json validation schema finds errors",
      () async => {
        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}missingSensorId.json",
          ),
          ImportResultStatus.invalidJsonFormatting,
        ),
        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongData.json",
          ),
          ImportResultStatus.invalidJsonFormatting,
        ),
        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongPrecision.json",
          ),
          ImportResultStatus.invalidJsonFormatting,
        ),
        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongTimestamp.json",
          ),
          ImportResultStatus.invalidJsonFormatting,
        ),
        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongUnit.json",
          ),
          ImportResultStatus.invalidJsonFormatting,
        )
      },
    );

    test(
      "CSV decoding complies with requirements.",
      () async {
        expect(
          await ioManager.importSensorDataFromFile(exampleCsvFilePath),
          ImportResultStatus.success,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongFirstLine.csv",
          ),
          ImportResultStatus.invalidCSVFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}noData.csv",
          ),
          ImportResultStatus.invalidCSVFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongUnit.csv",
          ),
          ImportResultStatus.invalidCSVFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongPrecision.csv",
          ),
          ImportResultStatus.invalidCSVFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongTimestamp.csv",
          ),
          ImportResultStatus.invalidCSVFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongData.csv",
          ),
          ImportResultStatus.invalidCSVFormatting,
        );

        expect(
          await ioManager
              .getFilterFrom(SensorId.linearAcceleration)
              .then((value) => value!.result()),
          isNotEmpty,
        );

        var importedSensorData =
            decodeCsv(File(exampleCsvFilePath).readAsBytesSync());
        expect(
          importedSensorData.importedData!.sensorId,
          SensorId.linearAcceleration,
        );
        expect(
          compareSensorDataLists(
            importedSensorData.importedData!.sensorData,
            exampleData,
          ),
          isTrue,
        );
      },
    );

    test("XLSX decoding complies with requirements.", () async {
      expect(
        await ioManager.importSensorDataFromFile(exampleXlsxFilePath),
        ImportResultStatus.success,
      );

      expect(
        await ioManager.importSensorDataFromFile(
          "${exampleFilePathWrongFormatted}noData.xlsx",
        ),
        ImportResultStatus.invalidXLSXFormatting,
      );

      expect(
        await ioManager.importSensorDataFromFile(
          "${exampleFilePathWrongFormatted}wrongUnit.xlsx",
        ),
        ImportResultStatus.invalidXLSXFormatting,
      );

      expect(
        await ioManager.importSensorDataFromFile(
          "${exampleFilePathWrongFormatted}wrongPrecision.xlsx",
        ),
        ImportResultStatus.invalidXLSXFormatting,
      );

      expect(
        await ioManager.importSensorDataFromFile(
          "${exampleFilePathWrongFormatted}wrongTimestamp.xlsx",
        ),
        ImportResultStatus.invalidXLSXFormatting,
      );

      expect(
        await ioManager.importSensorDataFromFile(
          "${exampleFilePathWrongFormatted}wrongData.xlsx",
        ),
        ImportResultStatus.invalidXLSXFormatting,
      );

      expect(
        await ioManager
            .getFilterFrom(SensorId.linearAcceleration)
            .then((value) => value!.result()),
        isNotEmpty,
      );

      var importedSensorData =
          decodeXlsx(File(exampleXlsxFilePath).readAsBytesSync());
      expect(
        importedSensorData.importedData!.sensorId,
        SensorId.linearAcceleration,
      );
      expect(
        compareSensorDataLists(
          importedSensorData.importedData!.sensorData,
          exampleData,
        ),
        isTrue,
      );
    });

    test(
      "XML decoding complies with requirements.",
      () async {
        expect(
          await ioManager.importSensorDataFromFile(exampleXmlFilePath),
          ImportResultStatus.success,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}missingSensorId.xml",
          ),
          ImportResultStatus.invalidXMLFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongData.xml",
          ),
          ImportResultStatus.invalidXMLFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongPrecision.xml",
          ),
          ImportResultStatus.invalidXMLFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongTimestamp.xml",
          ),
          ImportResultStatus.invalidXMLFormatting,
        );

        expect(
          await ioManager.importSensorDataFromFile(
            "${exampleFilePathWrongFormatted}wrongUnit.xml",
          ),
          ImportResultStatus.invalidXMLFormatting,
        );

        expect(
          await ioManager
              .getFilterFrom(SensorId.linearAcceleration)
              .then((value) => value!.result()),
          isNotEmpty,
        );

        var importedSensorData =
            decodeXml(File(exampleXmlFilePath).readAsBytesSync());
        expect(
          importedSensorData.importedData!.sensorId,
          SensorId.linearAcceleration,
        );
        expect(
          compareSensorDataLists(
            importedSensorData.importedData!.sensorData,
            exampleData,
          ),
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
