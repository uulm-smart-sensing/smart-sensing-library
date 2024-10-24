import 'dart:collection';
import 'package:sensing_plugin/sensing_plugin.dart';

///Base class of BufferManager
class BufferManager {
  BufferManager._constructor();
  static final _instance = BufferManager._constructor();
  final HashMap _buffer = HashMap<SensorId, List<SensorData>>();

  ///Return instance of BufferManager
  factory BufferManager() => _instance;

  ///Adds a Buffer to the Manager
  void addBuffer(SensorId id) {
    if (_buffer[id] == null) {
      _buffer[id] = <SensorData>[];
    } else {
      throw Exception("Buffer already added.");
    }
  }

  ///Removes the Buffer with [id] from the Manager
  void removeBuffer(SensorId id) {
    _buffer.remove(id);
  }

  ///Returns the sorted buffer list with [id] from the Manager
  List<SensorData> getBuffer(SensorId id) {
    if (_buffer[id] != null) {
      _sortBuffer(id);
      return _buffer[id] as List<SensorData>;
    } else {
      throw InvalidBufferException("No such buffer.");
    }
  }

  ///Sorts the buffer with [id]
  void _sortBuffer(SensorId id) {
    (_buffer[id] as List<SensorData>).sort(_sortComparison);
  }

  ///Comparison method that compares Sensordata timestamp [a] with [b]
  int _sortComparison(SensorData a, SensorData b) =>
      a.timestamp.compareTo(b.timestamp);
}

///Custom exception for wrong buffer
class InvalidBufferException implements Exception {
  ///Cause message of Exception
  String cause;

  ///Constructor for exception.
  ///
  ///Takes [cause] as message for exception.
  InvalidBufferException(this.cause);
}
