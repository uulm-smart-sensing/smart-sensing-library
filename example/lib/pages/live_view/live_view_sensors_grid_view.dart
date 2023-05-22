import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'live_view_sensor_widget.dart';

class LiveViewSensorsGridView extends StatelessWidget {
  final List<SensorId> sensorIds;

  const LiveViewSensorsGridView({super.key, required this.sensorIds});

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        physics: const BouncingScrollPhysics(),
        children: sensorIds
            .map(
              (id) => Padding(
                padding: const EdgeInsets.all(12),
                child: LiveViewSensorWidget(
                  key: ValueKey(id),
                  sensorId: id,
                ),
              ),
            )
            .toList(),
      );
}
