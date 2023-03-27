import 'dart:async';
import 'dart:collection';

import 'package:sensing_plugin/sensing_plugin.dart';
import 'sensor_data.dart';

///A SensorManager for testing purposes
class MockSensorManager {
  MockSensorManager._constructor();
  static final MockSensorManager _instance = MockSensorManager._constructor();
  final HashMap _streamMap = HashMap<SensorId, StreamController<SensorData>?>();

  ///Instance for MockSensorManager
  factory MockSensorManager() => _instance;

  ///Creates a Stream for with [id].
  ///
  ///Returns a stream that gives back data every second.
  Stream<SensorData> addSensor(SensorId id) =>
      _createStream(const Duration(seconds: 1), id);

  ///Removes the stream with [id].
  Future<void> removeSensor(SensorId id) async {
    await (_streamMap[id] as StreamController).close();
    _streamMap[id] = null;
  }

  ///Creates test data.
  SensorData _createTestData(int i, SensorId id) => SensorData(
        data: [i + 0.1, i + 0.2, i + 0.3],
        maxPrecision: 2,
        sensorID: id,
      );

  ///Creates a testing stream.
  Stream<SensorData> _createStream(
    Duration interval,
    SensorId id, [
    int? maxCount,
  ]) {
    late StreamController<SensorData> controller;
    Timer? timer;
    var counter = 0;

    Future<void> tick(_) async {
      counter++;
      controller.add(_createTestData(counter, id));
      if (counter == maxCount) {
        timer?.cancel();
        await controller.close(); // Ask stream to shut down and tell listeners.
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
