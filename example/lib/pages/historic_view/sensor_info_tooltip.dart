import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../../general_widgets/stylized_container.dart';
import 'historic_view_page.dart';
import 'sensor_tooltip_data.dart';

/// This widget is used to display the [SensorInfo] and the current [Unit]
/// (using the [SensorConfig]) of the according sensor with the passed
/// [sensorId] on top of the [HistoricViewPage].
///
/// The following information is arranged in a table and displayed:
/// * [SensorId]
/// * [SensorInfo.unit] and [SensorConfig.targetUnit]
/// * [SensorInfo.accuracy]
/// * [SensorInfo.timeIntervalInMilliseconds]
class SensorInfoTooltip extends StatelessWidget {
  final SensorId sensorId;
  final SensorTooltipData? sensorInfoAndConfig;

  const SensorInfoTooltip({
    super.key,
    required this.sensorId,
    this.sensorInfoAndConfig,
  });

  @override
  Widget build(BuildContext context) {
    List<TableRow> tableRows;
    if (sensorInfoAndConfig == null) {
      tableRows = [
        _getSensorInfoRow("Sensor ID", formatPascalCase(sensorId.name)),
        _getSensorInfoRow("Unit", "No data"),
        _getSensorInfoRow("Accuracy", "No data"),
        _getSensorInfoRow("Time Interval (ms)", "No data"),
      ];
    } else {
      var defaultUnit =
          sensorInfoAndConfig!.sensorInfo.unit.toTextDisplay(isShort: true);
      var currentUnit = sensorInfoAndConfig!.sensorConfig.targetUnit
          .toTextDisplay(isShort: true);

      tableRows = [
        _getSensorInfoRow("Sensor ID", formatPascalCase(sensorId.name)),
        _getSensorInfoRow("Unit", "$currentUnit (default: $defaultUnit)"),
        _getSensorInfoRow(
          "Accuracy",
          sensorInfoAndConfig!.sensorInfo.accuracy.name,
        ),
        _getSensorInfoRow(
          "Time Interval (ms)",
          sensorInfoAndConfig!.sensorInfo.timeIntervalInMilliseconds.toString(),
        ),
      ];
    }

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
