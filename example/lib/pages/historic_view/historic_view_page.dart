import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'sensor_info_tooltip.dart';

class HistoricViewPage extends StatelessWidget {
  final SensorId _sensorId;

  const HistoricViewPage({
    super.key,
    required SensorId sensorId,
  }) : _sensorId = sensorId;

  @override
  Widget build(BuildContext context) {
    OverlayEntry? tooltipEntry;

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _capitalizeSensorName(_sensorId.name),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              "(in m/s^2, prec: 2)",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        GestureDetector(
          child: const SizedBox.square(
            dimension: 30,
            child: Icon(Icons.info),
          ),
          onTapDown: (details) {
            tooltipEntry = OverlayEntry(
              builder: (context) => const SensorInfoTooltip(),
            );
            return Overlay.of(context).insert(tooltipEntry!);
          },
          onTapUp: (details) {
            tooltipEntry?.remove();
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historic view"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          children: [
            header,
            const Divider(thickness: 2),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 12,
              ),
              decoration: const ShapeDecoration(
                shape: StadiumBorder(),
                color: Color.fromARGB(255, 38, 0, 80),
              ),
              child: const Text(
                "5 min | 1 h | 12 h | 2 d | 1 w",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String _capitalizeSensorName(String name) => name
    .split(RegExp("(?=[A-Z])"))
    .map(
      (word) =>
          word.characters.take(1).toUpperCase().join() +
          word.characters.skip(1).join(),
    )
    .join(" ");
