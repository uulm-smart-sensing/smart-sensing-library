import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/section_header.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../utils.dart';
import 'precision_slider.dart';
import 'time_interval_selection_button.dart';
import 'unit_selection_button.dart';

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
  Unit? selectedUnit;

  @override
  Widget build(BuildContext context) {
    var unitHeader = SectionHeader("Unit");

    var totalWidth = MediaQuery.of(context).size.width;
    var units = _getUnitsFromSensorId(widget.sensorId);
    var buttonWidth = _getButtonWidth(totalWidth, units.length);
    var unitSelection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: units
          .map((unit) => _getUnitSelectionButtonFromUnit(unit, buttonWidth))
          .toList(),
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
      child: CustomTextButton(
        text: "Apply",
        onPressed: () {
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

  Widget _getUnitSelectionButtonFromUnit(Unit unit, double width) =>
      UnitSelectionButton(
        onPressed: () {
          setState(() {
            selectedUnit = unit;
          });
        },
        unit: unit,
        isSelected: selectedUnit == unit,
        width: width,
      );
}

List<Unit> _getUnitsFromSensorId(SensorId sensorId) {
  switch (sensorId) {
    case SensorId.accelerometer:
    case SensorId.linearAcceleration:
      return [
        Unit.gravitationalForce,
        Unit.metersPerSecondSquared,
      ];
    case SensorId.gyroscope:
      return [
        Unit.degreesPerSecond,
        Unit.radiansPerSecond,
      ];
    case SensorId.magnetometer:
      return [
        Unit.microTeslas,
      ];
    case SensorId.orientation:
      return [
        Unit.degrees,
        Unit.radians,
      ];
    case SensorId.barometer:
      return [
        Unit.bar,
        Unit.hectoPascal,
        Unit.kiloPascal,
      ];
    case SensorId.thermometer:
      return [
        Unit.celsius,
        Unit.fahrenheit,
        Unit.kelvin,
      ];
  }
}

double _getButtonWidth(double totalWidth, int numberOfWidgets) =>
    min(totalWidth / 3, totalWidth / numberOfWidgets - 18 * numberOfWidgets);
