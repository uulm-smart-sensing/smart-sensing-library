import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'stylized_container.dart';

class BrickLiveInformationContainer extends StatelessWidget {
  final String headLine;
  final Icon icon;
  final double? width;
  final double? height;
  final Stream<SensorData>? dataStream;
  final Function() onClick;

  const BrickLiveInformationContainer({
    super.key,
    required this.headLine,
    required this.icon,
    required this.onClick,
    this.height = 150,
    this.width = 150,
    required this.dataStream,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onClick,
        child: StylizedContainer(
          alignment: Alignment.center,
          width: width,
          height: height,
          child: _BrickLiveInformation(
            headLine: headLine,
            icon: icon,
            dataStream: dataStream,
          ),
        ),
      );
}

class _BrickLiveInformation extends StatefulWidget {
  final String headLine;
  final Icon icon;
  final Stream<SensorData>? dataStream;
  const _BrickLiveInformation({
    required this.headLine,
    required this.icon,
    required this.dataStream,
  });

  @override
  State<_BrickLiveInformation> createState() => _BrickLiveInformationState();
}

class _BrickLiveInformationState extends State<_BrickLiveInformation> {
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
    widget.dataStream?.listen(
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
                  widget.headLine,
                  style: style,
                ),
                const Spacer(),
                widget.icon,
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
