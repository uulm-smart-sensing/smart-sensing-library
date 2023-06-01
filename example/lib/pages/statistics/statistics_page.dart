import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../favorite_provider.dart';
import '../../formatter/time_formatter.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../historic_view/historic_view_page.dart';
import '../home/home_page.dart';
import 'statistics_page_body.dart';

/// Page containing a list of all implemented sensors and enables navigation
/// to the [HistoricViewPage]s of this sensors.
///
/// Therefor this list consists of [TextButton]s, which navigate to the
/// corresponding page of the sensor when pressed.
///
/// This [HistoricViewPage] is reachable through the [HomePage].
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FavoriteProvider>(context);

    var allSensorList = FutureBuilder(
      future: IOManager().getAvailableSensors(),
      builder: (context, snapshot) => StatisticsPageBody(
        noChildrenText: "No sensors are currently being available.",
        children: snapshot.data != null
            ? snapshot.data!
                .where((id) => !provider.sensorList.contains(id))
                .map((id) => getSensorListItem(id, context))
                .toList()
            : [],
      ),
    );

    var favoriteSensorList = FutureBuilder(
      future: IOManager().getAvailableSensors(),
      builder: (context, snapshot) => StatisticsPageBody(
        noChildrenText: "No sensors are currently favoured",
        children: snapshot.data != null
            ? snapshot.data!
                .where((id) => provider.sensorList.contains(id))
                .map((id) => getSensorListItem(id, context))
                .toList()
            : [],
      ),
    );
    // The list containing the buttons for all implemented sensors
    // for navigation to the [HistoricViewPage]s.
    var sensorList = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Favorites", style: TextStyle(fontSize: 24)),
          ),
          Expanded(child: SingleChildScrollView(child: favoriteSensorList)),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("All", style: TextStyle(fontSize: 24)),
          ),
          Expanded(child: SingleChildScrollView(child: allSensorList)),
        ],
      ),
    );

    return SmartSensingAppBar(
      title: "Statistics",
      subtitle: formatDate(
        dateTime: DateTime.now(),
        locale: Platform.localeName,
        extendWithDayName: true,
      ),
      body: sensorList,
    );
  }
}
