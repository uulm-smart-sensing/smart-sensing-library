import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../theme.dart';

/// This widget shows live sensor data with form the given [SensorId].
///
/// Data is shown in a [Column] with a correspoing Icon on the top right.
/// [padding] is the outside padding of the widget.
/// Widget should be wrapped e.g. by a [Container].
/// Base padding is
/// ```dart
/// EdgeInsets.symmetric(vertical: 10, horizontal: 15)
/// ```
class LiveDataInformation extends StatefulWidget {
  final SensorId id;
  final EdgeInsets? padding;
  const LiveDataInformation({
    super.key,
    required this.id,
    this.padding,
  });

  @override
  State<LiveDataInformation> createState() => _LiveDataInformationState();
}

class _LiveDataInformationState extends State<LiveDataInformation> {
  Duration lastUpdate = Duration.zero;
  DateTime lastTimeStamp = DateTime.now().toUtc();
  List<double?> mainData = [];
  Unit? unit;

  /// Gets the corresponding data stream of [SensorId]
  /// and updates the internal data.
  @override
  void initState() {
    super.initState();
    IOManager().getSensorStream(widget.id)?.listen(
      (event) {
        setState(() {
          var tmpDateTime = DateTime.fromMicrosecondsSinceEpoch(
            event.timestampInMicroseconds,
          );
          lastUpdate = tmpDateTime.difference(lastTimeStamp);
          lastTimeStamp = tmpDateTime;
          mainData = event.data;
          unit ??= event.unit;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: widget.padding ??
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _sensorIdConverter(widget.id),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: sensorIdToIcon[widget.id],
                  ),
                ],
              ),
              Expanded(
                child: _mainDataText(mainData, unit),
              ),
              _updateText(lastUpdate),
            ],
          ),
        ),
      );
}

/// Converts the main data to a readable string for the widget.
String _fromData(List<double?> data, Unit unit) {
  var result = "";
  for (var element in data) {
    result += "${element?.toStringAsFixed(0) ?? ""} ${_unitConverter(unit)}\n";
  }
  if (result.isEmpty) {
    return "No Data";
  }
  return result.substring(0, result.length - 1);
}

/// Converts the [Unit] enum to the corresponing unit string.
String _unitConverter(Unit unit) {
  switch (unit) {
    case Unit.metersPerSecondSquared:
      return "m/s²";
    case Unit.gravitationalForce:
      return "N";
    case Unit.radiansPerSecond:
      return "rad/s";
    case Unit.degreesPerSecond:
      return "deg/s";
    case Unit.microTeslas:
      return "µT";
    case Unit.radians:
      return "rad";
    case Unit.degrees:
      return "deg";
    case Unit.hectoPascal:
      return "hPa";
    case Unit.kiloPascal:
      return "kPa";
    case Unit.bar:
      return "bar";
    case Unit.celsius:
      return "°C";
    case Unit.fahrenheit:
      return "°F";
    case Unit.kelvin:
      return "K";
    case Unit.unitless:
    default:
      return "";
  }
}

/// Converts the [SensorId] enum to the corresponing name string.
String _sensorIdConverter(SensorId id) {
  switch (id) {
    case SensorId.accelerometer:
      return "Accelerometer";
    case SensorId.gyroscope:
      return "Gyroscope";
    case SensorId.magnetometer:
      return "Magnetometer";
    case SensorId.orientation:
      return "Orientation";
    case SensorId.linearAcceleration:
      return "LinearAcceleration";
    case SensorId.barometer:
      return "Barometer";
    case SensorId.thermometer:
      return "Thermometer";
    default:
      return "Not Implemented yet";
  }
}

double _mainDataSize(int rows) {
  if (rows > 1) {
    return 10;
  }
  return 16;
}

/// Creates the [Text] widget for the main data block.
/// Is responsive if there is only one data Point or many.
Widget _mainDataText(List<double?> data, Unit? unit) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          _fromData(data, unit ?? Unit.unitless),
          style: TextStyle(
            fontSize: _mainDataSize(data.length),
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

/// Creates the [Text] widget for the update block.
Widget _updateText(Duration lastUpdate) => Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: "Last update: \n   ${lastUpdate.toString().substring(
                2,
                lastUpdate.toString().length - 3,
              )}",
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
