import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_sensing_library_example/date_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting("en");
    await initializeDateFormatting("de");
  });

  test(
    'When date is formatted with locale "en", then date is formatted correctly',
    () {
      var result = formatDate(dateTime: DateTime(2023, 12, 1), locale: "en");
      expect(result, equals("12/01/2023"));
    },
  );

  test(
    'When date is formatted with locale "de", then date is formatted correctly',
    () {
      var result = formatDate(dateTime: DateTime(2023, 12, 1), locale: "de");
      expect(result, equals("01.12.2023"));
    },
  );

  test(
    'When date is formatted and shortenYear is true, then year is shortened',
    () {
      var result = formatDate(
        dateTime: DateTime(2023, 12, 1),
        locale: "en",
        shortenYear: true,
      );
      expect(result, equals("12/01/23"));
    },
  );
}
