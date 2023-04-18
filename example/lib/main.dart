import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'pages/home/home_page.dart';
import 'theme.dart';

void main() async {
  // Initialize date formatting for configured locale
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(Platform.localeName);
  await IOManager().openDatabase();
  await IOManager().addSensor(SensorId.accelerometer, 1000);
  runApp(const SmartSensingLibraryDemoApp());
}

class SmartSensingLibraryDemoApp extends StatelessWidget {
  const SmartSensingLibraryDemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Sensing Library Demo',
        theme: theme,
        home: const HomePage(),
      );
}
