import 'package:flutter_test/flutter_test.dart';
import 'package:smart_sensing_library/smart_sensing_library.dart';
import 'package:smart_sensing_library_example/theme.dart';

void main() {
  test('sensorIdToColor has a color for each SensorId', () {
    expect(
      SensorId.values.map((id) => sensorIdToColor[id]).contains(null),
      isFalse,
    );
  });

  test('Primary material color opcaity is correct', () {
    expect(primaryMaterialColor[50], primaryColor.withOpacity(.1));
    expect(primaryMaterialColor[100], primaryColor.withOpacity(.2));
    expect(primaryMaterialColor[200], primaryColor.withOpacity(.3));
    expect(primaryMaterialColor[300], primaryColor.withOpacity(.4));
    expect(primaryMaterialColor[400], primaryColor.withOpacity(.5));
    expect(primaryMaterialColor[500], primaryColor.withOpacity(.6));
    expect(primaryMaterialColor[600], primaryColor.withOpacity(.7));
    expect(primaryMaterialColor[700], primaryColor.withOpacity(.8));
    expect(primaryMaterialColor[800], primaryColor.withOpacity(.9));
    expect(primaryMaterialColor[900], primaryColor.withOpacity(1));
  });

  test('Theme uses primary color', () {
    expect(theme.primaryColor, primaryMaterialColor);
  });
}
