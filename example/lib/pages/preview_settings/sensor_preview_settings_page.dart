import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../filter_options.dart';
import '../../formatter/text_formatter.dart';
import '../../general_widgets/brick_container.dart';
import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/section_header.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../sensor_units.dart';
import '../../theme.dart';
import '../sensor_settings/time_interval_selection_button.dart';

/// Page to configure the sensor preview with the passed [sensorId].
///
/// The settings which can be configured are:
/// * filter of sensor data
/// * target unit of sensor data
/// * time interval of sensor update events
class SensorPreviewSettingsPage extends StatefulWidget {
  final SensorId sensorId;
  const SensorPreviewSettingsPage({
    super.key,
    required this.sensorId,
  });

  @override
  State<SensorPreviewSettingsPage> createState() =>
      _SensorPreviewSettingsPageState();
}

class _SensorPreviewSettingsPageState extends State<SensorPreviewSettingsPage> {
  late int selectedPrecision;
  late Unit selectedUnit;
  late SensorPreviewSetting sensorSettings;

  @override
  void initState() {
    selectedUnit = getUnitsFromSensorId(widget.sensorId).first;
    sensorSettings = SensorPreviewSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filterHeader = SectionHeader("Filters");
    var filterSelection = Expanded(
      flex: 1,
      child: _getFilterfromData(),
    );

    var timeIntervalHeader = SectionHeader(
      "Time Interval (m : s : ms)",
    );
    var timeIntervalSelection = Align(
      alignment: Alignment.topCenter,
      child: TimeIntervalSelectionButton(
        timeIntervalInMilliseconds: sensorSettings.timeInterval.inMilliseconds,
        onChanged: (newValue) {
          setState(() {
            sensorSettings.timeInterval = Duration(milliseconds: newValue);
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

        },
      ),
    );

    return SmartSensingAppBar(
      title: "Preview settings",
      subtitle: formatPascalCase(widget.sensorId.name),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  filterHeader,
                  filterSelection,
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        timeIntervalHeader,
                        timeIntervalSelection,
                      ],
                    ),
                  )
                ],
              ),
            ),
            applyButton,
          ],
        ),
      ),
    );
  }

 /// Creates a [GridView] with clickable [BrickContainer]s
 /// correspoding to the saved [SensorPreviewSetting].
 ///
 /// If no data is available, creates an empty [SensorPreviewSetting].
  Widget _getFilterfromData() {
    var itemList = <Widget>[];

    for (var filter in FilterOption.values) {
      var textContainer = Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          formatPascalCase(filter.shortText),
        ),
      );
      itemList.add(
        BrickContainer(
          color: sensorSettings.active[filter]!
              ? activeTrackColor
              : inactiveTrackColor,
          alignment: Alignment.center,
          onClick: () {
            // Switches each filter from on to off.
            setState(() {
              if (sensorSettings.active.containsKey(filter)) {
                sensorSettings.active[filter] = !sensorSettings.active[filter]!;
              } else {
                sensorSettings.active[filter] = false;
              }
            });
          },
          child: textContainer,
        ),
      );
    }

    // Creates a grit view for each filter.
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      padding: const EdgeInsets.all(5),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      children: itemList,
    );
  }
}

/// Class to save preview settings.
class SensorPreviewSetting {
  Duration timeInterval;
  late final Map<FilterOption, bool> active;
  SensorPreviewSetting({
    this.timeInterval = const Duration(seconds: 5),
    Map<FilterOption, bool>? activeMap,
  }) {
    activeMap ??= _createEmptyMap();
    active = activeMap;
  }

  Map<FilterOption, bool> _createEmptyMap() {
    var map = <FilterOption, bool>{};
    for (var filter in FilterOption.values) {
      map[filter] = false;
    }
    return map;
  }
}
