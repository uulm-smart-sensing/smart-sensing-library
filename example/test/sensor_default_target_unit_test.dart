import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library_example/sensor_unit_handler/sensor_default_target_unit.dart';

void main() {
  test('sensorIdToDefaultTargetUnit has a unit for each SensorId', () {
    expect(
      SensorId.values
          .map((id) => sensorIdToDefaultTargetUnit[id])
          .contains(null),
      isFalse,
    );
  });
}
