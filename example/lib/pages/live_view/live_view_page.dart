import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../date_formatter.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import 'live_view_sensor_widget.dart';

/// Page that displays sensor widgets for each sensor that is being tracked.
class LiveViewPage extends StatelessWidget {
  const LiveViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    var gridView = GridView.count(
      crossAxisCount: 2,
      physics: const BouncingScrollPhysics(),
      children: SensorId.values
          .map(
            (id) => Padding(
              padding: const EdgeInsets.all(12),
              child: LiveViewSensorWidget(sensorId: id),
            ),
          )
          .toList(),
    );

    return SmartSensingAppBar(
      title: "Live view",
      subtitle: formatDate(
        dateTime: DateTime.now(),
        locale: Platform.localeName,
        extendWithDayName: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: gridView,
      ),
    );
  }
}
