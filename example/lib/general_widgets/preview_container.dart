import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/filter_tools.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import '../filter_options.dart';
import '../formatter/text_formatter.dart';
import '../theme.dart';
import 'brick_container.dart';

/// Creates a preview for the given [filterOption].
///
/// The created preview shows all relevant axes form the data.
/// E.g. the maximum filter shows the maximum of all three axes,
/// while the average shows only one:
///
/// Max ->
/// ```
/// Axis 1    Axis 2    Axis 3
///    1         1         1
///    2         2         2
///    3         3         3
/// ```
///
/// Avg ->
/// ```
/// Axis 1
///    1
///    2
///    3
/// ```
class PreviewContainer extends StatefulWidget {
  final SensorId sensorId;
  final EdgeInsets padding;
  final double mainDataFontSize;
  final double headLineFontSize;
  final Duration duration;
  final FilterOption filterOption;
  const PreviewContainer({
    super.key,
    this.duration = const Duration(seconds: 5),
    required this.sensorId,
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
    //Creates the timer that periodically gets updated.
    timer = Timer.periodic(
      widget.duration,
      (t) async {
        if (mounted) {
          var dataList = <SensorData>[];
          for (var i = 0; i < widget.filterOption.axisNumber; i++) {
            var filter = await IOManager().getFilterFrom(widget.sensorId);
            if (filter != null) {
              dataList.addAll(
                _getFromFilter(widget.filterOption, filter, axis: i) ?? [],
              );
            }
          }
          setState(() {
            data
              ..clear()
              ..addAll(dataList);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget internalText() => Padding(
        padding: widget.padding,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                sensorIdToIcon[widget.sensorId],
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
                    formatPascalCase(widget.sensorId.name),
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
        width: 300,
        color: sensorIdToColor[widget.sensorId],
        child: internalText(),
      );
}

/// Creates the main data inside this widget.
///
/// If no data is loaded at the moment, the content is empty.
Widget mainData({
  required List<SensorData> data,
  required TextStyle style,
  required FilterOption filterOption,
}) =>
    Row(
      children: data.isEmpty
          ? [
              Text(
                "Data is loading.",
                style: style,
              ),
            ]
          : (data.length != 1
              ? _createWidgetList(data: data, style: style)
              : [
                  _createDataText(
                    data: data[0].data,
                    style: style,
                    unit: data[0].unit,
                  )
                ]),
    );

/// Transforms [data] into a usable [String] format for [PreviewContainer].
String _createStringFromData(List<double?> data, Unit unit) {
  var values = data.whereType<double>().toList();
  if (values.isEmpty) {
    return "No Data";
  }
  return values
      .map(
        (value) => "${value.toStringAsFixed(3)} "
            "${unit.toTextDisplay(isShort: true)}",
      )
      .join("\n");
}

/// Creates a flexible [Text] with the data given.
Widget _createDataText({
  required List<double?> data,
  required Unit unit,
  required TextStyle style,
  int? axisNumber,
}) =>
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          axisNumber != null
              ? Align(
                  child: Text(
                    _fromAxisNumberToAxis(axisNumber),
                    style: style,
                  ),
                )
              : const SizedBox.shrink(),
          Align(
            child: Text(
              _createStringFromData(data, unit),
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
        ],
      ),
    );

/// Returns the filtered data from given [option].
List<SensorData>? _getFromFilter(
  FilterOption option,
  FilterTools filterTool, {
  int axis = 0,
}) {
  switch (option) {
    case FilterOption.max:
      filterTool.getMax(axis: axis);
      break;
    case FilterOption.min:
      filterTool.getMin(axis: axis);
      break;
    case FilterOption.avg:
      filterTool.getAvg();
      break;
    case FilterOption.sd:
      filterTool.getSD();
      break;
    case FilterOption.mode:
      filterTool.getMode(axis: axis);
      break;
    case FilterOption.range:
      filterTool.getRange();
      break;
    case FilterOption.median:
      filterTool.getMedian();
      break;
    case FilterOption.sum:
      filterTool.getSum();
      break;
  }
  return filterTool.result();
}

/// Translates [number] to corresponding axes X, Y or Z.
String _fromAxisNumberToAxis(int number) {
  switch (number) {
    case 0:
      return 'X';
    case 1:
      return 'Y';
    case 2:
      return 'Z';
  }
  return 'X';
}

/// Creates a list for each [data] given.
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
        unit: data[i].unit,
      ),
    );
  }
  return widgetList;
}
