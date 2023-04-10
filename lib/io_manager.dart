import 'dart:async';
import 'dart:collection';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import 'buffer_manager.dart';
import 'fake_sensor_manager.dart';
import 'filter_tools.dart';
import 'objectbox.g.dart';
import 'sensor_data_dto.dart';
import 'sensor_data_mock.dart';

/// This class is the core component of the smart sensing library.
///
/// The IOManager is the main access point for getting and saving sensor data.
/// All other components are used/managed by the IOManager. To use its
/// functions, openDatabase() must be called!
class IOManager {
  IOManager._constructor() {
    _bufferManager = BufferManager();
    _sensorManager = SensorManager();
  }
  static final IOManager _instance = IOManager._constructor();

  late final BufferManager _bufferManager;
  late final Store? _objectStore;
  late final SensorManager _sensorManager;

  final int _maxBufferSize = 10000;
  final HashMap _subscriptions = HashMap<SensorId, StreamSubscription?>();

  var _sensorThreadLock = false;

  ///Returns instance of IOManager
  factory IOManager() => _instance;

  ///Constructor for testing
  IOManager.testManager() {
    _bufferManager = BufferManager();
    _sensorManager = FakeSensorManager();
  }

  ///Opens the database for access.
  ///
  ///Checks if an the basic Application path is available.
  ///If there is a database at the given location, it gets initialized.
  ///Otherwise a new database is created.
  ///Returns true when connection is established.
  Future<bool> openDatabase() async {
    await getApplicationDocumentsDirectory().then(
      (dir) => {
        _objectStore = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'smart_sensing_library.db'),
        )
      },
    );
    return true;
  }

  ///Returns a list of usable sensors
  Future<List<SensorId>> getUsableSensors() async =>
      _sensorManager.getUsableSensors();

  ///Retrieves information about the sensor with the passed [id].
  Future<SensorInfo> getSensorInfo(SensorId id) async =>
      _sensorManager.getSensorInfo(id);

  ///Retrieves the stream of sensor with the passed [id].
  Stream<SensorData>? getSensorStream(SensorId id) =>
      _sensorManager.getSensorStream(id);

  ///Returns a list of used sensors
  Future<List<SensorId>> getUsedSensors() async =>
      _sensorManager.getUsedSensors();

  ///Adds a Sensor with [id].
  ///
  ///Throws exception if a database connection is not established.
  Future<void> addSensor(SensorId id, int timeIntervalInMilliseconds) async {
    try {
      if (_objectStore == null) {
        throw Exception("Database connection is not established!"
            "Please first established to use the IOManager!");
      }
      while (_sensorThreadLock) {
        await Future.delayed(Duration.zero);
      }
      if (_subscriptions[id] != null) {
        throw Exception("Sensor already added!");
      }
      _sensorThreadLock = true;
      _bufferManager.addBuffer(id);
      var result = await _sensorManager.startSensorTracking(
        id,
        timeIntervalInMilliseconds,
      );
      if (result == SensorTaskResult.success) {
        _subscriptions[id] = _sensorManager.getSensorStream(id)!.listen(
              (e) => _processSensorData(e, id),
              onDone: () async => _onDataDone(id),
            );
      } else {
        throw Exception("Failed with $result");
      }
    } finally {
      _sensorThreadLock = false;
    }
  }

  ///Removes a Sensor with [id].
  ///
  ///Throws exception if a database connection is not established.
  Future<void> removeSensor(SensorId id) async {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!"
          "Please first established to use the IOManager!");
    }
    while (_sensorThreadLock) {
      await Future.delayed(Duration.zero);
    }
    if (_subscriptions[id] == null) {
      return;
    }
    _sensorThreadLock = true;
    await _sensorManager.stopSensorTracking(id);
  }

  ///Gets Data from Database
  ///
  ///Throws exception if a database connection is not established.
  ///Returns a Future with the requested List.
  ///The list values are between [from] and [to] and from the sensor [id].
  Future<List<SensorDataMock>> _getFromDatabase(
    DateTime from,
    DateTime to,
    SensorId id,
  ) async {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!");
    }
    var query = (_objectStore!.box<SensorDataDTO>().query(
              SensorDataDTO_.sensorID.equals(id.index).and(
                    SensorDataDTO_.dateTime.between(
                      from.millisecondsSinceEpoch,
                      to.millisecondsSinceEpoch,
                    ),
                  ),
            )..order(SensorDataDTO_.dateTime, flags: Order.descending))
        .build();
    var list = query.find();
    return list.map((e) => e.toSensorData()).toList();
  }

  ///Saves Data from Database
  ///
  ///Takes the buffer with the corresponding [id] and saves the
  ///content of it to the database. Clears the buffer afterwards.
  Future<void> flushToDatabase(SensorId id) async {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!"
          "Please first established to use the IOManager!");
    }
    var buffer = _bufferManager.getBuffer(id);
    var dtoList = buffer.map(SensorDataDTO.fromSensorData).toList();
    buffer.clear();
    await _objectStore!.box<SensorDataDTO>().putManyAsync(dtoList);
  }

  ///Checks if buffersize is too big.
  bool _checkBufferSize(int size) => size >= _maxBufferSize;

  ///Returns instance of FilterTools with corresponding data.
  ///
  ///Gets the data [from] until [to] from sensor [id].
  ///If not all of the data is in a buffer a get request
  ///will be sent to the database.
  ///Throws an exception if the buffer is empty.
  Future<FilterTools?> getFilterFrom(
    SensorId id, {
    DateTime? from,
    DateTime? to,
  }) async {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!"
          "Please first established to use the IOManager!");
    }
    from ??= DateTime.utc(-271821, 04, 20);
    to ??= DateTime.now().toUtc();
    if (to.isBefore(from)) {
      throw Exception(
        "Date range is incorrect: 'to' can not be before 'from'!",
      );
    }
    while (_sensorThreadLock) {
      await Future.delayed(Duration.zero);
    }
    try {
      var buffer = List.of(_bufferManager.getBuffer(id));
      //Check if first entry is older then given from.
      //If so, then the whole buffer contains all needed data.
      if (buffer.first.dateTime.isBefore(from)) {
        return FilterTools(_splitWithDateTime(from, to, buffer));
      }
      //Check if first entry is older then given to.
      //If so, then the buffer contains partial data.
      if (buffer.first.dateTime.isBefore(to)) {
        buffer = _splitWithDateTime(from, to, buffer);
      }
      var dbBuffer = await _getFromDatabase(from, buffer.first.dateTime, id);
      dbBuffer.addAll(buffer);
      if (dbBuffer.isEmpty) {
        throw Exception("Not a valid buffer!");
      }
      return FilterTools(dbBuffer);
    }
    // ignore: unused_catch_clause
    on InvalidBufferException catch (e) {
      //Expected catch
    }
    var buffer = await _getFromDatabase(from, to, id);

    if (buffer.isEmpty) {
      throw Exception("Not a valid buffer!");
    }
    return FilterTools(buffer);
  }

  ///Splits a partial list from [buffer] between [from] and [to].
  List<SensorDataMock> _splitWithDateTime(
    DateTime from,
    DateTime to,
    List<SensorDataMock> buffer,
  ) {
    var start = buffer.length, stop = 0;
    for (var i = 0; i < buffer.length; i++) {
      if (buffer[i].dateTime.isAfter(from)) {
        start = i;
        break;
      }
    }
    for (var i = buffer.length - 1; i >= 0; i--) {
      if (buffer[i].dateTime.isBefore(to)) {
        stop = i;
        break;
      }
    }
    return buffer.sublist(start, stop + 1);
  }

  ///Adds data to the buffer and checks if the maximum buffersize is reached.
  Future<void> _processSensorData(SensorData sensorData, SensorId id) async {
    var buffer = _bufferManager.getBuffer(id);
    if (_checkBufferSize(buffer.length)) {
      await flushToDatabase(id);
    }
    buffer.add(_convertFromSensorData(sensorData, id));
  }

  ///Converts SensorData to SensorDataMock
  SensorDataMock _convertFromSensorData(SensorData data, SensorId id) =>
      SensorDataMock(
        data: data.data.map((e) => e ?? 0).toList(),
        maxPrecision: data.maxPrecision,
        sensorID: id,
        setTime: DateTime.fromMillisecondsSinceEpoch(
          data.timestampInMicroseconds,
          isUtc: true,
        ),
      );

  ///Closes all connections to the stream and buffer.
  Future<void> _onDataDone(SensorId id) async {
    await (_subscriptions[id] as StreamSubscription).cancel();
    _subscriptions[id] = null;
    await flushToDatabase(id);
    _bufferManager.removeBuffer(id);
    _sensorThreadLock = false;
  }

  ///Removes data from the Database.
  ///
  ///Removes data between [from] and [to] with senor [id].
  ///If no [from] or [to] are given, it will use the maximum time for these.
  Future<void> removeData(SensorId id, [DateTime? from, DateTime? to]) async {
    from ??= DateTime.utc(-271821, 04, 20);
    to ??= DateTime.utc(275760, 09, 13);
    await (_objectStore!.box<SensorDataDTO>().query(
          SensorDataDTO_.sensorID.equals(id.index).and(
                SensorDataDTO_.dateTime.between(
                  from.millisecondsSinceEpoch,
                  to.millisecondsSinceEpoch,
                ),
              ),
        )).build().removeAsync();
  }
}
