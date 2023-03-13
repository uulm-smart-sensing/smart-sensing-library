import 'dart:collection';
// ignore: depend_on_referenced_packages
import 'package:sensing_plugin/sensing_plugin.dart';
import 'sensor_data.dart';


///Base class of BufferManager
class BufferManager {
  BufferManager._constructor();
  static final _instance = BufferManager._constructor();
  final HashMap _buffer = HashMap<SensorId, List<SensorData>>();

  ///Return instance of BufferManager
  factory BufferManager() => _instance;

  ///Adds a Buffer to the Manager
  void addBuffer(int id) {
    if (_buffer[id] == null) {
      _buffer[id] = <SensorData>[];
    } else {
      throw Exception("Buffer already added.");
    }
  }

  ///Removes the Buffer with [id] from the Manager
  void removeBuffer(int id) {
    _buffer.remove(id);
  }

  ///Returns the sorted buffer list with [id] from the Manager
  List<SensorData> getBuffer(int id) {
    if (_buffer[id] != null) {
      _sortBuffer(id);
      return _buffer[id] as List<SensorData>;
    } else {
      throw Exception("No such buffer.");
    }
  }

  ///Sorts the buffer with [id]
  void _sortBuffer(int id) {
    (_buffer[id] as List<SensorData>).sort(_sortComparision);
  }

  ///Comparision method that compares Sensordata timestap [a] with [b]
  int _sortComparision(SensorData a, SensorData b) =>
      a.getDateTime().compareTo(b.getDateTime());
}
