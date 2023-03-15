import 'sensor_data.dart';

///Base class of filter tools.
class FilterTools {
  ///Constructor for Filter Tools.
  FilterTools(List<SensorData> buffer) {
    _buffer.add(List.of(buffer));
  }
  final List<List<SensorData>> _buffer = List.empty(growable: true);

  ///Splits the [_buffer] into equal [intervall]s
  ///
  ///The startingpoint is for the calculation is the first entry in
  ///the [_buffer].
  void _splitBuffer(Duration intervall) {
    if (intervall.compareTo(Duration.zero) == 0) {
      return;
    }
    var tmpList = List<SensorData>.from(_buffer[0]);
    _buffer
      ..clear()
      ..add([]);
    var tmpDuration = Duration.zero;
    var intervallCount = intervall;
    var bufferCounter = 0;
    for (var i = 0; i < tmpList.length - 1; i++) {
      if (tmpDuration < intervallCount) {
        _buffer[bufferCounter].add(tmpList[i]);
      } else {
        bufferCounter++;
        _buffer.add([]);
        _buffer[bufferCounter].add(tmpList[i]);
        intervallCount += intervall;
      }
      tmpDuration += tmpList[i + 1].dateTime.difference(tmpList[i].dateTime);
    }
    if (tmpDuration < intervallCount) {
      _buffer[bufferCounter].add(tmpList.last);
    } else {
      _buffer
        ..add([])
        ..[bufferCounter + 1].add(tmpList.last);
    }
  }

  void _flattenBuffer() {
    var tmpList = _buffer.expand((element) => element).toList();
    _buffer
      ..clear()
      ..add(tmpList);
  }

 ///Gets maximum of [_buffer] in given [intervall] from [axis].
  void getMax({Duration intervall = Duration.zero, int axis = 0}) {
    _splitBuffer(intervall);
    for (var i = 0; i < _buffer.length; i++) {
      _buffer[i] = <SensorData>[
        _buffer[i].reduce(
          (current, next) =>
              (current.getData()[axis] > next.getData()[axis]) ? current : next,
        ),
      ];
    }
    _flattenBuffer();
  }



}
