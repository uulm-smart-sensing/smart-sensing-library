import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

class SensorSettingsPage extends StatelessWidget {
  final SensorId _sensorId;

  const SensorSettingsPage({
    super.key,
    required SensorId sensorId,
  }) : _sensorId = sensorId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Sensor settings"),
        ),
        body: Center(
          child: Text("These are the sensor settings of ${_sensorId.name}"),
        ),
      );
}
