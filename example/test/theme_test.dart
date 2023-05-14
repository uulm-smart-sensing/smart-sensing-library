import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library_example/theme/theme.dart';

void main() {
  test('sensorIdToColor has a color for each SensorId', () {
    expect(
      SensorId.values.map((id) => sensorIdToColor[id]).contains(null),
      isFalse,
    );
  });
}
