import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import '../formatter/text_formatter.dart';
import '../theme.dart';
import '../unit_string_representation.dart';
import 'brick_container.dart';

class PreviewContainer extends StatefulWidget {
  final SensorId id;
  final EdgeInsets padding;
  final double mainDataFontSize;
  final double headLineFontSize;
  final Duration duration;
  const PreviewContainer({
    super.key,
    this.duration = const Duration(seconds: 5),
    required this.id,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    this.mainDataFontSize = 15,
    this.headLineFontSize = 15,
  });
  @override
  State<StatefulWidget> createState() => _PreviewContainerState();
}

class _PreviewContainerState extends State<PreviewContainer> {
  int counter = 0;
  late Timer timer;
  var data = <SensorData>[];
  var style = const TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      widget.duration,
      (t) async {
        var filterMax = await IOManager().getFilterFrom(widget.id);
        var filterMin = await IOManager().getFilterFrom(widget.id);
        var filterAvg = await IOManager().getFilterFrom(widget.id);
        setState(() {
          data.clear();
          filterMax?.getMax();
          filterMin?.getMin();
          filterAvg?.getAvg();
          data
            ..add(filterMax!.result()[0])
            ..add(filterMin!.result()[0])
            ..add(filterAvg!.result()[0]);
          counter++;
        });
      },
    );
  }

  Widget internalText() => Padding(
        padding: widget.padding,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                sensorIdToIcon[widget.id],
                size: 15,
                color: Colors.black,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    formatPascalCase(widget.id.name),
                    style: TextStyle(
                      fontSize: widget.headLineFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: mainData(data, style),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => BrickContainer(
        width: 250,
        child: internalText(),
      );
}

Widget mainData(List<SensorData> data, TextStyle style) => Row(
      children: [
        data.isEmpty
            ? const SizedBox.shrink()
            : _createDataText(data: data[0].data, style: style),
        data.isEmpty
            ? const SizedBox.shrink()
            : _createDataText(data: data[0].data, style: style),
        data.isEmpty
            ? const SizedBox.shrink()
            : _createDataText(data: data[0].data, style: style),
      ],
    );

String createStringFromData(List<double?> data, Unit unit) {
  var values = data.whereType<double>().toList();

  if (values.isEmpty) {
    return "No Data";
  }
  return values
      .map(
        (value) => "${value.toStringAsFixed(3)} "
            "${unitToUnitStringRepresentation[unit]}",
      )
      .join("\n");
}


Widget _createDataText({
  required List<double?> data,
  Unit unit = Unit.metersPerSecondSquared,
  required TextStyle style,
}) =>
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            child: Text(
              "Max",
              style: style,
            ),
          ),
          Align(
            child: Text(
              createStringFromData(data, unit),
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
        ],
      ),
    );
