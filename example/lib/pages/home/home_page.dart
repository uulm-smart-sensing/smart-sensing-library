import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import '../../formatter/date_formatter.dart';
import '../live_view/live_view_page.dart';
import '../live_view/live_view_sensor_widget.dart';
import '../settings/settings_page.dart';
import '../statistics/statistics_page.dart';
import 'demo_sensor_widget.dart';
import 'device_widget.dart';
import 'home_page_section_body.dart';
import 'home_page_section_header.dart';
import 'package:provider/provider.dart';
import '../../favorite_provider.dart';

/// Starting point of this demo app.
///
/// This [HomePage] shows different sections which contain sensor widgets.
/// The first two sections let the user navigate to the according page:
/// * live view section -> [LiveViewPage].
/// * sensors section -> [StatisticsPage].
/// The last section contains basic information about the device on which this
/// app is running.
///
/// When navigating back to this page, the page is refreshed to update the live
/// view.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var todayFormatted = formatDate(dateTime: DateTime.now());
    var provider = Provider.of<FavoriteProvider>(context);
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
          onPressed: () => _navigateToPage(context, const SettingsPage()),
          icon: const Icon(Icons.settings),
        ),
      ),
    );

    var liveViewSectionHeader = HomePageSectionHeader(
      title: "live view",
      onPressed: () => _navigateToPage(context, const LiveViewPage()),
    );
    var liveViewSectionBody = FutureBuilder(
      future: IOManager().getUsedSensors(),
      builder: (context, snapshot) => HomePageSectionBody(
        noChildrenText: "No sensors are currently being tracked.",
        children: snapshot.data != null
            ? snapshot.data!
                .where((id) => provider.sensorList.contains(id))
                .map(
                  (id) => LiveViewSensorWidget(
                    sensorId: id,
                    isShortFormat: true,
                  ),
                )
                .toList()
            : [],
      ),
    );

    var sensorsSectionHeader = HomePageSectionHeader(
      title: "sensors",
      onPressed: () => _navigateToPage(context, const StatisticsPage()),
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => page))
        .then(
          // Called when navigating back to the this home page
          (value) => setState(() {}),
        );
  }
}
