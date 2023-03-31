import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

class HistoricViewPage extends StatelessWidget {
  final SensorId _sensorId;

  const HistoricViewPage({
    super.key,
    required SensorId sensorId,
  }) : _sensorId = sensorId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Historic view"),
        ),
        body: Center(
          child: Text("This is the historic view of ${_sensorId.name}"),
        ),
      );
}
