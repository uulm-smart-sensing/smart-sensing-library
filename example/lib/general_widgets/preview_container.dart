import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/filter_tools.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import '../filter_options.dart';
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
  final FilterOption filterOption;
  const PreviewContainer({
    super.key,
    this.duration = const Duration(seconds: 5),
    required this.id,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    this.mainDataFontSize = 15,
    this.headLineFontSize = 15,
    required this.filterOption,
  });
  @override
  State<StatefulWidget> createState() => _PreviewContainerState();
}

class _PreviewContainerState extends State<PreviewContainer> {
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
        var dataList = <SensorData>[];
        for (var i = 0; i < widget.filterOption.axisNumber; i++) {
          var filter = await IOManager().getFilterFrom(widget.id);
          dataList.addAll(
            _getFromFilter(widget.filterOption, filter, axis: i) ?? [],
          );
        }
        setState(() {
          data
            ..clear()
            ..addAll(dataList);
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
                Text(
                  widget.filterOption.shortText,
                  style: style,
                ),
                Expanded(
                  flex: 2,
                  child: mainData(
                    data: data,
                    style: style,
                    filterOption: widget.filterOption,
                  ),
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

Widget mainData({
  required List<SensorData> data,
  required TextStyle style,
  required FilterOption filterOption,
}) =>
    Row(
      children: data.isEmpty
          ? [const SizedBox.shrink()]
          : (data.length != 1
              ? _createWidgetList(data: data, style: style)
              : [_createDataText(data: data[0].data, style: style)]),
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
  int? axisNumber,
}) =>
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          axisNumber == null
              ? Align(
                  child: Text(
                    "Axis ${axisNumber!}",
                    style: style,
                  ),
                )
              : const SizedBox.shrink(),
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

List<SensorData>? _getFromFilter(
  FilterOption option,
  FilterTools? filterTool, {
  int axis = 0,
}) {
  switch (option) {
    case FilterOption.max:
      filterTool?.getMax(axis: axis);
      break;
    case FilterOption.min:
      filterTool?.getMin(axis: axis);
      break;
    case FilterOption.avg:
      filterTool?.getAvg();
      break;
    case FilterOption.sd:
      filterTool?.getSD();
      break;
  }
  return filterTool?.result();
}

List<Widget> _createWidgetList({
  required List<SensorData> data,
  required TextStyle style,
}) {
  var widgetList = <Widget>[];
  for (var i = 0; i < data.length; i++) {
    widgetList.add(
      _createDataText(
        data: data[i].data,
        style: style,
        axisNumber: i,
      ),
    );
  }
  return widgetList;
}
