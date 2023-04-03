import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/home/home_page.dart';

void main() async {
  // Initialize date formatting for configured locale
  await initializeDateFormatting(Platform.localeName);
  runApp(const SmartSensingLibraryDemoApp());
}

class SmartSensingLibraryDemoApp extends StatelessWidget {
  const SmartSensingLibraryDemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Sensing Library Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      );
}
