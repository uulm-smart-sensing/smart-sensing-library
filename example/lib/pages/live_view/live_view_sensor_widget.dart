import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../general_widgets/brick_container.dart';
import '../../general_widgets/live_data_information.dart';
import '../../theme.dart';
import '../historic_view/historic_view_page.dart';

/// [Widget] that displays the latest data of a sensor with the passed
/// [sensorId].
///
/// If [isShortFormat] is true, the time difference since the last data was
/// received isn't shown.
class LiveViewSensorWidget extends StatelessWidget {
  final SensorId sensorId;
  final bool isShortFormat;

  const LiveViewSensorWidget({
    super.key,
    required this.sensorId,
    this.isShortFormat = false,
  });

  @override
  Widget build(BuildContext context) => BrickContainer(
        height: isShortFormat ? 105 : null,
        color: sensorIdToColor[sensorId],
        child: LiveDataInformation(
          id: sensorId,
          headLineFontSize: 14,
          shortFormat: isShortFormat,
        ),
        onClick: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoricViewPage(sensorId: sensorId),
          ),
        ),
      );
}
