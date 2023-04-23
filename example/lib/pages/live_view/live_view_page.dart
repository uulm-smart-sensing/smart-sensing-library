import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/date_formatter.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import 'live_view_sensors_grid_view.dart';

/// Page that displays sensor widgets for each sensor that is being tracked.
class LiveViewPage extends StatelessWidget {
  const LiveViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    var gridView = FutureBuilder(
      future: IOManager().getUsedSensors(),
      builder: (context, snapshot) =>
          snapshot.data != null && snapshot.data!.isNotEmpty
              ? LiveViewSensorsGridView(sensorIds: snapshot.data!)
              : const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "No sensors are currently being tracked.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
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
