import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_sensing_library_example/formatter/time_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting("en");
    await initializeDateFormatting("de");
  });

  group("Date formatter tests", () {
    test(
      "When date is formatted with locale \"en\", then date is formatted "
      "correctly",
      () {
        var result = formatDate(dateTime: DateTime(2023, 12, 1), locale: "en");
        expect(result, equals("12/01/2023"));
      },
    );

    test(
      "When date is formatted with locale \"de\", then date is formatted "
      "correctly",
      () {
        var result = formatDate(dateTime: DateTime(2023, 12, 1), locale: "de");
        expect(result, equals("01.12.2023"));
      },
    );

    test(
      "When date is formatted and shortenYear is true, then year is shortened",
      () {
        var result = formatDate(
          dateTime: DateTime(2023, 12, 1),
          locale: "en",
          shortenYear: true,
        );
        expect(result, equals("12/01/23"));
      },
    );

    test(
      "When date is formatted and extendWithDayName is true, day name is added "
      "in front of formatted date (2)",
      () {
        var result = formatDate(
          dateTime: DateTime(2023, 12, 6),
          locale: "en",
          shortenYear: true,
          extendWithDayName: true,
        );
        expect(result, equals("Wed. 12/06/23"));
      },
    );

    test(
      "When date is formatted and extendWithDayName is true, day name is added "
      "in front of formatted date (2)",
      () {
        var result = formatDate(
          dateTime: DateTime(2023, 12, 6),
          locale: "de",
          extendWithDayName: true,
        );
        expect(result, equals("Mi. 06.12.2023"));
      },
    );

    test("When locale is not passed, then the platform locale is used", () {
      var platformLocale = Platform.localeName;

      var result = formatDate(dateTime: DateTime(2023, 12, 1));

      if (platformLocale.startsWith("en")) {
        expect(result, equals("12/01/2023"));
      } else if (platformLocale.startsWith("de")) {
        expect(result, equals("01.12.2023"));
      } else {
        fail("unexpected Platform locale");
      }
    });
  });

  group('Duration formatter tests', () {
    test(
      "When duration is formatted, then duration is formatted correctly",
      () {
        var result = formatDuration(
          const Duration(hours: 1, minutes: 2, seconds: 3),
        );
        expect(result, equals("1 Hour 2 Minutes 3 Seconds"));
      },
    );
  });
}
