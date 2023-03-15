import 'dart:math';
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

  double _calculateMedian(List<double> list) {
    double median;
    var middle = list.length ~/ 2;

    if (list.length.isOdd) {
      median = list[middle];
    } else {
      median = (list[middle - 1] + list[middle]) / 2.0;
    }
    return median;
  }

  ///Gets maximum of [_buffer] in given [intervall] from [axis].
  void getMax({Duration intervall = Duration.zero, int axis = 0}) {
    _splitBuffer(intervall);
    for (var i = 0; i < _buffer.length; i++) {
      _buffer[i] = <SensorData>[
        _buffer[i].reduce(
          (current, next) =>
              (current.data[axis] > next.data[axis]) ? current : next,
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
              (current.data[axis] < next.data[axis]) ? current : next,
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

  ///Gets the entry that happend the most at
  ///[axis] from [_buffer] in given [intervall].
  void getMode({Duration intervall = Duration.zero, int axis = 0}) {
    _splitBuffer(intervall);
    var maxCount = 0;
    var maxData = <double>[];
    for (var i = 0; i < _buffer.length; i++) {
      var count = 0;
      for (var j = 0; j < _buffer[i].length; j++) {
        for (var r = 0; r < _buffer[i].length; r++) {
          if (_buffer[i][j].data[axis] == _buffer[i][r].data[axis]) {
            count++;
          }
        }
        if (count > maxCount) {
          maxCount = count;
          maxData = _buffer[i][j].data;
        }
      }
      var lastEntry = _buffer[i].last;
      var modeEntry = SensorData(
        data: maxData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[i]
        ..clear()
        ..add(modeEntry);
    }
    _flattenBuffer();
  }

  ///Gets the difference between the highest and lowest value in [_buffer]
  ///with given [intervall].
  void getRange({Duration intervall = Duration.zero}) {
    _splitBuffer(intervall);
    var axisAmount = _buffer[0][0].data.length;
    for (var i = 0; i < _buffer.length; i++) {
      var maxData = List<double>.generate(axisAmount, (index) => 0);
      var minData = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < _buffer[i].length; j++) {
        for (var r = 0; r < axisAmount; r++) {
          if (maxData[r] < _buffer[i][j].data[r]) {
            maxData[r] = _buffer[i][j].data[r];
          }
          if (minData[r] > _buffer[i][j].data[r]) {
            minData[r] = _buffer[i][j].data[r];
          }
        }
      }
      var rangeData = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < axisAmount; j++) {
        rangeData[j] = (maxData[j] - minData[j]).abs();
      }
      var lastEntry = _buffer[i].last;
      var rangeEntry = SensorData(
        data: rangeData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[i]
        ..clear()
        ..add(rangeEntry);
    }
    _flattenBuffer();
  }

  ///Gets median of [_buffer] with given [intervall].
  void getMedian({Duration intervall = Duration.zero}) {
    _splitBuffer(intervall);
    var axisAmount = _buffer[0][0].data.length;
    for (var i = 0; i < _buffer.length; i++) {
      var medianData = <double>[];
      var tmpList = _buffer[i];
      for (var j = 0; j < axisAmount; j++) {
        var tmpAxisData = <double>[];
        for (var r = 0; r < tmpList.length; r++) {
          tmpAxisData.add(tmpList[r].data[j]);
        }
        medianData.add(_calculateMedian(tmpAxisData));
      }
      var lastEntry = _buffer[i].last;
      var medianEntry = SensorData(
        data: medianData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[i]
        ..clear()
        ..add(medianEntry);
    }
    _flattenBuffer();
  }

    ///Returns the standard deviation of [_buffer] in given [intervall].
  void getSD({Duration intervall = Duration.zero}) {
    var filter = FilterTools(_buffer[0])..getAvg(intervall: intervall);
    var averageList = filter.result();
    var axisAmount = _buffer[0][0].data.length;
    _splitBuffer(intervall);
    for (var i = 0; i < _buffer.length; i++) {
      var averageData = averageList[i].data;
      var varianceList = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < _buffer[i].length; j++) {
        for (var r = 0; r < axisAmount; r++) {
          varianceList[r] += (1 / _buffer[i].length) *
              pow(averageData[r] - _buffer[i][j].data[r], 2);
        }
      }
      var sdData = varianceList.map(sqrt);
      var lastEntry = _buffer[i].last;
      var sdEntry = SensorData(
        data: sdData.toList(),
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[i]
        ..clear()
        ..add(sdEntry);
    }
    _flattenBuffer();
  }

  ///Returns result of querry.
  List<SensorData> result() => _buffer[0];

}
