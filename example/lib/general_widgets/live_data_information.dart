import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

class _LiveDataInformation extends StatefulWidget {
  final SensorId id;
  const _LiveDataInformation({
   required this.id,
   });

  @override
  State<_LiveDataInformation> createState() => _LiveDataInformationState();
}

class _LiveDataInformationState extends State<_LiveDataInformation> {
  var style = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    fontFamily: "Ubuntu",
  );

  Duration lastUpdate = Duration.zero;
  DateTime lastTimeStamp = DateTime.now().toUtc();
  List<double?> mainData = [];
  Unit? unit;
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
        padding: const EdgeInsets.only(left: 16, right: 11, top: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.id.toString(),
                  style: style,
                ),
                const Spacer(),
                const Icon(Icons.abc) //TODO Stuff,
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
              style: style,
            ),
            Text(
              "Latest update:",
              style: style,
            ),
            Text(
              lastUpdate.toString(),
              style: style,
            ),
          ],
        ),
      );
}

String _fromData(List<double?> data, Unit unit) {
  var result = "";
  for (var element in data) {
    result +=
        ": ${element?.toStringAsFixed(3) ?? ""} ${_unitConverter(unit)}\n";
  }
  return result;
}

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
      return "";
  }
}