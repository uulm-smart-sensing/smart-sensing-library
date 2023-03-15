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

  ///Gets minimum of [_buffer] in given [intervall] from [axis].
  void getMin({Duration intervall = Duration.zero, int axis = 0}) {
    _splitBuffer(intervall);
    for (var i = 0; i < _buffer.length; i++) {
      _buffer[i] = <SensorData>[
        _buffer[i].reduce(
          (current, next) =>
              (current.getData()[axis] < next.getData()[axis]) ? current : next,
        ),
      ];
    }
    _flattenBuffer();
  }

  ///Gets average of [_buffer] in given [intervall].
  void getAvg({Duration intervall = Duration.zero}) {
    _splitBuffer(intervall);
    var axisAmount = _buffer[0][0].data.length;
    for (var i = 0; i < _buffer.length; i++) {
      var avgData = List<double>.generate(axisAmount, (index) => 0);
      var intervallLength = _buffer[i].length;
      for (var j = 0; j < _buffer[i].length; j++) {
        for (var r = 0; r < axisAmount; r++) {
          avgData[r] += _buffer[i][j].data[r];
        }
      }
      for (var j = 0; j < axisAmount; j++) {
        avgData[j] = avgData[j] / intervallLength;
      }
      var lastEntry = _buffer[i].last;
      var avgEntry = SensorData(
        data: avgData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[i]
        ..clear()
        ..add(avgEntry);
    }
    _flattenBuffer();
  }

  ///Gets sum of [_buffer] in given [intervall].
  void getSum({Duration intervall = Duration.zero}) {
    _splitBuffer(intervall);
    var axisAmount = _buffer[0][0].data.length;
    for (var i = 0; i < _buffer.length; i++) {
      var avgData = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < _buffer[i].length; j++) {
        for (var r = 0; r < axisAmount; r++) {
          avgData[r] += _buffer[i][j].data[r];
        }
      }
      var lastEntry = _buffer[i].last;
      var avgEntry = SensorData(
        data: avgData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[i]
        ..clear()
        ..add(avgEntry);
    }
    _flattenBuffer();
  }

  ///Gets amount of entries in [_buffer] in given [intervall].
  List<int> getCount({Duration intervall = Duration.zero}) {
    _splitBuffer(intervall);
    var countList = <int>[];
    for (var i = 0; i < _buffer.length; i++) {
      countList.add(_buffer[i].length);
    }
    _flattenBuffer();
    return countList;
  }
}
