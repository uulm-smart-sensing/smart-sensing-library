import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../theme.dart';

///This widget shows live sensor data with form the given [SensorId].
///
///Data is shown in a [Column] with a correspoing Icon on the top left.
///This widget shows the live data and the time since the last update.
///Padding can be ajusted between Items and for the [Column] itself.
///Internal Text can be ajusted with [style]
class LiveDataInformation extends StatefulWidget {
  final SensorId id;
  final TextStyle? style;
  final EdgeInsets? padding;
  final EdgeInsets? paddingBetweenitems;
  const LiveDataInformation({
    super.key,
    required this.id,
    this.style,
    this.padding,
    this.paddingBetweenitems,
  });

  @override
  State<LiveDataInformation> createState() => _LiveDataInformationState();
}

class _LiveDataInformationState extends State<LiveDataInformation> {
  var style = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: Colors.black,
  );

  Duration lastUpdate = Duration.zero;
  DateTime lastTimeStamp = DateTime.now().toUtc();
  List<double?> mainData = [];
  Unit? unit;

  ///Gets the corresponding data stream of [SensorId]
  ///and updates the internal data.
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
  Widget build(BuildContext context) => Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _sensorIdConverter(widget.id),
                  style: widget.style ?? style,
                ),
                const Spacer(),
                sensorIdToIcon[widget.id]!,
              ],
            ),
            Text(
              () {
                var string = _fromData(mainData, unit ?? Unit.unitless);
                if (string.isNotEmpty) {
                  return string;
                }
                return "No Data";
              }(),
              style: widget.style ?? style,
              textAlign: TextAlign.left,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Latest update:",
                style: widget.style ?? style,
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              lastUpdate
                  .toString()
                  .substring(3, lastUpdate.toString().length - 3),
              style: widget.style ?? style,
            ),
          ]
              .map(
                (e) => Padding(
                  padding: widget.paddingBetweenitems ?? EdgeInsets.zero,
                  child: e,
                ),
              )
              .toList(),
        ),
      );
}
///Converts the main data to a readable string for the widget.
String _fromData(List<double?> data, Unit unit) {
  var result = "";
  for (var element in data) {
    result += "${element?.toStringAsFixed(3) ?? ""} ${_unitConverter(unit)}\n";
  }
  if (result.isEmpty) {
    return result;
  }
  return result.substring(0, result.length - 2);
}
///Converts the [Unit] enum to the corresponing unit string.
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
///Converts the [SensorId] enum to the corresponing name string.
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
