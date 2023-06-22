import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

/// The FavoriteProvider class is responsible for managing a list of favored
/// sensors.It provides methods to toggle the favorite status of a sensor,
/// load previously stored favorites, and check if a sensor exists in the list
/// of favorites. It extends the ChangeNotifier class, allowing it to notify
/// listeners when the list is modified.

/// Example usage:
/// 1. Create an instance of FavoriteProvider
///    var favoriteProvider = FavoriteProvider();
///
/// 2. Toggle the favorite status of a sensor
///    var sensorId = SensorId.gyroscope;
///    favoriteProvider.toggleFavorite(sensorId);
///
/// 3. Check if a sensor exists in the list of favorites
///    var isFavorite = favoriteProvider.isExist(sensorId);
///    print('Is sensor $sensorId a favorite? $isFavorite');

class FavoriteProvider extends ChangeNotifier {
  /// List to store favored sensors
  List<SensorId> _sensorList = [];

  /// Getter to access the favored sensor list
  List<SensorId> get sensorList => _sensorList;

  /// Future object to store SharedPreferences
  final Future<SharedPreferences> _prefs;

  /// Constructor for the FavoriteProvider class
  FavoriteProvider() : _prefs = SharedPreferences.getInstance() {
    /// Load previously stored favorites from SharedPreferences
    loadFavorites();
  }

  /// Method to toggle the favorite status of a sensor
  Future<void> toggleFavorite(SensorId id) async {
    var isExist = _sensorList.contains(id);

    if (isExist) {
      /// Remove the sensor from the list if it already exists
      _sensorList.remove(id);
    } else {
      /// Add the sensor to the list if it doesn't exist
      _sensorList.add(id);
    }

    /// Notify listeners that the list has been updated
    notifyListeners();

    /// Store the updated list of favorite sensors in SharedPreferences for
    /// persistence
    var pref = await _prefs;
    await pref.setStringList(
      'favoriteSensors',
      _sensorList.map((id) => id.index.toString()).toList(),
    );
  }

  /// Load the list of favorite sensors from SharedPreferences
  Future<void> loadFavorites() async {
    var pref = await _prefs;
    var favoriteSensors = pref.getStringList('favoriteSensors') ?? [];

    _sensorList = favoriteSensors
        .map((sensor) => SensorId.values[int.parse(sensor)])
        .toList();

    /// Notify listeners that the list of favorites has been loaded
    notifyListeners();
  }

  /// Check if a sensor with the specified SensorId exists in the list
  /// of favorites
  bool isExist(SensorId id) => _sensorList.contains(id);
}
