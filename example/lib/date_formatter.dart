import 'dart:io';

import 'package:intl/intl.dart';

String formatDate({required DateTime dateTime, bool shortenYear = false}) {
  // Format the date according to the locale
  // This will output: en -> 12.31.2023 or de -> 31.12.2023
  var dateFormatted = DateFormat.yMd(Platform.localeName).format(dateTime);

  var datePartSeparator = "";
  if (dateFormatted.contains("/")) {
    datePartSeparator = "/";
  } else if (dateFormatted.contains(".")) {
    datePartSeparator = ".";
  }

  var dateParts = dateFormatted.split(datePartSeparator);

  // Add a leading zero to single digits for days and months
  dateParts = dateParts.map((part) => part.padLeft(2, "0")).toList();

  // If year should be shortend remove first two characters: 2023 -> 23
  if (shortenYear) {
    dateParts[dateParts.length - 1] = dateParts.last.substring(2);
  }

  return dateParts.join(datePartSeparator);
}
