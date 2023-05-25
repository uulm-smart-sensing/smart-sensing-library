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
    // request sensor config for this sensor
    var config = IOManager().getSensorConfig(widget.sensorId);
    if (config != null) {
      selectedPrecision = config.targetPrecision;
      selectedTimeIntervalInMilliseconds = config.timeInterval.inMilliseconds;
      selectedUnit = config.targetUnit;
    } else {
      selectedPrecision = 1;
      selectedTimeIntervalInMilliseconds = 500;
      selectedUnit = sensorIdToDefaultTargetUnit[widget.sensorId]!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var unitHeader = SectionHeader("Unit");

    var units = sensorIdToUnitCategory[widget.sensorId]!;
    var unitSelection = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: units.map(_getUnitSelectionButtonFromUnit).toList(),
      ),
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
          fontSize: 20,
        ),
        onPressed: _checkSettings() ? _applySettings : null,
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

  bool _checkSettings() {
    var newConfig = SensorConfig(
      targetUnit: selectedUnit,
      targetPrecision: selectedPrecision,
      timeInterval: Duration(milliseconds: selectedTimeIntervalInMilliseconds),
    );

    var validationResult =
        IOManager().validateSettings(widget.sensorId, newConfig);

    switch (validationResult) {
      case SensorTaskResult.success:
        return true;
      case SensorTaskResult.invalidTimeInterval:
      case SensorTaskResult.invalidPrecision:
      case SensorTaskResult.invalidUnit:
        return false;
      default:
        return false;
    }
  }

  void _applySettings() {
    IOManager()
        .editSensorConfig(
      widget.sensorId,
      targetUnit: selectedUnit,
      targetPrecision: selectedPrecision,
      timeInterval: Duration(
        milliseconds: selectedTimeIntervalInMilliseconds,
      ),
    )
        .then((result) {
      var snackBar = SnackBar(
        content: Text(formatPascalCase(result.name)),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 1),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (result == SensorTaskResult.success) {
        Navigator.of(context).pop();
      }
    });
  }
}
