import 'dart:io';

import 'package:intl/intl.dart';

/// Formats the passed [dateTime] according to the passed [locale].
///
/// When [locale] is null, [Platform.localeName] will be used instead.
/// When [shortenYear] is true, the first two characters of the year will be
/// omitted.
/// When [extendWithDayName] is true, the corresponding day (name in shortened
/// form) will be added at the beginning of the formatted string.
///
/// Example:
/// ```dart
/// // Date is formatted according to passed locale
/// formatDate(dateTime: DateTime(2023, 12, 1), locale: "en");
/// // results in 12/01/2023
/// formatDate(dateTime: DateTime(2023, 12, 1), locale: "de");
/// // results in 01.12.2023
///
/// // Year can be shortened
/// formatDate(
///   dateTime: DateTime(2023, 12, 1),
///   locale: "en",
///   shortenYear: true,
/// );
/// // results in 12/01/23
///
/// // Day name can be added
/// formatDate(
///   dateTime: DateTime(2023, 12, 1),
///   locale: "de",
///   shortenYear: true,
///   extendWithDayName: true,
/// );
/// // results in Fri. 01.12.23
/// ```
String formatDate({
  required DateTime dateTime,
  bool shortenYear = false,
  bool extendWithDayName = false,
  String? locale,
}) {
  locale ??= Platform.localeName;

  // Format the date according to the locale
  // This will output: en -> 12/31/2023 or de -> 31.12.2023
  var dateFormatted = DateFormat.yMd(locale).format(dateTime);

  var datePartSeparator = "";
  if (dateFormatted.contains("/")) {
    datePartSeparator = "/";
  } else if (dateFormatted.contains(".")) {
    datePartSeparator = ".";
  }

  var dateParts = dateFormatted.split(datePartSeparator);

  // Add a leading zero to single digits for days and months
  dateParts = dateParts.map((part) => part.padLeft(2, "0")).toList();

  // If year should be shortened remove first two characters: 2023 -> 23
  if (shortenYear) {
    dateParts[dateParts.length - 1] = dateParts.last.substring(2);
  }

  var finalDatetime = dateParts.join(datePartSeparator);

  if (extendWithDayName) {
    var dayName = DateFormat.E(locale).format(dateTime);
    finalDatetime = "$dayName. $finalDatetime";
  }

  return finalDatetime;
}
