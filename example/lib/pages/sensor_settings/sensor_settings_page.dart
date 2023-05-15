import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/section_header.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../sensor_default_target_unit.dart';
import 'precision_slider.dart';
import 'time_interval_selection_button.dart';
import 'unit_selection_button.dart';

/// Page to configure the sensor with the passed [sensorId].
///
/// The settings which can be configured are:
/// * target unit of sensor data
/// * target precision of sensor data
/// * time interval of sensor update events
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
  late int selectedPrecision;
  late int selectedTimeIntervalInMilliseconds;
  late Unit selectedUnit;

  @override
  void initState() {
    // TODO: Make call to smart sensing library to initialize values
    selectedPrecision = 2;
    selectedTimeIntervalInMilliseconds = 100;
    selectedUnit = sensorIdToDefaultTargetUnit[widget.sensorId]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var unitHeader = SectionHeader("Unit");

    var units = sensorIdToUnitCategory[widget.sensorId]!;
    var unitSelection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: units.map(_getUnitSelectionButtonFromUnit).toList(),
    );

    var precisionHeader = SectionHeader("Precision");
    var precisionSelection = PrecisionSlider(
      startValue: selectedPrecision,
      onChanged: (newValue) {
        selectedPrecision = newValue;
      },
    );

    var timeIntervalHeader = SectionHeader(
      "Time Interval (m : s : ms)",
    );
    var timeIntervalSelection = Center(
      child: TimeIntervalSelectionButton(
        timeIntervalInMilliseconds: selectedTimeIntervalInMilliseconds,
        onChanged: (newValue) {
          setState(() {
            selectedTimeIntervalInMilliseconds = newValue;
          });
        },
      ),
    );

    var applyButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CustomTextButton(
        isDense: false,
        width: 200,
        text: "Apply settings",
        style: const TextStyle(
          fontSize: 24,
        ),
        onPressed: () {
          // TODO: Validate settings
          // TODO: Apply settings
        },
      ),
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
                const SizedBox(height: 20),
                precisionHeader,
                precisionSelection,
                const SizedBox(height: 20),
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

  Widget _getUnitSelectionButtonFromUnit(Unit unit) => UnitSelectionButton(
        onPressed: () {
          setState(() {
            selectedUnit = unit;
          });
        },
        unit: unit,
        isSelected: selectedUnit == unit,
      );
}
