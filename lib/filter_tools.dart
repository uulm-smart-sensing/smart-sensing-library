import 'dart:math';
import 'sensor_data.dart';

///Base class of filter tools.
class FilterTools {
  ///Constructor for Filter Tools.
  FilterTools(List<SensorData> buffer) {
    _buffer.add(List.of(buffer));
    _precision = _buffer[0][0].maxPrecision;
  }
  final List<List<SensorData>> _buffer = List.empty(growable: true);
  late final int _precision;

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
    list.sort((a, b) => a.compareTo(b));

    if (list.length.isOdd) {
      median = list[middle];
    } else {
      median = double.parse(
        ((list[middle - 1] + list[middle]) / 2.0).toStringAsFixed(_precision),
      );
    }
    return median;
  }

  ///Gets maximum of [_buffer] in given [intervall] from [axis].
  void getMax({Duration intervall = Duration.zero, int axis = 0}) {
    _splitBuffer(intervall);
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      _buffer[currIntervall] = <SensorData>[
        _buffer[currIntervall].reduce(
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
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      _buffer[currIntervall] = <SensorData>[
        _buffer[currIntervall].reduce(
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
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      var avgData = List<double>.generate(axisAmount, (index) => 0);
      var intervallLength = _buffer[currIntervall].length;
      for (var currEntry = 0;
          currEntry < _buffer[currIntervall].length;
          currEntry++) {
        for (var r = 0; r < axisAmount; r++) {
          avgData[r] += _buffer[currIntervall][currEntry].data[r];
        }
      }
      for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
        avgData[currAxis] = double.parse(
          (avgData[currAxis] / intervallLength).toStringAsFixed(_precision),
        );
      }
      var lastEntry = _buffer[currIntervall].last;
      var avgEntry = SensorData(
        data: avgData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[currIntervall]
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
      var sumData = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < _buffer[i].length; j++) {
        for (var r = 0; r < axisAmount; r++) {
          sumData[r] += _buffer[i][j].data[r];
        }
      }
      for (var r = 0; r < axisAmount; r++) {
        sumData[r] = double.parse(sumData[r].toStringAsFixed(_precision));
      }
      var lastEntry = _buffer[i].last;
      var avgEntry = SensorData(
        data: sumData,
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
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      countList.add(_buffer[currIntervall].length);
    }
    _flattenBuffer();
    return countList;
  }

  ///Gets the entry appears most often at
  ///[axis] from [_buffer] in given [intervall].
  void getMode({Duration intervall = Duration.zero, int axis = 0}) {
    _splitBuffer(intervall);
    var maxCount = 0;
    var modeData = <double>[];
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      var count = 0;
      for (var currEntry = 0;
          currEntry < _buffer[currIntervall].length;
          currEntry++) {
        for (var nextEntry = 0;
            nextEntry < _buffer[currIntervall].length;
            nextEntry++) {
          if (_buffer[currIntervall][currEntry].data[axis] ==
              _buffer[currIntervall][nextEntry].data[axis]) {
            count++;
          }
        }
        if (count > maxCount) {
          maxCount = count;
          modeData = _buffer[currIntervall][currEntry].data;
        }
      }
      var lastEntry = _buffer[currIntervall].last;
      var modeEntry = SensorData(
        data: modeData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[currIntervall]
        ..clear()
        ..add(modeEntry);
    }
    _flattenBuffer();
  }

  ///Gets the difference between the highest and lowest value in [_buffer]
  ///in given [intervall].
  void getRange({Duration intervall = Duration.zero}) {
    _splitBuffer(intervall);
    var axisAmount = _buffer[0][0].data.length;
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      var maxData =
          List<double>.generate(axisAmount, (index) => double.negativeInfinity);
      var minData =
          List<double>.generate(axisAmount, (index) => double.infinity);
      for (var currEntry = 0;
          currEntry < _buffer[currIntervall].length;
          currEntry++) {
        for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
          if (maxData[currAxis] <
              _buffer[currIntervall][currEntry].data[currAxis]) {
            maxData[currAxis] =
                _buffer[currIntervall][currEntry].data[currAxis];
          }
          if (minData[currAxis] >
              _buffer[currIntervall][currEntry].data[currAxis]) {
            minData[currAxis] =
                _buffer[currIntervall][currEntry].data[currAxis];
          }
        }
      }
      var rangeData = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < axisAmount; j++) {
        rangeData[j] = double.parse(
          (maxData[j] - minData[j]).abs().toStringAsFixed(_precision),
        );
      }
      var lastEntry = _buffer[currIntervall].last;
      var rangeEntry = SensorData(
        data: rangeData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[currIntervall]
        ..clear()
        ..add(rangeEntry);
    }
    _flattenBuffer();
  }

  ///Gets median of [_buffer] in given [intervall].
  void getMedian({Duration intervall = Duration.zero}) {
    _splitBuffer(intervall);
    var axisAmount = _buffer[0][0].data.length;
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      var medianData = <double>[];
      var tmpList = _buffer[currIntervall];
      for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
        var tmpAxisData = <double>[];
        for (var currEntry = 0; currEntry < tmpList.length; currEntry++) {
          tmpAxisData.add(tmpList[currEntry].data[currAxis]);
        }
        medianData.add(_calculateMedian(tmpAxisData));
      }
      var lastEntry = _buffer[currIntervall].last;
      var medianEntry = SensorData(
        data: medianData,
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[currIntervall]
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
    for (var currIntervall = 0;
        currIntervall < _buffer.length;
        currIntervall++) {
      var averageData = averageList[currIntervall].data;
      var varianceList = List<double>.generate(axisAmount, (index) => 0);
      for (var currEntry = 0;
          currEntry < _buffer[currIntervall].length;
          currEntry++) {
        for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
          varianceList[currAxis] += (1 / _buffer[currIntervall].length) *
              pow(
                  averageData[currAxis] -
                      _buffer[currIntervall][currEntry].data[currAxis],
                  2,);
        }
      }
      var sdData = varianceList.map(
        (e) => double.parse(
          sqrt(e).toStringAsFixed(_precision),
        ),
      );
      var lastEntry = _buffer[currIntervall].last;
      var sdEntry = SensorData(
        data: sdData.toList(),
        maxPrecision: lastEntry.maxPrecision,
        sensorID: lastEntry.sensorID,
        setTime: lastEntry.dateTime,
      );
      _buffer[currIntervall]
        ..clear()
        ..add(sdEntry);
    }
    _flattenBuffer();
  }

  ///Returns result of querry.
  List<SensorData> result() => _buffer[0];
}
