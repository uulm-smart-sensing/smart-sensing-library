import 'dart:async';
import 'dart:collection';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import 'buffer_manager.dart';
import 'filter_tools.dart';
import 'mock_sensor_manager.dart';
import 'objectbox.g.dart';
import 'sensor_data.dart';
import 'sensor_data_dto.dart';

/// This class is the core component of the smart sensing library.
///
/// The IOManager is the main access point for getting and saving sensor data.
/// All other components are used/managed by the IOManager. To use its
/// functions, openDatabase() must be called!
class IOManager {
  IOManager._constructor() {
    _bufferManager = BufferManager();
    _sensorManager = MockSensorManager();
  }
  static final IOManager _instance = IOManager._constructor();

  late final BufferManager _bufferManager;
  late final Store? _objectStore;
  late final MockSensorManager _sensorManager;

  final int _maxBufferSize = 10000;
  final HashMap _subscription = HashMap<SensorId, StreamSubscription?>();

  ///Returns instance of IOManager
  factory IOManager() => _instance;

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

  ///Adds a Sensor with [id].
  ///
  ///Throws exception if a database connection is not established.
  ///WIP. Currently works with the Mock SensorManager
  void addSensor(SensorId id) {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!"
          "Please first established to use the IOManager!");
    }
    _bufferManager.addBuffer(id);
    _subscription[id] = _sensorManager.addSensor(id).listen(
          _processSensorData,
          onDone: () async => _onDataDone(id),
        );
  }

  ///Removes a Sensor with [id].
  ///
  ///Throws exception if a database connection is not established.
  ///WIP. Currently works with the Mock SensorManager
  Future<void> removeSensor(SensorId id) async {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!"
          "Please first established to use the IOManager!");
    }
    await _sensorManager.removeSensor(id);
  }

  ///Gets Data from Database
  ///
  ///Throws exception if a database connection is not established.
  ///Returns the a Future with the requested List.
  ///The list values are between [from] and [to] and from the sensor [id].
  Future<List<SensorData>> getFromDatabase(
    DateTime from,
    DateTime to,
    SensorId id,
  ) async {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!");
    }
    var query = (_objectStore!.box<SensorDataDTO>().query(
              SensorDataDTO_.id.equals(id.index).and(
                    SensorDataDTO_.dateTime.between(
                      from.millisecondsSinceEpoch,
                      to.millisecondsSinceEpoch - 1,
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
  Future<void> saveToDatabase(SensorId id) async {
    if (_objectStore == null) {
      throw Exception("Database connection is not established!"
          "Please first established to use the IOManager!");
    }
    var buffer = _bufferManager.getBuffer(id);
    var dtoList = buffer.map(SensorDataDTO.fromSensorData).toList();
    await _objectStore!.box<SensorDataDTO>().putManyAsync(dtoList);
    buffer.clear();
  }

  ///Checks if buffersize is too big.
  bool _checkBufferSize(int size) => size >= _maxBufferSize;

  ///Returns instance of FilterTool with corresponding data.
  ///
  ///Gets the data between [from] and [to] from sensor [id].
  ///If data isn't completly in a buffer, a get request is
  ///sent to the database.
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
    to ??= DateTime.now();

    var buffer = _bufferManager.getBuffer(id);
    if (buffer.first.dateTime.isBefore(from) &&
        buffer.last.dateTime.isAfter(to)) {
      return FilterTools(_splitWithDateTime(from, to, buffer));
    } else {
      buffer = await getFromDatabase(from, to, id);
    }
    if (buffer.isEmpty){
      throw Exception("Not a valid buffer!");
    }
    return FilterTools(buffer);
  }

  ///Splits a partial list from [buffer] between [from] and [to].
  List<SensorData> _splitWithDateTime(
    DateTime from,
    DateTime to,
    List<SensorData> buffer,
  ) {
    var start = 0, stop = 0;
    buffer.firstWhere((element) => element.dateTime.isAfter(from));
    for (var i = 0; i < buffer.length; i++) {
      if (buffer[i].dateTime.isAfter(from)) {
        start = i;
        break;
      }
    }
    for (var i = buffer.length; i >= 0; i--) {
      if (buffer[i].dateTime.isBefore(to)) {
        stop = i;
        break;
      }
    }
    return buffer.sublist(start, stop);
  }

  ///Adds data to the buffer and checks if the maximum buffersize is reached.
  Future<void> _processSensorData(SensorData sensorData) async {
    var buffer = _bufferManager.getBuffer(sensorData.sensorID);
    if (_checkBufferSize(buffer.length)) {
      await saveToDatabase(sensorData.sensorID);
    }
    buffer.add(sensorData);
  }

  ///Closes all connections to the stream and buffer.
  Future<void> _onDataDone(SensorId id) async {
    await (_subscription[id] as StreamSubscription).cancel();
    _subscription[id] = null;
    await saveToDatabase(id);
    _bufferManager.removeBuffer(id);
  }
}
