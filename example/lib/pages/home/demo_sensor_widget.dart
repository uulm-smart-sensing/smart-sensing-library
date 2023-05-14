import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../theme/theme.dart';
import '../historic_view/historic_view_page.dart';

/// [Widget] used as placecholder for the sensor widgets
/// TODO: Remove when not required anymore
class DemoSensorWidget extends StatelessWidget {
  final SensorId sensorId;

  const DemoSensorWidget({super.key, required this.sensorId});

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          width: 140,
          height: 140,
          color: sensorIdToColor[sensorId]!.withAlpha(128),
          child: Placeholder(
            color: sensorIdToColor[sensorId]!,
            child: Center(child: Text(sensorId.name)),
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoricViewPage(sensorId: sensorId),
          ),
        ),
      );
}
