import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/text_formatter.dart';
import '../../general_widgets/brick_container.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../home/home_page.dart';
import 'sensor_preview_settings_page.dart';

/// Page containing a list of all currently tracked sensors and enables
/// navigation to the [SensorPreviewSettingsPage]s of this sensors.
///
/// Therefor this list consists of [BrickContainer]s, which navigate to the
/// corresponding page of the sensor when pressed.
///
/// This [PreviewSettingsPage] is reachable through the [HomePage].
class PreviewSettingsPage extends StatelessWidget {
  const PreviewSettingsPage({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: IOManager().getUsedSensors(),
        builder: (context, snapshot) => SmartSensingAppBar(
          title: "Previews",
          body: Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot.data != null
                      ? _getSensorsListFromIds(
                          sensorIds: snapshot.data!,
                          context: context,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      );

  /// Creates [ListView] from the passed [sensorIds].
  ///
  /// If [sensorIds] is empty, [noSensorsText] is shown.
  /// Uses [seperator] to seperate each Item.
  Widget _getSensorsListFromIds({
    required List<SensorId> sensorIds,
    String noSensorsText = "No sensors are tracked right now.",
    required BuildContext context,
    Widget seperator = const SizedBox(
      height: 15,
    ),
  }) =>
      Expanded(
        flex: 1,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          physics: const BouncingScrollPhysics(),
          itemCount: sensorIds.isNotEmpty ? sensorIds.length : 1,
          itemBuilder: (context, index) => sensorIds.isNotEmpty
              ? _getSensorListItem(sensorIds[index], context)
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Center(
                    child: Text(
                      noSensorsText,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
          separatorBuilder: (context, index) => seperator,
        ),
      );

  /// Creates a list item for the sensor with the given [sensorId].
  ///
  /// Adds a routing to the corresponding [SensorPreviewSettingsPage].
  Widget _getSensorListItem(SensorId sensorId, BuildContext context) =>
      BrickContainer(
        height: 50,
        width: 330,
        padding: const EdgeInsets.all(15),
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SensorPreviewSettingsPage(
                sensorId: sensorId,
              ),
            ),
          );
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            formatPascalCase(sensorId.name),
          ),
        ),
      );
}
