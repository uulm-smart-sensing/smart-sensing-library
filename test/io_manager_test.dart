import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/io_manager.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel(
    'plugins.flutter.io/path_provider',
  ).setMockMethodCallHandler((methodCall) async => r"\.");
  var ioManager = IOManager();

  if (!await ioManager.openDatabase()) {
    throw Exception("Database connection failed!");
  }

  test("Add Sensor", () async {
    ioManager.addSensor(SensorId.accelerometer);
    await Future.delayed(const Duration(seconds: 15));
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });
}
