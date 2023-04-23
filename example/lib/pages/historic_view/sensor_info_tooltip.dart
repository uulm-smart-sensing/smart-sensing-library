import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../../general_widgets/stylized_container.dart';
import 'historic_view_page.dart';

/// This widget is used to display the [SensorInfo] of the according sensor with
/// the passed [sensorId] on top of the [HistoricViewPage].
///
/// The following information is arranged in a table and displayed:
/// * [SensorId]
/// * [SensorInfo.unit]
/// * [SensorInfo.accuracy]
/// * [SensorInfo.timeIntervalInMilliseconds]
class SensorInfoTooltip extends StatelessWidget {
  final SensorId sensorId;
  final SensorInfo sensorInfo;

  const SensorInfoTooltip({
    super.key,
    required this.sensorId,
    required this.sensorInfo,
  });

  @override
  Widget build(BuildContext context) {
    var tableRows = [
      _getSensorInfoRow("Sensor ID", formatPascalCase(sensorId.name)),
      _getSensorInfoRow("Unit", formatPascalCase(sensorInfo.unit.name)),
      _getSensorInfoRow("Accuracy", formatPascalCase(sensorInfo.accuracy.name)),
      _getSensorInfoRow(
        "Time Interval (ms)",
        sensorInfo.timeIntervalInMilliseconds.toString(),
      ),
    ];

    return StylizedContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: FlexColumnWidth(),
          },
          children: tableRows,
        ),
      ),
    );
  }
}

TableRow _getSensorInfoRow(String title, String value) => TableRow(
      children: [
        Text("$title:"),
        const SizedBox(width: 5),
        Text(value),
      ],
    );
