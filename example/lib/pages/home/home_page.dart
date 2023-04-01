import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../settings/settings_page.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          settingsButton,
        ],
      ),
      body: const Placeholder(),
    );
  }
}
