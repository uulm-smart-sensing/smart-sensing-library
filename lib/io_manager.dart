import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import 'buffer_manager.dart';
import 'filter_tools.dart';
import 'objectbox.g.dart';
import 'sensor_data.dart';
import 'sensor_data_dto.dart';

/// This class is the main component of the smart sensing library
class IOManager {
  IOManager._constructor() {
    _bufferManager = BufferManager();
  }
  late final BufferManager _bufferManager;
  static final IOManager _instance = IOManager._constructor();
  late final Store? _objectStore;
  final int _maxBufferSize = 0;

  ///Returns instance of IOManager
  factory IOManager() => _instance;

  ///Opens the Database for access
  Future<bool> openDatabase() async {
    try {
      await _openObjectboxDB();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  ///Adds a Sensor with [id].
  void addSensor(SensorId id) {
    _checkBufferSize(1);
  }

  ///Removes a Sensor with [id].
  void removeSensor(SensorId id) {}

  ///Gets Data from Database
  Future<List<SensorData>> getFromDatabase(DateTime from, DateTime to) async {
    if(_objectStore != null){
    var query = (_objectStore!.box<SensorDataDTO>().query(
              SensorDataDTO_.id.equals(1).and(
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
    return Future.error("Database connection is not established");
  }

  ///Saves Data from Database
  Future<void> saveToDatabase(SensorId id) async {
    if(_objectStore != null){
    var buffer = _bufferManager.getBuffer(id);
    var dtoList = buffer.map(SensorDataDTO.fromSensorData).toList();
    await _objectStore!.box<SensorDataDTO>().putManyAsync(dtoList);
    buffer.clear();
    }
  }

  bool _checkBufferSize(int size) => size >= _maxBufferSize;

  Future<void> _openObjectboxDB() async {
    await getApplicationDocumentsDirectory().then(
      (dir) => {
        _objectStore = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'my_databaseObjectBox.db'),
        )
      },
    );
  }

  ///Returns instance of FilterTool with corresponding buffer.
  Future<FilterTools?> getFilterFrom(
    SensorId id, {
    DateTime? from,
    DateTime? to,
    Duration interval = Duration.zero,
  }) async {
    from ??= DateTime.utc(-271821, 04, 20);
    to ??= DateTime.now();
    try {
      var buffer = _bufferManager.getBuffer(id);
      if (buffer.first.dateTime.isBefore(from) &&
          buffer.last.dateTime.isAfter(to)) {
        return FilterTools(_splitWithDateTime(from, to, buffer));
      } else {
        buffer = await getFromDatabase(from, to);
      }
      return FilterTools(buffer);
    } on Exception catch (e) {
      rethrow;
    }
  }

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
}
