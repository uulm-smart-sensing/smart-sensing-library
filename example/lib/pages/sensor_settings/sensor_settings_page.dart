import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/smart_sensing_appbar.dart';

class SensorSettingsPage extends StatelessWidget {
  final SensorId sensorId;

  const SensorSettingsPage({
    super.key,
    required this.sensorId,
  });

  @override
  Widget build(BuildContext context) {
    var unitHeader = const Text(
      "devices",
      style: TextStyle(
        fontSize: 24,
      ),
    );
    var unitSelection = Container(

    );

    var precisionHeader = const Text(
      "Precision",
      style: TextStyle(
        fontSize: 24,
      ),
    );
    var precisionSelection = Container(

    );

    var timeIntervalHeader = const Text(
      "Time Interval (h:m:s)",
      style: TextStyle(
        fontSize: 24,
      ),
    );
    var timeIntervalSelection = Container(
      // TODO: use time selection from demo maybe
    );

    var applyButton = Container(
      width: 100,
      height: 40,
      child: const Placeholder(),
    );

    return SmartSensingAppBar(
      title: "Sensor settings",
      // TODO: Capitalize
      subtitle: sensorId.name,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                unitHeader,
                unitSelection,
                precisionHeader,
                precisionSelection,
                timeIntervalHeader,
                timeIntervalSelection,
              ],
            ),
            applyButton,
          ],
        ),
      ),
    );
  }
}
