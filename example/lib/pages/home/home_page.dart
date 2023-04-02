import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../live_view/live_view_page.dart';
import '../settings/settings_page.dart';
import '../statistics/statistics_page.dart';
import 'home_page_section_body.dart';
import 'home_page_section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    // Format the current date according to the locale
    // This will output: en -> 12.31.2023 or de -> 31.12.2023
    var todayFormatted = DateFormat.yMd(Platform.localeName)
        .format(now)
        // Some dates are separated using '/' replace them with '.'
        .replaceAll("/", ".")
        // Add a leading zero to single digits for days and months
        .split('.')
        .map((part) => part.padLeft(2, '0'))
        .join('.');

    var title = Row(
      children: [
        const Text(
          "Hello",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(", $todayFormatted"),
      ],
    );

    var settingsButton = IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );

    var livePreviewSectionHeader = HomePageSectionHeader(
      title: "live preview",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LiveViewPage(),
          ),
        );
      },
    );
    var livePreviewSectionBody = HomePageSectionBody(
      axis: Axis.horizontal,
      spaceBetweenChildren: 20,
      hasFixedSize: true,
      size: 80,
      children: ["Temperature", "Gyroscope", "Light"]
          .map(
            (e) => SizedBox(
              width: 150,
              height: 80,
              child: Placeholder(
                color: Colors.red,
                child: Text(e),
              ),
            ),
          )
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
      axis: Axis.horizontal,
      spaceBetweenChildren: 20,
      hasFixedSize: true,
      size: 80,
      children: ["Temperature", "Gyroscope", "Light"]
          .map(
            (e) => SizedBox(
              width: 150,
              height: 80,
              child: Placeholder(
                color: Colors.red,
                child: Text(e),
              ),
            ),
          )
          .toList(),
    );

    var devicesSectionHeader = HomePageSectionHeader(
      title: "devices",
      onPressed: () {},
    );
    var devicesSectionBody = HomePageSectionBody(
      spaceBetweenChildren: 20,
      children: ["iPhone 13 Pro"]
          .map(
            (e) => SizedBox(
              width: 150,
              height: 80,
              child: Placeholder(
                color: Colors.red,
                child: Text(e),
              ),
            ),
          )
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          settingsButton,
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            livePreviewSectionHeader,
            livePreviewSectionBody,
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
