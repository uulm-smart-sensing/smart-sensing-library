import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensing_plugin/sensing_plugin.dart';
import 'package:smart_sensing_library/fake_sensor_manager.dart';
import 'package:smart_sensing_library/io_manager.dart';
import 'package:smart_sensing_library/src/database_connection_not_established_exception.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel(
    'plugins.flutter.io/path_provider',
  ).setMockMethodCallHandler((methodCall) async => ".");
  var ioManager = IOManager.testManager();

  await ioManager.openDatabase();

  const exampleConfig = SensorConfig(
    targetUnit: Temperature.celsius,
    targetPrecision: 2,
    timeInterval: Duration(milliseconds: 1000),
  );

  setUp(
    () => FakeSensorManager().resetState().then(
          (value) => ioManager.removeSensor(SensorId.accelerometer),
        ),
  );

  tearDown(() => ioManager.deleteDatabase());

  test("Get and set max Buffer", () async {
    IOManager().maxBufferSize = 10;
    expect(IOManager().maxBufferSize, 10);
  });

  test("Set negative max Buffer", () async {
    IOManager().maxBufferSize = -10;
    expect(IOManager().maxBufferSize, 1);
  });

  ///The fakeSensorManager cancels the Stream after 10 seconds,
  ///so after 15 seconds all data is saved in the database.
  test("Add sensor and get from database", () async {
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    await Future.delayed(const Duration(seconds: 15));
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });

  test("Add sensor and get from buffer", () async {
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    await Future.delayed(const Duration(seconds: 5));
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });

  test("Manual save to database", () async {
    var from = DateTime.now().toUtc();
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    await Future.delayed(const Duration(seconds: 3));
    var to = DateTime.now().toUtc();
    await ioManager.flushToDatabase(SensorId.accelerometer);
    await Future.delayed(const Duration(seconds: 3));
    var test = await ioManager.getFilterFrom(
      SensorId.accelerometer,
      from: from,
      to: to,
    );
    expect(test?.result().isNotEmpty, true);
  });

  test("Remove data from database", () async {
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
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
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    var result = await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    expect(result, equals(SensorTaskResult.alreadyTrackingSensor));

    await Future.delayed(const Duration(seconds: 5));
    await ioManager.removeSensor(SensorId.accelerometer);
    var test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);

    await ioManager.removeData(SensorId.accelerometer);
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    await Future.delayed(const Duration(seconds: 5));
    await ioManager.removeSensor(SensorId.accelerometer);
    test = await ioManager.getFilterFrom(SensorId.accelerometer);
    expect(test?.result().isNotEmpty, true);
  });

  test("Test multi query functionality", () async {
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    await ioManager.addSensor(
      id: SensorId.gyroscope,
      config: exampleConfig,
    );
    await Future.delayed(const Duration(seconds: 15));
    var test = await ioManager
        .getMultiFilterFrom([SensorId.accelerometer, SensorId.gyroscope]);
    expect(test?.result()[SensorId.accelerometer]!.isNotEmpty, true);
    expect(test?.result()[SensorId.gyroscope]!.isNotEmpty, true);
  });

  test("Test multi query functionality when skip faulty is false.", () async {
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    await Future.delayed(const Duration(seconds: 15));
    expect(
      () async => ioManager.getMultiFilterFrom(
        [SensorId.accelerometer, SensorId.gyroscope],
        skipFaulty: false,
      ),
      throwsException,
    );
  });

  test("Test multi query functionality when skip faulty is true.", () async {
    await ioManager.addSensor(
      id: SensorId.accelerometer,
      config: exampleConfig,
    );
    await Future.delayed(const Duration(seconds: 15));
    var test = await ioManager.getMultiFilterFrom(
      [SensorId.accelerometer, SensorId.gyroscope],
      skipFaulty: true,
    );
    expect(test?.result()[SensorId.accelerometer]!.isNotEmpty, true);
  });

  test(
    'When sensor is available, then isSensorAvailable returns true',
    () async {
      var id = SensorId.accelerometer;
      FakeSensorManager().configureAvailableSensors([id], available: true);
      var isAvailable = await ioManager.isSensorAvailable(id);
      expect(isAvailable, isTrue);
    },
  );

  test(
    'When sensor is not available, then isSensorAvailable returns false',
    () async {
      var id = SensorId.accelerometer;
      FakeSensorManager().configureAvailableSensors([id], available: false);
      var isAvailable = await ioManager.isSensorAvailable(id);
      expect(isAvailable, isFalse);
    },
  );

  test(
    'When a set of sensors are available, then getAvailableSensors returns this'
    ' set of available sensors',
    () async {
      var availableSensorIds = [
        SensorId.accelerometer,
        SensorId.barometer,
        SensorId.gyroscope
      ];
      var notAvailableSensorIds =
          SensorId.values.whereNot(availableSensorIds.contains).toList();
      FakeSensorManager().configureAvailableSensors(
        availableSensorIds,
        available: true,
      );
      FakeSensorManager().configureAvailableSensors(
        notAvailableSensorIds,
        available: false,
      );
      var availableSensors = await ioManager.getAvailableSensors();
      expect(availableSensors.length, availableSensorIds.length);
      expect(
        availableSensorIds
            .map(availableSensors.contains)
            .any((element) => !element),
        isFalse,
        reason: "getAvailableSensors doesn't contain all available sensors",
      );
    },
  );

  test(
    'When three sensors are available and two of them aren\'t used, then '
    'these two sensors are returned from getUsableSensors',
    () async {
      FakeSensorManager().configureAvailableSensors(
        SensorId.values,
        available: false,
      );
      FakeSensorManager().configureAvailableSensors(
        [SensorId.accelerometer, SensorId.barometer, SensorId.gyroscope],
        available: true,
      );
      FakeSensorManager().configureUsedSensors([
        SensorId.accelerometer,
      ]);
      var usableSensors = await ioManager.getUsableSensors();
      expect(usableSensors.length, 2);
      expect(usableSensors.contains(SensorId.barometer), isTrue);
      expect(usableSensors.contains(SensorId.gyroscope), isTrue);
    },
  );

  test(
    'When SensorInfo is requested, then the correct SensorInfo is returned',
    () async {
      for (var sensorId in SensorId.values) {
        var sensorInfo = await ioManager.getSensorInfo(sensorId);

        Unit expectedUnit;
        switch (sensorId) {
          case SensorId.accelerometer:
          case SensorId.linearAcceleration:
            expectedUnit = Acceleration.meterPerSecondSquared;
            break;
          case SensorId.barometer:
            expectedUnit = Pressure.pascal;
            break;
          case SensorId.gyroscope:
            expectedUnit = AngularVelocity.radiansPerSecond;
            break;
          case SensorId.magnetometer:
            expectedUnit = MagneticFluxDensity.microTesla;
            break;
          case SensorId.orientation:
            expectedUnit = Angle.degrees;
            break;
          case SensorId.thermometer:
            expectedUnit = Temperature.celsius;
            break;
        }

        expect(sensorInfo.unit, equals(expectedUnit));
        expect(sensorInfo.accuracy, equals(SensorAccuracy.high));
        expect(sensorInfo.timeIntervalInMilliseconds, equals(1000));
      }
    },
  );

  test(
    'When sensor is started and getSensorStream is called, then the stream of'
    ' the started sensor is returned',
    () async {
      var id = SensorId.accelerometer;
      FakeSensorManager().configureAvailableSensors([id], available: true);
      var config = const SensorConfig(
        targetUnit: Acceleration.meterPerSecondSquared,
        targetPrecision: 2,
        timeInterval: Duration(milliseconds: 1000),
      );
      await ioManager.addSensor(id: id, config: config);
      var stream = ioManager.getSensorStream(id);
      expect(stream, isNotNull);
    },
  );

  test(
    'When getSensorStream is called on a sensor that is not being tracked, then'
    ' the stream of the started sensor is returned',
    () async {
      var stream = ioManager.getSensorStream(SensorId.accelerometer);
      expect(stream, isNull);
    },
  );

  test(
    'When sensors are used, then getUsedSensors() returns the used sensors',
    () async {
      FakeSensorManager().configureUsedSensors([
        SensorId.accelerometer,
        SensorId.barometer,
        SensorId.gyroscope,
      ]);
      var usedSensors = await ioManager.getUsedSensors();
      expect(usedSensors.length, 3);
      expect(usedSensors.contains(SensorId.accelerometer), isTrue);
      expect(usedSensors.contains(SensorId.barometer), isTrue);
      expect(usedSensors.contains(SensorId.gyroscope), isTrue);
    },
  );

  test(
    'When a sensor is started but the database connection is not established,'
    ' then a DatabaseConnectionNotEstablishedException is thrown',
    () async {
      ioManager.closeDatabase();
      var id = SensorId.accelerometer;
      FakeSensorManager().configureAvailableSensors([id], available: true);
      var config = const SensorConfig(
        targetUnit: Acceleration.meterPerSecondSquared,
        targetPrecision: 2,
        timeInterval: Duration(milliseconds: 1000),
      );

      expect(
        () async => ioManager.addSensor(id: id, config: config),
        throwsA(
          isA<DatabaseConnectionNotEstablishedException>(),
        ),
      );

      // Reset ioManager to avoid errors in other tests, because implementation
      // doesn't allow to open the database again.
      ioManager = IOManager.testManager();
      await ioManager.openDatabase();
    },
  );

  test(
    'When sensor is not available and addSensor is called, then '
    'SensorTaskResult.sensorNotAvailable is returned',
    () async {
      var id = SensorId.accelerometer;
      FakeSensorManager().configureAvailableSensors([id], available: false);
      var config = const SensorConfig(
        targetUnit: Acceleration.meterPerSecondSquared,
        targetPrecision: 2,
        timeInterval: Duration(milliseconds: 1000),
      );
      var result = await ioManager.addSensor(id: id, config: config);
      expect(result, SensorTaskResult.sensorNotAvailable);
    },
  );
}
