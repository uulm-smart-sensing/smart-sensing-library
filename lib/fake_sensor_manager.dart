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
  final _streamMap = HashMap<SensorId, StreamController<SensorData>>();
  var _usedSensors = <SensorId>[];

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

  /// Sets the internal used sensors to [ids].
  void configureUsedSensors(List<SensorId> ids) => _usedSensors = ids;

  ///Resets the SensorManager to the initial state
  Future<void> resetState() async {
    configureAvailableSensors(SensorId.values);
    for (var key in _streamMap.keys) {
      await _streamMap[key]!.close();
    }
    _platformCallResult = SensorTaskResult.success;
    _creationFunction = null;
    _streamUpTime = 10;
  }

  @override
  Stream<SensorData>? getSensorStream(SensorId id) =>
      _streamMap.containsKey(id) ? _streamMap[id]?.stream : null;

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

  @override
  Future<SensorTaskResult> stopSensorTracking(SensorId id) async {
    if (!_streamMap.containsKey(id)) {
      return Future(() => SensorTaskResult.notTrackingSensor);
    }
    try {
      await _streamMap[id]!.close();
      _streamMap.remove(id);
    } on Exception catch (e) {
      log(e.toString());
      return Future(() => SensorTaskResult.failure);
    }
    return Future(() => SensorTaskResult.success);
  }

  @override
  List<SensorId> getUsedSensors() => _usedSensors;

  @override
  Future<List<SensorId>> getUsableSensors() async {
    var usableSensors = <SensorId>[];
    for (var id in SensorId.values) {
      if (!_usedSensors.contains(id) && await isSensorAvailable(id)) {
        usableSensors.add(id);
      }
    }
    return usableSensors;
  }

  @override
  Future<bool> isSensorAvailable(SensorId id) =>
      Future(() => _sensorAvailableMap[id]!);

  @override
  Future<SensorInfo> getSensorInfo(SensorId id) => Future.value(
        SensorInfo(
          _getSensorUnit(id),
          SensorAccuracy.high,
          1000,
        ),
      );

  ///Base implementation for test data creation.
  SensorData _createTestData(int i) => SensorData(
        data: [i + 0.1, i + 0.2, i + 0.3],
        maxPrecision: 2,
        unit: Temperature.fahrenheit,
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

  Unit _getSensorUnit(SensorId id) {
    switch (id) {
      case SensorId.accelerometer:
      case SensorId.linearAcceleration:
        return Acceleration.meterPerSecondSquared;
      case SensorId.barometer:
        return Pressure.pascal;
      case SensorId.gyroscope:
        return AngularVelocity.radiansPerSecond;
      case SensorId.magnetometer:
        return MagneticFluxDensity.microTesla;
      case SensorId.orientation:
        return Angle.degrees;
      case SensorId.thermometer:
        return Temperature.celsius;
    }
  }
}
