import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

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
      _getSensorInfoRow("Sensor ID", sensorId.name),
      _getSensorInfoRow("Unit", sensorInfo.unit.name),
      _getSensorInfoRow("Accuracy", sensorInfo.accuracy.name),
      _getSensorInfoRow(
        "Time Interval (ms)",
        sensorInfo.timeIntervalInMilliseconds.toString(),
      ),
    ];

    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 38, 0, 80),
          ),
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
        ),
      ),
    );
  }
}

TableRow _getSensorInfoRow(String title, String value) => TableRow(
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
