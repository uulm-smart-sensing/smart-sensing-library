import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/io_manager.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel(
    'plugins.flutter.io/path_provider',
  ).setMockMethodCallHandler((methodCall) async => ".");
  var ioManager = IOManager();

  if (!await ioManager.openDatabase()) {
    throw Exception("Database connection failed!");
  }

  setUp(() async => ioManager.removeData(SensorId.accelerometer));

  test("Add sensor and get from database", () async {
    await ioManager.addSensor(SensorId.accelerometer);
    await Future.delayed(const Duration(seconds: 15));
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });
  test("Add sensor and get from buffer", () async {
    await ioManager.addSensor(SensorId.accelerometer);
    await Future.delayed(const Duration(seconds: 5));
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });
  test("Remove sensor", () async {
    await ioManager.addSensor(SensorId.accelerometer);
    expect(() => ioManager.addSensor(SensorId.accelerometer), throwsException);

    await Future.delayed(const Duration(seconds: 5));
    await ioManager.removeSensor(SensorId.accelerometer);
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);

    await ioManager.removeData(SensorId.accelerometer);
    await ioManager.addSensor(SensorId.accelerometer);
    await Future.delayed(const Duration(seconds: 5));
    await ioManager.removeSensor(SensorId.accelerometer);
    test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });
}
