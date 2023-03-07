import 'dart:collection';
import 'sensor_data.dart';

///Base class of BufferManager
class BufferManager {
  BufferManager._constructor();
  static final _instance = BufferManager._constructor();
  final HashMap _buffer = HashMap<int, List<SensorData>>();

  ///Return instance of BufferManager
  factory BufferManager() => _instance;

  ///Adds a Buffer to the Manager
  void addBuffer(int id) {
    _buffer[id] = <SensorData>[];
  }

  ///Removes the Buffer with [id] from the Manager
  void removeBuffer(int id) {
    _buffer[id] = null;
  }

  ///Returns the sorted buffer list with [id] from the Manager
  List<SensorData> getBuffer(int id) {
    _sortBuffer(id);
    return _buffer[id] as List<SensorData>;
  }

  ///Sorts the buffer with [id]
  void _sortBuffer(int id) {
    (_buffer[id] as List<SensorData>).sort(_sortComparision);
  }

  ///Comparision method that compares Sensordata timestap [a] with [b]
  int _sortComparision(SensorData a, SensorData b) =>
      a.getDateTime().compareTo(b.getDateTime());
}
