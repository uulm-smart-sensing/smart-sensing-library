// ignore_for_file: use_setters_to_change_properties

import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:mockito/mockito.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

///A SensorManager for testing purposes
class FakeSensorManager extends Fake implements SensorManager {
  FakeSensorManager._constructor();
  static final FakeSensorManager _instance = FakeSensorManager._constructor();
  final Map _streamMap = HashMap<SensorId, StreamController<SensorData>>();

  ///Configurable fake inputs
  final Map<SensorId, bool> _sensorAvailableMap = {
    SensorId.accelerometer: true,
    SensorId.barometer: true,
    SensorId.gyroscope: true,
    SensorId.linearAcceleration: true,
    SensorId.magnetometer: true,
    SensorId.orientation: true,
    SensorId.thermometer: true,
  };
  SensorTaskResult _platformCallResult = SensorTaskResult.success;
  SensorData Function(int)? _creationFunction;
  //Is in seconds
  int _streamUpTime = 10;

  ///Instance for FakeSensorManager
  factory FakeSensorManager() => _instance;

  ///Sets the internal available sensors with [ids] to [available].
  void configureAvailableSensors(
    List<SensorId> ids, {
    bool available = true,
  }) {
    for (var id in ids) {
      _sensorAvailableMap[id] = available;
    }
  }

  ///Sets the internal platformResult to [result].
  void configurePlatformResult(SensorTaskResult result) =>
      _platformCallResult = result;

  ///Sets the internal maximum uptime of a stream to [time]
  void configureStreamUpTime(int time) => _streamUpTime = time;

  ///Resets the SensorManager to the initial state
  Future<void> resetState() async {
    configureAvailableSensors(SensorId.values);
    for (var key in _streamMap.keys) {
      await (_streamMap[key] as StreamController<SensorData>).close();
    }
    _platformCallResult = SensorTaskResult.success;
    _creationFunction = null;
    _streamUpTime = 10;
  }

  @override
  Stream<SensorData>? getSensorStream(SensorId id) =>
      _createStream(const Duration(seconds: 1), id);

  ///Starts the tracking of a sensor.
  @override
  Future<SensorTaskResult> startSensorTracking({
    required SensorId id,
    required SensorConfig config,
  }) {
    if (!_sensorAvailableMap[id]!) {
      return Future(() => SensorTaskResult.sensorNotAvailable);
    }
    if (_streamMap.containsKey(id)) {
      return Future(() => SensorTaskResult.alreadyTrackingSensor);
    }
    if (_platformCallResult == SensorTaskResult.success) {
      _createStream(config.timeInterval, id);
    }
    return Future(() => _platformCallResult);
  }

  ///Stops the tracking of a sensor.
  @override
  Future<SensorTaskResult> stopSensorTracking(SensorId id) async {
    if (!_streamMap.containsKey(id)) {
      return Future(() => SensorTaskResult.notTrackingSensor);
    }
    try {
      await (_streamMap[id] as StreamController<SensorData>).close();
      _streamMap.remove(id);
    } on Exception catch (e) {
      log(e.toString());
      return Future(() => SensorTaskResult.failure);
    }
    return Future(() => SensorTaskResult.success);
  }

  ///Returns a list of usable sensors.
  @override
  Future<List<SensorId>> getUsableSensors() => Future(
        () => (Map.from(_sensorAvailableMap)
          ..removeWhere((key, value) => value)
          ..keys.toList()) as List<SensorId>,
      );

  @override
  Future<bool> isSensorAvailable(SensorId id) =>
      Future(() => _sensorAvailableMap[id]!);

  ///Base implementation for test data creation.
  SensorData _createTestData(int i) => SensorData(
        data: [i + 0.1, i + 0.2, i + 0.3],
        maxPrecision: 2,
        unit: Unit.fahrenheit,
        timestamp: DateTime.now().toUtc(),
      );

  ///Creates a testing stream with fake data.
  Stream<SensorData> _createStream(
    Duration interval,
    SensorId id,
  ) {
    late StreamController<SensorData> controller;
    Timer? timer;
    var counter = 0;

    Future<void> tick(_) async {
      counter++;
      if (!controller.isClosed) {
        var create = _creationFunction ?? _createTestData;
        controller.add(create(counter));
        if (counter == _streamUpTime) {
          timer?.cancel();
          // Ask stream to shut down and tell listeners.
          await stopSensorTracking(id);
        }
      } else {
        timer?.cancel();
      }
    }

    void startTimer() {
      timer = Timer.periodic(interval, tick);
    }

    void stopTimer() {
      timer?.cancel();
      timer = null;
    }

    controller = StreamController<SensorData>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer,
    );
    _streamMap[id] = controller;
    return controller.stream;
  }
}
