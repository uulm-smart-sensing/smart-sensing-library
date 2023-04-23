import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

/// Class that handles Favorite Managment
class FavoriteProvider extends ChangeNotifier {
  /// List of all favorite Sensors
  List<SensorId> _sensorList = [];
  List<SensorId> get sensorList => _sensorList;

  final Future<SharedPreferences> _prefs;

  // Constructor that initialises the SharedPreferences and loads the
  //list of favourites.
  FavoriteProvider() : _prefs = SharedPreferences.getInstance() {
    loadFavorites();
  }

  /// adds and remove SensorId to sensorList if it has not already been added
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

  /// loads the list of favorite Sensors from SharedPreferences
  Future<void> loadFavorites() async {
    var pref = await _prefs;
    var favoriteSensors = pref.getStringList('favoriteSensors') ?? [];

    _sensorList = favoriteSensors
        .map((sensor) => SensorId.values[int.parse(sensor)])
        .toList();

    notifyListeners();
  }

  /// checks if SensorId exists in List
  bool isExist(SensorId id) => _sensorList.contains(id);

  /// checks if SensorId is slideable
  bool isSlidableEnabled(SensorId id) => id != SensorId.barometer;
}
