import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/section_header.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../utils.dart';
import 'precision_slider.dart';
import 'time_interval_selection_button.dart';

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
  late int selectedTimeInterval;

  @override
  Widget build(BuildContext context) {
    var unitHeader = SectionHeader("Unit");

    var unitSelection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomTextButton(text: "G", onPressed: () {}),
        CustomTextButton(text: "m/s^2", onPressed: () {}),
      ],
    );

    var precisionHeader = SectionHeader("Precision");
    var precisionSelection = PrecisionSlider(
      startValue: selectedPrecision,
      onChanged: (newValue) {
        selectedPrecision = newValue;
      },
    );

    var timeIntervalHeader = SectionHeader("Time Interval (m:s:ms)");
    var timeIntervalSelection = Center(
      child: TimeIntervalSelectionButton(
        sensorId: widget.sensorId,
        onChanged: (newValue) {
          selectedTimeInterval = newValue;
        },
      ),
    );

    var applyButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CustomTextButton(text: "Apply", onPressed: () {}),
    );

    return SmartSensingAppBar(
      title: "Sensor settings",
      subtitle: formatPascalCase(widget.sensorId.name),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
