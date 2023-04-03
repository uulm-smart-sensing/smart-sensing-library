import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({super.key});

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  @override
  Widget build(BuildContext context) {
    var phoneIcon = Platform.isIOS ? Icons.phone_iphone : Icons.phone_android;
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getDeviceNameTitle(),
        Icon(
          phoneIcon,
          color: Colors.white,
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color.fromARGB(255, 170, 77, 255),
      ),
      width: 320,
      height: 80,
      child: Column(
        children: [
          header,
        ],
      ),
    );
  }
}

/// Fetches the device name and builds a [Text] widget with it.
Widget _getDeviceNameTitle() => FutureBuilder(
      future: Future.sync(() async {
        var deviceInfo = DeviceInfoPlugin();
        if (Platform.isIOS) {
          return deviceInfo.iosInfo.then((info) => info.utsname.machine);
        } else if (Platform.isAndroid) {
          return deviceInfo.androidInfo
              .then((info) => "${info.brand} ${info.device}");
        }
        throw StateError("Unexpected platform");
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!);
        }

        if (snapshot.hasError) {
          return const Text("Error occured while fetching device name.");
        }

        return const Text("Device name is being fetched ...");
      },
    );
