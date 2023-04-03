import 'package:flutter/material.dart';

class SensorInfoTooltip extends StatefulWidget {
  const SensorInfoTooltip({super.key});

  @override
  State<SensorInfoTooltip> createState() => _SensorInfoTooltipState();
}

class _SensorInfoTooltipState extends State<SensorInfoTooltip> {
  @override
  Widget build(BuildContext context) {
    var tooltipTextStyle = const TextStyle(
      color: Colors.white,
    );
    var horizontalPadding = 5.0;

    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 152, horizontal: 15),
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
                children: [
                  TableRow(
                    children: [
                      Text(
                        "Sensor ID:",
                        style: tooltipTextStyle,
                      ),
                      SizedBox(width: horizontalPadding),
                      Text(
                        "[Sensor ID]",
                        style: tooltipTextStyle,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        "Unit:",
                        style: tooltipTextStyle,
                      ),
                      SizedBox(width: horizontalPadding),
                      Text(
                        "[Unit]",
                        style: tooltipTextStyle,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        "Accuracy:",
                        style: tooltipTextStyle,
                      ),
                      SizedBox(width: horizontalPadding),
                      Text(
                        "[Accuracy]",
                        style: tooltipTextStyle,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        "Time Interval:",
                        style: tooltipTextStyle,
                      ),
                      SizedBox(width: horizontalPadding),
                      Text(
                        "[Time Interval]",
                        style: tooltipTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
