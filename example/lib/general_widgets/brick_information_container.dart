import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'stylized_container.dart';

class BrickContainer extends StatelessWidget {
  final String headLine;
  final Icon icon;
  final double? width;
  final double? height;
  final Stream<SensorData> dataStream;
  final Function() onClick;
  const BrickContainer({
    super.key,
    required this.headLine,
    required this.icon,
    required this.onClick,
    this.height = 100,
    this.width = 100,
    required this.dataStream,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onClick,
        child: StylizedContainer(
          alignment: Alignment.center,
          width: width,
          height: height,
          child: _BrickInformation(
            headLine: headLine,
            icon: icon,
            dataStream: dataStream,
          ),
        ),
      );
}

class _BrickInformation extends StatefulWidget {
  final String headLine;
  final Icon icon;
  final Stream<SensorData> dataStream;

  const _BrickInformation({
    required this.headLine,
    required this.icon,
    required this.dataStream,
  });

  @override
  State<_BrickInformation> createState() => _BrickInformationState();
}

class _BrickInformationState extends State<_BrickInformation> {
  Duration lastUpdate = Duration.zero;
  DateTime lastTimeStamp = DateTime.now().toUtc();
  List<double?> mainData = [];
  _BrickInformationState() {
    widget.dataStream.listen((event) {
      setState(() {
        var tmpDateTime =
            DateTime.fromMicrosecondsSinceEpoch(event.timestampInMicroseconds);
        lastUpdate = tmpDateTime.difference(lastTimeStamp);
        lastTimeStamp = tmpDateTime;
        mainData = event.data;
      });
    }, onDone: () => {
      ///DO Done stuff
    });
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
