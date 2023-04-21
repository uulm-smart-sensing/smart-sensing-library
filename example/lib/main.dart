import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'favorite_provider.dart';
import 'pages/home/home_page.dart';
import 'theme.dart';

void main() async {
  // Is needed for Objectbox initialization.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize date formatting for configured locale
  await initializeDateFormatting(Platform.localeName);
  await IOManager().openDatabase();
  runApp(const SmartSensingLibraryDemoApp());
}

class SmartSensingLibraryDemoApp extends StatelessWidget {
  const SmartSensingLibraryDemoApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => FavoriteProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Sensing Library Demo',
          theme: theme,
          home: const HomePage(),
        ),
      );
}
