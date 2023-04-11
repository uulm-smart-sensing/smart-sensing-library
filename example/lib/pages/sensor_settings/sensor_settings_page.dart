import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/blue_button.dart';
import '../../general_widgets/section_header.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import 'precision_slider.dart';

class SensorSettingsPage extends StatefulWidget {
  final SensorId sensorId;

  const SensorSettingsPage({
    super.key,
    required this.sensorId,
  });

  @override
  State<SensorSettingsPage> createState() => _SensorSettingsPageState();
}

class _SensorSettingsPageState extends State<SensorSettingsPage> {
  var selectedPrecision = 2;

  @override
  Widget build(BuildContext context) {
    var unitHeader = SectionHeader("devices");

    var unitSelection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BlueButton(title: "G"),
        BlueButton(title: "m/s^2"),
      ],
    );

    var precisionHeader = const Text(
      "Precision",
      style: TextStyle(
        fontSize: 24,
      ),
    );
    var precisionSelection = Container(

    );

    var timeIntervalHeader = SectionHeader("Time Interval (h:m:s)");
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
      subtitle: widget.sensorId.name,
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
