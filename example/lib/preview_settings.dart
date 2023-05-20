import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

import 'pages/preview_settings/sensor_preview_settings.dart';

/// Handles the Preview settings management.
/// The class uses the preference shared by the database. With shared preference
/// it is possible to store the data globally and to modify it.
class PreviewSettings {
  /// List of all preview settings
  final Map<SensorId, SensorPreviewSetting> _sensorPreviewSetting = {};
  Map<SensorId, SensorPreviewSetting> get sensorPreviewSettings =>
      _sensorPreviewSetting;

  static SharedPreferences? _prefs;
  static PreviewSettings? _instance;

  /// Private singleton constructor to initialize [SharedPreferences]
  /// and init. [SensorPreviewSetting].
  PreviewSettings._create() {
    loadPreviewSettings();
  }

  /// Factory Method for getting [PreviewSettings].
  ///
  /// Will only create one instance of [PreviewSettings]
  /// and returns only that afterwards.
  static Future<PreviewSettings> getProvider() async {
    _prefs ??= await SharedPreferences.getInstance();
    _instance ??= PreviewSettings._create();
    return _instance!;
  }

  /// Updates the [SensorPreviewSetting] of sensor [sensorId] with [settings].
  ///
  /// Gets updated in [SharedPreferences] afterwards.
  Future<void> updateSensorPreviewSettings(
    SensorId sensorId,
    SensorPreviewSetting settings,
  ) async {
    _sensorPreviewSetting[sensorId] = settings;
    await _prefs!.setStringList(
      'previewSetting_$sensorId',
      [settings.toJson()],
    );
  }

  /// Loads the Map of [SensorPreviewSetting] from [SharedPreferences].
  void loadPreviewSettings() {
    for (var sensorId in SensorId.values) {
      var previewSettings = _prefs!.getStringList('previewSetting_$sensorId');
      if (previewSettings != null) {
        _sensorPreviewSetting[sensorId] =
            SensorPreviewSetting.fromJson(previewSettings.first);
      }
    }
  }
}
