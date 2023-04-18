import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../date_formatter.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../theme.dart';
import '../historic_view/historic_view_page.dart';

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
              // TODO: Replace with sensor widget
              child: GestureDetector(
                child: Container(
                  color: sensorIdToColor[id]!.withAlpha(128),
                  child: Placeholder(
                    color: sensorIdToColor[id]!,
                    child: Center(child: Text(id.name)),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoricViewPage(sensorId: id),
                  ),
                ),
              ),
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
