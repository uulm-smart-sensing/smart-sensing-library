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
  Duration lastUpdate = Duration.zero;
  DateTime lastTimeStamp = DateTime.now().toUtc();
  List<double?> mainData = [];
  @override
  void initState() {
    super.initState();
    widget.dataStream?.listen(
      (event) {
        setState(() {
          var tmpDateTime = DateTime.fromMicrosecondsSinceEpoch(
              event.timestampInMicroseconds);
          lastUpdate = tmpDateTime.difference(lastTimeStamp);
          lastTimeStamp = tmpDateTime;
          mainData = event.data;
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "Ubuntu",
                  ),
                ),
                const Spacer(),
                widget.icon,
              ],
            ),
            Text(_fromData(mainData)),
            const Text(
              "Latest update:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: "Ubuntu",
              ),
            ),
            Text(
              lastUpdate.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: "Ubuntu",
              ),
            ),
          ],
        ),
      );
}

String _fromData(List<double?> data) {
  var result = "";
  for (var element in data) {
    result += element?.toString() ?? "";
  }
  return result;
}
