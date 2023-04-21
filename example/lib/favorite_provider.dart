import 'package:flutter/foundation.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';

class FavoriteProvider extends ChangeNotifier {
  List<SensorId> _sensorList = [];
  List<SensorId> get sensorList => _sensorList;

  void toggleFavorite(SensorId id) {
    var isExist = _sensorList.contains(id);
    if (isExist) {
      _sensorList.remove(id);
    } else {
      _sensorList.add(id);
    }
    notifyListeners();
  }

  bool isExist(SensorId id) => _sensorList.contains(id);
  bool isSlidableEnabled(SensorId id) => id != SensorId.barometer;
  bool isEmpty() => _sensorList.isEmpty;
  void clearFavorite() {
    _sensorList = [];
    notifyListeners();
  }
}
