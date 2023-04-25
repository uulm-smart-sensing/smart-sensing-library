import 'package:flutter/material.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

/// [Text] widget that fetches the device name and styles it.
class DeviceNameTitle extends StatelessWidget {
  final TextStyle style;

  const DeviceNameTitle({super.key, required this.style});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: getDeviceName(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data!,
              style: style,
            );
          }

          if (snapshot.hasError) {
            return const Text("Error occurred while fetching device name.");
          }

          return const Text("Device name is being fetched ...");
        },
      );
}
