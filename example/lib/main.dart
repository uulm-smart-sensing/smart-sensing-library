import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/information/information_page.dart';

void main() async {
  // Initialize date formatting for configured locale
  await initializeDateFormatting(Platform.localeName);
  runApp(const SmartSensingLibraryDemoApp());
}

const primaryColorHex = 0xFF00072F;
const primaryColor = MaterialColor(
  primaryColorHex,
  {
    50: Color.fromRGBO(0, 7, 47, .1),
    100: Color.fromRGBO(0, 7, 47, .2),
    200: Color.fromRGBO(0, 7, 47, .3),
    300: Color.fromRGBO(0, 7, 47, .4),
    400: Color.fromRGBO(0, 7, 47, .5),
    500: Color.fromRGBO(0, 7, 47, .6),
    600: Color.fromRGBO(0, 7, 47, .7),
    700: Color.fromRGBO(0, 7, 47, .8),
    800: Color.fromRGBO(0, 7, 47, .9),
    900: Color.fromRGBO(0, 7, 47, 1),
  },
);

class SmartSensingLibraryDemoApp extends StatelessWidget {
  const SmartSensingLibraryDemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Sensing Library Demo',
        theme: ThemeData(
          primarySwatch: primaryColor,
          scaffoldBackgroundColor: const Color(primaryColorHex),
          dividerColor: Colors.white,
          cardColor: const Color.fromARGB(255, 34, 0, 77),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        home: const InformationPage(),
      );
}
