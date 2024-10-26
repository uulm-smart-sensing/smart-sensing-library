import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sensing_plugin/sensing_plugin.dart';

import 'buffer_manager.dart';
import 'fake_sensor_manager.dart';
import 'filter_tools.dart';
import 'multi_filter_tools.dart';
import 'objectbox.g.dart';
import 'sensor_data_dto.dart';
import 'src/database_connection_not_established_exception.dart';
import 'src/import_export_module/export_result.dart';
import 'src/import_export_module/export_tool.dart';
import 'src/import_export_module/import_result.dart';
import 'src/import_export_module/import_tool.dart';
import 'src/import_export_module/supported_file_format.dart';

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

  int _maxBufferSize = 1000;
  final HashMap _subscriptions = HashMap<SensorId, StreamSubscription?>();

  var _sensorThreadLock = false;

  ///The max buffer size, that the IOManager saves per sensor.
  int get maxBufferSize => _maxBufferSize;

  ///Changes max buffer size of IOManager.
  ///
  ///If [size] is set <= 0, value 1 will be given.
  set maxBufferSize(int size) {
    if (size <= 0) {
      _maxBufferSize = 1;
      return;
    }
    _maxBufferSize = size;
  }

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
  Future<void> openDatabase() async {
    await getApplicationDocumentsDirectory().then(
      (dir) => {
        _objectStore = Store(
          getObjectBoxModel(),
          directory: path.join(dir.path, 'smart_sensing_library.db'),
        )
      },
    );
  }

  /// Closes the database.
  ///
  /// Throws an exception if the database connection is not established.
  void closeDatabase() {
    if (!isDatabaseConnectionEstablished()) {
      throw const DatabaseConnectionNotEstablishedException();
    }
    _objectStore!.close();
  }

  /// Checks whether the database connection is established.
  bool isDatabaseConnectionEstablished() =>
      _objectStore != null && !_objectStore!.isClosed();

  /// Deletes all data from the database.
  Future<void> deleteDatabase() async {
    _objectStore!.box<SensorDataDTO>().removeAll();
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

  /// Checks whether the sensor with the passed [id] is available.
  Future<bool> isSensorAvailable(SensorId id) =>
      _sensorManager.isSensorAvailable(id);

  /// Return the [SensorConfig] for a sensor with the given [id], if it already
  /// exists, otherwise null.
  SensorConfig? getSensorConfig(SensorId id) =>
      _sensorManager.getSensorConfig(id);

  /// Edits the configuration of a sensor with a given [id] to the (optional)
  /// set new values for the
  /// * [targetUnit], so the unit in which the sensor data should be converted
  /// * [targetPrecision], so the precision the sensor data should be rounded to
  /// * [timeInterval], so the interval at which the sensor data should be
  ///   collected.
  ///
  /// The result of the edit will be wrapped in the [SensorTaskResult], so
  /// whether the editing was successful or an error occurred (and if so, which
  /// error).
  Future<SensorTaskResult> editSensorConfig(
    SensorId id, {
    Unit? targetUnit,
    int? targetPrecision,
    Duration? timeInterval,
  }) async =>
      _sensorManager.editSensorConfig(
        id,
        targetUnit: targetUnit,
        targetPrecision: targetPrecision,
        timeInterval: timeInterval,
      );

  /// Validates an updated [SensorConfig] for a given sensor (with the given
  /// [id]).
  ///
  /// It returns the result wrapped in the [SensorTaskResult] class, which
  /// contains the reason for an invalid config, if something went wrong.
  SensorTaskResult validateSettings(SensorId id, SensorConfig config) =>
      _sensorManager.validateSensorConfig(id, config);

  /// Returns all available sensors.
  ///
  /// This is equivalent to call [isSensorAvailable] on each element of
  /// [SensorId.values] and return the [SensorId] if the result is true.
  Future<List<SensorId>> getAvailableSensors() async {
    var availableSensors = <SensorId>[];
    for (var sensorId in SensorId.values) {
      if (await isSensorAvailable(sensorId)) {
        availableSensors.add(sensorId);
      }
    }
    return availableSensors;
  }

  /// Adds a Sensor with the passed [id].
  ///
  /// The returned [SensorTaskResult] indicates whether the operation was
  /// successful ([SensorTaskResult.success]) or not. The sensor is subscribed
  /// and data is collected only if the operation was successful.
  ///
  /// The passed [config] is used to specify the sensor time interval and the
  /// properties of the sensor output data.
  ///
  /// Throws an exception if the database connection is not established.
  Future<SensorTaskResult> addSensor({
    required SensorId id,
    required SensorConfig config,
  }) async {
    SensorTaskResult result;
    try {
      if (!isDatabaseConnectionEstablished()) {
        throw const DatabaseConnectionNotEstablishedException();
      }

      while (_sensorThreadLock) {
        await Future.delayed(Duration.zero);
      }

      if (_subscriptions[id] != null) {
        return SensorTaskResult.alreadyTrackingSensor;
      }

      _sensorThreadLock = true;

      result = await _sensorManager.startSensorTracking(
        id: id,
        config: config,
      );

      if (result == SensorTaskResult.success) {
        _bufferManager.addBuffer(id);
        _subscriptions[id] = _sensorManager.getSensorStream(id)!.listen(
              (sensorData) => _processSensorData(sensorData, id),
              onDone: () async => _onDataDone(id),
            );
      }
    } finally {
      _sensorThreadLock = false;
    }
    return result;
  }

  /// Removes a Sensor with the passed [id].
  ///
  /// The returned [SensorTaskResult] indicates whether the operation was
  /// successful ([SensorTaskResult.success]) or not. The sensor is unsubscribed
  /// only if the operation was successful.
  ///
  /// Throws an exception if the database connection is not established.
  Future<SensorTaskResult> removeSensor(SensorId id) async {
    if (!isDatabaseConnectionEstablished()) {
      throw const DatabaseConnectionNotEstablishedException();
    }

    if (_subscriptions[id] == null) {
      return SensorTaskResult.notTrackingSensor;
    }

    return _sensorManager.stopSensorTracking(id);
  }

  ///Gets Data from Database
  ///
  ///Throws exception if a database connection is not established.
  ///Returns a Future with the requested List.
  ///The list values are between [from] and [to] and from the sensor [id].
  Future<List<SensorData>> _getFromDatabase(
    DateTime from,
    DateTime to,
    SensorId id,
  ) async {
    if (!isDatabaseConnectionEstablished()) {
      throw const DatabaseConnectionNotEstablishedException();
    }
    var query = (_objectStore!.box<SensorDataDTO>().query(
              SensorDataDTO_.sensorID.equals(id.index).and(
                    SensorDataDTO_.dateTime.between(
                      from.microsecondsSinceEpoch * 1000,
                      to.microsecondsSinceEpoch * 1000,
                    ),
                  ),
            )..order(SensorDataDTO_.dateTime))
        .build();
    var list = await query.findAsync();
    return list.map((e) => e.toSensorData()).toList();
  }

  ///Saves Data from Database
  ///
  ///Takes the buffer with the corresponding [id] and saves the
  ///content of it to the database. Clears the buffer afterwards.
  Future<void> flushToDatabase(SensorId id) async {
    if (!isDatabaseConnectionEstablished()) {
      throw const DatabaseConnectionNotEstablishedException();
    }
    var buffer = _bufferManager.getBuffer(id);
    var dtoList =
        buffer.map((e) => SensorDataDTO.fromSensorData(e, id)).toList();
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
    if (!isDatabaseConnectionEstablished()) {
      throw const DatabaseConnectionNotEstablishedException();
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
      if (buffer.isNotEmpty) {
        if (buffer.first.timestamp.isBefore(from)) {
          return FilterTools(_splitWithDateTime(from, to, buffer));
        }
        //Check if first entry is older then given to.
        //If so, then the buffer contains partial data.
        if (buffer.first.timestamp.isBefore(to)) {
          buffer = _splitWithDateTime(from, to, buffer);
        }
      }
      var dbBuffer = await _getFromDatabase(
        from,
        buffer.first.timestamp,
        id,
      );
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

  /// Returns instance of MultiFilterTools with corresponding data.
  ///
  /// Gets the data [from] until [to] from all sensors in [idList].
  /// If not all of the data is in a buffer a get request
  /// will be sent to the database.
  /// If [skipFaulty] is set, skips faulty requests and removes the [SensorId]
  /// from [idList]
  /// Otherwise throws the corresponding [Exception].
  Future<MultiFilterTools?> getMultiFilterFrom(
    List<SensorId> idList, {
    DateTime? from,
    DateTime? to,
    bool skipFaulty = false,
  }) async {
    var filterMap = <SensorId, FilterTools?>{};
    for (var id in idList) {
      try {
        filterMap[id] = await getFilterFrom(id, from: from, to: to);
      } on Exception catch (_) {
        if (!skipFaulty) {
          rethrow;
        } else {
          filterMap.remove(id);
        }
      }
    }
    return MultiFilterTools(filterMap);
  }

  ///Splits a partial list from [buffer] between [from] and [to].
  List<SensorData> _splitWithDateTime(
    DateTime from,
    DateTime to,
    List<SensorData> buffer,
  ) {
    var start = buffer.length, stop = 0;
    for (var i = 0; i < buffer.length; i++) {
      if (buffer[i].timestamp.isAfter(from)) {
        start = i;
        break;
      }
    }
    for (var i = buffer.length - 1; i >= 0; i--) {
      if (buffer[i].timestamp.isBefore(to)) {
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
    buffer.add(sensorData);
  }

  ///Closes all connections to the stream and buffer.
  Future<void> _onDataDone(SensorId id) async {
    while (_sensorThreadLock) {
      await Future.delayed(Duration.zero);
    }
    _sensorThreadLock = true;
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
                  from.microsecondsSinceEpoch * 1000,
                  to.microsecondsSinceEpoch * 1000,
                ),
              ),
        )).build().removeAsync();
  }

  /// Exports the sensor data of a sensor or different sensors, considering a
  /// certain [format] and optional a certain time interval.
  ///
  /// The time interval ranges from [startTime] to [endTime], where the
  /// following default values are used, if the user do not specify either or
  /// both of them:
  /// * startTime = DateTime.fromMicrosecondsSinceEpoch(0), so the furthest back
  /// in time
  /// * endTime = DateTime.now(), so the latest moment in time, where sensor
  /// data could exist.
  ///
  /// The sensor data will be exported into a file with the following naming
  /// pattern:
  /// _<sensorId>\_<startTime>\_<endTime>_
  /// and be saved in the directory with the given [directoryName].
  ///
  /// Returns
  /// * [ExportResult.directoryDoNotExist] if there exist no directory with the
  ///   [directoryName]
  /// * [ExportResult.noSensorIdsProvided] if the list of [sensorIds] is empty,
  ///   so actually no export is requested.
  /// * [ExportResult.noSensorDataExisting] if there exist no data (for one of
  ///   the sensors, eventually in the time interval from [startTime] to
  ///   [endTime])
  /// * otherwise [ExportResult.success]
  /// TODO: add parameter to turn the spacing and line breaks of (= don't
  /// "beautify")
  Future<ExportResult> exportSensorDataToFile(
    String directoryName,
    SupportedFileFormat format,
    List<SensorId> sensorIds, [
    DateTime? startTime,
    DateTime? endTime,
  ]) async {
    if (!await Directory(directoryName).exists()) {
      return ExportResult.directoryDoNotExist;
    }

    // Set the start and end time, if not specified by the user to
    // furthest back in time and latest time.
    startTime ??= DateTime.fromMicrosecondsSinceEpoch(0);
    endTime ??= DateTime.now();

    if (sensorIds.isEmpty) return ExportResult.noSensorIdsProvided;

    // Fetch the data for all sensors, format them and save the result in a new
    // file.
    for (var sensor in sensorIds) {
      var fileName =
          "$directoryName/${createFileName(sensor, startTime, endTime)}";

      var formattedData = "".codeUnits;
      await _getFromDatabase(startTime, endTime, sensor).then(
        (sensorData) =>
            {formattedData = formatData(sensor, sensorData, format)},
      );

      if (formattedData.isEmpty) return ExportResult.noSensorDataExisting;

      await writeFormattedData(fileName, format, formattedData);
    }

    return ExportResult.success;
  }

  /// Imports sensor data from a file (located at [path]).
  ///
  /// Therefore the corresponding file format is checked and if the format of
  /// data is supported (so format is contained in [SupportedFileFormat.values])
  /// the file is read and decoded.
  /// The decoding is includes also a validation, so it will be checked, whether
  /// data are correct formatted.
  ///
  /// Returns
  /// * [ImportResultStatus.fileDoNotExist] if there exist no file at [path]
  /// * [ImportResultStatus.fileFormatNotSupported] if the file at [path] have
  ///   not a supported file extension
  /// * [ImportResultStatus.noSensorDataExisting] if the list of [SensorData],
  ///   which was decoded is empty, indicating, that there was no data to decode
  ///   in the file
  /// * otherwise [ImportResultStatus.success].
  Future<ImportResultStatus> importSensorDataFromFile(String path) async {
    var file = File(path);

    if (!await file.exists()) {
      return ImportResultStatus.fileDoNotExist;
    }

    var format = _determineFileFormat(file.path);
    if (format == null) {
      return ImportResultStatus.fileFormatNotSupported;
    }

    var data = await file.readAsBytes();
    var importResult = await decodeSensorData(rawData: data, format: format);

    if (importResult.resultStatus != ImportResultStatus.success) {
      return importResult.resultStatus;
    }

    var decodedData = importResult.importedData!;

    if (decodedData.sensorData.isEmpty) {
      return ImportResultStatus.noSensorDataExisting;
    }

    // create buffer, write data into buffer and then flush data into database
    _bufferManager.addBuffer(decodedData.sensorId);
    for (var element in decodedData.sensorData) {
      await _processSensorData(element, decodedData.sensorId);
    }
    await flushToDatabase(decodedData.sensorId);
    _bufferManager.removeBuffer(decodedData.sensorId);

    return ImportResultStatus.success;
  }

  /// Determines the file extension of the file located at [filePath] and
  /// checks, whether this is a supported file format.
  ///
  /// If so, the corresponding [SupportedFileFormat] will be returned, otherwise
  /// null.
  SupportedFileFormat? _determineFileFormat(String filePath) {
    var extension = path.extension(filePath);
    switch (extension) {
      case ".csv":
        return SupportedFileFormat.csv;
      case ".json":
        return SupportedFileFormat.json;
      case ".xml":
        return SupportedFileFormat.xml;
      case ".xlsx":
        return SupportedFileFormat.xlsx;
      default:
        return null;
    }
  }
}
