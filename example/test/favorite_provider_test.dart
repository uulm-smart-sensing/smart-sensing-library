import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library_example/favorite_provider.dart';

void main() {
  test('Adds a sensor to the favorites list if it is not available', () async {
    SharedPreferences.setMockInitialValues({});
    var favoriteProvider = FavoriteProvider();
    await favoriteProvider.loadFavorites();
    var sensorId = SensorId.accelerometer;

    await favoriteProvider.toggleFavorite(sensorId);

    expect(favoriteProvider.isExist(sensorId), isTrue);
  });

  test('Removes a sensor from the favorites list if it already exists',
      () async {
    SharedPreferences.setMockInitialValues({});
    var favoriteProvider = FavoriteProvider();
    await favoriteProvider.loadFavorites();
    var sensorId = SensorId.accelerometer;
    await favoriteProvider.toggleFavorite(sensorId);

    expect(favoriteProvider.isExist(sensorId), isTrue);

    await favoriteProvider.toggleFavorite(sensorId);

    expect(favoriteProvider.isExist(sensorId), isFalse);
  });

  test(
    'When sensor is added to favorites, then favorite list contains sensor',
    () async {
      SharedPreferences.setMockInitialValues({});
      var favoriteProvider = FavoriteProvider();
      await favoriteProvider.loadFavorites();
      var sensorId = SensorId.accelerometer;
      await favoriteProvider.toggleFavorite(sensorId);

      expect(favoriteProvider.sensorList.contains(sensorId), isTrue);
    },
  );
}
