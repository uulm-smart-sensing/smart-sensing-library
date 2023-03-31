import 'package:flutter/material.dart';

import '../settings/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text("Hello, 28.03.2023"),
        actions: [
          settingsButton,
        ],
      ),
      body: const Placeholder(),
    );
  }
}
