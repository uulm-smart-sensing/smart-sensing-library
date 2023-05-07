import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library_example/sensor_unit_handler/unit_string_representation.dart';

void main() {
  test('unitToUnitStringRepresentation has a string for each Unit', () {
    expect(
      Unit.values
          .map((unit) => unitToUnitStringRepresentation[unit])
          .contains(null),
      isFalse,
    );
  });
}
