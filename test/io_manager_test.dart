import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/io_manager.dart';

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
  });

  ///The fakeSensorManager cancles the Stream after 10 seconds,
  ///so after 15 seconds all data is saved in the database.
  test("Add sensor and get from database", () async {
    await ioManager.addSensor(SensorId.accelerometer, 1000);
    await Future.delayed(const Duration(seconds: 15));
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });
  test("Add sensor and get from buffer", () async {
    await ioManager.addSensor(SensorId.accelerometer, 1000);
    await Future.delayed(const Duration(seconds: 5));
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });

  test("Manual save to database", () async {
    var from = DateTime.now();
    await ioManager.addSensor(SensorId.accelerometer, 1000);
    await Future.delayed(const Duration(seconds: 3));
    var to = DateTime.now();
    await ioManager.flushToDatabase(SensorId.accelerometer);
    await Future.delayed(const Duration(seconds: 3));
    var test = await ioManager.getFilterFrom(
      SensorId.accelerometer,
      from: from,
      to: to,
    );
    expect(test?.result().isNotEmpty, true);
  });

  test("Remove data from databse", () async {
    await ioManager.addSensor(SensorId.accelerometer, 1000);
    await Future.delayed(const Duration(seconds: 15));
    await ioManager.removeData(SensorId.accelerometer);
    expect(
      () => ioManager.getFilterFrom(SensorId.accelerometer),
      throwsException,
    );
  });

  ///Adds a Sensor and checks if the same sensor can be added.
  ///If not, removes the sensor and checks if data was written.
  ///Removes all data and tries again to add a sensor.
  ///Checks if new sensor add also created data.
  test("Remove sensor", () async {
    await ioManager.addSensor(SensorId.accelerometer, 1000);
    expect(
      () => ioManager.addSensor(SensorId.accelerometer, 1000),
      throwsException,
    );

    await Future.delayed(const Duration(seconds: 5));
    await ioManager.removeSensor(SensorId.accelerometer);
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);

    await ioManager.removeData(SensorId.accelerometer);
    await ioManager.addSensor(SensorId.accelerometer, 1000);
    await Future.delayed(const Duration(seconds: 5));
    await ioManager.removeSensor(SensorId.accelerometer);
    test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });
}
