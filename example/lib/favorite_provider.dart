import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

/// Handles the favorite management.
/// The class uses the preference shared by the database. With shared preference
/// it is possible to store the data globally and to modify it.
class FavoriteProvider extends ChangeNotifier {
  /// List of all favored sensors
  List<SensorId> _sensorList = [];
  List<SensorId> get sensorList => _sensorList;

  final Future<SharedPreferences> _prefs;

  /// Initializes the `SharedPreferences` and loads the
  /// previously stored list of favorites.
  FavoriteProvider() : _prefs = SharedPreferences.getInstance() {
    loadFavorites();
  }

  /// Adds or removes a sensor[id] to the [_sensorList] depending on whether
  /// the sensor (with [id]) was already been added (= remove) or not (= add).
  Future<void> toggleFavorite(SensorId id) async {
    var isExist = _sensorList.contains(id);
    if (isExist) {
      _sensorList.remove(id);
    } else {
      _sensorList.add(id);
    }
    notifyListeners();

    var pref = await _prefs;
    await pref.setStringList(
      'favoriteSensors',
      _sensorList.map((id) => id.index.toString()).toList(),
    );
  }

  /// Loads the list of favorite sensors from SharedPreferences
  Future<void> loadFavorites() async {
    var pref = await _prefs;
    var favoriteSensors = pref.getStringList('favoriteSensors') ?? [];

    _sensorList = favoriteSensors
        .map((sensor) => SensorId.values[int.parse(sensor)])
        .toList();

    notifyListeners();
  }

  /// Checks if SensorId exists in list
  bool isExist(SensorId id) => _sensorList.contains(id);
}
