import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'stylized_container.dart';

class BrickLiveInformationContainer extends StatelessWidget {
  final String headLine;
  final Icon icon;
  final double? width;
  final double? height;
  final Stream<SensorData> dataStream;
  final Function() onClick;
  final Function()? onDone;

  const BrickLiveInformationContainer({
    super.key,
    required this.headLine,
    required this.icon,
    required this.onClick,
    this.height = 100,
    this.width = 100,
    required this.dataStream,
    this.onDone,
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
            onDone: onDone,
          ),
        ),
      );
}

class _BrickLiveInformation extends StatefulWidget {
  final String headLine;
  final Icon icon;
  final Stream<SensorData> dataStream;
  final Function()? onDone;
  const _BrickLiveInformation({
    required this.headLine,
    required this.icon,
    required this.dataStream,
    this.onDone,
  });

  @override
  State<_BrickLiveInformation> createState() => _BrickLiveInformationState();
}

class _BrickLiveInformationState extends State<_BrickLiveInformation> {
  Duration lastUpdate = Duration.zero;
  DateTime lastTimeStamp = DateTime.now().toUtc();
  List<double?> mainData = [];
  _BrickLiveInformationState() {
    widget.dataStream.listen((event) {
      setState(() {
        var tmpDateTime =
            DateTime.fromMicrosecondsSinceEpoch(event.timestampInMicroseconds);
        lastUpdate = tmpDateTime.difference(lastTimeStamp);
        lastTimeStamp = tmpDateTime;
        mainData = event.data;
      });
    }, onDone: widget.onDone,
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [Text(widget.headLine), widget.icon],
          ),
          Text(_fromData(mainData)),
          const Text("Latest update:"),
          Text(lastUpdate.toString()),
        ],
      );
}

String _fromData(List<double?> data){
  var result = "";
  for (var element in data) {
   result += element?.toString() ?? "";
  }
  return result;
}
