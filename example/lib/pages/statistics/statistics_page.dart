import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../date_formatter.dart';
import '../../favorite_provider.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/text_formatter.dart';
import '../../general_widgets/smart_sensing_appbar.dart';
import '../../general_widgets/stylized_container.dart';
import '../historic_view/historic_view_page.dart';
import '../home/home_page.dart';

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

    // The list containing the buttons for all implemented sensors
    // for navigation to the [HistoricViewPage]s.
    var sensorList = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Favorite"),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: provider.sensorList
                  .map((id) => _getSensorListItem(id, context))
                  .toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("All"),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: SensorId.values
                  .where((sensorId) => !provider.sensorList.contains(sensorId))
                  .map((id) => _getSensorListItem(id, context))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
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

  // Create the button (= List item) for a sensor with [sensorId]
  Widget _getSensorListItem(SensorId sensorId, BuildContext context) {
    var sensorButton = StylizedContainer(
      height: 50,
      width: 330,
      padding: const EdgeInsets.all(15),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoricViewPage(
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
      ),
    );

    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        sensorButton,
      ],
    );
  }
}
