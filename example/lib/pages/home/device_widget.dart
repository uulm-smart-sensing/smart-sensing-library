import 'dart:io';

import 'package:flutter/material.dart';

import '../../general_widgets/device_name_title.dart';

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({super.key});

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    var phoneIcon = Platform.isIOS ? Icons.phone_iphone : Icons.phone_android;
    var header = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DeviceNameTitle(
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Icon(
            phoneIcon,
            color: Colors.white,
          ),
        ],
      ),
    );

    var horizontalPadding = 16.0;
    var rowPadding = 8.0;
    var body = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              _getAvailableSensorsText(),
              SizedBox(width: horizontalPadding),
              const Text(
                "sensors available",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // Padding row
          TableRow(
            children: [
              SizedBox(height: rowPadding),
              SizedBox(height: rowPadding),
              SizedBox(height: rowPadding),
            ],
          ),
          TableRow(
            children: [
              _getRunningSensorsText(),
              SizedBox(width: horizontalPadding),
              const Text(
                "sensors running",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color.fromARGB(255, 170, 77, 255),
      ),
      child: Column(
        children: [
          header,
          body,
        ],
      ),
    );
  }
}

/// Fetches the number of available sensors and builds a [Text] widget with it.
Widget _getAvailableSensorsText() => FutureBuilder(
      // ignore: prefer_expression_function_bodies
      future: Future.sync(() async {
        // TODO: Replace with call to smart sensing library
        return "14";
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            "Error occured while fetching number of available sensors",
          );
        }

        return const Text("Number of available sensors is being fetched ...");
      },
    );

/// Fetches the number of running sensors and builds a [Text] widget with it.
Widget _getRunningSensorsText() => FutureBuilder(
      // ignore: prefer_expression_function_bodies
      future: Future.sync(() async {
        // TODO: Replace with call to smart sensing library
        return "10";
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            "Error occured while fetching number of running sensors",
          );
        }

        return const Text("Number of running sensors is being fetched ...");
      },
    );
