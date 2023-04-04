import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Requests the version of the operation system of the device, this library
/// is running on.
///
/// Therefor the [DeviceInfoPlugin] will be used to access the iOS or
/// Android version of the device.
///
/// Depending on the device, the returned string (containing the OS version)
/// will have a different format:
/// * iPhone -> "iOS <majorVersion>.<minorVersion", e. g. "iOS 16.2"
/// * Android device - "Android <majorVersion> (SDK <sdkVersion>)", e. g.
/// "Android 9 (SDK 23)"
Future<String> getOSVersion() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    var os = iosDeviceInfo.systemName;
    var version = iosDeviceInfo.systemVersion;
    return "$os $version";
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    var releaseVersion = androidDeviceInfo.version.release;
    var sdkVersion = androidDeviceInfo.version.sdkInt;
    return "Android $releaseVersion (SDK $sdkVersion)";
  }

  return "ERROR: Could not get OS version";
}
