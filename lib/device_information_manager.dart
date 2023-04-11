import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:disk_space/disk_space.dart';

/// Requests the free storage of the device, this library
/// is running on.
///
/// Therefor the [DiskSpace] plugin will be used to access free disk space
/// The disk space, will be returned in MB rounded to 2 fractional digits, so
/// e. g. "4038.23 (MB)"
Future<String> getOSVersion() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    var os = iosDeviceInfo.systemName;
    var version = iosDeviceInfo.systemVersion;
    return "  • $os $version";
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    var releaseVersion = androidDeviceInfo.version.release;
    var sdkVersion = androidDeviceInfo.version.sdkInt;
    return "  • Android $releaseVersion (SDK $sdkVersion)";
  }

  return "   ERROR: Could not get OS version";
}

///
Future<String> getFreeStorage() async {
  var freeDiskSpace = await DiskSpace.getFreeDiskSpace ?? -1.0;
  if (freeDiskSpace == -1.0) {
    return "   ERROR: Could not get free storage!";
  }
  var freeDiskSpaceRounded = freeDiskSpace.toStringAsFixed(2);
  return "  • $freeDiskSpaceRounded (MB)";
}

/// Fetches the device name e.g. OnePlus Nord
Future<String> getDeviceName() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    return deviceInfo.iosInfo.then((info) => info.utsname.machine ?? "");
  } else if (Platform.isAndroid) {
    return deviceInfo.androidInfo
        .then((info) => "${info.brand} ${info.device}");
  }
  throw StateError("Unexpected platform");
}
