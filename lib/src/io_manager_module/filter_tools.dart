import 'dart:math';
import 'package:sensing_plugin/sensing_plugin.dart';

///Base class of filter tools.
///
///This class is used for filtering Sensor data lists.
///It uses cascading functions to manipulate it's internal [_buffer].
class FilterTools {
  ///Constructor for Filter Tools.
  ///
  ///The [buffer] gets shallow copied into the internal [_buffer].
  ///The [_buffer] is used to do all filter options.
  FilterTools(List<SensorData> buffer) {
    //Assumes that we have a valid buffer with valid enties.
    _buffer.add(List.of(buffer));
    _precision = _buffer[0][0].maxPrecision;
  }

  ///Internal buffer that is used for every filter.
  ///
  ///At the end of each function, the buffer's
  ///first entry should always contain the full list,
  ///while all other entries should be empty.
  ///The reason why it's a list of lists is
  ///to split it into different intervals within each function.
  final List<List<SensorData>> _buffer = List.empty(growable: true);
  late final int _precision;

  ///Splits the fist entry of [_buffer] into equal [interval]s
  ///
  ///The startingpoint for the calculation is the first entry in
  ///the [_buffer]. After that, the fist entry of [_buffer] gets split
  ///into equal [interval]s, so each [interval] gets its own list.
  ///
  ///Example:
  ///
  ///If the number in the list would represent the a day, the split
  ///could look like this:
  ///[[1,2,3,4],] -> interval: 1 Day [[1,][2,][3,][4,],]
  ///
  ///This is still a very abstract example, but illustrates the functionality.
  void _splitBuffer(Duration interval) {
    if (interval.compareTo(Duration.zero) == 0) {
      return;
    }
    var tmpList = List<SensorData>.from(_buffer[0]);
    _buffer
      ..clear()
      ..add([]);
    var tmpDuration = Duration.zero;
    var intervalCount = interval;
    var bufferCounter = 0;
    for (var i = 0; i < tmpList.length - 1; i++) {
      //Checks if the current entry should be in an new list/interval
      if (tmpDuration < intervalCount) {
        _buffer[bufferCounter].add(tmpList[i]);
      } else {
        bufferCounter++;
        _buffer.add([]);
        _buffer[bufferCounter].add(tmpList[i]);
        intervalCount += interval;
      }
      tmpDuration += DateTime.fromMicrosecondsSinceEpoch(
        tmpList[i + 1].timestampInMicroseconds,
        isUtc: true,
      ).difference(
        DateTime.fromMicrosecondsSinceEpoch(
          tmpList[i].timestampInMicroseconds,
          isUtc: true,
        ),
      );
    }
    //Is used for the last entry in the list.
    if (tmpDuration < intervalCount) {
      _buffer[bufferCounter].add(tmpList.last);
    } else {
      _buffer
        ..add([])
        ..[bufferCounter + 1].add(tmpList.last);
    }
  }

  ///Flattens the [_buffer] again, that only the fist element of the list
  ///contains all data.
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

  ///Gets maximum of [_buffer] in given [interval] from [axis].
  void getMax({Duration interval = Duration.zero, int axis = 0}) {
    _splitBuffer(interval);
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      _buffer[currinterval] = <SensorData>[
        _buffer[currinterval].reduce(
          (current, next) =>
              (current.data[axis]! > next.data[axis]!) ? current : next,
        ),
      ];
    }
    _flattenBuffer();
  }

  ///Gets minimum of [_buffer] in given [interval] from [axis].
  void getMin({Duration interval = Duration.zero, int axis = 0}) {
    _splitBuffer(interval);
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      _buffer[currinterval] = <SensorData>[
        _buffer[currinterval].reduce(
          (current, next) =>
              (current.data[axis]! < next.data[axis]!) ? current : next,
        ),
      ];
    }
    _flattenBuffer();
  }

  ///Gets average of [_buffer] in given [interval].
  void getAvg({Duration interval = Duration.zero}) {
    _splitBuffer(interval);
    var axisAmount = _buffer[0][0].data.length;
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      var avgData = List<double>.generate(axisAmount, (index) => 0);
      var intervalLength = _buffer[currinterval].length;
      for (var currEntry = 0;
          currEntry < _buffer[currinterval].length;
          currEntry++) {
        for (var r = 0; r < axisAmount; r++) {
          avgData[r] += _buffer[currinterval][currEntry].data[r]!;
        }
      }
      for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
        avgData[currAxis] = double.parse(
          (avgData[currAxis] / intervalLength).toStringAsFixed(_precision),
        );
      }
      var lastEntry = _buffer[currinterval].last;
      var avgEntry = SensorData(
        data: avgData,
        maxPrecision: lastEntry.maxPrecision,
        timestampInMicroseconds: lastEntry.timestampInMicroseconds,
        unit: lastEntry.unit,
      );
      _buffer[currinterval]
        ..clear()
        ..add(avgEntry);
    }
    _flattenBuffer();
  }

  ///Gets sum of [_buffer] in given [interval].
  void getSum({Duration interval = Duration.zero}) {
    _splitBuffer(interval);
    var axisAmount = _buffer[0][0].data.length;
    for (var i = 0; i < _buffer.length; i++) {
      var sumData = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < _buffer[i].length; j++) {
        for (var r = 0; r < axisAmount; r++) {
          sumData[r] += _buffer[i][j].data[r]!;
        }
      }
      for (var r = 0; r < axisAmount; r++) {
        sumData[r] = double.parse(sumData[r].toStringAsFixed(_precision));
      }
      var lastEntry = _buffer[i].last;
      var sumEntry = SensorData(
        data: sumData,
        maxPrecision: lastEntry.maxPrecision,
        timestampInMicroseconds: lastEntry.timestampInMicroseconds,
        unit: lastEntry.unit,
      );
      _buffer[i]
        ..clear()
        ..add(sumEntry);
    }
    _flattenBuffer();
  }

  ///Gets amount of entries in [_buffer] in given [interval].
  List<int> getCount({Duration interval = Duration.zero}) {
    _splitBuffer(interval);
    var countList = <int>[];
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      countList.add(_buffer[currinterval].length);
    }
    _flattenBuffer();
    return countList;
  }

  ///Gets the entry appears most often at
  ///[axis] from [_buffer] in given [interval].
  void getMode({Duration interval = Duration.zero, int axis = 0}) {
    _splitBuffer(interval);
    var maxCount = 0;
    var modeData = <double?>[];
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      for (var currEntry = 0;
          currEntry < _buffer[currinterval].length;
          currEntry++) {
        var count = 0;
        for (var nextEntry = 0;
            nextEntry < _buffer[currinterval].length;
            nextEntry++) {
          if (_buffer[currinterval][currEntry].data[axis] ==
              _buffer[currinterval][nextEntry].data[axis]) {
            count++;
          }
        }
        if (count > maxCount) {
          maxCount = count;
          modeData = _buffer[currinterval][currEntry].data;
        }
      }
      var lastEntry = _buffer[currinterval].last;
      var modeEntry = SensorData(
        data: modeData,
        maxPrecision: lastEntry.maxPrecision,
        timestampInMicroseconds: lastEntry.timestampInMicroseconds,
        unit: lastEntry.unit,
      );
      _buffer[currinterval]
        ..clear()
        ..add(modeEntry);
    }
    _flattenBuffer();
  }

  ///Gets the difference between the highest and lowest value in [_buffer]
  ///in given [interval].
  void getRange({Duration interval = Duration.zero}) {
    _splitBuffer(interval);
    var axisAmount = _buffer[0][0].data.length;
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      var maxData =
          List<double>.generate(axisAmount, (index) => double.negativeInfinity);
      var minData =
          List<double>.generate(axisAmount, (index) => double.infinity);
      for (var currEntry = 0;
          currEntry < _buffer[currinterval].length;
          currEntry++) {
        for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
          if (maxData[currAxis] <
              _buffer[currinterval][currEntry].data[currAxis]!) {
            maxData[currAxis] =
                _buffer[currinterval][currEntry].data[currAxis]!;
          }
          if (minData[currAxis] >
              _buffer[currinterval][currEntry].data[currAxis]!) {
            minData[currAxis] =
                _buffer[currinterval][currEntry].data[currAxis]!;
          }
        }
      }
      var rangeData = List<double>.generate(axisAmount, (index) => 0);
      for (var j = 0; j < axisAmount; j++) {
        rangeData[j] = double.parse(
          (maxData[j] - minData[j]).abs().toStringAsFixed(_precision),
        );
      }
      var lastEntry = _buffer[currinterval].last;
      var rangeEntry = SensorData(
        data: rangeData,
        maxPrecision: lastEntry.maxPrecision,
        timestampInMicroseconds: lastEntry.timestampInMicroseconds,
        unit: lastEntry.unit,
      );
      _buffer[currinterval]
        ..clear()
        ..add(rangeEntry);
    }
    _flattenBuffer();
  }

  ///Gets median of [_buffer] in given [interval].
  void getMedian({Duration interval = Duration.zero}) {
    _splitBuffer(interval);
    var axisAmount = _buffer[0][0].data.length;
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      var medianData = <double>[];
      var tmpList = _buffer[currinterval];
      for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
        var tmpAxisData = <double>[];
        for (var currEntry = 0; currEntry < tmpList.length; currEntry++) {
          tmpAxisData.add(tmpList[currEntry].data[currAxis]!);
        }
        medianData.add(_calculateMedian(tmpAxisData));
      }
      var lastEntry = _buffer[currinterval].last;
      var medianEntry = SensorData(
        data: medianData,
        maxPrecision: lastEntry.maxPrecision,
        unit: lastEntry.unit,
        timestampInMicroseconds: lastEntry.timestampInMicroseconds,
      );
      _buffer[currinterval]
        ..clear()
        ..add(medianEntry);
    }
    _flattenBuffer();
  }

  ///Returns the standard deviation of [_buffer] in given [interval].
  void getSD({Duration interval = Duration.zero}) {
    var filter = FilterTools(_buffer[0])..getAvg(interval: interval);
    var averageList = filter.result();
    var axisAmount = _buffer[0][0].data.length;
    _splitBuffer(interval);
    for (var currinterval = 0; currinterval < _buffer.length; currinterval++) {
      var averageData = averageList[currinterval].data;
      var varianceList = List<double>.generate(axisAmount, (index) => 0);
      for (var currEntry = 0;
          currEntry < _buffer[currinterval].length;
          currEntry++) {
        for (var currAxis = 0; currAxis < axisAmount; currAxis++) {
          varianceList[currAxis] += (1 / _buffer[currinterval].length) *
              pow(
                averageData[currAxis]! -
                    _buffer[currinterval][currEntry].data[currAxis]!,
                2,
              );
        }
      }
      var sdData = varianceList.map(
        (e) => double.parse(
          sqrt(e).toStringAsFixed(_precision),
        ),
      );
      var lastEntry = _buffer[currinterval].last;
      var sdEntry = SensorData(
        data: sdData.toList(),
        maxPrecision: lastEntry.maxPrecision,
        unit: lastEntry.unit,
        timestampInMicroseconds: lastEntry.timestampInMicroseconds,
      );
      _buffer[currinterval]
        ..clear()
        ..add(sdEntry);
    }
    _flattenBuffer();
  }

  ///Returns result of querry.
  List<SensorData> result({Duration interval = Duration.zero}) {
    if (interval == Duration.zero) return _buffer[0];

    // select only values depending on the given [interval].
    _splitBuffer(interval);
    return _buffer.map((interValList) => interValList.first).toList();
  }
}
