import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../filter_options.dart';
import '../../formatter/text_formatter.dart';
import '../../general_widgets/brick_container.dart';
import '../../general_widgets/custom_text_button.dart';
import '../../general_widgets/section_header.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../preview_settings.dart';
import '../../sensor_units.dart';
import '../../theme.dart';
import '../sensor_settings/time_interval_selection_button.dart';
import 'sensor_preview_settings.dart';

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
  late Future<PreviewSettings> provider =
      PreviewSettings.getProvider();
  late Future<SensorPreviewSetting> previewSettings;

  @override
  void initState() {
    selectedUnit = getUnitsFromSensorId(widget.sensorId).first;
    previewSettings = provider.then(
      (value) =>
          value.sensorPreviewSettings[widget.sensorId] ??
          SensorPreviewSetting(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: previewSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildSettingsPage(snapshot.data!);
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Center(
                child: Text(
                  "Waiting for Data",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        },
      );

  Widget _buildSettingsPage(SensorPreviewSetting settings) {
    var filterHeader = SectionHeader("Filters");
    var filterSelection = Expanded(
      flex: 1,
      child: _getFilterfromData(settings),
    );

    var timeIntervalHeader = SectionHeader(
      "Time Interval (m : s : ms)",
    );
    var timeIntervalSelection = Align(
      alignment: Alignment.topCenter,
      child: TimeIntervalSelectionButton(
        timeIntervalInMilliseconds: settings.timeInterval.inMilliseconds,
        onChanged: (newValue) {
          setState(() {
            settings.timeInterval = Duration(milliseconds: newValue);
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
        onPressed: () async {
          await (await provider).updateSensorPreviewSettings(
            widget.sensorId,
            await previewSettings,
          );
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
  Widget _getFilterfromData(SensorPreviewSetting previewSettings) {
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
          color: previewSettings.active[filter]!
              ? activeTrackColor
              : inactiveTrackColor,
          alignment: Alignment.center,
          onClick: () {
            // Switches each filter from on to off.
            setState(() {
              if (previewSettings.active.containsKey(filter)) {
                previewSettings.active[filter] =
                    !previewSettings.active[filter]!;
              } else {
                previewSettings.active[filter] = false;
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
