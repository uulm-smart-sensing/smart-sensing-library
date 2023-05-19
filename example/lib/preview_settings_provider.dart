import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'pages/preview_settings/sensor_preview_settings.dart';

/// Handles the Preview settings management.
/// The class uses the preference shared by the database. With shared preference
/// it is possible to store the data globally and to modify it.
class PreviewSettingsProvider extends ChangeNotifier {
  /// List of all preview settings
  final Map<SensorId, SensorPreviewSetting> _sensorPreviewSetting = {};
  Map<SensorId, SensorPreviewSetting> get sensorPreviewSettings =>
      _sensorPreviewSetting;

  static late final SharedPreferences? _prefs;
  static late final PreviewSettingsProvider? _instance;

  /// Initializes the `SharedPreferences` and loads the
  /// previously stored list of favorites.
  PreviewSettingsProvider._create() {
    loadPreviewSettings();
  }

  static Future<PreviewSettingsProvider> getProvider() async {
    _prefs ??= await SharedPreferences.getInstance();
    _instance ??= PreviewSettingsProvider._create();
    return _instance!;
  }

  /// Adds or removes a sensor[sensorId] to the [_sensorPreviewSetting] depending on whether
  /// the sensor (with [sensorId]) was already been added (= remove) or not (= add).
  Future<void> updateSensorPreviewSettings(
    SensorId sensorId,
    SensorPreviewSetting settings,
  ) async {
    notifyListeners();
    await _prefs!.setStringList(
      'previewSetting_$sensorId',
      [settings.toJson()],
    );
  }

  /// Loads the list of favorite sensors from SharedPreferences
  void loadPreviewSettings() {
    for (var sensorId in SensorId.values) {
      var previewSettings = _prefs!.getStringList('previewSetting_$sensorId');
      if (previewSettings != null) {
        _sensorPreviewSetting[sensorId] =
            SensorPreviewSetting.fromJson(previewSettings.first);
      }
    }

    notifyListeners();
  }
}
