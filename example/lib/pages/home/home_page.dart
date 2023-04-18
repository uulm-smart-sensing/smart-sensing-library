import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../date_formatter.dart';
import '../live_view/live_view_page.dart';
import '../settings/settings_page.dart';
import '../statistics/statistics_page.dart';
import 'demo_sensor_widget.dart';
import 'device_widget.dart';
import 'home_page_section_body.dart';
import 'home_page_section_header.dart';

/// Starting point of this demo app.
///
/// This [HomePage] shows different sections which contain sensor widgets.
/// The first two sections let the user navigate to the according page:
/// * live view section -> [LiveViewPage].
/// * sensors section -> [StatisticsPage].
/// The last section contains basic information about the device on which this
/// app is running.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var todayFormatted = formatDate(dateTime: DateTime.now());

    var title = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Text(
          "Hello",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ", $todayFormatted",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );

    var settingsButton = Center(
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromARGB(255, 23, 27, 137),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 30,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ),
    );

    var liveViewSectionHeader = HomePageSectionHeader(
      title: "live view",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LiveViewPage(),
          ),
        );
      },
    );
    var liveViewSectionBody = HomePageSectionBody(
      // TODO: Replace with call to smart sensing library
      children: SensorId.values
          .take(3)
          .map((id) => DemoSensorWidget(sensorId: id))
          .toList(),
    );

    var sensorsSectionHeader = HomePageSectionHeader(
      title: "sensors",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StatisticsPage(),
          ),
        );
      },
    );
    var sensorsSectionBody = HomePageSectionBody(
      children:
          SensorId.values.map((id) => DemoSensorWidget(sensorId: id)).toList(),
    );

    var devicesSectionHeader = Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: const Text(
        "devices",
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    var devicesSectionBody = Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: const DeviceWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: title,
        actions: [
          settingsButton,
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            liveViewSectionHeader,
            liveViewSectionBody,
            sensorsSectionHeader,
            sensorsSectionBody,
            devicesSectionHeader,
            devicesSectionBody,
          ],
        ),
      ),
    );
  }
}
